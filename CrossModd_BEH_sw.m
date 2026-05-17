%% mpc2beh

ID=['LK05';'LK06';'LK09';'LK10';'LK11';'LL01';'LL02';'LL03';'LL04'];
for i=1:size(ID,1)
    mpc2beh('ID',ID(i,:));
end
%%
clear all
cd '/Volumes/linlab_sync/Matlab_Scripts/Updates/crossmodal/'
load LOOKUP_crossmodal.mat

cd /Volumes/ZonaIncerta_DATA/Szwen_Data/Behavior_data/BEH_database/
RAT=['LK05';'LK06';'LK09';'LK10';'LK11';'LL01';'LL02';'LL03';'LL04'];
RAT=['LL04'];
startdate=251014;
enddate=260000;

for r=1:size(RAT,1)
    ratname=RAT(r,:);
    cd /Volumes/ZonaIncerta_DATA/Szwen_Data/Behavior_data/BEH_database/
    files=dir([ratname,'*.beh']);
    
    % path choice
    if contains(ratname(1),'R') | contains(ratname,'LA') | contains(ratname,'LD')
        path_figure='/Volumes/ZonaIncerta_DATA/Szwen_Data/sync_ZonaIncerta/CrossMOdd/';
        save_folder='/Volumes/ZonaIncerta_DATA/Szwen_Data/sync_ZonaIncerta/CrossMOdd/PSTH/';
        savedir=[save_folder,ratname,'/'];
    else
        path_figure='/Volumes/ZonaIncerta_DATA/Szwen_Data/sync_ZonaIncerta/CrossMTRN/BEH/';
        savedir=[path_figure,ratname,'/'];
    end
    figure_file=dir([path_figure,ratname,'/','*.jpg']);
    if isempty(startdate) & ~isempty(figure_file)
        d1=str2double(figure_file(1).name(6:11));
        dend=str2double(figure_file(end).name(6:11));
        RAT_startdate=max([d1;dend]);
    else
        RAT_startdate=startdate;
    end
    for j=1:length(files)
        if str2double(files(j).name(6:11))>=startdate & str2double(files(j).name(6:11))<=enddate & ~contains(files(j).name,'MOL') & ~contains(files(j).name,'SAL')
            ID=(files(j).name(1:11));
            Data=ReadBehData(ID);
            if contains(Data.MSN,'Resp4')
                t=4;
            else
                t=2;
            end
            
            figure;
            x0=500;
            y0=500;
            width=2000;
            height=1000;
            set(gcf,'position',[x0,y0,width,height])
            
            if contains(Data.MSN,'SingleModd') | contains(Data.MSN,'LIGHTodd')
                subplot(3,5,[1,2,6,7])
                ts=BEH_get_TS(Data,3);
                RTr=sparse_distanceXY(ts,BEH_get_TS(Data,35));
                RTl=sparse_distanceXY(ts,BEH_get_TS(Data,43));
                [RT,class]=min([RTr;RTl]);
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',1-class,'sort_RT',RT)
                title(['Light','-Odd'])
                
                subplot(3,5,[3,4,8,9])
                ts=BEH_get_TS(Data,51);
                if contains(Data.MSN,'AUDswap')
                    ts=BEH_get_TS(Data,49);
                end
                if ~isempty(ts)
                    RTr=sparse_distanceXY(ts,BEH_get_TS(Data,35));
                    RTl=sparse_distanceXY(ts,BEH_get_TS(Data,43));
                    [RT,class]=min([RTr;RTl]);
                    BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',1-class,'sort_RT',RT)
                    title(['Sound','-Odd'])
                end
                
                TS_LIGHT_ODD=BEH_get_TS(Data,3);
                TS_SOUND_ODD=BEH_get_TS(Data,51);
                if contains(Data.MSN,'AUDswap')
                    TS_SOUND_ODD=BEH_get_TS(Data,49);
                end
                TS_Lick_R=BEH_get_TS(Data,35);
                TS_Lick_L=BEH_get_TS(Data,43);
                TS_REW_R=BEH_get_TS(Data,27);
                TS_REW_L=BEH_get_TS(Data,31);
                
                if ~isempty(TS_SOUND_ODD)
                    [ts,trial]=sort([TS_LIGHT_ODD,TS_SOUND_ODD]);
                    y=[-ones(1,length(TS_LIGHT_ODD))+0.5,ones(1,length(TS_SOUND_ODD))-0.5];
                    y=y(trial);
                    yA=y;
                    yA(y<0)=0;
                    yV=y;
                    yV(y>0)=0;
                    x=(1:1:length(ts));
                    % Lick
                    xlickV=sparse_distanceXY(ts,TS_Lick_R);
                    xlickA=sparse_distanceXY(ts,TS_Lick_L);
                    [xlickAV,xlick]=min([xlickA;xlickV]);
                    xlickAV=x(xlickAV<=t);
                    xlick(xlick==2)=-1;
                    
                    % Reward
                    ITI=sparse_distanceXY(ts,[ts,ts(1)+3600]);
                    xREWV=sparse_distanceXY(ts,TS_REW_R);
                    xREWA=sparse_distanceXY(ts,TS_REW_L);
                    
                    subplot(3,5,[11,12,13,14,15]);hold on;
                    % Cue
                    bar(x,yA,'EdgeColor','none','FaceColor',[0.3 0.5 0.01],'BarWidth',0.5)
                    bar(x,yV,'EdgeColor','none','FaceColor',[0.8500 0.3250 0.0980],'BarWidth',0.5)
                    plot(x,zeros(1,length(x)),'k-','LineWidth',1)
                    
                    % Lick
                    % Sound Lick
                    x1=xlickAV(xlick(xlickAV)>0 & y(xlickAV)>0);
                    plot(x1,xlick(x1)-0.2,'bv')
                    x1=xlickAV(xlick(xlickAV)<0 & y(xlickAV)>0);
                    plot(x1,xlick(x1)+0.2,'b^')
                    
                    % Light Lick
                    x1=xlickAV(xlick(xlickAV)>0 & y(xlickAV)<0);
                    plot(x1,xlick(x1)-0.2,'rv')
                    x1=xlickAV(xlick(xlickAV)<0 & y(xlickAV)<0);
                    plot(x1,xlick(x1)+0.2,'r^')
                    
                    % REW
                    if ~isempty(xREWV)
                        xREWV=x(xREWV<=ITI);
                        plot(xREWV,zeros(1,length(xREWV))-1,'o','color',[0.3010 0.7450 0.9330],'MarkerFaceColor',[0.3010 0.7450 0.9330])
                    end
                    if ~isempty(xREWA)
                        xREWA=x(xREWA<=ITI);
                        plot(xREWA,zeros(1,length(xREWA))+1,'o','color',[0.3010 0.7450 0.9330],'MarkerFaceColor',[0.3010 0.7450 0.9330])
                    end
                    
                    % Odd trial count
                    subplot(3,5,5); hold on;
                    b=bar([1,2],[length(TS_SOUND_ODD),length(TS_LIGHT_ODD)]);
                    b.FaceColor = 'flat';
                    b.CData(1,:) = [0 0 1];
                    b.CData(2,:) = [1 0 0];
                    text(0.9,length(TS_SOUND_ODD)+3,num2str(length(TS_SOUND_ODD)))
                    text(1.9,length(TS_LIGHT_ODD)+3,num2str(length(TS_LIGHT_ODD)))
                    title('Oddball trials')
                    
                    % Reward trial count
                    subplot(3,5,10); hold on;
                    REW_L=ceil(length(TS_REW_L)/3);
                    REW_R=ceil(length(TS_REW_R)/3);
                    b=bar([1,2],[length(REW_L),length(REW_R)]);
                    b.FaceColor = 'flat';
                    b.CData(1,:) = [0 0 1];
                    b.CData(2,:) = [1 0 0];
                    text(0.9,length(REW_L)+3,num2str(length(REW_L)))
                    text(1.9,length(REW_R)+3,num2str(length(REW_R)))
                    title('Reward trials')
                    
                else
                    [ts,trial]=sort([TS_LIGHT_ODD]);
                    y=[-ones(1,length(TS_LIGHT_ODD))+0.5];
                    y=y(trial);
                    yV=y;
                    yV(y>0)=0;
                    x=(1:1:length(ts));
                    % Lick
                    xlickV=sparse_distanceXY(ts,TS_Lick_R);
                    xlickA=sparse_distanceXY(ts,TS_Lick_L);
                    [xlickAV,xlick]=min([xlickA;xlickV]);
                    xlickAV=x(xlickAV<=t);
                    xlick(xlick==2)=-1;
                    % Reward
                    ITI=sparse_distanceXY(ts,[ts,ts(1)+3600]);
                    xREWV=sparse_distanceXY(ts,TS_REW_R);
                    subplot(3,5,[11,12,13,14,15]);hold on;
                    % Cue
                    bar(x,yV,'EdgeColor','none','FaceColor',[0.8500 0.3250 0.0980],'BarWidth',0.5)
                    plot(x,zeros(1,length(x)),'k-','LineWidth',1)
                    % Light Lick
                    x1=xlickAV(xlick(xlickAV)>0 & y(xlickAV)<0);
                    plot(x1,xlick(x1)-0.2,'rv')
                    x1=xlickAV(xlick(xlickAV)<0 & y(xlickAV)<0);
                    plot(x1,xlick(x1)+0.2,'r^')
                    % REW
                    if ~isempty(xREWV)
                        xREWV=x(xREWV<=ITI);
                        plot(xREWV,zeros(1,length(xREWV))-1.3,'o','color',[0.3010 0.7450 0.9330],'MarkerFaceColor',[0.3010 0.7450 0.9330])
                    end
                end
            elseif contains(Data.MSN,'SingleM') & ~contains(Data.MSN,'CrossM')
                
                TS_LIGHT_ODD=BEH_get_TS(Data,3);
                TS_LIGHT_STD=BEH_get_TS(Data,11);
                TS_SOUND_ODD=BEH_get_TS(Data,51);
                TS_SOUND_STD=BEH_get_TS(Data,49);
                
                if contains(Data.MSN,'AUDswap')
                    TS_SOUND_ODD=BEH_get_TS(Data,49);
                    TS_SOUND_STD=BEH_get_TS(Data,51);
                end
                
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
                
                % Stimulus & block
                ID_LightOdd=zeros(length(TS_LIGHT_ODD),1)+NI_VIS_ODD;
                ID_LightSTD=zeros(length(TS_LIGHT_STD),1)+NI_VIS_STD;
                ID_SoundOdd=zeros(length(TS_SOUND_ODD),1)+NI_AUD_ODD;
                ID_SoundSTD=zeros(length(TS_SOUND_STD),1)+NI_AUD_STD;
                
                [TS_TRIALS,I]=sort([TS_LIGHT_ODD,TS_LIGHT_STD,TS_SOUND_ODD,TS_SOUND_STD]);
                ID_TRIALS=[ID_LightOdd;ID_LightSTD;ID_SoundOdd;ID_SoundSTD];
                ID_TRIALS=ID_TRIALS(I);
                TS_TRIALS=[ones(length(TS_TRIALS),1),TS_TRIALS'];
                TS_TRIALS(ID_TRIALS==NI_AUD_ODD,1)=2;
                TS_TRIALS(ID_TRIALS==NI_AUD_STD,1)=2;
                
                % Licking & Reward cluster
                thr=0.7;
                TS=TS_TRIALS(:,2);
                
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
                if ~isempty(TS_REW_R)
                    [TS_REW_R_1st,~]=lickcluster_includingsinglelick(TS_REW_R,'ILI',thr);
                end
                
                if ~isempty(TS_REW_L)
                    [TS_REW_L_1st,~]=lickcluster_includingsinglelick(TS_REW_L,'ILI',thr);
                end
                
%                 [TS_TRIALS,n_TRIALS, BLOCK_TRIALS, TRANSITION, LICKCLUSTER]=get_TRIALS_crossmodal(Data);
                
                % PSTH
                TS_Rlick=TS_RLick1st;
                TS_Llick=TS_LLick1st;
                
                % bkA stimA
                subplot(3,5,[1,6])
                i=find(TS_TRIALS(:,NI_BK_MPC)==2 & ID_TRIALS==NI_AUD_ODD);
                ts=TS_TRIALS(i,2);
                RTr=sparse_distanceXY(ts,TS_Rlick);
                RTl=sparse_distanceXY(ts,TS_Llick);
                [RT,class]=min([RTr;RTl]);
                class(RT>t)=0;
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',class,'sort_RT',RT)
                title('bkA stimA')
                
                % bkA stimS
                subplot(3,5,[2,7])
                i=find(TS_TRIALS(:,NI_BK_MPC)==2 & ID_TRIALS==NI_AUD_STD);
                ts=TS_TRIALS(i,2);
                RTr=sparse_distanceXY(ts,TS_Rlick);
                RTl=sparse_distanceXY(ts,TS_Llick);
                [RT,class]=min([RTr;RTl]);
                class(RT>t)=0;
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',class,'sort_RT',RT)
                title('bkA stimS')
                
                % bkV stimV
                subplot(3,5,[3,8])
                i=find(TS_TRIALS(:,NI_BK_MPC)==1 & ID_TRIALS==NI_VIS_ODD);
                ts=TS_TRIALS(i,2);
                RTr=sparse_distanceXY(ts,TS_Rlick);
                RTl=sparse_distanceXY(ts,TS_Llick);
                [RT,class]=min([RTr;RTl]);
                class(RT>t)=0;
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',class,'sort_RT',RT)
                title('bkV stimV')
                
                % bkV stimS
                subplot(3,5,[4,9])
                i=find(TS_TRIALS(:,NI_BK_MPC)==1 & ID_TRIALS==NI_VIS_STD);
                ts=TS_TRIALS(i,2);
                RTr=sparse_distanceXY(ts,TS_Rlick);
                RTl=sparse_distanceXY(ts,TS_Llick);
                [RT,class]=min([RTr;RTl]);
                class(RT>t)=0;
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',class,'sort_RT',RT)
                title('bkV stimS')
                
                % Trial
                colorcue=[0.6350 0.0780 0.1840;0 0.4470 0.7410];
                color=[0.98 0.45 0.1;0.3 0.7 0.01];
                BLOCK=TS_TRIALS(:,NI_BK_MPC);
                TRANS=find([0;diff(BLOCK)]~=0);
                TS=TS_TRIALS(:,2);
                x=(1:1:length(TS))';
                
                ax=subplot(3,5,[11,12,13,14,15]);hold on; 
                MPC_BLOCK=[-2;find(diff(BLOCK(:,1))~=0);x(end)];
                for i=1:length(MPC_BLOCK)-1
                    hold on
                    patch([MPC_BLOCK(i)+0.5,MPC_BLOCK(i+1)+0.5,MPC_BLOCK(i+1)+0.5,MPC_BLOCK(i)+0.5],[-2,-2,2,2],color(BLOCK(MPC_BLOCK(i+1),1),:),'LineStyle','none','FaceAlpha',0.15)
                end
                
                % Cue
                y1=zeros(sum(~isnan(TS)),1);
                y2=ID_TRIALS==NI_VIS_ODD;
                x1=x(y2==1);
                plot([x1,x1]',[y1(y2==1),y1(y2==1)-0.35]','color','r','LineWidth',2)
                y2=ID_TRIALS==NI_VIS_STD;
                x1=x(y2==1);
                plot([x1,x1]',[y1(x1),y1(x1)-0.2]','color','#de9898','LineWidth',1)
                
                y1=zeros(sum(~isnan(TS)),1);
                y2=ID_TRIALS==NI_AUD_ODD;
                x1=x(y2==1);
                plot([x1,x1]',[y1(y2==1),y1(y2==1)+0.35]','color','b','LineWidth',2)
                y2=ID_TRIALS==NI_AUD_STD;
                x1=x(y2==1);
                plot([x1,x1]',[y1(x1),y1(x1)+0.2]','color','#9898db','LineWidth',1)
                
                plot([-2,x(end)+0.5],[0,0],'k-','LineWidth',2)
                
                % Lick
                TS=TS_TRIALS(:,2);
                RTr=sparse_distanceXY(TS,TS_Rlick);
                RTl=sparse_distanceXY(TS,TS_Llick);

                x1=find(RTr<=2);
                y1=zeros(sum(RTr<=2),1)-0.6;
                plot(x1,y1,'r^','LineWidth',1,'MarkerSize',8)
                
                x1=find(RTl<=2);
                y1=zeros(sum(RTl<=2),1)+0.6;
                plot(x1,y1,'b^','LineWidth',1,'MarkerSize',8)
                
                % Reward
                ITI=zeros(length(TS),1)+10000;
                ts=TS(ID_TRIALS~=NI_AUD_STD & ID_TRIALS~=NI_VIS_STD);
                ITI(ID_TRIALS~=NI_AUD_STD & ID_TRIALS~=NI_VIS_STD)=sparse_distanceXY(ts,[ts;ts(1)+3600]);
                
                if ~isempty(TS_REW_R)
                    xREW=sparse_distanceXY(TS,TS_REW_R_1st);
                    
                    x1=x(xREW'<=ITI & ID_TRIALS~=NI_AUD_STD & ID_TRIALS~=NI_VIS_STD);
                    y1=zeros(length(x1),1)-0.75;
                    
                    plot(x1',y1','o','color',[0.3010 0.7450 0.9330],'MarkerFaceColor',[0.3010 0.7450 0.9330],'LineWidth',1)
                end
                
                if ~isempty(TS_REW_L)
                    xREW=sparse_distanceXY(TS,TS_REW_L_1st);
                    
                    x1=x(xREW'<=ITI & ID_TRIALS~=NI_AUD_STD & ID_TRIALS~=NI_VIS_STD);
                    y1=zeros(length(x1),1)+0.75;
                    
                    plot(x1',y1','o','color',[0.3010 0.7450 0.9330],'MarkerFaceColor',[0.3010 0.7450 0.9330],'LineWidth',1)
                end

                xlim([0.5,length(TS)+0.5])
                ylim([-1,1])
                
            elseif contains(Data.MSN,'CrossM')
                cd '/Volumes/linlab_sync/Matlab_Scripts/Updates/crossmodal/'
%                 [TS_TRIALS,n_TRIALS, BLOCK_TRIALS, TRANSITION, LICKCLUSTER]=get_TRIALS_crossmodal(Data);
                [TS_TRIALS,n_TRIALS, BLOCK_TRIALS, TRANSITION, LICKCLUSTER]=get_TRIALS_crossmodal_sw2(Data);
                
                % PSTH
                TS_Rlick=LICKCLUSTER.R_1st;
                TS_Llick=LICKCLUSTER.L_1st;
                
                % bkA stimAS
                subplot(3,5,1)
                i=find(n_TRIALS(:,NI_BK_MPC)==2 & n_TRIALS(:,NI_AUD_ODD)==1 & n_TRIALS(:,NI_AUD_STD)==0 & n_TRIALS(:,NI_VIS_ODD)==0 & n_TRIALS(:,NI_VIS_STD)==1);
                ts=TS_TRIALS(i,2);
                RTr=sparse_distanceXY(ts,TS_Rlick);
                RTl=sparse_distanceXY(ts,TS_Llick);
                [RT,class]=min([RTr;RTl]);
                class(RT>t)=0;
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',class,'sort_RT',RT)
                title('bkA stimAS')
                
                % bkA stimVS
                subplot(3,5,2)
                i=find(n_TRIALS(:,NI_BK_MPC)==2 & n_TRIALS(:,NI_AUD_ODD)==0 & n_TRIALS(:,NI_AUD_STD)==1 & n_TRIALS(:,NI_VIS_ODD)==1 & n_TRIALS(:,NI_VIS_STD)==0);
                ts=TS_TRIALS(i,2);
                RTr=sparse_distanceXY(ts,TS_Rlick);
                RTl=sparse_distanceXY(ts,TS_Llick);
                [RT,class]=min([RTr;RTl]);
                class(RT>t)=0;
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',class,'sort_RT',RT)
                title('bkA stimVS')
                
                % bkA stimAV
                subplot(3,5,3)
                i=find(n_TRIALS(:,NI_BK_MPC)==2 & n_TRIALS(:,NI_AUD_ODD)==1 & n_TRIALS(:,NI_AUD_STD)==0 & n_TRIALS(:,NI_VIS_ODD)==1 & n_TRIALS(:,NI_VIS_STD)==0);
                ts=TS_TRIALS(i,2);
                RTr=sparse_distanceXY(ts,TS_Rlick);
                RTl=sparse_distanceXY(ts,TS_Llick);
                [RT,class]=min([RTr;RTl]);
                class(RT>t)=0;
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',class,'sort_RT',RT)
                title('bkA stimAV')
                
                % bkA stimSS
                subplot(3,5,4)
                i=find(n_TRIALS(:,NI_BK_MPC)==2 & n_TRIALS(:,NI_AUD_ODD)==0 & n_TRIALS(:,NI_AUD_STD)==1 & n_TRIALS(:,NI_VIS_ODD)==0 & n_TRIALS(:,NI_VIS_STD)==1);
                ts=TS_TRIALS(i,2);
                RTr=sparse_distanceXY(ts,TS_Rlick);
                RTl=sparse_distanceXY(ts,TS_Llick);
                [RT,class]=min([RTr;RTl]);
                class(RT>t)=0;
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',class,'sort_RT',RT)
                title('bkA stimSS')
                
                % bkV stimAS
                subplot(3,5,6)
                i=find(n_TRIALS(:,NI_BK_MPC)==1 & n_TRIALS(:,NI_AUD_ODD)==1 & n_TRIALS(:,NI_AUD_STD)==0 & n_TRIALS(:,NI_VIS_ODD)==0 & n_TRIALS(:,NI_VIS_STD)==1);
                ts=TS_TRIALS(i,2);
                RTr=sparse_distanceXY(ts,TS_Rlick);
                RTl=sparse_distanceXY(ts,TS_Llick);
                [RT,class]=min([RTr;RTl]);
                class(RT>t)=0;
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',class,'sort_RT',RT)
                title('bkV stimAS')
                
                % bkV stimVS
                subplot(3,5,7)
                i=find(n_TRIALS(:,NI_BK_MPC)==1 & n_TRIALS(:,NI_AUD_ODD)==0 & n_TRIALS(:,NI_AUD_STD)==1 & n_TRIALS(:,NI_VIS_ODD)==1 & n_TRIALS(:,NI_VIS_STD)==0);
                ts=TS_TRIALS(i,2);
                RTr=sparse_distanceXY(ts,TS_Rlick);
                RTl=sparse_distanceXY(ts,TS_Llick);
                [RT,class]=min([RTr;RTl]);
                class(RT>t)=0;
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',class,'sort_RT',RT)
                title('bkV stimVS')
                
                % bkV stimAV
                subplot(3,5,8)
                i=find(n_TRIALS(:,NI_BK_MPC)==1 & n_TRIALS(:,NI_AUD_ODD)==1 & n_TRIALS(:,NI_AUD_STD)==0 & n_TRIALS(:,NI_VIS_ODD)==1 & n_TRIALS(:,NI_VIS_STD)==0);
                ts=TS_TRIALS(i,2);
                RTr=sparse_distanceXY(ts,TS_Rlick);
                RTl=sparse_distanceXY(ts,TS_Llick);
                [RT,class]=min([RTr;RTl]);
                class(RT>t)=0;
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',class,'sort_RT',RT)
                title('bkV stimAV')
                
                % bkV stimSS
                subplot(3,5,9)
                i=find(n_TRIALS(:,NI_BK_MPC)==1 & n_TRIALS(:,NI_AUD_ODD)==0 & n_TRIALS(:,NI_AUD_STD)==1 & n_TRIALS(:,NI_VIS_ODD)==0 & n_TRIALS(:,NI_VIS_STD)==1);
                ts=TS_TRIALS(i,2);
                RTr=sparse_distanceXY(ts,TS_Rlick);
                RTl=sparse_distanceXY(ts,TS_Llick);
                [RT,class]=min([RTr;RTl]);
                class(RT>t)=0;
                BEH_PSTH(Data,0,'REF_TS',ts,'maxlag',t,'minlag',-1,'sort2',class,'sort_RT',RT)
                title('bkV stimSS')
                
                % Trial
                colorcue=[0.6350 0.0780 0.1840;0 0.4470 0.7410];
                color=[0.98 0.45 0.1;0.3 0.7 0.01];
                BLOCK=BLOCK_TRIALS;
                TRANS=TRANSITION;
                TS=TS_TRIALS(:,2);
                x=(1:1:length(TS))';
                
                ax=subplot(3,5,[11,12,13,14,15]);hold on; 
                MPC_BLOCK=[-2;find(diff(BLOCK(:,1))~=0);x(end)];
                for i=1:length(MPC_BLOCK)-1
                    hold on
                    patch([MPC_BLOCK(i)+0.5,MPC_BLOCK(i+1)+0.5,MPC_BLOCK(i+1)+0.5,MPC_BLOCK(i)+0.5],[-2,-2,2,2],color(BLOCK(MPC_BLOCK(i+1),1),:),'LineStyle','none','FaceAlpha',0.15)
                end
                
                % Cue
                y1=zeros(sum(~isnan(TS)),1);
                y2=~isnan(TS_TRIALS(:,3));
                x1=x(y2==1);
                plot([x1,x1]',[y1(y2==1),y1(y2==1)-0.35]','color','r','LineWidth',2)
                x1=x(y2==0);
                plot([x1,x1]',[y1(x1),y1(x1)-0.2]','color','#de9898','LineWidth',1)
                
                y1=zeros(sum(~isnan(TS)),1);
                y2=~isnan(TS_TRIALS(:,5));
                x1=x(y2==1);
                plot([x1,x1]',[y1(y2==1),y1(y2==1)+0.35]','color','b','LineWidth',2)
                x1=x(y2==0);
                plot([x1,x1]',[y1(x1),y1(x1)+0.2]','color','#9898db','LineWidth',1)
                
                plot([-2,x(end)+0.5],[0,0],'k-','LineWidth',2)
                
                % Lick
                x1=find(~isnan(TS_TRIALS(:,9)));
                y1=zeros(sum(~isnan(TS_TRIALS(:,9))),1)-0.6;
                plot(x1,y1,'r^','LineWidth',1,'MarkerSize',8)
                
                x1=find(~isnan(TS_TRIALS(:,14)));
                y1=zeros(sum(~isnan(TS_TRIALS(:,14))),1)+0.6;
                plot(x1,y1,'b^','LineWidth',1,'MarkerSize',8)
                
                % Reward
                x1=find(~isnan(TS_TRIALS(:,12)));
                y1=zeros(sum(~isnan(TS_TRIALS(:,12))),1)-0.75;
                plot(x1',y1','o','color',[0.3010 0.7450 0.9330],'MarkerFaceColor',[0.3010 0.7450 0.9330],'LineWidth',1)
                
                x1=find(~isnan(TS_TRIALS(:,17)));
                y1=zeros(sum(~isnan(TS_TRIALS(:,17))),1)+0.75;
                plot(x1',y1','o','color',[0.3010 0.7450 0.9330],'MarkerFaceColor',[0.3010 0.7450 0.9330],'LineWidth',1)
                
                xlim([0.5,length(TS)+0.5])
                ylim([-1,1])

            end
            sgtitle(['Box ',Data.Box])
            saveas(gcf,[savedir,ID,'_BEH_',Data.MSN(13:end),'.jpg'])
            close
        end
    end
end
