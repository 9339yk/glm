function [TS,class]=BEH_getcatTS_SW(data,code,varargin)

corr=[];
inout=[];
corrcode=[];
RT=[];
lickcode=[];
lick=[];

if isstruct(data) 
    event=data.allEvent;
    trialcode=[event.TrialType];
    corrcode=[event.corrCode];
    lickcode=[event.LickCode];
else
    event=[];
    eventTS=data;
    corr=10;
end

if nargin>2
    while length(varargin)>1
        switch varargin{1}
            case {'event'}
                inout=varargin{2};
            case {'corr','incorr'}
                corr=varargin{2};
            case {'class'}
                trialcode=varargin{2};
            case {'corrcode'}
                corrcode=varargin{2};
            case {'RT'}
                eventTS=varargin{2};
                RT=1;
            case {'lick'}
                lick=varargin{2};
                
        end
        varargin(1:2)=[];
    end
end

% Get TS
if ~isempty(inout)
    switch inout
        case 'Light'
            eventTS=[event.LightTS];
        case 'Sound'
            eventTS=[event.PeizoTS];
        case 'Cue'
            eventTS=[event.CueTS];
        case 'Lick'
            eventTS=[event.LickTS];
        case 'Reward'
            eventTS=[event(~isnan([event.SolenoidTS])).SolenoidTS];
            trialcode=[event(~isnan([event.SolenoidTS])).TrialType];
        case 'Target'
            eventTS=[event.TarTS];
        case '1Mol'
            eventTS=[event.TarTS];
        otherwise
            warning('incorrect input')
            return
    end
else
end

TS=[];
if isempty(corr)
    if isempty(lick)
        for i=1:length(code)
            tempTS=eventTS(trialcode==code(i));
            TS=[TS,tempTS];
        end
    else
        for i=1:length(code)
            tempTS=eventTS(trialcode==code(i)&lickcode==lick);
            TS=[TS,tempTS];
        end
    end
elseif corr==1 | corr==2
    if isempty(lick)
        for i=1:length(code)
            tempTS=eventTS(trialcode==code(i)&corrcode==corr);
            TS=[TS,tempTS];
        end
    else
        for i=1:length(code)
            tempTS=eventTS(trialcode==code(i)&corrcode==corr&lickcode==lick);
            TS=[TS,tempTS];
        end
    end
else
    if isempty(lick)
        for i=1:length(code)
            tempTS=eventTS(trialcode==code(i));
            TS=[TS,tempTS];
        end
    else
        for i=1:length(code)
            tempTS=eventTS(trialcode==code(i)&lickcode==lick);
            TS=[TS,tempTS];
        end
    end
end

TS=sort(TS);

if isempty(RT)
    if isnan(TS)
        class=0;
    else
        class=zeros(1,length(TS));
        for i=1:length(TS)
            class(i)=trialcode(eventTS==TS(i));
        end
    end
else
    class=0;
end







