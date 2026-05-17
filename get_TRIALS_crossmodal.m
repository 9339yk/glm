function [TS_TRIALS,n_TRIALS, BLOCK_TRIALS, TRANSITION, LICKCLUSTER]=get_TRIALS_crossmodal(Data)
%%

load LOOKUP_crossmodal.mat

%% TS_TRIALS

% NaN by default
% 1     Block	1: Light	2: Sound
% 2 	TS_Trial
% 3 	TS_Light_Odd		No: nan
% 4 	TS_Light_Standard		No: nan
% 5 	TS_Sound_Odd		No: nan
% 6 	TS_Sound_Standard		No: nan
% 7 	TS_IRR1_entry	1st IRR1On within 2s
% 8 	TS_IRL1_entry	1st IRLIOn within 2s
% 9 	TS_RLick_1st	1st lick of a new right lick cluster within 2s
% 10	TS_RLick_2nd	2nd lick of a new right lick cluster within 2s
% 11	TS_RLick_3rd	3rd lick of a new right lick cluster within 2s
% 12	TS_RRew1	1st reward RIGHT within 2s
% 13	TS_RLick_last	last lick of a new right lick cluster; can go beyond 2s
% 14	TS_LLick_1st	1st lick of a new LEFT lick cluster within 2s
% 15	TS_LLick_2nd	2nd lick of a new LEFT lick cluster within 2s
% 16	TS_LLick_3rd	3rd lick of a new LEFT lick cluster within 2s
% 17	TS_LRew1	1st reward LEFT within 2s
% 18	TS_LLick_last	last lick of a new LEFT lick cluster; can go beyond 2s
% 19	TS_IRR1_exit	IRR1OFF in RIGHT licking trials
% 20	TS_IRL1_exit	IRL1OFF in LEFT licking trials
% 21    TS_IRR1_exit in Right IRR1Off in Light Odd rewarded trials
% 22    TS_IRL1_exit in Sound IRR1Off in Sound Odd rewraded trials

% TI_DIM=22;
% TI_BK_MPC=1;
% TI_TRIALTS=2;
% TI_VIS_ODD=3;
% TI_VIS_STD=4;
% TI_AUD_ODD=5;
% TI_AUD_STD=6;
% TI_IRR1ON=7;
% TI_IRL1ON=8;
% TI_RLICK1=9;
% TI_RLICK2=10;
% TI_RLICK3=11;
% TI_RREW1=12;
% TI_RLICKEND=13;
% TI_LLICK1=14;
% TI_LLICK2=15;
% TI_LLICK3=16;
% TI_LREW1=17;
% TI_LLICKEND=18;
% TI_IRR1OFF=19;
% TI_IRL1OFF=20;
% TI_IRR1OFF_postREW=21;
% TI_IRL1OFF_postREW=22;
% 
% NI_DIM=28;
% NI_BK_MPC=1;
% NI_BK_BEH=2;
% NI_VIS_ODD=3;
% NI_AUD_ODD=4;
% NI_VIS_CH=5;
% NI_AUD_CH=6;
% NI_MISS=7;
% NI_VIS_REW=8;
% NI_AUD_REW=9;
% NI_REMOVE_CUEduringLICKING=10;
% NI_REMOVE_LICKwoIROFF=11;
% NI_REMOVE_LICK_postREWpreIROFF=12;
% NI_LICK_DIR=13;
% NI_NREW=14;
% NI_NLICK=15;
% NI_LICKBLOCK_LENGTH=16;
% NI_LICKBLOCK_NREW=17;
% NI_LICKBLOCK_NLICK=18;
% NI_RAT=19;
% NI_SESSION=20;
% NI_TRIALNUM=21;
% NI_BK_LICKBLOCK_LENGTH=22;
% NI_BK_LLICKBLOCK_NREW=23;
% NI_BK_MPC2BEH=24;
% NI_SPON_SWITCH=25;
% NI_BK_SPON_SWITCH=26;
% NI_ODDAV=27;
% NI_RT=28;

% n_TRIALS
% n_TRIALS=repmat(0,NTRIALS,12);
% n_TRIALS(:,1)=BLOCK_TRIALS(:,1); % mpc block
% n_TRIALS(:,2)=BLOCK_TRIALS(:,2); % beh block
% n_TRIALS(:,3)=ind_LIGHT_odd; % 1:ODD; 0:STD
% n_TRIALS(:,4)=ind_SOUND_odd; % 1:ODD; 0:STD
% n_TRIALS(:,5)=~isnan(TS_TRIALS(:,9)); % lick R_1st (new R lickcluster)
% n_TRIALS(:,6)=~isnan(TS_TRIALS(:,14)); % lick L_1st (new L lickcluster)
% n_TRIALS(:,7)= (isnan(TS_TRIALS(:,9)) & isnan(TS_TRIALS(:,14))); % miss
% n_TRIALS(:,8)=~isnan(TS_TRIALS(:,12)); % Rew R (1:Y, 0:N)
% n_TRIALS(:,9)=~isnan(TS_TRIALS(:,17)); % Rew L (1:Y, 0:N)
% % trials when rats were already licking;
% n_TRIALS(i_eliminate_R,10)=1;
% n_TRIALS(i_eliminate_L,10)=1;
% % trials when rats licked without leaving IR1 --> this is not reliable; do NOT use use criteria
% n_TRIALS(i_eliminate_R2,11)=1;
% n_TRIALS(i_eliminate_L2,11)=1;
% % trials when rats got rewarded and licked again before leaving IR1
% n_TRIALS(i_eliminate_R3,12)=1;
% n_TRIALS(i_eliminate_L3,12)=1;
% % for each trial with a new lick cluster:
% n_TRIALS(j(end),13)=LICK_DIR(i);
% n_TRIALS(j(end),14)=nRew(i);
% n_TRIALS(j(end),15)=nlicks(i);
% % for the FIRST trial of a NEW lick block
% if k==i
%     n_TRIALS(j(end),16)=LICKCLUSTER.LICKBLOCK_LENGTH(i);
%     n_TRIALS(j(end),17)=LICKCLUSTER.LICKBLOCK_REW(i);
%     n_TRIALS(j(end),18)=LICKCLUSTER.LICKBLOCK_NLICKS(i);
% end
% % these are reserved for later use
% %             n_TRIALS(j(end),19)=nRat;
% %             n_TRIALS(j(end),20)=nSession;
% %             n_TRIALS(j(end),21)=j(end); % trial number
% % for ALL trials within each lick block
% n_TRIALS(j(end),22)=LICKCLUSTER.LICKBLOCK_LENGTH(k);  % assign this for all lick clusters within a lick block
% n_TRIALS(j(end),23)=LICKCLUSTER.LICKBLOCK_REW(k); % assign this for all lick clusters within a lick block
% n_TRIALS(j(end),24)=any(j(end)>=mpc_block_start_id & j(end)<beh_block_trans_id_1');  % is this within transition period?
% n_TRIALS(:,25) = spontaneous transition y/n
% n_TRIALS(:,26) = entire spontaneous transition state (block_start:block_end = 1)
% n_TRIALS(:,27) = odd-odd

% BLOCK_TRIALS=repmat(nan,NTRIALS,6);
% column 1: mpc block
% column 2: beh block (smooth 1)
% column 3: beh block (smooth 3)
% column 4: beh block (smooth 5)
% column 5: beh block (smooth 7)
% column 6: beh block (smooth 9)


% TRANSITION
% TRANSITION.mpc_ts=changeTS;
% TRANSITION.mpc_dir=ind_block; % 1:L2S  2:S2L
% TRANSITION.beh_ts=ts_behtrans; (non-smoothed)
% TRANSITION.beh_postdir=post_dir_behtrans; % 1:Light(R), 2:Sound(L)
% TRANSITION.beh_lickcluster_id=i_behtrans;
% TRANSITION.mpc_id_trial=mpc_block_start_id;  % first trial in each new mpc block
% TRANSITION.beh_id_trial_def1=beh_block_trans_id_1;  % first trial in each new behavioral block (smooth=3) following each mpc block
% TRANSITION.beh_id_trial_def2
% TRANSITION.beh_id_trial_def3
% TRANSITION.beh_id_trial_def4

%% declare empty outputs; if there is a break 'return' in the code, it will return empty n_TRIALS

TS_TRIALS=[];
n_TRIALS=[];
BLOCK_TRIALS=[];
TRANSITION=[];
LICKCLUSTER=[];

%% get TS all
DELTA=0.001/2; % this is to prevent round off error

TS_LIGHT_ODD=BEH_get_TS(Data,3);
TS_LIGHT_STD=BEH_get_TS(Data,11);
TS_SOUND_ODD=BEH_get_TS(Data,51);
TS_SOUND_STD=BEH_get_TS(Data,49);

TS_IRR1_ON=BEH_get_TS(Data,33);
TS_IRL1_ON=BEH_get_TS(Data,41);
TS_IRR1_OFF=BEH_get_TS(Data,34);
TS_IRL1_OFF=BEH_get_TS(Data,42);
TS_Lick_R=BEH_get_TS(Data,35);
TS_Lick_L=BEH_get_TS(Data,43);
TS_REW_R=BEH_get_TS(Data,27);
TS_REW_L=BEH_get_TS(Data,31);

if contains(Data.MSN,'Reverse')  % reverse L/R association; for convenience, reverse assignment so that Light-->Right
    TS_IRR1_ON=BEH_get_TS(Data,41);
    TS_IRL1_ON=BEH_get_TS(Data,33);
    TS_IRR1_OFF=BEH_get_TS(Data,42);
    TS_IRL1_OFF=BEH_get_TS(Data,34);
    TS_Lick_R=BEH_get_TS(Data,43);
    TS_Lick_L=BEH_get_TS(Data,35);
    TS_REW_R=BEH_get_TS(Data,31);
    TS_REW_L=BEH_get_TS(Data,27);
end

%% get number of trials, timestamp of each trial

if contains(Data.MSN,'Single')
    
    %keyboard;
    [TS_LIGHT_TASK,ind]=sort([TS_LIGHT_ODD,TS_LIGHT_STD]);
    ind_LIGHT_odd_task=repmat(0,numel(TS_LIGHT_TASK),1);
    ind_LIGHT_odd_task(ind<=numel(TS_LIGHT_ODD))=1;
    
    [TS_SOUND_TASK,ind]=sort([TS_SOUND_ODD,TS_SOUND_STD]);
    ind_SOUND_odd_task=repmat(0,numel(TS_SOUND_TASK),1);
    ind_SOUND_odd_task(ind<=numel(TS_SOUND_ODD))=1;
    
    idxL=cumsum([1,floor(diff(TS_LIGHT_TASK))/2]);
    idxS=cumsum([1,floor(diff(TS_SOUND_TASK))/2]);
    
    % check if first trial is single modality
    if (TS_LIGHT_TASK(1)-TS_SOUND_TASK(1))>0.1  % don't set the cutoff at zero, because there is always a small difference
        idxL=idxL+floor(TS_LIGHT_TASK(1)-TS_SOUND_TASK(1))/2;
    elseif (TS_LIGHT_TASK(1)-TS_SOUND_TASK(1))<-0.1
        idxS=idxS+floor(-(TS_LIGHT_TASK(1)-TS_SOUND_TASK(1)))/2;
    end
   
    NTRIALS=max([idxL,idxS]);

    TS_LIGHT_ALL=nan(NTRIALS,1);
    TS_SOUND_ALL=nan(NTRIALS,1);
    
    TS_LIGHT_ALL(idxL)=TS_LIGHT_TASK;
    TS_SOUND_ALL(idxS)=TS_SOUND_TASK;
    TS=min([TS_LIGHT_ALL,TS_SOUND_ALL],[],2);

    ind_LIGHT_odd=repmat(0,NTRIALS,1);
    ind_LIGHT_std=repmat(0,NTRIALS,1);    
    ind_SOUND_odd=repmat(0,NTRIALS,1);
    ind_SOUND_std=repmat(0,NTRIALS,1);
    
    %keyboard;
    
    ind_LIGHT_odd(idxL(ind_LIGHT_odd_task==1))=1;
    ind_LIGHT_std(idxL(ind_LIGHT_odd_task==0))=1;
    
    ind_SOUND_odd(idxS(ind_SOUND_odd_task==1))=1;
    ind_SOUND_std(idxS(ind_SOUND_odd_task==0))=1;
    
    
else
    %keyboard;
    TS_LIGHT_ALL=[TS_LIGHT_ODD,TS_LIGHT_STD];
    TS_SOUND_ALL=[TS_SOUND_ODD,TS_SOUND_STD];
    if numel(TS_LIGHT_ALL)~=numel(TS_SOUND_ALL)
        warning('number of trials do not match!!!');
        return
    end

    
    NTRIALS=numel(TS_LIGHT_ALL);
    
    [TS_LIGHT_ALL,ind]=sort(TS_LIGHT_ALL);
    ind_LIGHT_odd=repmat(0,NTRIALS,1);
    ind_LIGHT_odd(ind<=numel(TS_LIGHT_ODD))=1;
    ind_LIGHT_std=repmat(0,NTRIALS,1);
    ind_LIGHT_std(ind>numel(TS_LIGHT_ODD))=1;
    
    [TS_SOUND_ALL,ind]=sort(TS_SOUND_ALL);
    ind_SOUND_odd=repmat(0,NTRIALS,1);
    ind_SOUND_odd(ind<=numel(TS_SOUND_ODD))=1;
    ind_SOUND_std=repmat(0,NTRIALS,1);
    ind_SOUND_std(ind>numel(TS_SOUND_ODD))=1;
    
    % trial time
    TS=min([TS_LIGHT_ALL; TS_SOUND_ALL]);
    TS=TS';
end

TS_TRIALS=repmat(nan,NTRIALS,TI_DIM);  % declare nan matrix in the beginning
TS_TRIALS(:,TI_TRIALTS)=TS;

%% Block types

% Assign block type
L2S=BEH_get_TS(Data,45);  % 1->2
S2L=BEH_get_TS(Data,46);  % 2->1

[changeTS,ind_temp]=sort([L2S,S2L]);
if isempty(changeTS), return; end

ind_block=[repmat(1,size(L2S)), repmat(2,size(S2L))];
ind_block=ind_block(ind_temp);

i_block=repmat(nan,NTRIALS,1);

j=find(TS<changeTS(1));
i_block(j)=ind_block(1);
for i=2:numel(changeTS)
    j=find(TS<changeTS(i) & TS>=changeTS(i-1));
    i_block(j)=ind_block(i);
end
j=find(TS>=changeTS(end));
i_block(j)=3-ind_block(end);
Block=i_block;


TS_TRIALS(:,TI_BK_MPC)=Block; % 1:L(Right), 2:S(Left)

TRANSITION.mpc_ts=changeTS;
TRANSITION.mpc_dir=ind_block; % 1:L2S  2:S2L

%% trial type: four stimulus combinations

TS_TRIALS(ind_LIGHT_odd==1,TI_VIS_ODD)=TS_LIGHT_ALL(ind_LIGHT_odd==1);
TS_TRIALS(ind_LIGHT_std==1,TI_VIS_STD)=TS_LIGHT_ALL(ind_LIGHT_std==1);
TS_TRIALS(ind_SOUND_odd==1,TI_AUD_ODD)=TS_SOUND_ALL(ind_SOUND_odd==1);
TS_TRIALS(ind_SOUND_std==1,TI_AUD_STD)=TS_SOUND_ALL(ind_SOUND_std==1);



% % assign IR on after cue
% [latency2IRR1,TS_IRR1on_1st]=sparse_distanceXY(TS,TS_IRR1_ON);
% [latency2IRL1,TS_IRL1on_1st]=sparse_distanceXY(TS,TS_IRL1_ON);
% 
% i=find(latency2IRR1<=RESP_WINDOW);
% TS_TRIALS(i,TI_IRR1ON)=TS_IRR1on_1st(i);
% 
% i=find(latency2IRL1<=RESP_WINDOW);
% TS_TRIALS(i,TI_IRLION)=TS_IRL1on_1st(i);


%% licking and reward clusters
thr=0.7;

[TS_RLick1st,TS_RLick_last]=lickcluster_includingsinglelick(TS_Lick_R,'ILI',thr);
[TS_LLick1st,TS_LLick_last]=lickcluster_includingsinglelick(TS_Lick_L,'ILI',thr);

% eliminate lick clusters that started before 1st stimulus presentation
i1=find(TS_RLick1st<TS(1));
TS_RLick1st(i1)=[];
TS_RLick_last(i1)=[];
i2=find(TS_LLick1st<TS(1));
TS_LLick1st(i2)=[];
TS_LLick_last(i2)=[];

i1=find(TS_RLick1st>(TS(end)+2));
TS_RLick1st(i1)=[];
TS_RLick_last(i1)=[];
i2=find(TS_LLick1st>(TS(end)+2));
TS_LLick1st(i2)=[];
TS_LLick_last(i2)=[];


% get first solenoid TS
thr=2;
if isempty(TS_REW_R) | isempty(TS_REW_L), return; end

[TS_REW_R_1st,~]=lickcluster_includingsinglelick(TS_REW_R,'ILI',thr);
[TS_REW_L_1st,~]=lickcluster_includingsinglelick(TS_REW_L,'ILI',thr);


%% R licks & L licks (a caveat is that this only deals with 1st lick cluster after each stim; sometimes there are two clusters

RESP_WINDOW=2.001+DELTA;  % response window in mpc is actually 2.0001s; add 0.5ms to ensure no round off error
% IR1ON is problematic... because rat might already be inside IR1

% RIGHT side
[rt_1st,temp_ts_1st,temp_ts_1st_ind]=sparse_distanceXY(TS,TS_RLick1st,'tolerance',0);
rt_last=TS_RLick_last(temp_ts_1st_ind)-TS';
temp_ts_last=TS_RLick_last(temp_ts_1st_ind);

[temp_ts0,rt0]=sparse_firstNafterX(TS,TS_IRR1_ON,1);
[temp_ts2,rt2]=sparse_firstNafterX(TS,TS_Lick_R,2);
[temp_ts3,rt3]=sparse_firstNafterX(TS,TS_Lick_R,3);

% THIS IS IMPORTANT: Reward delivery can occur after 2s; as long as the 1st lick is within 2s, and animal did not exit IR1 off;
[~,temp_ts_IRR1off]=sparse_distanceXY(temp_ts_1st,TS_IRR1_OFF);
[temp_ts4,~]=sparse_firstNafterX(TS,temp_ts_IRR1off,1); % this is the reward window;

% instead of ignoring trials in which rats are already licking at the time of stimulus onset, still label them and note the trial index in i_eliminate
i=find(rt0<=RESP_WINDOW);
TS_TRIALS(i,TI_IRR1ON)=temp_ts0(i); % IRR1ON within 2 s
i=find(rt_1st<=RESP_WINDOW);
TS_TRIALS(i,TI_RLICK1)=temp_ts_1st(i); % 1st lick
i=find(rt_1st<=RESP_WINDOW & rt2<=rt_last);
TS_TRIALS(i,TI_RLICK2)=temp_ts2(i);  % 2nd lick
i=find(rt_1st<=RESP_WINDOW & rt3<=rt_last);
TS_TRIALS(i,TI_RLICK3)=temp_ts3(i);  % 3rd lick

i=find(rt_1st<=RESP_WINDOW);
TS_TRIALS(i,TI_RLICKEND)=temp_ts_last(i); % last lick
TS_TRIALS(i,TI_IRR1OFF)=temp_ts4(i); % IRR1OFF in licking trials

% identify rewarded trials
% Add additional condition to account for split lick cluster in an oddball trials:
% example: In this case Odd trial is rewarded, but assigned to the next STD-STD trial
% Odd - (1st lick < 2s);  STD; (2nd-10th lick >2s); IRR1Off
ind1=find(ind_LIGHT_odd==1);
[rt_1st,ts_lick1st]=sparse_distanceXY(TS(ind1),TS_RLick1st,'tolerance',0);
ind2=find(rt_1st<=RESP_WINDOW); % light odd hit trial --> check IRR1off
[rt_IRR1off,ts_IRR1off_tmp]=sparse_distanceXY(ts_lick1st(ind2),TS_IRR1_OFF);
[rt_rew,ts_rew1_tmp]=sparse_distanceXY(ts_lick1st(ind2),TS_REW_R_1st);
ind3=ind1(ind2(rt_rew<rt_IRR1off)); % these are light odd trials that are rewarded
TS_TRIALS(ind3,TI_RREW1)=ts_rew1_tmp(rt_rew<rt_IRR1off);
TS_TRIALS(ind3,TI_IRR1OFF_postREW)=ts_IRR1off_tmp(rt_rew<rt_IRR1off);


% LEFT side
[rt_1st,temp_ts_1st,temp_ts_1st_ind]=sparse_distanceXY(TS,TS_LLick1st,'tolerance',0);
rt_last=TS_LLick_last(temp_ts_1st_ind)-TS';
temp_ts_last=TS_LLick_last(temp_ts_1st_ind);

[temp_ts0,rt0]=sparse_firstNafterX(TS,TS_IRL1_ON,1);
[temp_ts2,rt2]=sparse_firstNafterX(TS,TS_Lick_L,2);
[temp_ts3,rt3]=sparse_firstNafterX(TS,TS_Lick_L,3);

% THIS IS IMPORTANT: Reward delivery can occur after 2s; as long as the 1st lick is within 2s, and animal did not exit IR1 off;
[~,temp_ts_IRL1off]=sparse_distanceXY(temp_ts_1st,TS_IRL1_OFF);
[temp_ts4,rt4]=sparse_firstNafterX(TS,temp_ts_IRL1off,1); % this is the reward window;

% instead of ignoring trials in which rats are already licking at the time of stimulus onset, still label them and note the trial index in i_eliminate
i=find(rt0<=RESP_WINDOW);
TS_TRIALS(i,TI_IRL1ON)=temp_ts0(i); % IRR1ON within 2 s
i=find(rt_1st<=RESP_WINDOW);
TS_TRIALS(i,TI_LLICK1)=temp_ts_1st(i);  % left 1st lick
i=find(rt_1st<=RESP_WINDOW & rt2<=rt_last);
TS_TRIALS(i,TI_LLICK2)=temp_ts2(i); % 2nd lick
i=find(rt_1st<=RESP_WINDOW & rt3<=rt_last);
TS_TRIALS(i,TI_LLICK3)=temp_ts3(i); % 3rd lick

i=find(rt_1st<=RESP_WINDOW);
TS_TRIALS(i,TI_LLICKEND)=temp_ts_last(i); % last lick
TS_TRIALS(i,TI_IRL1OFF)=temp_ts4(i);  % IRL1_OFF in licked trials

% identify rewarded trials
% Add additional condition to account for split lick cluster in an oddball trials:
% example: In this case Odd trial is rewarded, but assigned to the next STD-STD trial
% Odd - (1st lick < 2s);  STD; (2nd-10th lick >2s); IRR1Off

ind1=find(ind_SOUND_odd==1);
[rt_1st,ts_lick1st]=sparse_distanceXY(TS(ind1),TS_LLick1st,'tolerance',0);
ind2=find(rt_1st<=RESP_WINDOW); % light odd hit trial --> check IRR1off
[rt_IRL1off,ts_IRL1off_tmp]=sparse_distanceXY(ts_lick1st(ind2),TS_IRL1_OFF);
[rt_rew,ts_rew1_tmp]=sparse_distanceXY(ts_lick1st(ind2),TS_REW_L_1st);
ind3=ind1(ind2(rt_rew<rt_IRL1off)); % these are light odd trials that are rewarded
TS_TRIALS(ind3,TI_LREW1)=ts_rew1_tmp(rt_rew<rt_IRL1off);
TS_TRIALS(ind3,TI_IRL1OFF_postREW)=ts_IRL1off_tmp(rt_rew<rt_IRL1off);


%% Deal with rewarded lick clusters
% Let's label them instead of eliminating them! do not adjust licking cluster in rewarded trials


if 1==1
    % if the lick cluster is rewarded, label the lickcluster before exiting the reward port (IR1off)
    % these lick clusters should be excluded from analysis
    
    Rlick_dur=TS_RLick_last-TS_RLick1st;
    nRew_R=sparse_countXY(TS_RLick1st,TS_REW_R,'minlag',0-DELTA,'maxlag',Rlick_dur+DELTA);
    
    ind=find(~isnan(TS_TRIALS(:,TI_RREW1))); % light oddball rewarded trials
    [~,~,ind1]=sparse_distanceXY(TS_TRIALS(ind,TI_TRIALTS),TS_RLick1st,'tolerance',0);
    [~,~,ind2]=sparse_distanceYX(TS_TRIALS(ind,TI_IRR1OFF_postREW),TS_RLick1st);
    
    eliminate_ind_R=[];
    for m=find((ind2-ind1)~=0)
        eliminate_ind_R=[eliminate_ind_R [ind1(m)+1:ind2(m)]];  % eliminate reward in non-target trials after a reward trial (lick before IR1off)
        if nRew_R(ind1(m))==0
            %keyboard;
            newRew_R=max(nRew_R(ind1(m)+1:ind2(m)));
            nRew_R(ind1(m))=newRew_R;
            nRew_R(ind1(m)+1:ind2(m))=0;
        end
    end
    
    if ~issorted(eliminate_ind_R), return; end
    
    Llick_dur=TS_LLick_last-TS_LLick1st;
    nRew_L=sparse_countXY(TS_LLick1st,TS_REW_L,'minlag',0-DELTA,'maxlag',Llick_dur+DELTA);
    
    ind=find(~isnan(TS_TRIALS(:,TI_LREW1))); % light oddball rewarded trials
    [~,~,ind1]=sparse_distanceXY(TS_TRIALS(ind,TI_TRIALTS),TS_LLick1st,'tolerance',0);
    [~,~,ind2]=sparse_distanceYX(TS_TRIALS(ind,TI_IRL1OFF_postREW),TS_LLick1st);
    
    eliminate_ind_L=[];
    for m=find((ind2-ind1)~=0)
        eliminate_ind_L=[eliminate_ind_L [ind1(m)+1:ind2(m)]];
        if nRew_L(ind1(m))==0
            %keyboard;
            newRew_L=max(nRew_L(ind1(m)+1:ind2(m)));
            nRew_L(ind1(m))=newRew_L;
            nRew_L(ind1(m)+1:ind2(m))=0;
        end
    end
    
    
    if ~issorted(eliminate_ind_L), return; end
    
end

LICKCLUSTER.R_1st=TS_RLick1st;
LICKCLUSTER.R_last=TS_RLick_last;
LICKCLUSTER.L_1st=TS_LLick1st;
LICKCLUSTER.L_last=TS_LLick_last;
LICKCLUSTER.R_eliminate_ind=eliminate_ind_R;
LICKCLUSTER.L_eliminate_ind=eliminate_ind_L;


nlicks_R=sparse_countXY(TS_RLick1st,TS_Lick_R,'minlag',-DELTA,'maxlag',Rlick_dur+DELTA);
nlicks_L=sparse_countXY(TS_LLick1st,TS_Lick_L,'minlag',-DELTA,'maxlag',Llick_dur+DELTA);
LICKCLUSTER.R_nlicks=nlicks_R;
LICKCLUSTER.L_nlicks=nlicks_L;
LICKCLUSTER.R_nRew=nRew_R;
LICKCLUSTER.L_nRew=nRew_L;


TS_Lick1st=[TS_RLick1st, TS_LLick1st];
[TS_Lick1st,i]=sort(TS_Lick1st);
TS_Licklast=[TS_RLick_last, TS_LLick_last];
if ~issorted(TS_Licklast(i)), return; end  % this should not be a problem now that we disable adjustment of licking cluster end
TS_Licklast=TS_Licklast(i);

LICK_DIR=repmat(-1,1,numel(TS_Lick1st));
LICK_DIR(i<=numel(TS_RLick1st))=1;


nRew=[nRew_R, nRew_L];
nRew=nRew(i);
nlicks=[nlicks_R, nlicks_L];
nlicks=nlicks(i);

LICKCLUSTER.RL_1st=TS_Lick1st;
LICKCLUSTER.RL_last=TS_Licklast;
LICKCLUSTER.RL_dir=LICK_DIR; % +1R, -1L
LICKCLUSTER.RL_nRew=nRew;
LICKCLUSTER.RL_nlicks=nlicks;


% without cumsum smoothing
%i_change=find(diff(LICK_DIR)~=0)+1;
lickcluster_id_1st=[1 find(diff(LICK_DIR)~=0)+1];
lickcluster_id_last=[find(diff(LICK_DIR)~=0) numel(LICK_DIR)];

LICKCLUSTER.LICKBLOCK_LENGTH=[lickcluster_id_last-lickcluster_id_1st+1];
LICKCLUSTER.LICKBLOCK_1st=lickcluster_id_1st;
LICKCLUSTER.LICKBLOCK_last=lickcluster_id_last;
LICKCLUSTER.LICKBLOCK_dir=LICK_DIR(lickcluster_id_1st);
for k=1:numel(lickcluster_id_1st)
    LICKCLUSTER.LICKBLOCK_REW(k)=sum(nRew(lickcluster_id_1st(k):lickcluster_id_last(k)));
    LICKCLUSTER.LICKBLOCK_NLICKS(k)=mean(nlicks(lickcluster_id_1st(k):lickcluster_id_last(k)));
end

%% trials labeled for elimination (removal from further analysis)


[rt_1st,~]=sparse_distanceXY(TS,TS_RLick1st,'tolerance',0);
[rt_last,~]=sparse_distanceXY(TS,TS_RLick_last);
%i_eliminate_R=find(rt_1st>rt_last & rt_last<RESP_WINDOW); % trials where rats were licking; should be excluded from analysis
i_eliminate_R=find(rt_1st>rt_last); % trials where rats were licking; should be excluded from analysis
% mostly standard-standard trials
i_eliminate_R2=find(TS_TRIALS(2:end,TI_RLICK1)<TS_TRIALS(1:end-1,TI_IRR1OFF))+1; % trials rats started to lick before leaving the IR1

[rt_1st,~]=sparse_distanceXY(TS,TS_RLick1st(eliminate_ind_R),'tolerance',0);
i_eliminate_R3=find(rt_1st<=RESP_WINDOW);
%n_TRIALS(:,8)=~isnan(TS_TRIALS(:,12)); % Rew R
i_eliminate_R3(~isnan(TS_TRIALS(i_eliminate_R3,TI_RREW1)))=[];


[rt_1st,~]=sparse_distanceXY(TS,TS_LLick1st,'tolerance',0);
[rt_last,~]=sparse_distanceXY(TS,TS_LLick_last);
%i_eliminate_L=find(rt_1st>rt_last & rt_last<RESP_WINDOW); % trials where rats were licking; should be excluded from analysis
i_eliminate_L=find(rt_1st>rt_last); % trials where rats were licking; should be excluded from analysis
% mostly standard-standard trials
i_eliminate_L2=find(TS_TRIALS(2:end,TI_LLICK1)<TS_TRIALS(1:end-1,TI_IRL1OFF))+1;  % IRR1 & IRL1 may not be very reliable
%keyboard;

[rt_1st,~]=sparse_distanceXY(TS,TS_LLick1st(eliminate_ind_L),'tolerance',0);
i_eliminate_L3=find(rt_1st<=RESP_WINDOW);
%n_TRIALS(:,9)=~isnan(TS_TRIALS(:,17)); % Rew L
i_eliminate_L3(~isnan(TS_TRIALS(i_eliminate_L3,TI_LREW1)))=[];


%% Use 1st lick to identify beh transition blocks
BLOCK_TRIALS=repmat(nan,NTRIALS,6);
% column 1: mpc block
% column 2: beh block (smooth 1)
% column 3: beh block (smooth 3)
% column 4: beh block (smooth 5)
% column 5: beh block (smooth 7)
% column 6: beh block (smooth 9)


%Add beh_block, ts_behtrans to TS_TRIALS n_TRIALS


for behtrans_smoothwin=[1:2:10] % try different smoothwin, 3 seems likes a good one. Need survey and quantification of beh_block length distribution
    %keyboard;
    dir_cumsum=smooth(cumsum(LICK_DIR),ones(1,behtrans_smoothwin));
    
    i_max=local_max(dir_cumsum);  % need to add one trial, that's when the transition actually starts
    i_min=local_max(-dir_cumsum);
    
    if LICK_DIR(1)==1 & i_min(1)==1, i_min(1)=[]; end
    if LICK_DIR(1)==-1 & i_max(1)==1, i_max(1)=[]; end
    
    i_R2L=i_max+1;
    i_L2R=i_min+1;
    
    for j=1:numel(i_R2L)
        while i_R2L(j)<numel(TS_Lick1st) & LICK_DIR(i_R2L(j))~=-1
            i_R2L(j)=i_R2L(j)+1;
        end
    end
    
    for j=1:numel(i_L2R)
        while i_L2R(j)<numel(TS_Lick1st) & LICK_DIR(i_L2R(j))~=1
            i_L2R(j)=i_L2R(j)+1;
        end
    end
    
    i_R2L(i_R2L>numel(TS_Lick1st))=[];
    i_L2R(i_L2R>numel(TS_Lick1st))=[];
    
    [i_behtrans,i]=sort([i_R2L, i_L2R]);
    post_dir_behtrans=repmat(1,1,numel(i_behtrans));
    post_dir_behtrans(i<=numel(i_R2L))=2;
    
%     i_behtrans(1)=[];
%     i_behtrans(end)=[];
%     post_dir_behtrans(1)=[];
%     post_dir_behtrans(end)=[];
    
    % timestamp of beh transition is defined as 0.1s before the previous stimulus
    % (within 2s).
    clear ts_behtrans
    [~,ts_lastcue]=sparse_distanceYX(TS_Lick1st(i_behtrans),TS);
    [~,ts_lastlick]=sparse_distanceYX(TS_Lick1st(i_behtrans)-DELTA,TS_Licklast); % this 1ms offset ensure that TS_Licklast gets the last lickcluser when a cluster is only ONE lick
    ts_behtrans(ts_lastcue>=ts_lastlick)=ts_lastcue(ts_lastcue>=ts_lastlick)-0.1;
    ts_behtrans(ts_lastcue<ts_lastlick)=ts_lastlick(ts_lastcue<ts_lastlick)+0.1;
    
    if behtrans_smoothwin==1 % <--- update to use non-smoothed version
        TRANSITION.beh_lickcluster_id=i_behtrans;
        TRANSITION.beh_postdir=post_dir_behtrans; % 1:Light(R), 2:Sound(L)
        TRANSITION.beh_ts=ts_behtrans;
    end
    
    if behtrans_smoothwin==3 & 1==0
        figure, plot(TS_Lick1st,smooth(cumsum(LICK_DIR),ones(1,behtrans_smoothwin)),'r-o')
        hold on, plot(TS_Lick1st,smooth(cumsum(LICK_DIR),ones(1,1)),'b-o')
        plot([ts_behtrans(post_dir_behtrans==1);ts_behtrans(post_dir_behtrans==1);],get(gca,'ylim'),'r')
        plot([ts_behtrans(post_dir_behtrans==2);ts_behtrans(post_dir_behtrans==2);],get(gca,'ylim'),'g')
        title('SMOOTH WIN=3; CURRENT SETTING IS 1');
    end
    
    pre_dir_behtrans=3-post_dir_behtrans;
    beh_block=repmat(nan,NTRIALS,1);
    
    %j=find(TS<ts_behtrans(1));
    % Using ts_behtrans here creates issues about first trial of a new block, which may occur in the next trial after licking to the opposite side
    % occurs. Intead, just use TS_Lick1st(i_behtrans)
    
    TS_Lick1st_TRAN=TS_Lick1st(i_behtrans);
    
    j=find(TS<=TS_Lick1st_TRAN(1));
    beh_block(1:(j(end)-1))=pre_dir_behtrans(1);
    
    for i=2:numel(TS_Lick1st_TRAN)
        j=find(TS<=TS_Lick1st_TRAN(i) & TS>TS_Lick1st_TRAN(i-1));
        beh_block(j-1)=pre_dir_behtrans(i);
    end
    j=find(TS>TS_Lick1st_TRAN(end));
    if ~isempty(j)
        beh_block([j(1)-1;j])=3-pre_dir_behtrans(end);
    else
        beh_block(end)=3-pre_dir_behtrans(end);
    end
    
    BLOCK_TRIALS(:,1+(behtrans_smoothwin+1)/2)=beh_block;
    %BLOCK_TRIALS(:,behtrans_smoothwin)=beh_block;
    %TS_TRIALS(:,1)=Block;
end

BLOCK_TRIALS(:,1)=TS_TRIALS(:,TI_BK_MPC); 


%% find the behavioral block transition trial after each mpc block transition (use smooth=3)
mpc_block_start_id=find(diff(BLOCK_TRIALS(:,1))~=0)+1;

% Definition#1: find first trial after mpc transition so that (BEH==MPC) SMOOTH_WIN==3
mpc_block_start_id=find(diff(BLOCK_TRIALS(:,1))~=0)+1;
tmp_BEH_TRANS_ID=find(diff(BLOCK_TRIALS(:,3))~=0);  % <---- SMOOTHED VERSION WIN=3
beh_block_start_id=[1; tmp_BEH_TRANS_ID+1];
beh_block_end_id=[tmp_BEH_TRANS_ID; NTRIALS];
same_block=find(BLOCK_TRIALS(:,1)==BLOCK_TRIALS(:,3));  % <----- SMOOTH VERSION WIN=3

beh_block_trans_id_1=[];

nBlockTran=numel(mpc_block_start_id);

for k=1:nBlockTran
    mpc_block_start=mpc_block_start_id(k); % trial_id of new mpc trial block
    j=find(beh_block_start_id >= mpc_block_start);
    %keyboard;
    if ~isempty(j)
    beh_block_trans_id_1=[beh_block_trans_id_1, beh_block_start_id(j(1))];
    end
end

if numel(beh_block_trans_id_1)<nBlockTran
    beh_block_trans_id_1=[beh_block_trans_id_1 NTRIALS];
end


TRANSITION.mpc_id_trial=mpc_block_start_id';
TRANSITION.beh_id_trial_def1=beh_block_trans_id_1;


%% n_TRIALS

n_TRIALS=repmat(0,NTRIALS,NI_DIM);

n_TRIALS(:,NI_BK_MPC)=BLOCK_TRIALS(:,1); % mpc block
n_TRIALS(:,NI_BK_BEH)=BLOCK_TRIALS(:,2); % beh block  <--- Update to make this the unsmoothed version
n_TRIALS(:,NI_VIS_ODD)=ind_LIGHT_odd;
n_TRIALS(:,NI_AUD_ODD)=ind_SOUND_odd;
n_TRIALS(:,NI_VIS_STD)=ind_LIGHT_std;
n_TRIALS(:,NI_AUD_STD)=ind_SOUND_std;
n_TRIALS(:,NI_ODDAV)=(n_TRIALS(:,NI_VIS_ODD)==1 & n_TRIALS(:,NI_AUD_ODD)==1); % odd-odd

n_TRIALS(:,NI_VIS_CH)=~isnan(TS_TRIALS(:,TI_RLICK1)); % lick R
n_TRIALS(:,NI_AUD_CH)=~isnan(TS_TRIALS(:,TI_LLICK1)); % lick L
n_TRIALS(:,NI_MISS)= (isnan(TS_TRIALS(:,TI_RLICK1)) & isnan(TS_TRIALS(:,TI_LLICK1))); % miss

n_TRIALS(:,NI_VIS_REW)=~isnan(TS_TRIALS(:,TI_RREW1)); % Rew R
n_TRIALS(:,NI_AUD_REW)=~isnan(TS_TRIALS(:,TI_LREW1)); % Rew L

% trials when rats were already licking; usually the previous trial or two trials before were a licking trials, most often a rewarded trial
n_TRIALS(i_eliminate_R,NI_REMOVE_CUEduringLICKING)=1;
n_TRIALS(i_eliminate_L,NI_REMOVE_CUEduringLICKING)=1;

% trials when rats licked without leaving IR1
n_TRIALS(i_eliminate_R2,NI_REMOVE_LICKwoIROFF)=1;
n_TRIALS(i_eliminate_L2,NI_REMOVE_LICKwoIROFF)=1;

% trials when rats got rewarded and licked again before leaving IR1
n_TRIALS(i_eliminate_R3,NI_REMOVE_LICK_postREWpreIROFF)=1;
n_TRIALS(i_eliminate_L3,NI_REMOVE_LICK_postREWpreIROFF)=1;


%% Lick-cluster based coding
% this section is a verification based on lick clusters; potential issues are two lick clusters within 2s window; sometimes these can be opposite
% directions... these are excluded for further analysis now, but the opposite direction trials might be interesting
j_temp=-1;
for i=1:numel(TS_Lick1st)
    j=find(TS<=TS_Lick1st(i));
    if ~isempty(j) & n_TRIALS(j(end),NI_MISS)==0 % in get_TRIALS, we have the additional condition that lick clusters don't count if the animal was already licking at cue onset
        if j(end)~=j_temp % make sure only one lick cluster in each trial
        j_temp=j(end);
        if n_TRIALS(j(end),NI_NREW)==0  % if the trial is not rewarded yet; this prevents subsequent non-rewarded lick clusters overwrite earlier ones
            n_TRIALS(j(end),NI_LICK_DIR)=LICK_DIR(i);
            n_TRIALS(j(end),NI_NREW)=nRew(i);
            n_TRIALS(j(end),NI_NLICK)=nlicks(i);
            
            % these are reserved for later use
            %             n_TRIALS(j(end),19)=nRat;
            %             n_TRIALS(j(end),20)=nSession;
            %             n_TRIALS(j(end),21)=j(end); % trial number
            
            % this is assigned to ALL trials within each lick block
            k=find(lickcluster_id_1st<=i);
            k=k(end);
            n_TRIALS(j(end),NI_BK_LICKBLOCK_LENGTH)=LICKCLUSTER.LICKBLOCK_LENGTH(k);  % assign this for all lick clusters within a lick block
            n_TRIALS(j(end),NI_BK_LLICKBLOCK_NREW)=LICKCLUSTER.LICKBLOCK_REW(k); % assign this for all lick clusters within a lick block
            %n_TRIALS(j(end),24)=any(j(end)>=mpc_block_start_id & j(end)<beh_block_trans_id_1');  % is this within transition period?
            
            % this is assigned to the first trial of each lick block
            if lickcluster_id_1st(k)==i
                n_TRIALS(j(end),NI_LICKBLOCK_LENGTH)=LICKCLUSTER.LICKBLOCK_LENGTH(k);
                n_TRIALS(j(end),NI_LICKBLOCK_NREW)=LICKCLUSTER.LICKBLOCK_REW(k);
                n_TRIALS(j(end),NI_LICKBLOCK_NLICK)=LICKCLUSTER.LICKBLOCK_NLICKS(k);
            end
        end
        end
    end
end


% Need to update LICK_DIR because the 2nd lick-cluster in the same trial would overwrite the lick direction
% which may give the opposite lick direction, and also a slower RT estimate

rt1=TS_TRIALS(:,TI_RLICK1)-TS_TRIALS(:,TI_TRIALTS);
rt2=TS_TRIALS(:,TI_LLICK1)-TS_TRIALS(:,TI_TRIALTS);
[rt3,lick_dir_i]=min([rt1,rt2],[],2);

i1=find(n_TRIALS(:,NI_VIS_CH)==1);
i2=find(n_TRIALS(:,NI_AUD_CH)==1);
i3=intersect(i1,i2);

% need update here
% n_TRIALS(j(end),NI_LICK_DIR)=LICK_DIR(i);
% n_TRIALS(j(end),NI_NREW)=nRew(i);
% n_TRIALS(j(end),NI_NLICK)=nlicks(i);

if ~isempty(i3)    
    n_TRIALS(i3,NI_LICK_DIR)=(lick_dir_i(i3)-1.5)*-2;
    for k=1:numel(i3)
       if n_TRIALS(i3(k),NI_LICK_DIR)==1 % ChV
          temp_nRew=sparse_countXY(TS_TRIALS(i3(k),TI_RLICK1),TS_REW_R,'minlag',-DELTA,...
              'maxlag',TS_TRIALS(i3(k),TI_RLICKEND)-TS_TRIALS(i3(k),TI_RLICK1)+DELTA);
          n_TRIALS(i3(k),NI_NREW)=temp_nRew;

          temp_nLicks=sparse_countXY(TS_TRIALS(i3(k),TI_RLICK1),TS_Lick_R,'minlag',-DELTA,...
              'maxlag',TS_TRIALS(i3(k),TI_RLICKEND)-TS_TRIALS(i3(k),TI_RLICK1)+DELTA);
          n_TRIALS(i3(k),NI_NLICK)=temp_nLicks;
           
       elseif n_TRIALS(i3(k),NI_LICK_DIR)==-1 % ChA
           
          temp_nRew=sparse_countXY(TS_TRIALS(i3(k),TI_LLICK1),TS_REW_L,'minlag',-DELTA,...
              'maxlag',TS_TRIALS(i3(k),TI_LLICKEND)-TS_TRIALS(i3(k),TI_LLICK1)+DELTA);
          n_TRIALS(i3(k),NI_NREW)=temp_nRew;

          temp_nLicks=sparse_countXY(TS_TRIALS(i3(k),TI_LLICK1),TS_Lick_L,'minlag',-DELTA,...
              'maxlag',TS_TRIALS(i3(k),TI_LLICKEND)-TS_TRIALS(i3(k),TI_LLICK1)+DELTA);
          n_TRIALS(i3(k),NI_NLICK)=temp_nLicks;
       end
        
    end
    
end

n_TRIALS(:,NI_RT)=rt3;

%% Behavioral Transition Def #2 - #5 (Any Odd? Any odd+lick? Any Rew? 1st Rew?)

% Definition#2: the first new lick block should contain at least one odd-lick trial

mpc_block_start_id=find(diff(BLOCK_TRIALS(:,1))~=0)+1;
tmp_BEH_TRANS_ID=find(diff(BLOCK_TRIALS(:,2))~=0);
beh_block_start_id=[1; tmp_BEH_TRANS_ID+1];
beh_block_end_id=[tmp_BEH_TRANS_ID; NTRIALS];
same_block=find(BLOCK_TRIALS(:,1)==BLOCK_TRIALS(:,2));  % <-- NON-SMOOTHED VERSION
% need to deal with rare cases where lick block switching occurred during [T-1, T] trial
for k=1:numel(beh_block_start_id)
    if any((beh_block_start_id(k)-mpc_block_start_id)==-1)  % check next trial
        if BLOCK_TRIALS(beh_block_start_id(k)+1,1)==BLOCK_TRIALS(beh_block_start_id(k)+1,2)
            same_block=[same_block; beh_block_start_id(k)]; % add this beh_block if the next trial is the same direction as MPC block
        else
            same_block(same_block==beh_block_start_id(k))=[];
        end
    end
end



beh_block_trans_id_2=[];
beh_block_trans_id_3=[];
beh_block_trans_id_4=[];
beh_block_trans_id_5=[];

nBlockTran=numel(mpc_block_start_id);

for k=1:nBlockTran
    mpc_block_start=mpc_block_start_id(k); % trial_id of new mpc trial block
	for j=find(beh_block_start_id >= (mpc_block_start-1))'
        beh_block_start=beh_block_start_id(j);
        beh_block_end=beh_block_end_id(j);
        
        if ismember(beh_block_start,same_block) 
            anyOdd=sum(n_TRIALS(beh_block_start:beh_block_end,NI_VIS_ODD))+sum(n_TRIALS(beh_block_start:beh_block_end,NI_AUD_ODD));
            if anyOdd>0
                beh_block_trans_id_2=[beh_block_trans_id_2, beh_block_start];
                break;
            end
        end
    end
end

for k=1:nBlockTran
    mpc_block_start=mpc_block_start_id(k); % trial_id of new mpb trial block
	for j=find(beh_block_start_id >= (mpc_block_start-1))'
        beh_block_start=beh_block_start_id(j);
        beh_block_end=beh_block_end_id(j);
        
        if ismember(beh_block_start,same_block) 
            anyOdd_Lick=sum( (n_TRIALS(beh_block_start:beh_block_end,NI_VIS_ODD)==1 & n_TRIALS(beh_block_start:beh_block_end,NI_VIS_CH)==1) ...
                | (n_TRIALS(beh_block_start:beh_block_end,NI_AUD_ODD)==1 & n_TRIALS(beh_block_start:beh_block_end,NI_AUD_CH)==1) ); 
            if anyOdd_Lick>0
                beh_block_trans_id_3=[beh_block_trans_id_3, beh_block_start];
                break;
            end
        end
    end
end

for k=1:nBlockTran
    mpc_block_start=mpc_block_start_id(k); % trial_id of new mpb trial block
	for j=find(beh_block_start_id >= (mpc_block_start-1))'
        beh_block_start=beh_block_start_id(j);
        beh_block_end=beh_block_end_id(j);
        
        if ismember(beh_block_start,same_block) 
            anyRew=find( (n_TRIALS(beh_block_start:beh_block_end,NI_VIS_REW)==1 | n_TRIALS(beh_block_start:beh_block_end,NI_AUD_REW)==1)); 
            if ~isempty(anyRew) %anyRew>0
                beh_block_trans_id_4=[beh_block_trans_id_4, beh_block_start];
                
                trial_seq=[beh_block_start:beh_block_end];
                beh_block_trans_id_5=[beh_block_trans_id_5, trial_seq(anyRew(1))];
                
                break;
            end
        end
    end
end

% add the last trial if the last transition is missing
if numel(beh_block_trans_id_2)<nBlockTran
    beh_block_trans_id_2=[beh_block_trans_id_2 NTRIALS];
end
if numel(beh_block_trans_id_3)<nBlockTran
    beh_block_trans_id_3=[beh_block_trans_id_3 NTRIALS];
end
if numel(beh_block_trans_id_4)<nBlockTran
    beh_block_trans_id_4=[beh_block_trans_id_4 NTRIALS];
end
if numel(beh_block_trans_id_5)<nBlockTran
    beh_block_trans_id_5=[beh_block_trans_id_5 NTRIALS];
end

TRANSITION.beh_id_trial_def2=beh_block_trans_id_2;
TRANSITION.beh_id_trial_def3=beh_block_trans_id_3;
TRANSITION.beh_id_trial_def4=beh_block_trans_id_4;
TRANSITION.beh_id_trial_def5=beh_block_trans_id_5;



% is this trial during behavioral transition? Use DEF#4 as the most conservative definition
% for i=1:numel(TS_Lick1st)
%     j=find(TS<TS_Lick1st(i));
%     if ~isempty(j) & n_TRIALS(j(end),7)==0 %
%         %keyboard;
%             n_TRIALS(j(end),24)=any(j(end)>=mpc_block_start_id & j(end)<beh_block_trans_id_4');  % is this within transition period?
%     end
% end

for i=1:NTRIALS
    n_TRIALS(i,NI_BK_MPC2BEH)=any(i>=mpc_block_start_id & i<beh_block_trans_id_4');  % is this within transition period?
end

for i=1:NTRIALS
    n_TRIALS(i,NI_BK_MPC2NEWREW)=any(i>=mpc_block_start_id & i<beh_block_trans_id_5');  % is this within transition period?
end
%% Spontaneous transition


tmp_BEH_TRANS_ID=find(diff(BLOCK_TRIALS(:,2))~=0); % last trial ID of each BEH block <-- unsmoothed version

%tmp_BEH_TRANS_ID=[tmp_BEH_TRANS_ID; NTRIALS]; % Pad the last entry NTRIALS
% when we charactere all BEH blocks, the last block ending in NTRIALS should be excluded
% because it is a truncated block.

numNonRewOddA=repmat(0,numel(tmp_BEH_TRANS_ID),1);
numNonRewOddAChA=repmat(0,numel(tmp_BEH_TRANS_ID),1);
numNonRewOddV=repmat(0,numel(tmp_BEH_TRANS_ID),1);
numNonRewOddVChV=repmat(0,numel(tmp_BEH_TRANS_ID),1);

for block_id=0:numel(tmp_BEH_TRANS_ID)-1  % does not deal with the last licking block of the session
    if block_id>0
        block_start=tmp_BEH_TRANS_ID(block_id)+1;
    else
        block_start=1;
    end
    %block_end=tmp_BEH_TRANS_ID(block_id+1);
    
    % eg VAV switch
    % block length calculation is restricted to trials where animals licked A side
    % but alignment at blockend for transition analysis should be at the start of the next V side
    % VVVVVAAAAA(Nolick)VVVV
    
    block_end_temp=tmp_BEH_TRANS_ID(block_id+1);
    blocklength_2nextswitch(block_id+1)=(block_end_temp-block_start)+1; % this is for alignment of the start of the next switch
    
    j=find(n_TRIALS(1:block_end_temp,NI_LICK_DIR)~=0);
    if ~isempty(j)
        block_end=j(end);
    else
        block_end=block_end_temp;
    end
        
    blocktrials=block_start:block_end;
    
    blockstart(block_id+1)=block_start;
    blocklength(block_id+1)=numel(blocktrials);
    
    % ALL non rewarded lick blocks; this is a simpler definition, and mostly get at the same spontaneous transitions
    if sum(n_TRIALS(blocktrials,NI_VIS_REW))==0 & sum(n_TRIALS(blocktrials,NI_AUD_REW))==0 % & (block_end-block_start+1)>=3
        
        numNonRewOddA(block_id+1)=sum(n_TRIALS(blocktrials,NI_BK_MPC)==1 & BLOCK_TRIALS(blocktrials,2)==2 & ...
            n_TRIALS(blocktrials,NI_AUD_ODD)==1);
        numNonRewOddAChA(block_id+1)=sum(n_TRIALS(blocktrials,NI_BK_MPC)==1 & BLOCK_TRIALS(blocktrials,2)==2 & ...
            n_TRIALS(blocktrials,NI_AUD_ODD)==1 & n_TRIALS(blocktrials,NI_AUD_CH)==1);
        numNonRewOddV(block_id+1)=sum(n_TRIALS(blocktrials,NI_BK_MPC)==2 & BLOCK_TRIALS(blocktrials,2)==1 & ...
            n_TRIALS(blocktrials,NI_VIS_ODD)==1);
        numNonRewOddVChV(block_id+1)=sum(n_TRIALS(blocktrials,NI_BK_MPC)==2 & BLOCK_TRIALS(blocktrials,2)==1 & ...
            n_TRIALS(blocktrials,NI_VIS_ODD)==1 & n_TRIALS(blocktrials,NI_VIS_CH)==1);
    end
end

i1=find(numNonRewOddAChA>=2 & numNonRewOddA<=numNonRewOddAChA*2);
i2=find(numNonRewOddVChV>=2 & numNonRewOddV<=numNonRewOddVChV*2);

spon_tran_id=[i1; i2];
spon_tran_id=sort(spon_tran_id);

n_TRIALS(blockstart(spon_tran_id),NI_SPON_SWITCH)=1; % block_start: start of each spontaneous transition

for k=1:numel(spon_tran_id)
    n_TRIALS(blockstart(spon_tran_id(k)):blockstart(spon_tran_id(k))+blocklength(spon_tran_id(k))-1,NI_BK_SPON_SWITCH)=1;
end

for k=1:numel(spon_tran_id)
    n_TRIALS(blockstart(spon_tran_id(k)):blockstart(spon_tran_id(k))+blocklength_2nextswitch(spon_tran_id(k))-1,NI_BK_SPON_SWITCH_NEXTSTART)=1;
end


%% Switch trials

ind=find(diff(n_TRIALS(:,2))~=0)+1;
n_TRIALS(ind,NI_DIR_SWITCH)=1;
ind=find(n_TRIALS(:,NI_VIS_CH)==1 & n_TRIALS(:,NI_AUD_CH)==1);
n_TRIALS(ind,NI_DIR_SWITCH)=1;







