function BEH_PSTH_cat_SW(Data,REF_EVENT, varargin)

% plots PSTH rasters based on behavioral data Data from a BEH file
% REF_EVENT: event number, as indicated in the MPC code in the YM_Template
% see the table below for detailed description
% REF_EVENT must be between 1-99. Use REF_EVENT=0 to indicate REF_TS
% Input pair:
% 'REF_TS',TS --> user defined REF event
% 'sort_event' --> use RT=sparse_xy(REF_EVENT,SORT_EVENT) for trial sorting
% 'sort_RT' --> User input sorting RT

SORT_EVENT='';
TMAX=20;
TMIN=-20;
REF_TS=[];
SORT_RT=[];
SORT2=[];
OFFSET=0;
if nargin>2
    while length(varargin)>1
        switch varargin{1}
            case {'sort_event','sort'}
                SORT_EVENT=varargin{2};
            case {'sort_RT'}
                SORT_RT=varargin{2};
            case {'MAX','max','maxlag','TMAX'}
                TMAX=varargin{2};
                TMIN=-TMAX;
            case {'MIN','min','minlag','TMIN'}
                TMIN=varargin{2};
            case {'REF_TS'}
                REF_TS=varargin{2};
            case {'sort2'}
                SORT2=varargin{2};
            case {'event_list'}
                EVENT_LIST=varargin{2};
            case {'offset'}
                OFFSET=varargin{2};
            case {'add'}
                EVENT=varargin{2};
                E_TS=EVENT{1};
                E_COLOR=EVENT{2};
                E_LINEWIDTH=EVENT{3};
                E_MARKER=EVENT{4};
                E_MARKERSIZE=EVENT{5};
                %               sparse_PSTH_raster_sort(REF,Data.EventTS{i},RT,...
                %                     'sort2',SORT2,'color',EVENT_COLOR(Data.EventCode{i}),'linewidth',EVENT_LINEWIDTH(Data.EventCode{i}),...
                %                     'marker',EVENT_MARKER{Data.EventCode{i}},'markersize',EVENT_MARKERSIZE(Data.EventCode{i}),'max',TMAX,'min',TMIN);
        end
        varargin(1:2)=[];
    end
end
%%
    
    OUT_01_DVR_ON =1;
    OUT_02_LIGHT_TOP_ON =3;
    OUT_03_LIGHT_RIGHT_ON =5;
    OUT_04_LIGHT_CRIGHT_ON =7;
    OUT_05_LIGHT_FIX_ON =9;
    OUT_06_LIGHT_CLEFT_ON =11;
    OUT_07_LIGHT_LEFT_ON =13;
    OUT_08_CATCH_ON =15;
    OUT_09_PEIZO_RIGHT_ON =17;
    OUT_10_PEIZO_CRIGHT_ON =19;
    OUT_11_PEIZO_CLEFT_ON =21;
    OUT_12_PEIZO_LEFT_ON =23;
    OUT_13_SOL_R1_ON =25;
    OUT_14_SOL_R2_ON =27;
    OUT_15_SOL_L1_ON =29;
    OUT_16_SOL_L2_ON =31;
    OUT_01_DVR_OFF =2;
    OUT_02_LIGHT_TOP_OFF =4;
    OUT_03_LIGHT_RIGHT_OFF =6;
    OUT_04_LIGHT_CRIGHT_OFF =8;
    OUT_05_LIGHT_FIX_OFF =10;
    OUT_06_LIGHT_CLEFT_OFF =12;
    OUT_07_LIGHT_LEFT_OFF =14;
    OUT_08_CATCH_OFF =16;
    OUT_09_PEIZO_RIGHT_OFF =18;
    OUT_10_PEIZO_CRIGHT_OFF =20;
    OUT_11_PEIZO_CLEFT_OFF =22;
    OUT_12_PEIZO_LEFT_OFF =24;
    OUT_13_SOL_R1_OFF =26;
    OUT_14_SOL_R2_OFF =28;
    OUT_15_SOL_L1_OFF =30;
    OUT_16_SOL_L2_OFF =32;
    
    IN_01_IR_R1_ON =33;
    IN_02_IR_RLICK_ON =35;
    IN_03_IR_CFIX1_ON =37;
    IN_04_IR_CFIX2_ON =39;
    IN_05_IR_L1_ON =41;
    IN_06_IR_LLICK_ON =43;
    IN_07_ON =45;
    IN_08_ON =47;
    
    IN_01_IR_R1_OFF =34;
    IN_02_IR_RLICK_OFF =36;
    IN_03_IR_CFIX1_OFF =38;
    IN_04_IR_CFIX2_OFF =40;
    IN_05_IR_L1_OFF =42;
    IN_06_IR_LLICK_OFF =44;
    IN_07_OFF =46;
    IN_08_OFF =48;
    
    SOUND1_6K_ON=49;
    SOUND2_CATCH_ON=51;
    SOUND3_CLICKER_ON=53;
    SOUND4_ON=55;
    SOUND1_6K_OFF=50;
    SOUND2_CATCH_OFF=52;
    SOUND3_CLICKER_OFF=54;
    SOUND4_OFF=56;
    
    LightTS_DisR_TarR_SolR=60;
    LightTS_DisR_TarR_SolL=61;
    LightTS_DisL_TarR_SolR=62;
    LightTS_DisL_TarR_SolL=63;
    LightTS_DisL_TarL_SolL=64;
    LightTS_DisL_TarL_SolR=65;
    LightTS_DisR_TarL_SolL=66;
    LightTS_DisR_TarL_SolR=67;
    
    SoundTS_DisR_TarR_SolR=70;
    SoundTS_DisR_TarR_SolL=71;
    SoundTS_DisL_TarR_SolR=72;
    SoundTS_DisL_TarR_SolL=73;
    SoundTS_DisL_TarL_SolL=74;
    SoundTS_DisL_TarL_SolR=75;
    SoundTS_DisR_TarL_SolL=76;
    SoundTS_DisR_TarL_SolR=77;
    
    STIMFREQ_CLICKER=80;
    STIMFREQ_NOISE=81;
    STIMFREQ_6k=82;
    STIMFREQ_8k=83;
    STIMFREQ_10k=84;
    STIMFREQ_12k=85;
    
    MASTERLIST_01=88;
    MASTERLIST_02=89;
    MASTERLIST_03=90;
    MASTERLIST_04=91;
    MASTERLIST_05=92;
    MASTERLIST_06=93;
    MASTERLIST_07=94;
    MASTERLIST_08=95;
    MASTERLIST_09=96;
    MASTERLIST_10=97;
    MASTERLIST_11=98;
    MASTERLIST_12=99;
    
    
    
    EVENT_COLOR=[...
        'y','y','c','y','r','r','m','m','y','y','c','c','b','b','w',... % 1-15
        'w','y','y','m','m','c','c','r','r','k','k','b','b','w','w',... % 16-30
        'm','m','k','k','g','g','r','r','m','m','c','c','b','b','y',... % 31-45
        'y','w','w','k','k','g','g','m','m','r','r','c','c','b','b',... % 46-60
        'y','y','w','w','r','r','r','r','y','y','y','y','b','b','b',... % 61-75
        'b','w','w','w','w'];
    
    EVENT_LINEWIDTH=[...
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,...
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,...
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,...
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,...
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1];
    
    EVENT_MARKER={...
        '','','^','v','^','v','^','v','^','v','^','v','^','v','^','v',...
        '','','','','','','','','d','','d','','d','','d','',...
        '','','','','','','','','','','','','','','','',...
        'o','','o','','o','','o','','','','','','','','','',...
        '^','v','v','v','v','v','v','v','v','v','v','v','v','v','v','v'};
    
    EVENT_MARKERSIZE=[...
        1,1,5,5,5,5,5,5,5,5,5,5,5,5,1,1,...
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,...
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,...
        5,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,...
        5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5];

%%





NumEvent=numel(Data.EventName);
DataEventCode=repmat(0,1,NumEvent);
for k=1:NumEvent
    DataEventCode(k)=Data.EventCode{k};
end

if isempty(strfind(Data.MSN,'TEMPLATE')) & isempty(strfind(Data.MSN,'YM_NP0'))
    PLOT_EVENTS=[1:sum(DataEventCode<60)];
else
    PLOT_EVENTS=[fliplr(1:sum(DataEventCode<60))];
end
if exist('EVENT_LIST'), 
    PLOT_EVENTS=[];
    for k=EVENT_LIST
        PLOT_EVENTS=[PLOT_EVENTS, find(DataEventCode==k)];
    end
end


figure(gcf);
hold on;
%REF_EVENT=49;  % SOUND1 ON

if REF_EVENT>0 & REF_EVENT<100
    if ~isempty(find(DataEventCode==REF_EVENT))
        index_REF_EVENT=find(DataEventCode==REF_EVENT);
        REF=Data.EventTS{index_REF_EVENT};
    end
end
if ~isempty(REF_TS)
    REF=REF_TS;
end

if exist('REF') & ~isempty(REF)
    if ~isempty(SORT_EVENT)
        index_SORT_EVENT=find(DataEventCode==SORT_EVENT);
        RT=sparse_distanceXY(REF,Data.EventTS{index_SORT_EVENT},'tolerance',-0.002);
    else
        RT=[1:numel(REF)];
    end
    
    if ~isempty(SORT_RT) && numel(SORT_RT)==numel(REF)
        RT=SORT_RT;
    end
    
    
    if isempty(strfind(Data.MSN,'TEMPLATE')) & isempty(strfind(Data.MSN,'YM_NP0'))
        if isempty(SORT2)
            for i=PLOT_EVENTS
                sparse_PSTH_raster_sort(REF,Data.EventTS{i},RT,...
                    'color',EVENT_COLOR(Data.EventCode{i}),'linewidth',EVENT_LINEWIDTH(Data.EventCode{i}),...
                    'marker',EVENT_MARKER{Data.EventCode{i}},'markersize',EVENT_MARKERSIZE(Data.EventCode{i}),'max',TMAX,'min',TMIN,'offset',OFFSET);
            end
        else
                sparse_PSTH_raster_sort(REF,Data.EventTS{i},RT,...
                    'sort2',SORT2,'color',EVENT_COLOR(Data.EventCode{i}),'linewidth',EVENT_LINEWIDTH(Data.EventCode{i}),...
                    'marker',EVENT_MARKER{Data.EventCode{i}},'markersize',EVENT_MARKERSIZE(Data.EventCode{i}),'max',TMAX,'min',TMIN,'offset',OFFSET);
        end
    else
        if isempty(SORT2)
            if ~exist('EVENT')
                for i=PLOT_EVENTS
                    sparse_PSTH_raster_sort(REF,Data.EventTS{i},RT,...
                        'color',EVENT_COLOR(Data.EventCode{i}),'linewidth',EVENT_LINEWIDTH(Data.EventCode{i}),...
                        'marker',EVENT_MARKER{Data.EventCode{i}},'markersize',EVENT_MARKERSIZE(Data.EventCode{i}),'max',TMAX,'min',TMIN,'offset',OFFSET);
                end
            else
                sparse_PSTH_raster_sort(REF,E_TS,RT,...
                    'color',E_COLOR,'linewidth',E_LINEWIDTH,...
                    'marker',E_MARKER,'markersize',E_MARKERSIZE,'max',TMAX,'min',TMIN,'offset',OFFSET);
            end
        else
            if ~exist('EVENT')
                for i=PLOT_EVENTS
                    sparse_PSTH_raster_sort(REF,Data.EventTS{i},RT,...
                        'sort2',SORT2,'color',EVENT_COLOR(Data.EventCode{i}),'linewidth',EVENT_LINEWIDTH(Data.EventCode{i}),...
                        'marker',EVENT_MARKER{Data.EventCode{i}},'markersize',EVENT_MARKERSIZE(Data.EventCode{i}),'max',TMAX,'min',TMIN,'offset',OFFSET);
                end
            else
                sparse_PSTH_raster_sort(REF,E_TS,RT,...
                    'sort2',SORT2,'color',E_COLOR,'linewidth',E_LINEWIDTH,...
                    'marker',E_MARKER,'markersize',E_MARKERSIZE,'max',TMAX,'min',TMIN,'offset',OFFSET);
            end
            
        end
    end
end
