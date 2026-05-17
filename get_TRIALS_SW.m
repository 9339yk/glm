function [TS_TRIALS,TS_TRIALS22,oTS_TRIALS,oTS_TRIALS22,n_TRIALS,n_TRIALS22,TTL_MPC,TTL_Open]=get_TRIALS_SW(ID,varargin)
clear TS_TRIAlS* oTS_TRIALS* n_TRIALS*
Data=ReadBehData(ID);

% get TS all
TS_LIGHT_House=BEH_get_TS(Data,3);
TS_LIGHT_CL=BEH_get_TS(Data,11);
TS_SOUND_Pure=BEH_get_TS(Data,51);
TS_SOUND_WN=BEH_get_TS(Data,49);

TS_IRR1_ON=BEH_get_TS(Data,33);
TS_IRL1_ON=BEH_get_TS(Data,41);
TS_IRR1_OFF=BEH_get_TS(Data,34);
TS_IRL1_OFF=BEH_get_TS(Data,42);
TS_Lick_R=BEH_get_TS(Data,35);
TS_Lick_L=BEH_get_TS(Data,43);
TS_REW_R=BEH_get_TS(Data,27);
TS_REW_L=BEH_get_TS(Data,31);

if contains(Data.MSN,'Reverse')
    TS_IRR1_ON=BEH_get_TS(Data,41);
    TS_IRL1_ON=BEH_get_TS(Data,33);
    TS_IRR1_OFF=BEH_get_TS(Data,42);
    TS_IRL1_OFF=BEH_get_TS(Data,34);
    TS_Lick_R=BEH_get_TS(Data,43);
    TS_Lick_L=BEH_get_TS(Data,35);
    TS_REW_R=BEH_get_TS(Data,31);
    TS_REW_L=BEH_get_TS(Data,27);
end

% if isempty(TS_Lick_R) & isempty(TS_Lick_R)
%     return
% end

filedir=[];
filename=[];

if nargin>2
    while length(varargin)>1
        switch varargin{1}
            case {'filedir'}
                filedir=varargin{2};
            case {'filename'}
                filename=varargin{2};
        end
        varargin(1:2)=[];
    end
end

if ~isempty(filedir)
    % get TTL
    [TTL_On, TTL_Off]=loadEvents_H5file(filedir,filename);
    MPC_TTL=BEH_get_TS(Data,61); % timing event

    if ~isempty(strfind(Data.MSN,'20200309'))||~isempty(strfind(Data.MSN,'20200324'))||...
       ~isempty(strfind(Data.MSN,'2020410'))||~isempty(strfind(Data.MSN,'2020413'))
        TTL_temp=TTL_On(TTL_Off-TTL_On<0.1005);
        TTL_temp2=TTL_temp-TTL_temp(1);
        MPC_TTL_temp=MPC_TTL-MPC_TTL(1);
        % [RT,TTL]=sparse_distanceXY(TTL_temp,MPC_TTL,'tolerance',-0.15);
        % figure,plot(RT,'o-')

        [RT1,TTL1]=sparse_distanceXY(TTL_temp2,MPC_TTL_temp,'tolerance',0);
        [RT2,TTL2]=sparse_distanceYX(TTL_temp2,MPC_TTL_temp,'tolerance',0);
        RT3=RT1; RT3(abs(RT2)<abs(RT1))=RT2(abs(RT2)<abs(RT1));
        TTL=TTL1; TTL(abs(RT2)<abs(RT1))=TTL2(abs(RT2)<abs(RT1));
        % figure,plot(RT3,'o-')
        TTL_MPC=TTL+MPC_TTL(1);
        TTL_Open=TTL_temp;
    else
        TTL_MPC=MPC_TTL;
        TTL_Open=TTL_On;
    end

    if contains(ID,'RT03_220817')
        TTL_Open=[TTL_Open(1:104);TTL_Open(106:end)];
    end
    if contains(ID,'RY07_240103')
        TTL_Open=[TTL_Open(1:476);TTL_Open(478:end)];
    end
end

% get trial numbers
tstart=min([TS_LIGHT_House,TS_LIGHT_CL,TS_SOUND_Pure,TS_SOUND_WN]);
tend=max([TS_LIGHT_House,TS_LIGHT_CL,TS_SOUND_Pure,TS_SOUND_WN]);
% trialnum=((tend-tstart)/ISI)+1;

% Creat TS_TRIALS matrix
% Block TrialTS HL CL Pure WN IRRON IRRLON LICK1R LICK2R LICK3R REWR1 LICKlastR LICK1L LICK2L LICK3L REWL1 LICKlastL IRROFF IRLOFF Transid Behtransid
% 1 .    2 .    3 . 4 .5 . 6 . 7 .   8 .    9 .    10 .   11 .   12 .   13.      14 .    15 .   16 .  17 .  18 .      19 .    20 .   21 .    22

% Creat n_TRIALS    
% Tridsys Cuetype HLb CLb PUb WNb IRRONcou IRLONcou LR1rt LRcount LR3b REWb LickDur LL1rt LLcount LL3b  REWb LickDur 
%    1 .   2 .    3 .  4 . 5.  6.   7 .      8 .     9 .    10.    11.  12.  13.     14.   15.     16 .  17.  18.       
TS_TRIALS=[];
ISI=2;
Resp=2;

% House Light
tempcue=TS_LIGHT_House';
cue=tempcue;
k=floor([0;diff(tempcue)])-ISI;
for i=1:length(k)
    if k(i)>0
        j=find(cue<=tempcue(i),1,'last');
        cue=[cue(1:j-1);zeros(k(i)/ISI,1);cue(j:end)];
    end
end
% cue=[zeros((floor(cue(1))-tstart)/ISI,1);cue;zeros((tend-floor(cue(end)))/ISI,1)];
cue=[zeros(floor(cue(1)-tstart)/ISI,1);cue;zeros(floor(tend-cue(end))/ISI,1)];
cue(cue==0)=nan;
TS_TRIALS=[TS_TRIALS,cue];

% Central Left Light
tempcue=TS_LIGHT_CL';
cue=tempcue;
k=floor([0;diff(tempcue)])-ISI;
for i=1:length(k)
    if k(i)>0
        j=find(cue<=tempcue(i),1,'last');
        cue=[cue(1:j-1);zeros(k(i)/ISI,1);cue(j:end)];
    end
end
cue=[zeros(floor(cue(1)-tstart)/ISI,1);cue;zeros(floor(tend-cue(end))/ISI,1)];
cue(cue==0)=nan;
TS_TRIALS=[TS_TRIALS,cue];

% Sound pure
tempcue=TS_SOUND_Pure';
cue=tempcue;
k=floor([0;diff(tempcue)])-ISI;
for i=1:length(k)
    if k(i)>0
        j=find(cue<=tempcue(i),1,'last');
        cue=[cue(1:j-1);zeros(k(i)/ISI,1);cue(j:end)];
    end
end
% cue=[zeros((floor(cue(1))-tstart)/ISI,1);cue;zeros((tend-floor(cue(end)))/ISI,1)];
cue=[zeros(floor(cue(1)-tstart)/ISI,1);cue;zeros(floor(tend-cue(end))/ISI,1)];
cue(cue==0)=nan;
TS_TRIALS=[TS_TRIALS,cue];

% Sound white noise
tempcue=TS_SOUND_WN';
cue=tempcue;
k=floor([0;diff(tempcue)])-ISI;
for i=1:length(k)
    if k(i)>0
        j=find(cue<=tempcue(i),1,'last');
        cue=[cue(1:j-1);zeros(k(i)/ISI,1);cue(j:end)];
    end
end
cue=[zeros(floor(cue(1)-tstart)/ISI,1);cue;zeros(floor(tend-cue(end))/ISI,1)];
cue(cue==0)=nan;
TS_TRIALS=[TS_TRIALS,cue];

% assign IR on after cue
for i=1:size(TS_TRIALS,1)
    [rr,r]=sparse_distanceXY(min(TS_TRIALS(i,1:4)),TS_IRR1_ON);
    [lr,l]=sparse_distanceXY(min(TS_TRIALS(i,1:4)),TS_IRL1_ON);
    if rr<=ISI
        TS_TRIALS(i,5)=r;
    else
        TS_TRIALS(i,5)=nan;
    end
    if lr<=ISI
        TS_TRIALS(i,6)=l;
    else
        TS_TRIALS(i,6)=nan;
    end
end
    
% get first lick of each cluster
thr=0.7;
Rinter=diff(TS_Lick_R);
Linter=diff(TS_Lick_L);

TS_RLick1=TS_Lick_R(1);
TS_LLick1=TS_Lick_L(1);

for i=1:length(Rinter)
    if Rinter(i)>thr
        TS_RLick1=[TS_RLick1,TS_Lick_R(i+1)];
    end
end

for i=1:length(Linter)
    if Linter(i)>thr
        TS_LLick1=[TS_LLick1,TS_Lick_L(i+1)];
    end
end

% get last lick of each cluster
% thr=0.7;
TS_RLick_last=zeros(1,length(TS_RLick1));
for i=1:length(TS_RLick1)-1
    TS_RLick_last(i)=TS_Lick_R(find(TS_Lick_R<TS_RLick1(i+1),1,'last'));
end
TS_RLick_last(end)=TS_Lick_R(end);

TS_LLick_last=zeros(1,length(TS_LLick1));
for i=1:length(TS_LLick1)-1
    TS_LLick_last(i)=TS_Lick_L(find(TS_Lick_L<TS_LLick1(i+1),1,'last'));
end
TS_LLick_last(end)=TS_Lick_L(end);


% 
% TS_RLick_last=zeros(1,length(TS_RLick1));
% for i=1:length(TS_RLick1)-1
%     a=find(TS_Lick_R==TS_RLick1(i));
%     b=TS_Lick_R(find(Rinter(a:end)>thr,1)+a-1);
%     [~,c]=sparse_distanceXY(TS_RLick1(i),TS_IRR1_OFF);
%     if b<TS_RLick1(i+1) & c>b
%         TS_RLick_last(i)=TS_Lick_R(find(Rinter(a:end)>thr,1)+a-1);
%     elseif c<b
%         [~,d]=sparse_distanceYX(c,TS_Lick_R);
%         TS_RLick_last(i)=d;
%     else
%         TS_RLick_last(i)=nan;
%     end
% end
% TS_RLick_last(end)=TS_Lick_R(end);
        

% 
% TS_LLick_last=zeros(1,length(TS_LLick1));
% for i=1:length(TS_LLick1)-1
%     a=find(TS_Lick_L==TS_LLick1(i));
%     b=TS_Lick_L(find(Linter(a:end)>thr,1)+a-1);
%     [~,c]=sparse_distanceXY(TS_LLick1(i),TS_IRL1_OFF);
%     if b<TS_LLick1(i+1) & c>b
%         TS_LLick_last(i)=TS_Lick_L(find(Linter(a:end)>thr,1)+a-1);
%     elseif c<b
%         [~,d]=sparse_distanceYX(c,TS_Lick_L);
%         TS_LLick_last(i)=d;
%     else
%         TS_LLick_last(i)=nan;
%     end
% end
% TS_LLick_last(end)=TS_Lick_L(end);

% rewarded trial: set licking cluster from first lick to last lick before port exit
% 231107: licking cluster is more important than port exit



TS1=TS_RLick1(1);
TS2=TS_RLick_last(1);
for i=2:length(TS_RLick1)
    if TS_RLick1(i)>TS_RLick_last(i-1)
        TS1(i)=TS_RLick1(i);
        if sum(TS_REW_R>TS_RLick1(i) & TS_REW_R<TS_RLick_last(i))~=0
            a=TS_IRR1_OFF(find(TS_IRR1_OFF>TS1(i),1));
            if ~isempty(a) & a>TS_RLick_last(i)
                TS2(i)=TS_RLick_last(find(TS_RLick_last<a,1,'last'));
            elseif ~isempty(a) & a<TS_RLick_last(i)
                TS2(i)=TS_RLick_last(i);
            elseif sum(TS_RLick_last>TS1(i))~=0
                TS2(i)=TS_RLick_last(i);
            else
                TS2(i)=TS1(i);
            end
        else
            TS2(i)=TS_RLick_last(i);
        end
        
    end
end

TS_RLick1=TS1;
TS_RLick_last=TS2;

TS1=TS_LLick1(1);
TS2=TS_LLick_last(1);
for i=2:length(TS_LLick1)
    if TS_LLick1(i)>TS_LLick_last(i-1)
        TS1(i)=TS_LLick1(i);
        if sum(TS_REW_L>TS_LLick1(i) & TS_REW_L<TS_LLick_last(i))~=0
            a=TS_IRL1_OFF(find(TS_IRL1_OFF>TS1(i),1));
            if ~isempty(a) & a>TS_LLick_last(i)
                TS2(i)=TS_LLick_last(find(TS_LLick_last<a,1,'last'));
            elseif ~isempty(a) & a<TS_LLick_last(i)
                TS2(i)=TS_LLick_last(i);
            elseif sum(TS_LLick_last>TS1(i))~=0
                TS2(i)=TS_LLick_last(i);
            else
%                 TS2(i)=TS1(i);
            end
        else
            TS2(i)=TS_LLick_last(i);
        end
    end
end
TS_LLick1=TS1;
TS_LLick_last=TS2;


% Assign Licking to TS_ALL and solenoid
% get first solenoid TS
thr=2;
r=[10,diff(TS_REW_R)];
if isempty(TS_REW_R)
    REWR1=[];
else
    REWR1=TS_REW_R(r>thr);
end
l=[10,diff(TS_REW_L)];
if isempty(TS_REW_L)
    REWL1=[];
else
    REWL1=TS_REW_L(l>thr);
end

thr=0.7;
for i=1:size(TS_TRIALS,1)
    [rr,r]=sparse_distanceXY(min(TS_TRIALS(i,1:4)),TS_RLick1);
    rend=TS_RLick_last(TS_RLick1==r);
    if rr>Resp
        TS_TRIALS(i,7:11)=nan;
    else
        TS_TRIALS(i,7)=r;
        [rr,r]=sparse_distanceXY(r+0.00001,TS_Lick_R);
        if rr>thr
            TS_TRIALS(i,8:9)=nan;
        elseif r>rend
            TS_TRIALS(i,8:9)=nan;
        else
            TS_TRIALS(i,8)=r;
            [rr,r]=sparse_distanceXY(r+0.00001,TS_Lick_R);
            if rr>thr
                TS_TRIALS(i,9)=nan;
            elseif r>rend
                TS_TRIALS(i,9)=nan;
            else
                TS_TRIALS(i,9)=r;
            end
        end
        [~,rew]=sparse_distanceXY(min(TS_TRIALS(i,1:4)),REWR1);
        if rew<=rend
            TS_TRIALS(i,10)=rew;
        else
            TS_TRIALS(i,10)=nan;
        end
        TS_TRIALS(i,11)=rend;
    end
                
    [rr,r]=sparse_distanceXY(min(TS_TRIALS(i,1:4)),TS_LLick1);
    lend=TS_LLick_last(TS_LLick1==r);
    if rr>Resp
        TS_TRIALS(i,12:16)=nan;
    else
        TS_TRIALS(i,12)=r;
        [rr,r]=sparse_distanceXY(r+0.00001,TS_Lick_L);
        if rr>thr
            TS_TRIALS(i,13:14)=nan;
        elseif r>lend
            TS_TRIALS(i,13:14)=nan;
        else
            TS_TRIALS(i,13)=r;
            [rr,r]=sparse_distanceXY(r+0.00001,TS_Lick_L);
            if rr>thr
                TS_TRIALS(i,14)=nan;
            elseif r>lend
                TS_TRIALS(i,14)=nan;
            else
                TS_TRIALS(i,14)=r;
            end
        end
        [~,rew]=sparse_distanceXY(min(TS_TRIALS(i,1:4)),REWL1);
        if rew<=lend
            TS_TRIALS(i,15)=rew;
        else
            TS_TRIALS(i,15)=nan;
        end
        TS_TRIALS(i,16)=lend;
    end
end

% Assign IR OFF
for i=1:size(TS_TRIALS,1)
    if ~isnan(TS_TRIALS(i,7))
        [~,TS_TRIALS(i,17)]=sparse_distanceXY(TS_TRIALS(i,7),TS_IRR1_OFF);
    else
        TS_TRIALS(i,17)=nan;
    end
    if ~isnan(TS_TRIALS(i,12))
        [~,TS_TRIALS(i,18)]=sparse_distanceXY(TS_TRIALS(i,12),TS_IRL1_OFF);
    else
        TS_TRIALS(i,18)=nan;
    end
end


% trial time
ts=zeros(size(TS_TRIALS,1),1);
for i=1:size(TS_TRIALS,1)
    ts(i)=min(TS_TRIALS(i,1:4));
end
TS_TRIALS=[ts,TS_TRIALS];
       
% Assign block type
L2S=BEH_get_TS(Data,45);
S2L=BEH_get_TS(Data,46);
changeTS=sort([L2S,S2L]);
Block=zeros(size(TS_TRIALS,1),1);

fakecuets=(min([TS_LIGHT_House,TS_LIGHT_CL,TS_SOUND_Pure,TS_SOUND_WN])...
    :2:max([TS_LIGHT_House,TS_LIGHT_CL,TS_SOUND_Pure,TS_SOUND_WN]));   
temp=zeros(1,length(fakecuets));
if ~isempty(S2L) & ~isempty(L2S)
    beg=(S2L(1)<L2S(1))+1;
elseif isempty(S2L)
    beg=1;
elseif isempty(L2S)
    beg=2;
end
temp=temp+beg;
for i=1:length(changeTS)
    temp=temp+(fakecuets>changeTS(i));
end
for i=1:length(temp)
    if rem(temp(i),2)==1
        Block(i)=1;
    elseif rem(temp(i),2)==0
        Block(i)=2;
    end
end
TS_TRIALS=[Block,TS_TRIALS];

if ~isempty(filedir)
    TS_TRIALS22=TS_TRIALS;
    oTS_TRIALS22=TS_TRIALS;

    for i=2:size(TS_TRIALS22,2)
        oTS_TRIALS22(:,i)=interp1(TTL_MPC,TTL_Open,TS_TRIALS22(:,i),'linear','extrap');
    end

    trials=~isnan(TS_TRIALS22(:,3)) + ~isnan(TS_TRIALS22(:,5));
    TS_TRIALS=TS_TRIALS22(trials>0,:);
    oTS_TRIALS=oTS_TRIALS22(trials>0,:);
else
    TS_TRIALS22=TS_TRIALS;
    trials=~isnan(TS_TRIALS22(:,3)) + ~isnan(TS_TRIALS22(:,5));
    TS_TRIALS=TS_TRIALS22(trials>0,:);
    
    oTS_TRIALS22=[];
    oTS_TRIALS=[];
end

% n_TRIALS, n_TRIALS22
  
% Tridsys Cuetype HLb CLb PUb WNb IRRONcou IRLONcou LR1rt LRcount LR3b REWb LickDur LL1rt LLcount LL3b  REWb LickDur Behtrid 1Hitid 1RJid  CueOutID
%    1 .   2 .    3 .  4 . 5.  6.   7 .      8 .     9 .    10.    11.  12.    13.     14.   15.     16 .  17.  18.    19 .    20 .   21 .   22.
% only 1:18 now!

% get transid
% first light trial(sys) =1, first sound trial(sys)=2, exclude first block
transid=zeros(size(TS_TRIALS22,1),1);
block=TS_TRIALS22(:,1);
for i=2:length(block)
    transid(i)=block(i-1)-block(i);
end
transid(transid==-1)=2;
transidx=find(transid~=0);
transidx(end+1)=size(TS_TRIALS22,1);
n_TRIALS=transid;
% transid(1)=block(1);

% cuetype
cue=zeros(size(TS_TRIALS22,1),1)+22;
cue(~isnan(TS_TRIALS22(:,3)) & ~isnan(TS_TRIALS22(:,5)))=11;
cue(~isnan(TS_TRIALS22(:,3)) & isnan(TS_TRIALS22(:,5)))=12;
cue(isnan(TS_TRIALS22(:,3)) & ~isnan(TS_TRIALS22(:,5)))=21;
n_TRIALS=[n_TRIALS,cue];

% count cuenum after each transition
c=[3,4,5,6];
for j=c
    ts=TS_TRIALS22(:,j);
    num=zeros(size(TS_TRIALS22,1),1);
    for i=1:length(transidx)-1
        num(transidx(i):transidx(i+1))=cumsum(~isnan(ts(transidx(i):transidx(i+1))));
    end
    num(isnan(ts))=0;
    n_TRIALS=[n_TRIALS,num];
end

% IR count within 2 sec ISI
numR=zeros(size(TS_TRIALS22,1),1);
numL=zeros(size(TS_TRIALS22,1),1);
ts=TS_TRIALS22(:,2);
for i=1:length(ts)
    numR(i)=sum(TS_IRR1_ON>ts(i) & TS_IRR1_ON<=(ts(i)+ISI));
    numL(i)=sum(TS_IRL1_ON>ts(i) & TS_IRL1_ON<=(ts(i)+ISI));
end
n_TRIALS=[n_TRIALS,numR];
n_TRIALS=[n_TRIALS,numL];

% LickR all (9:13)
numR=zeros(size(TS_TRIALS22,1),5);
ts=TS_TRIALS22(:,2);
L1=TS_TRIALS22(:,9);
Llast=TS_TRIALS22(:,13);
numR(:,1)=L1-ts;
for i=1:size(numR,1)
    if ~isnan(L1(i))
        numR(i,5)=Llast(i)-L1(i);
        numR(i,2)=sum(TS_Lick_R>=L1(i) & TS_Lick_R<=Llast(i));
    else
        numR(i,5)=nan;
        numR(i,2)=nan;
    end
end
ts=TS_TRIALS22(:,11);
for i=1:length(transidx)-1
    numR(transidx(i):transidx(i+1),3)=cumsum(~isnan(ts(transidx(i):transidx(i+1))));
end
numR(isnan(ts),3)=0;
ts=TS_TRIALS22(:,12);
for i=1:length(transidx)-1
    numR(transidx(i):transidx(i+1),4)=cumsum(~isnan(ts(transidx(i):transidx(i+1))));
end
numR(isnan(ts),4)=0;
n_TRIALS=[n_TRIALS,numR];

% LickL all (14:18)
numL=zeros(size(TS_TRIALS22,1),5);
ts=TS_TRIALS22(:,2);
L1=TS_TRIALS22(:,14);
Llast=TS_TRIALS22(:,18);
numL(:,1)=L1-ts;
for i=1:size(numL,1)
    if ~isnan(L1(i))
        numL(i,5)=Llast(i)-L1(i);
        numL(i,2)=sum(TS_Lick_L>=L1(i) & TS_Lick_L<=Llast(i));
    else
        numL(i,5)=nan;
        numL(i,2)=nan;
    end
end
ts=TS_TRIALS22(:,16);
for i=1:length(transidx)-1
    numL(transidx(i):transidx(i+1),3)=cumsum(~isnan(ts(transidx(i):transidx(i+1))));
end
numL(isnan(ts),3)=0;
ts=TS_TRIALS22(:,17);
for i=1:length(transidx)-1
    numL(transidx(i):transidx(i+1),4)=cumsum(~isnan(ts(transidx(i):transidx(i+1))));
end
numL(isnan(ts),4)=0;
n_TRIALS=[n_TRIALS,numL];



% % set transition id
% prepost=25;
% % first light trial(sys) =1, first sound trial(sys)=2
% % exclude first block
% transid=zeros(1,size(TS_ALL,1));
% block=TS_ALL(:,1);
% for i=2:length(block)
%     transid(i)=block(i-1)-block(i);
% end
% transid(transid==-1)=2;
% % lickcode trials
% lick=zeros(1,size(TS_ALL,1));
% lick(~isnan(TS_ALL(:,9)))=1;
% lick(~isnan(TS_ALL(:,14)))=-1;
% lick=cumsum(lick);
% 
% sysid=find(transid~=0);
% transtrial=zeros(1,length(lick));
% for i=1:length(sysid)
%     if sysid(i)+prepost>length(transid)
%         winlick=lick(sysid(i)-prepost:end);
%         if block(sysid(i))==2
%             translick=max(winlick);
%         else
%             translick=min(winlick);
%         end
%         trans=find(winlick==translick,1,'last');
%         temp=zeros(1,2*prepost+1);
%         temp(trans)=1*transid(sysid(i));
%         transtrial(sysid(i)-prepost:end)=temp(1:length(transtrial(sysid(i)-prepost:end))); 
%     else
%         winlick=lick(sysid(i)-prepost:sysid(i)+prepost);
%         if block(sysid(i))==2
%             translick=max(winlick);
%         else
%             translick=min(winlick);
%         end
%         trans=find(winlick==translick,1,'last');
%         temp=zeros(1,2*prepost+1);
%         temp(trans)=1*transid(sysid(i));
%         transtrial(sysid(i)-prepost:sysid(i)+prepost)=temp; 
%     end
% end
% TS_ALL=[TS_ALL,transid',transtrial'];
% oTS_ALL=[oTS_ALL,transid',transtrial'];
% 
% prepost=50;
% % lickcode trials
% lick=zeros(1,size(TS_TRIALS22,1));
% lick(~isnan(TS_TRIALS22(:,9)))=1;
% lick(~isnan(TS_TRIALS22(:,14)))=-1;
% lick=cumsum(lick);
% 
% transtrial=zeros(length(lick),1);
% for i=1:length(transidx)
%     if transidx(i)+prepost>length(transid)
%         winlick=lick(transidx(i)-prepost:end);
%         if block(transidx(i))==2
%             translick=max(winlick);
%         else
%             translick=min(winlick);
%         end
%         trans=find(winlick==translick,1,'last');
%         temp=zeros(1,2*prepost+1);
%         temp(trans)=1*transid(transidx(i));
%         transtrial(transidx(i)-prepost:end)=temp(1:length(transtrial(transidx(i)-prepost:end))); 
%     else
%         winlick=lick(transidx(i)-prepost:transidx(i)+prepost);
%         if block(transidx(i))==2
%             translick=max(winlick);
%         else
%             translick=min(winlick);
%         end
%         trans=find(winlick==translick,1,'last');
%         temp=zeros(1,2*prepost+1);
%         temp(trans)=1*transid(transidx(i));
%         transtrial(transidx(i)-prepost:transidx(i)+prepost)=temp; 
%     end
% end
% transtrial=[0;transtrial(1:end-1)];
% n_TRIALS=[n_TRIALS,transtrial];
% 
% % get firat hit trials
% lickid=zeros(size(TS_TRIALS22,1),1);
% lickid(~isnan(TS_TRIALS22(:,9)))=1;
% lickid(~isnan(TS_TRIALS22(:,14)))=2;
% % correct=1 error=2 correctRJ=3 miss=0 (not done)
% corr=zeros(size(TS_TRIALS22,1),1);
% corr(block==1 & rem(cue,10)==1 & lickid==0)=3;
% corr(block==2 & floor(cue/10)==1 & lickid==0)=3;
% corr(block==1 & floor(cue/10)==1 & lickid==1)=1;
% corr(block==2 & rem(cue,10)==1 & lickid==2)=1;
% 
% transtrial=zeros(length(lickid),1);
% for i=1:length(transidx)
%     wincorr=corr(transidx(i):end);
%     trans=find(wincorr==1,1,'first');
%     temp=zeros(1,length(wincorr));
%     temp(trans)=1*transid(transidx(i));
%     transtrial(transidx(i):end)=temp; 
% end
% n_TRIALS=[n_TRIALS,transtrial];
% 
% transtrial=zeros(length(lickid),1);
% for i=1:length(transidx)
%     wincorr=corr(transidx(i):end);
%     trans=find(wincorr==3,1,'first');
%     temp=zeros(1,length(wincorr));
%     temp(trans)=1*transid(transidx(i));
%     transtrial(transidx(i):end)=temp; 
% end
% n_TRIALS=[n_TRIALS,transtrial];

% Reduce cue onset within licking
cueoutside=ones(length(n_TRIALS(:,1)),1);
ts=TS_TRIALS22(:,2);
for i=1:length(TS_RLick1)
    cueoutside(ts>=TS_RLick1(i) & ts<=TS_RLick_last(i))=0;
end
for i=1:length(TS_LLick1)
    cueoutside(ts>=TS_LLick1(i) & ts<=TS_LLick_last(i))=0;
end
n_TRIALS=[n_TRIALS,cueoutside];

n_TRIALS22=n_TRIALS;

% n_TRIALS
% get transid
% first light trial(sys) =1, first sound trial(sys)=2, exclude first block
transid=zeros(size(TS_TRIALS,1),1);
block=TS_TRIALS(:,1);
for i=2:length(block)
    transid(i)=block(i-1)-block(i);
end
transid(transid==-1)=2;
transidx=find(transid~=0);
transidx(end+1)=size(TS_TRIALS,1);
n_TRIALS=transid;
% transid(1)=block(1);

% cuetype
cue=zeros(size(TS_TRIALS,1),1)+22;
cue(~isnan(TS_TRIALS(:,3)) & ~isnan(TS_TRIALS(:,5)))=11;
cue(~isnan(TS_TRIALS(:,3)) & isnan(TS_TRIALS(:,5)))=12;
cue(isnan(TS_TRIALS(:,3)) & ~isnan(TS_TRIALS(:,5)))=21;
n_TRIALS=[n_TRIALS,cue];

% count cuenum after each transition
c=[3,4,5,6];
for j=c
    ts=TS_TRIALS(:,j);
    num=zeros(size(TS_TRIALS,1),1);
    for i=1:length(transidx)-1
        num(transidx(i):transidx(i+1))=cumsum(~isnan(ts(transidx(i):transidx(i+1))));
    end
    num(isnan(ts))=0;
    n_TRIALS=[n_TRIALS,num];
end

% IR count within 2 sec ISI
numR=zeros(size(TS_TRIALS,1),1);
numL=zeros(size(TS_TRIALS,1),1);
ts=TS_TRIALS(:,2);
for i=1:length(ts)
    numR(i)=sum(TS_IRR1_ON>ts(i) & TS_IRR1_ON<=(ts(i)+ISI));
    numL(i)=sum(TS_IRL1_ON>ts(i) & TS_IRL1_ON<=(ts(i)+ISI));
end
n_TRIALS=[n_TRIALS,numR];
n_TRIALS=[n_TRIALS,numL];

% LickR all (9:13)
numR=zeros(size(TS_TRIALS,1),5);
ts=TS_TRIALS(:,2);
L1=TS_TRIALS(:,9);
Llast=TS_TRIALS(:,13);
numR(:,1)=L1-ts;
for i=1:size(numR,1)
    if ~isnan(L1(i))
        numR(i,5)=Llast(i)-L1(i);
        numR(i,2)=sum(TS_Lick_R>=L1(i) & TS_Lick_R<=Llast(i));
    else
        numR(i,5)=nan;
        numR(i,2)=nan;
    end
end
ts=TS_TRIALS(:,11);
for i=1:length(transidx)-1
    numR(transidx(i):transidx(i+1),3)=cumsum(~isnan(ts(transidx(i):transidx(i+1))));
end
numR(isnan(ts),3)=0;
ts=TS_TRIALS(:,12);
for i=1:length(transidx)-1
    numR(transidx(i):transidx(i+1),4)=cumsum(~isnan(ts(transidx(i):transidx(i+1))));
end
numR(isnan(ts),4)=0;
n_TRIALS=[n_TRIALS,numR];

% LickL all (14:18)
numL=zeros(size(TS_TRIALS,1),5);
ts=TS_TRIALS(:,2);
L1=TS_TRIALS(:,14);
Llast=TS_TRIALS(:,18);
numL(:,1)=L1-ts;
for i=1:size(numL,1)
    if ~isnan(L1(i))
        numL(i,5)=Llast(i)-L1(i);
        numL(i,2)=sum(TS_Lick_L>=L1(i) & TS_Lick_L<=Llast(i));
    else
        numL(i,5)=nan;
        numL(i,2)=nan;
    end
end
ts=TS_TRIALS(:,16);
for i=1:length(transidx)-1
    numL(transidx(i):transidx(i+1),3)=cumsum(~isnan(ts(transidx(i):transidx(i+1))));
end
numL(isnan(ts),3)=0;
ts=TS_TRIALS(:,17);
for i=1:length(transidx)-1
    numL(transidx(i):transidx(i+1),4)=cumsum(~isnan(ts(transidx(i):transidx(i+1))));
end
numL(isnan(ts),4)=0;
n_TRIALS=[n_TRIALS,numL];

% prepost=30;
% MSN=Data.MSN;
% if contains(MSN,'B05')
%     prepost=5;
% elseif contains(MSN,'B10')
%     prepost=10;
% elseif contains(MSN,'B01')
%     prepost=1;
% end
% % lickcode trials
% lick=zeros(1,size(TS_TRIALS,1));
% lick(~isnan(TS_TRIALS(:,9)))=1;
% lick(~isnan(TS_TRIALS(:,14)))=-1;
% lick=cumsum(lick);
% 
% transtrial=zeros(length(lick),1);
% for i=1:length(transidx)
%     if transidx(i)+prepost>length(transid)
%         winlick=lick(transidx(i)-prepost:end);
%         if block(transidx(i))==2
%             translick=max(winlick);
%         else
%             translick=min(winlick);
%         end
%         trans=find(winlick==translick,1,'last');
%         temp=zeros(1,2*prepost+1);
%         temp(trans)=1*transid(transidx(i));
%         transtrial(transidx(i)-prepost:end)=temp(1:length(transtrial(transidx(i)-prepost:end))); 
%     else
%         winlick=lick(transidx(i)-prepost:transidx(i)+prepost);
%         if block(transidx(i))==2
%             translick=max(winlick);
%         else
%             translick=min(winlick);
%         end
%         trans=find(winlick==translick,1,'last');
%         temp=zeros(1,2*prepost+1);
%         temp(trans)=1*transid(transidx(i));
%         transtrial(transidx(i)-prepost:transidx(i)+prepost)=temp; 
%     end
% end
% transtrial=[0;transtrial(1:end-1)];
% n_TRIALS=[n_TRIALS,transtrial];
% 
% % get first hit trials
% lickid=zeros(size(TS_TRIALS,1),1);
% lickid(~isnan(TS_TRIALS(:,9)))=1;
% lickid(~isnan(TS_TRIALS(:,14)))=2;
% % correct=1 error=2 correctRJ=3 miss=0 (not done)
% corr=zeros(size(TS_TRIALS,1),1);
% corr(block==1 & rem(cue,10)==1 & lickid==0)=3;
% corr(block==2 & floor(cue/10)==1 & lickid==0)=3;
% corr(block==1 & floor(cue/10)==1 & lickid==1)=1;
% corr(block==2 & rem(cue,10)==1 & lickid==2)=1;
% 
% transtrial=zeros(length(lickid),1);
% for i=1:length(transidx)
%     wincorr=corr(transidx(i):end);
%     trans=find(wincorr==1,1,'first');
%     temp=zeros(1,length(wincorr));
%     temp(trans)=1*transid(transidx(i));
%     transtrial(transidx(i):end)=temp; 
% end
% n_TRIALS=[n_TRIALS,transtrial];
% 
% transtrial=zeros(length(lickid),1);
% for i=1:length(transidx)
%     wincorr=corr(transidx(i):end);
%     trans=find(wincorr==3,1,'first');
%     temp=zeros(1,length(wincorr));
%     temp(trans)=1*transid(transidx(i));
%     transtrial(transidx(i):end)=temp; 
% end
% n_TRIALS=[n_TRIALS,transtrial];

% Reduce cue onet within licking
cueoutside=ones(length(n_TRIALS(:,1)),1);
ts=TS_TRIALS(:,2);
for i=1:length(TS_RLick1)
    cueoutside(ts>=TS_RLick1(i) & ts<=TS_RLick_last(i))=0;
end
for i=1:length(TS_LLick1)
    cueoutside(ts>=TS_LLick1(i) & ts<=TS_LLick_last(i))=0;
end
n_TRIALS=[n_TRIALS,cueoutside];



















