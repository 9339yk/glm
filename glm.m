% glm
% merge all the trials from the same Rat
% LK05 first

%%
load ('LOOKUP_crossmodal.mat');
X = S.X;
CLASS = S.CLASS;
BLOCK  = S.BLOCK;
DAY = S.DAY;
Rat='LK05';
Date = '25';
files=dir([Rat,'*',Date,'*.mat']);
files = files(~contains({files.name}, {'pooled','drop','GLM','result'}));

FS=2000;
mint=0;
maxt=0.3;

nT = round((maxt-mint)*FS);
time_axis = mint + (0:nT-1)/FS;

%% GLM first version: trial-wise regression at each time bin

Y = X;        % channel x trial x time
CLASS = CLASS;
BLOCK = BLOCK;

nCh = size(Y,1);
nTrial = size(Y,2);
nTime = size(Y,3);

% -----------------------------
% Build regressors
% -----------------------------

% CLASS coding:
% 11 = Aud odd + Vis odd
% 12 = Aud odd + Vis std
% 21 = Aud std + Vis odd
% 22 = Aud std + Vis std

Aodd = floor(CLASS/10) == 1;   % auditory oddball
Vodd = mod(CLASS,10) == 1;     % visual oddball

BlockA = BLOCK == 1;           % auditory block = 1, visual block = 0

% Use effect coding: -0.5 / +0.5
Aodd_c  = double(Aodd)  - 0.5;
Vodd_c  = double(Vodd)  - 0.5;
Block_c = double(BlockA) - 0.5;

% Interactions
Aodd_Block = Aodd_c .* Block_c;
Vodd_Block = Vodd_c .* Block_c;
Aodd_Vodd  = Aodd_c .* Vodd_c;

% Design matrix
Xglm = [ ...
    ones(nTrial,1), ...
    Aodd_c(:), ...
    Vodd_c(:), ...
    Block_c(:), ...
    Aodd_Block(:), ...
    Vodd_Block(:), ...
    Aodd_Vodd(:)];

regressor_names = { ...
    'Intercept', ...
    'Auditory oddball', ...
    'Visual oddball', ...
    'Block A vs V', ...
    'Auditory oddball x Block', ...
    'Visual oddball x Block', ...
    'Auditory oddball x Visual oddball'};

nReg = size(Xglm,2);

% -----------------------------
% Fit GLM / linear model
% -----------------------------
%% Cross-validated full GLM

K = 5;
BETA_cv = nan(nCh,nReg,nTime,K);
YHAT_cv = nan(size(Y));
R2_cv = nan(nCh,nTime);

cv = cvpartition(nTrial,'KFold',K);

validX = all(~isnan(Xglm),2);
validX = validX(:);

for ch = 1:nCh
    % fprintf('CV full model: Channel %d\n', ch);

    Y_ch = squeeze(Y(ch,:,:));   % trial x time

    for tt = 1:nTime
        y = Y_ch(:,tt);
        y = y(:);                % 放這裡

        yhat = nan(nTrial,1);

        for k = 1:K
            trainIdx = training(cv,k);
            testIdx  = test(cv,k);

            trainIdx = trainIdx(:);   % 放這裡
            testIdx  = testIdx(:);    % 放這裡

            validTrain = trainIdx & ~isnan(y) & validX;
            validTest  = testIdx  & ~isnan(y) & validX;

            if sum(validTrain) <= nReg || sum(validTest) < 2
                continue
            end

            beta = Xglm(validTrain,:) \ y(validTrain);

            BETA_cv(ch,:,tt,k) = beta;
            yhat(validTest) = Xglm(validTest,:) * beta;
        end

        YHAT_cv(ch,:,tt) = yhat;

        validEval = ~isnan(yhat) & ~isnan(y);

        if sum(validEval) > 2
            R2_cv(ch,tt) = 1 - sum((y(validEval)-yhat(validEval)).^2) / ...
                               sum((y(validEval)-mean(y(validEval))).^2);
        end
    end
end

time_axis = mint + (0:nTime-1)/FS;
save_name = [Rat '_' Date '_pooled_LFP_GLM_result.mat'];

save(save_name, ...
    'X', 'CLASS', 'BLOCK', ...
    'BETA_cv', 'YHAT_cv', 'R2_cv', ...
    'Xglm', 'regressor_names', ...
    'time_axis', 'FS', 'mint', 'maxt', ...
    'Rat', 'Date', 'files', ...
    '-v7.3');

%% Plot GLM beta kernels
chList = [1 2 4];
BETA = mean(BETA_cv,4,'omitnan');
YHAT = YHAT_cv;
R2 = R2_cv;
fig = figure('visible', 'on');
for r = 2:nReg
    subplot(nReg-1,1,r-1); hold on

    for ch = chList
        plot(time_axis, squeeze(BETA(ch,r,:)), 'LineWidth', 1.5);
    end

    title(regressor_names{r});
    xlabel('Time from stimulus onset (s)');
    ylabel('Beta');

    if r == 2
        legend(arrayfun(@(x) sprintf('Ch %d', x), chList, 'UniformOutput', false), ...
               'Location', 'best');
    end
end

sgtitle('GLM beta kernels');
outName = 'GLM_beta_kernels';

savefig(fig, [outName '.fig']);
exportgraphics(fig, [outName '.png'], 'Resolution', 300);
BETA = mean(BETA_cv,4,'omitnan');

chList = [1 2 4];
colors = lines(nReg);

fig = figure('Visible','on');

for ci = 1:length(chList)

    ch = chList(ci);

    subplot(length(chList),1,ci); hold on

    h = gobjects(nReg,1);

    for r = 1:nReg
        beta_trace = squeeze(BETA(ch,r,:));

        h(r) = plot(time_axis, beta_trace, ...
            'LineWidth', 1.5, ...
            'Color', colors(r,:));
    end

    xline(0,'k--');
    yline(0,'k:');

    title(sprintf('Channel %d', ch));
    xlabel('Time from stimulus onset (s)');
    ylabel('Beta');
    if ci == 1
        legend(h, regressor_names, 'Location','best');
    end
end

sgtitle('GLM beta kernels across channels');

outName = 'GLM_beta_kernels_all_channels';
savefig(fig, [outName '.fig']);
exportgraphics(fig, [outName '.png'], 'Resolution',300);
%% Compare raw vs GLM reconstruction (per day, multi-channel, color shade)

title_all = ['bkA OS'; 'bkV OS'; 'bkA SO'; 'bkV SO'; 'bkA OO'; 'bkV OO'];
block_id  = [1,2,1,2,1,2];
trial_all = [12,12,21,21,11,11];

chList = [1 2 4];
base_colors = lines(length(chList));   % 每個 channel 一個顏色

days = unique(DAY);

for di = 1:length(days)

    d = days(di);

    fig = figure('Visible','off');

    for id = 1:6
        subplot(3,2,id); hold on

        for ci = 1:length(chList)
            ch = chList(ci);

            idx = (DAY==d) & (BLOCK==block_id(id)) & (CLASS==trial_all(id));

            if sum(idx) < 5
                continue
            end

            % --- raw ---
            raw_data = squeeze(X(ch,idx,:));
            raw_mu   = mean(raw_data,1,'omitnan');

            % --- prediction ---
            rec_data = squeeze(YHAT_cv(ch,idx,:));
            rec_mu   = mean(rec_data,1,'omitnan');

            base_c = base_colors(ci,:);

            % 深色 = raw
            raw_c = base_c;

            % 淺色 = prediction
            rec_c = base_c + (1 - base_c)*0.6;   % 變淡（往白靠）

            plot(time_axis, raw_mu, ...
                'Color', raw_c, ...
                'LineWidth', 1.2);

            plot(time_axis, rec_mu, ...
                'Color', rec_c, ...
                'LineWidth', 1.2);
        end

        xline(0,'k--');

        title(title_all(id,:));
        xlabel('Time (s)');
        ylabel('LFP');

        if id == 1
            legend({'Ch1 raw','Ch1 pred', ...
                    'Ch2 raw','Ch2 pred', ...
                    'Ch4 raw','Ch4 pred'}, ...
                    'Location','best');
        end
    end

    sgtitle(sprintf('Day %d - Multi-channel GLM', d));

    saveas(fig, sprintf('GLM_day_%d_multich.png', d));
    close(fig);
end
%% Raw mean ± SEM across days (fixed legend + visible shading)

chList = [1 2 4];
colors = lines(length(chList));
days = unique(DAY);

fig = figure;

for id = 1:6
    subplot(3,2,id); hold on

    h_line = gobjects(length(chList),1);   % 存 line handle

    for ci = 1:length(chList)
        ch = chList(ci);

        daily_mu_all = [];

        for di = 1:length(days)
            d = days(di);

            idx = (DAY==d) & (BLOCK==block_id(id)) & (CLASS==trial_all(id));

            if sum(idx) < 5
                continue
            end

            daily_mu = squeeze(mean(X(ch,idx,:),2,'omitnan'));
            daily_mu_all = [daily_mu_all; daily_mu(:)'];
        end

        if size(daily_mu_all,1) < 2
            continue
        end

        mu  = mean(daily_mu_all,1,'omitnan');
        sem = std(daily_mu_all,0,1,'omitnan') / sqrt(size(daily_mu_all,1));

        c = colors(ci,:);

        % --- shaded (不進 legend)
        h_fill = fill([time_axis fliplr(time_axis)], ...
                      [mu+sem fliplr(mu-sem)], ...
                      c, 'FaceAlpha',0.3, 'EdgeColor','none');
        set(h_fill, 'HandleVisibility','off');

        % --- line（進 legend）
        h_line(ci) = plot(time_axis, mu, ...
            'Color', c, ...
            'LineWidth', 1.5);
    end

    xline(0,'k--');

    title(title_all(id,:));
    xlabel('Time (s)');
    ylabel('LFP');

    if id == 1
        legend(h_line, ...
            arrayfun(@(x) sprintf('Ch %d', x), chList, ...
            'UniformOutput', false), ...
            'Location','best');
    end
end

sgtitle('Raw LFP: Mean ± SEM across days');

%% Compare raw vs GLM reconstruction (all pooled trials, multi-channel)

title_all = ['bkA OS'; 'bkV OS'; 'bkA SO'; 'bkV SO'; 'bkA OO'; 'bkV OO'];
block_id  = [1,2,1,2,1,2];
trial_all = [12,12,21,21,11,11];

chList = [1 2 4];
base_colors = lines(length(chList));

fig = figure('Visible','on'); 

for id = 1:6
    subplot(3,2,id); hold on

    for ci = 1:length(chList)
        ch = chList(ci);

        idx = (BLOCK==block_id(id)) & (CLASS==trial_all(id));

        if sum(idx) < 5
            continue
        end

        raw_data = squeeze(X(ch,idx,:));
        raw_mu   = mean(raw_data,1,'omitnan');

        rec_data = squeeze(YHAT_cv(ch,idx,:));
        rec_mu   = mean(rec_data,1,'omitnan');

        base_c = base_colors(ci,:);
        raw_c = base_c;
        rec_c = base_c + (1 - base_c)*0.6;   % lighter prediction

        plot(time_axis, raw_mu, ...
            'Color', raw_c, ...
            'LineWidth', 1.2);

        plot(time_axis, rec_mu, ...
            'Color', rec_c, ...
            'LineWidth', 1.2);
    end

    xline(0,'k--');
    title(title_all(id,:));
    xlabel('Time (s)');
    ylabel('LFP');

end

sgtitle('All pooled trials - Raw vs GLM reconstruction');
outName = sprintf('GLM_pooled_multich.png');
saveas(fig, outName);

savefig(fig, strrep(outName,'.png','.fig'));
%% Daily prediction error mean ± SEM across days
%% Daily relative prediction error ± SEM (fixed legend)

block_id  = [1,2,1,2,1,2];
trial_all = [12,12,21,21,11,11];

chList = [1 2 4];
colors = lines(length(chList));
days = unique(DAY);

eps_val = 1e-6;   % 防止除以0

fig = figure('Visible','on');

for id = 1:6
    subplot(3,2,id); hold on

    h_line = gobjects(length(chList),1);   % 存 legend 用

    for ci = 1:length(chList)
        ch = chList(ci);

        daily_err = [];

        for di = 1:length(days)
            d = days(di);

            idx = DAY==d & BLOCK==block_id(id) & CLASS==trial_all(id);

            if sum(idx) < 5
                continue
            end

            raw_mu  = squeeze(mean(X(ch,idx,:),2,'omitnan'));
            pred_mu = squeeze(mean(YHAT_cv(ch,idx,:),2,'omitnan'));

            % -------- relative error
            scale = max(abs(raw_mu));
            err_trace = (raw_mu - pred_mu) ./ (scale + eps_val);

            daily_err = [daily_err; err_trace(:)'];
        end

        if size(daily_err,1) < 2
            continue
        end

        err_mu  = mean(daily_err,1,'omitnan');
        err_sem = std(daily_err,0,1,'omitnan') / sqrt(size(daily_err,1));

        c = colors(ci,:);

        % -------- shaded (不進 legend)
        h_fill = fill([time_axis fliplr(time_axis)], ...
                      [err_mu+err_sem fliplr(err_mu-err_sem)], ...
                      c, 'FaceAlpha',0.3, 'EdgeColor','none');
        set(h_fill, 'HandleVisibility','off');

        % -------- line（進 legend）
        h_line(ci) = plot(time_axis, err_mu, ...
            'Color', c, ...
            'LineWidth', 1.5);
    end

    yline(0,'k--');
    xline(0,'k--');

    title(title_all(id,:));
    xlabel('Time (s)');
    ylabel('Relative Error');

    if id == 1
        legend(h_line, ...
            arrayfun(@(x) sprintf('Ch %d', x), chList, ...
            'UniformOutput', false), ...
            'Location','best');
    end
end

sgtitle('Daily relative prediction error ± SEM across days');

outName = 'GLM_relative_error_SEM_multich.png';
exportgraphics(fig, outName, 'Resolution', 300);
savefig(fig, strrep(outName,'.png','.fig'));
%% Cross-validated drop-one GLM

Y = X;

nCh = size(Y,1);
nTrial = size(Y,2);
nTime = size(Y,3);
nReg = size(Xglm,2);
YHAT = nan(nCh,nTrial,nTime);
YHAT_DROP = nan(nCh,nTrial,nReg,nTime);

K = 5;
cv = cvpartition(nTrial,'KFold',K);

R2_full_cv = nan(nCh,nTime);
R2_drop_cv = nan(nCh,nReg,nTime);
Delta_R2 = nan(nCh,nReg,nTime);

for ch = 1:nCh
    fprintf('Channel %d\n', ch);

    Y_ch = squeeze(Y(ch,:,:));  % trial x time

    for tt = 1:nTime

        y = Y_ch(:,tt);

        yhat_full = nan(nTrial,1);
        yhat_drop = nan(nTrial,nReg);

        for k = 1:K

            trainIdx = training(cv,k);
            testIdx  = test(cv,k);

            validTrain = trainIdx & ~isnan(y) & all(~isnan(Xglm),2);
            validTest  = testIdx  & ~isnan(y) & all(~isnan(Xglm),2);

            if sum(validTrain) <= nReg || sum(validTest) < 2
                continue
            end

            % -------------------------
            % Full model
            % -------------------------
            beta_full = Xglm(validTrain,:) \ y(validTrain);
            yhat_full(validTest) = Xglm(validTest,:) * beta_full;

            % -------------------------
            % Drop-one models
            % -------------------------
            for r = 2:nReg   % skip intercept
                keepReg = true(1,nReg);
                keepReg(r) = false;

                X_drop = Xglm(:,keepReg);

                beta_drop = X_drop(validTrain,:) \ y(validTrain);
                yhat_drop(validTest,r) = X_drop(validTest,:) * beta_drop;
            end
        end
        YHAT(ch,:,tt) = yhat_full;

        for r = 2:nReg
            YHAT_DROP(ch,:,r,tt) = yhat_drop(:,r);
        end
        validEval = ~isnan(yhat_full) & ~isnan(y);

        if sum(validEval) > 2
            R2_full_cv(ch,tt) = 1 - sum((y(validEval)-yhat_full(validEval)).^2) / ...
                                    sum((y(validEval)-mean(y(validEval))).^2);
        end

        for r = 2:nReg
            validEval = ~isnan(yhat_drop(:,r)) & ~isnan(y);

            if sum(validEval) > 2
                R2_drop_cv(ch,r,tt) = 1 - sum((y(validEval)-yhat_drop(validEval,r)).^2) / ...
                                          sum((y(validEval)-mean(y(validEval))).^2);

                Delta_R2(ch,r,tt) = R2_full_cv(ch,tt) - R2_drop_cv(ch,r,tt);
            end
        end
    end
end
save_name = [Rat '_' Date '_drop_one_GLM_results.mat'];
save(save_name, ...
    'X', 'CLASS', 'BLOCK', ...
    'YHAT', 'YHAT_DROP', ...
    'BETA', 'R2_full_cv', 'R2_drop_cv', 'Delta_R2', ...
    'Xglm', 'regressor_names', ...
    'time_axis', ...
    '-v7.3');
%% Plot drop-one Delta R2

chList = [1 2 4];

figure;

for r = 2:nReg
    subplot(nReg-1,1,r-1); hold on

    for ch = chList
        plot(time_axis, squeeze(Delta_R2(ch,r,:)), 'LineWidth', 1.5);
    end

    yline(0,'k--');
    title(['Drop-one importance: ', regressor_names{r}]);
    xlabel('Time from stimulus onset (s)');
    ylabel('\Delta R^2');

    if r == 2
        legend(arrayfun(@(x) sprintf('Ch %d', x), chList, ...
            'UniformOutput', false), 'Location','best');
    end
end

sgtitle('Cross-validated drop-one analysis');
%% Prediction error (MSE over time)

chList = [1 2 4];

figure; hold on

for ch = chList
    err = squeeze(X(ch,:,:) - YHAT(ch,:,:));   % trial x time
    mse = mean(err.^2,1,'omitnan');

    plot(time_axis, mse, 'LineWidth', 1.5);
end

legend(arrayfun(@(x) sprintf('Ch %d', x), chList, 'UniformOutput', false));
xlabel('Time (s)');
ylabel('MSE');
title('Prediction Error over Time');
yline(0,'k--');
%% Compute AIC-like change: log(SSE_drop / SSE_full)

nCh = size(X,1);
nTime = size(X,3);
nReg = size(Xglm,2);

AIC_change = nan(nCh,nReg,nTime);

for ch = 1:nCh
    Y_ch = squeeze(X(ch,:,:));   % trial x time

    for tt = 1:nTime
        y = Y_ch(:,tt);
        y = y(:);

        yhat_full_all = squeeze(YHAT(ch,:,tt));
        yhat_full_all = yhat_full_all(:);

        valid = ~isnan(y) & ~isnan(yhat_full_all);

        if sum(valid) < 3
            continue
        end

        yv = y(valid);
        yhat_full = yhat_full_all(valid);

        SSE_full = sum((yv - yhat_full).^2);

        for r = 2:nReg
            yhat_drop_all = squeeze(YHAT_DROP(ch,:,r,tt));
            yhat_drop_all = yhat_drop_all(:);

            valid_r = valid & ~isnan(yhat_drop_all);

            if sum(valid_r) < 3
                continue
            end

            yv_r = y(valid_r);
            yhat_full_r = yhat_full_all(valid_r);
            yhat_drop_r = yhat_drop_all(valid_r);

            SSE_full_r = sum((yv_r - yhat_full_r).^2);
            SSE_drop_r = sum((yv_r - yhat_drop_r).^2);

            if SSE_full_r > 0 && SSE_drop_r > 0
                AIC_change(ch,r,tt) = log(SSE_drop_r / SSE_full_r);
            end
        end
    end
end
%% Boxplot + scatter for AIC-like change

% average over time for each channel/regressor
AIC_summary = squeeze(mean(AIC_change,3,'omitnan'));  
% size: ch x regressor

data = [];
group = [];

for r = 2:nReg   % skip intercept
    vals = AIC_summary(:,r);
    vals = vals(~isnan(vals));

    data = [data; vals(:)];
    group = [group; r*ones(length(vals),1)];
end

figure; hold on

boxplot(data, group, 'Colors','k','Symbol','');

uGroup = unique(group);

for ii = 1:length(uGroup)
    g = uGroup(ii);
    idx = group == g;

    x = ii + 0.18*(rand(sum(idx),1)-0.5);

    scatter(x, data(idx), 35, 'filled', ...
        'MarkerFaceAlpha', 0.45);
end

xticks(1:length(uGroup))
xticklabels(regressor_names(uGroup))
xtickangle(35)

yline(0,'k--');

ylabel('AIC-like change: log(SSE_{drop}/SSE_{full})');
title('Drop-one model importance');
%% Build regressors: corrected block labels + full-rank model

CLASS = CLASS(:);
BLOCK = BLOCK(:);

% CLASS coding:
% 11 = A odd + V odd = OO
% 12 = A odd + V std = OS
% 21 = A std + V odd = SO
% 22 = A std + V std = SS

A_odd = floor(CLASS/10) == 1;
A_std = floor(CLASS/10) == 2;

V_odd = mod(CLASS,10) == 1;
V_std = mod(CLASS,10) == 2;

% BLOCK coding:
% 1 = Visual block
% 2 = Auditory block
BlockV = BLOCK == 1;
BlockA = BLOCK == 2;

% effect-coded oddball difference
Aodd_c = double(A_odd) - 0.5;
Vodd_c = double(V_odd) - 0.5;

% attended stimulus terms
A_odd_in_Ablock = A_odd & BlockA;
A_std_in_Ablock = A_std & BlockA;

V_odd_in_Vblock = V_odd & BlockV;
V_std_in_Vblock = V_std & BlockV;  % reference, not included

% Full-rank design matrix
% Drop V_std_in_Vblock to avoid collinearity with intercept
Xglm = [ ...
    ones(nTrial,1), ...
    Aodd_c(:), ...
    Vodd_c(:), ...
    double(A_odd_in_Ablock(:)), ...
    double(A_std_in_Ablock(:)), ...
    double(V_odd_in_Vblock(:))];

regressor_names = { ...
    'Intercept', ...
    'A odd diff', ...
    'V odd diff', ...
    'A odd in A block', ...
    'A std in A block', ...
    'V odd in V block'};

nReg = size(Xglm,2);

fprintf('rank(Xglm) = %d, nReg = %d\n', rank(Xglm), nReg);