function [alldrift_props, alltotaltimes, alllegends] = get_drift_properties(current_tag, snames, S , filters_to_use )

% Modified by Richard J. Cui.: Thu 06/14/2012  4:36:41.346 PM
% $Revision: 0.1 $  $Date: Thu 06/14/2012  4:36:41.346 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com


alldrift_props = {};
alltotaltimes  = {};
alllegends = {};

try
    if ( nargin == 1 )
        command = current_tag;
        switch (command)
            case 'get_categories'
                alldrift_props = get_categories();
        end
        return
    end
    currexp = CorrGui.ExperimentConstructor(current_tag);

    for i= 1:length(snames) %% for each session
        % sname = char(snames{i});
        sname = snames;
        
        [drift_props , totaltimes, leg_trial, leg_drift] = get_drift_properties_session_trial(currexp, sname, S  , filters_to_use);
        alldrift_props{i} = drift_props;
        alltotaltimes{i} = totaltimes;
        
        alllegends{1}{i} = sname;
        alllegends{2} = leg_trial;
        alllegends{3} = leg_drift;
    end


catch ex
    fprintf('\n\nCORRUI ERROR GETTING DRIFT PROPERTIES, continueing with empty drift properties\n');
    ex.getReport
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BY TRIAL CONDITIONS
function [alldrift_props, alltotaltimes, leg_trial, leg_drift] = get_drift_properties_session_trial(currexp, sname, S , filters_to_use)

enum	= currexp.db.getsessvar( sname, 'enum' );
if ( ~isfield( enum, 'drift_props' ) )
    alldrift_props = {};
    alltotaltimes = {};
    leg_trial = {};
    leg_drift = {};
    return
end

% get all the drift properties for the session
[drift_props, leg_drift] = get_drift_properties_session( currexp, sname, S, enum );

if length(drift_props) == 1, drift_props = drift_props{1}; end
alldrift_props = {};
alltotaltimes  = {};
leg_trial       = {};

if ( length(drift_props)>1 || ~isempty(drift_props) )
    %-- for each type of trial conditions  apply a filter to the drift properties of the session
    for i= 1:length(filters_to_use)
        filter = filters_to_use(i);
        
        % get the legend associated with the condition
        condition_names = CorrGui.filter_conditions( 'get_condition_names', currexp );
        leg_trial{i} = condition_names{filter};
        
        % for each type of drift
        for j = 1:length(drift_props)
            % get drifts that are part of the trials
            drift_included      = CorrGui.filter_conditions(currexp,drift_props{j}(:,enum.drift_props.condition), filter, enum,sname);
            alldrift_props{i}{j}= drift_props{j}(drift_included, :);
            alltotaltimes{i}{j} = currexp.get_totaltime( sname, filter);
        end
    end
end





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BY drift CATEGORY



function [drift_props, leg] = get_drift_properties_session( currexp, sname, S,enum )

drift_props = {};
totaltimes	= [];
leg			= {};


plotdat = currexp.db.get_plotdat( [], sname, { 'drift_props'},S.Which_Eyes_To_Use );

if isempty(plotdat)
    return
end
% -- All ------------------------------------------------------------------
if ( isempty(S))
    drift_props{end+1} =  plotdat.drift_props;
    leg{end+1} = 'All';
    return;
end

if ( S.Drift_Categories.All )
    drift_props{end+1} =  plotdat.drift_props;
    leg{end+1} = 'All';
end
if ( S.Drift_Categories.Longer_Than_1_Sec )
    idx = plotdat.drift_props(:,enum.drift_props.duration) > 1;
    drift_props{end+1} =  plotdat.drift_props(idx,:);
    leg{end+1} = 'Longer Than 1 Sec';
end

if ( S.Drift_Categories.Longer_Than_2_Sec )
    idx = plotdat.drift_props(:,enum.drift_props.duration) > 2;
    drift_props{end+1} =  plotdat.drift_props(idx,:);
    leg{end+1} = 'Longer Than 2 Sec';
end

if ( S.Drift_Categories.Longer_Than_3_Sec )
    idx = plotdat.drift_props(:,enum.drift_props.duration) > 3;
    drift_props{end+1} =  plotdat.drift_props(idx,:);
    leg{end+1} = 'Longer Than 3 Sec';
end
if ( S.Drift_Categories.In_Peak )
    dat1 = currexp.db.getsessvars( sname, {'isInTrialPeak_Illus'});
    if isempty(dat1)
        dat1 = currexp.db.getsessvars( sname, {'re_on' 'samplerate'});
        idx = find(dat1.re_on);
        if ~isempty(idx)
            idx = max(zeros(size(idx)),idx - 200/dat1.samplerate*1000);
            dat1.isInTrialPeak_Illus = zeros(size(dat1.re_on));
            for i = 1:length(idx)
                dat1.isInTrialPeak_Illus(max(0,idx(i) - 500/dat1.samplerate*1000):idx(i)) = 1;
            end
        else
            dat1 = [];
        end
    end
    if ~isempty(dat1)
        k=1;
        drift_in_idx = zeros(length(plotdat.drift_props(:,1)),1);
        for i = 1:length(plotdat.drift_props(:,1))
            start = plotdat.drift_props(i,enum.drift_props.start_index);
            stop = plotdat.drift_props(i,enum.drift_props.end_index);
            
            drift_in = sum(dat1.isInTrialPeak_Illus(start:stop)) > 0;% any(ismember(start:stop,idx));
            if drift_in
                drift_in_idx(k) = i;
                k=k+1;
            end
        end
        drift_in_idx = drift_in_idx(drift_in_idx~=0);
        drift_props{end+1} =  plotdat.drift_props(drift_in_idx,:);
        leg{end+1} = 'In_Peak';
    end
end
if ( S.Drift_Categories.In_Trough )
    dat1 = currexp.db.getsessvars( sname, {'isInTrialTrough_Illus'});
    if isempty(dat1)
        dat1 = currexp.db.getsessvars( sname, {'pr_on' 'samplerate'});
        idx = find(dat1.pr_on);
        if ~isempty(idx)
            idx = max(zeros(size(idx)),idx - 200/dat1.samplerate*1000);
            dat1.isInTrialTrough_Illus = zeros(size(dat1.pr_on));
            for i = 1:length(idx)
                dat1.isInTrialTrough_Illus(max(0,idx(i) - 500/dat1.samplerate*1000):idx(i)) = 1;
            end
        else
            dat1 = [];
        end
        
    end
    if ~isempty(dat1)
        k=1;
        drift_in_idx = zeros(length(plotdat.drift_props(:,1)),1);
        for i = 1:length(plotdat.drift_props(:,1))
            start = plotdat.drift_props(i,enum.drift_props.start_index);
            stop = plotdat.drift_props(i,enum.drift_props.end_index);
            
            drift_in = sum(dat1.isInTrialTrough_Illus(start:stop)) > 0;% any(ismember(start:stop,idx));
            if drift_in
                drift_in_idx(k) = i;
                k=k+1;
            end
        end
        drift_in_idx = drift_in_idx(drift_in_idx~=0);
        drift_props{end+1} =  plotdat.drift_props(drift_in_idx,:);
        leg{end+1} = 'In_Trough';
    end
end

if ( S.Drift_Categories.In_Peak_No_Event )
    dat1 = currexp.db.getsessvars( sname, {'isInTrialPeak_NoEvent_Illus'});
    
    if ~isempty(dat1)
        k=1;
        drift_in_idx = zeros(length(plotdat.drift_props(:,1)),1);
        for i = 1:length(plotdat.drift_props(:,1))
            start = plotdat.drift_props(i,enum.drift_props.start_index);
            stop = plotdat.drift_props(i,enum.drift_props.end_index);
            
            drift_in = sum(dat1.isInTrialPeak_NoEvent_Illus(start:stop)) > 0;% any(ismember(start:stop,idx));
            if drift_in
                drift_in_idx(k) = i;
                k=k+1;
            end
        end
        drift_in_idx = drift_in_idx(drift_in_idx~=0);
        drift_props{end+1} =  plotdat.drift_props(drift_in_idx,:);
    else
        drift_props{end+1} = [];
    end
    leg{end+1} = 'In_Peak_No_Event';
end
if ( S.Drift_Categories.In_Trough_No_Event )
    dat1 = currexp.db.getsessvars( sname, {'isInTrialTrough_NoEvent_Illus'});
    
    if ~isempty(dat1)
        k=1;
        drift_in_idx = zeros(length(plotdat.drift_props(:,1)),1);
        for i = 1:length(plotdat.drift_props(:,1))
            start = plotdat.drift_props(i,enum.drift_props.start_index);
            stop = plotdat.drift_props(i,enum.drift_props.end_index);
            
            drift_in = sum(dat1.isInTrialTrough_NoEvent_Illus(start:stop)) > 0;% any(ismember(start:stop,idx));
            if drift_in
                drift_in_idx(k) = i;
                k=k+1;
            end
        end
        drift_in_idx = drift_in_idx(drift_in_idx~=0);
        drift_props{end+1} =  plotdat.drift_props(drift_in_idx,:);
        
    else
        drift_props{end+1} = [];
    end
    leg{end+1} = 'In_Trough_No_Event';
end




% % -- other_category_example -----------------------------------------------
% if ( S.Drift_Categories.other_category_example )
%     drift_props{end+1} =  plotdat.drift_props;
% 	leg{end+1} = 'other category example';
% end




function Drift_Categories = get_categories()
Drift_Categories.All						= { {'0', '{1}' } };
Drift_Categories.Longer_Than_1_Sec		    = { {'{0}', '1' } };
Drift_Categories.Longer_Than_2_Sec		    = { {'{0}', '1' } };
Drift_Categories.Longer_Than_3_Sec		    = { {'{0}', '1' } };
Drift_Categories.In_Peak                = { {'{0}', '1' } };
Drift_Categories.In_Trough              = { {'{0}', '1' } };
Drift_Categories.In_Peak_No_Event       = { {'{0}', '1' } };
Drift_Categories.In_Trough_No_Event     = { {'{0}', '1' } };

