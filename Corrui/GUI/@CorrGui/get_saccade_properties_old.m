function [allsaccade_props, alltotaltimes, alllegends] = get_saccade_properties(current_tag, snames, S , filters_to_use )

allsaccade_props = {};
alltotaltimes  = {};
alllegends = {};

try
    if ( nargin == 1 )
        command = current_tag;
        switch (command)
            case 'get_categories'
                allsaccade_props = get_categories();
        end
        return
    end
    currexp = CorrGui.ExperimentConstructor(current_tag);
    
    if ~iscell(snames)
        snames = {snames};
    end % if
    
    for i= 1:length(snames) %% for each session
        sname = char(snames{i});
        
        [saccade_props , totaltimes, leg_trial, leg_saccade] = get_saccade_properties_session_trial(currexp, sname, S, filters_to_use);
        allsaccade_props{i} = saccade_props;
        alltotaltimes{i} = totaltimes;
        
        alllegends{1}{i} = sname;
        alllegends{2} = leg_trial;
        alllegends{3} = leg_saccade;
    end
    
catch ex
    fprintf('\n\nCORRUI ERROR GETTING SACCADE PROPERTIES, continueing with empty saccade properties\n');
    ex.getReport
end

% BY TRIAL CONDITIONS
function [allsaccade_props, alltotaltimes, leg_trial, leg_saccade] = get_saccade_properties_session_trial(currexp, sname, S, filters_to_use)

enum	= currexp.db.getsessvar( sname, 'enum' );

allsaccade_props = {};
alltotaltimes  = {};
leg_trial       = {};

% get all the saccade properties for the session
[saccade_props, leg_saccade] = get_saccade_properties_session( currexp, sname, S, enum );
if ( isempty(saccade_props) || isempty( saccade_props{1}))
    return
end


%-- for each type of trial conditions  apply a filter to the saccade properties of the session
for i= 1:length(filters_to_use)
    filter = filters_to_use(i);
    
    % get the legend associated with the condition
    condition_names = CorrGui.filter_conditions( 'get_condition_names', currexp);
    leg_trial{i} = condition_names{filter};
    
    % for each type of microsaccade
    for j = 1:length(saccade_props)
        % get microsaccades that are part of the trials
        saccade_included      = CorrGui.filter_conditions(currexp,saccade_props{j}(:,enum.saccade_props.condition), filter, enum,sname);
        allsaccade_props{i}{j}= saccade_props{j}(saccade_included, :);
        alltotaltimes{i}{j} = currexp.get_totaltime( sname, filter);
    end
end





% BY USACC CATEGORY
function [saccade_props, leg] = get_saccade_properties_session( currexp, sname, S,enum )

% FIXATION_TIME = 0;

saccade_props = {};
% totaltimes	= [];
leg			= {};

S.Which_Eyes_To_Use_Orig = S.Which_Eyes_To_Use;
if ( strcmp( S.Which_Eyes_To_Use , 'Both') ) % if we want both eyes, not only one, the data will be concatenated
    S.Which_Eyes_To_Use = 'Concat'; % two eyes concatenated
end

if currexp.is_Avg
    S.Which_Eyes_To_Use = 'Unique';
end

plotdat = currexp.db.get_plotdat( [], sname, { 'saccade_flags' 'saccade_props'}, S.Which_Eyes_To_Use );

concatenated_vars = currexp.db.getsessvar(sname, 'concatenated_vars');
if ( ~isempty( concatenated_vars ) )
    plotdat.saccade_props = [plotdat.saccade_props concatenated_vars.saccade_props.LRflag concatenated_vars.saccade_props.sessionflag];
    
    switch S.Which_Eyes_To_Use_Orig
        case 'Left'
            lidx = plotdat.saccade_props(:, end-1) == 0;
            plotdat.saccade_props(~lidx, :) = [];
        case 'Right'
            lidx = plotdat.saccade_props(:, end-1) == 1;
            plotdat.saccade_props(~lidx, :) = [];
        case 'Both'
            % concatenate - use all usacc
            
            % % average the data from the two eyes
            % sessions = unique(plotdat.saccade_props(:,end));
            % for i=length(sessions):-1:1
            %     sess = sessions(i);
            %     lidx = find(plotdat.saccade_props(:,end)==sess & plotdat.saccade_props(:,end-1)==0 );
            %     ridx = find(plotdat.saccade_props(:,end)==sess & plotdat.saccade_props(:,end-1)==1 );
            %     if ( ~isempty(lidx) && ~isempty(ridx))
            %         plotdat.saccade_props(lidx,:) = mean(cat(3,  plotdat.saccade_props(lidx, :), plotdat.saccade_props(ridx, :)), 3);
            %         plotdat.saccade_props(ridx,:) = [];
            %     end
            % end
    end
    
end


% if check_data_exist(plotdat,'saccade_props')
%     % -- All ------------------------------------------------------------------
%
%     saccade_props{end+1} =  plotdat.saccade_props;
% 	leg{end+1} = 'All';
% else
%     saccade_props = [];
%     leg =[];
%     return
% end

% -- All ------------------------------------------------------------------
if ( isempty(S))
    saccade_props{end+1} =  plotdat.saccade_props;
    leg{end+1} = 'All';
    return
end
% -- All ------------------------------------------------------------------
if ( S.Saccade_Categories.All )
    saccade_props{end+1} =  plotdat.saccade_props;
    leg{end+1} = 'All';
    return
end
% -- No SWJ ---------------------------------------------------------------
if ( S.Saccade_Categories.NoSWJ )
    index		= find(~plotdat.saccade_flags(:,1));
    
    saccade_props{end+1} =  plotdat.saccade_props(index,:);
    leg{end+1} = 'No SWJ';
end
% -- Horizontal -----------------------------------------------------------
if ( S.Saccade_Categories.Horizontal )
    saccade_directions = deg2rad( plotdat.saccade_props(:,enum.saccade_props.direction) );
    indexH = find(abs(cos(saccade_directions)) < 0.5 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexH,:);
    
    
    leg{end+1} = 'Horizontal';
end
% -- Vertical -------------------------------------------------------------
if ( S.Saccade_Categories.Vertical )
    saccade_directions = deg2rad( plotdat.saccade_props(:,enum.saccade_props.direction) );
    indexV = find(abs(sin(saccade_directions)) < 0.5 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexV,:);
    
    
    leg{end+1} = 'Vertical';
end
% -- SWJ -------------------------------------------------------------
if ( S.Saccade_Categories.SWJ )
    index = find(plotdat.saccade_flags(:,1));
    
    saccade_props{end+1} =  plotdat.saccade_props(index,:);
    
    
    leg{end+1} = 'SWJ';
    
    % 	if ( exist( 'indexH' ) )
    % 		H_percent = length(intersect([swj';swj'+1], indexH)) / length(plotdat.saccade_props(:,enum.saccade_props.magnitude))*100
    % 	end
    % 	if ( exist( 'indexH' ) )
    % 		V_percent = length(intersect([swj';swj'+1], indexV)) / length(plotdat.saccade_props(:,enum.saccade_props.magnitude))*100
    % 	end
end

if ( S.Saccade_Categories.Less_than_04_deg )
    indexM = find(plotdat.saccade_props(:,enum.saccade_props.magnitude) < 0.4 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'mag < 0.4 deg';
end
if ( S.Saccade_Categories.More_than_04_deg )
    indexM = find(plotdat.saccade_props(:,enum.saccade_props.magnitude) > 0.4 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'mag > 0.4 deg';
end
if ( S.Saccade_Categories.Less_than_2_deg )
    indexM = find(plotdat.saccade_props(:,enum.saccade_props.magnitude) < 2 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'mag < 2 deg';
end
if ( S.Saccade_Categories.More_than_2_deg )
    indexM = find(plotdat.saccade_props(:,enum.saccade_props.magnitude) > 2 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'mag > 2 deg';
end
if ( S.Saccade_Categories.Less_than_1_deg )
    indexM = find(plotdat.saccade_props(:,enum.saccade_props.magnitude) < 1 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'mag < 1 deg';
end
if ( S.Saccade_Categories.Less_than_3_deg )
    indexM = find(plotdat.saccade_props(:,enum.saccade_props.magnitude) < 3 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'mag < 3 deg';
end
if ( S.Saccade_Categories.Less_than_5_deg )
    indexM = find(plotdat.saccade_props(:,enum.saccade_props.magnitude) < 5 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'mag < 5 deg';
end
if ( S.Saccade_Categories.Less_than_10_deg )
    indexM = find(plotdat.saccade_props(:,enum.saccade_props.magnitude) < 10 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'mag < 10 deg';
end
if ( S.Saccade_Categories.Less_than_15_deg )
    indexM = find(plotdat.saccade_props(:,enum.saccade_props.magnitude) < 15 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'mag < 15 deg';
end
if ( S.Saccade_Categories.WithOvershoot )
    indexM = find(plotdat.saccade_flags(:,2));
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'mag > 0.2 deg';
end
if ( S.Saccade_Categories.PKV_Less_than_10_degs )
    indexM = find(plotdat.saccade_props(:,enum.saccade_props.pkvel) < plotdat.saccade_props(:,enum.saccade_props.magnitude)*15+6 );
    
    %indexM = find(plotdat.saccade_props(:,enum.saccade_props.direction) < 340 & plotdat.saccade_props(:,enum.saccade_props.direction) > 290 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'below';
end
if ( S.Saccade_Categories.PKV_More_than_10_degs )
    indexM = find(plotdat.saccade_props(:,enum.saccade_props.pkvel) > plotdat.saccade_props(:,enum.saccade_props.magnitude)*15+6 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'above';
end

if ( S.Saccade_Categories.Peak_Velocity_binning )
    bins1 = [2 4 6 9 12 15 20 40 100 200];
    for i= 1:length(bins1)-1
        indexM = find(plotdat.saccade_props(:,enum.saccade_props.pkvel) > bins1(i) & plotdat.saccade_props(:,enum.saccade_props.pkvel) < bins1(i+1));
        
        saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
        
        
        leg{end+1} = [ num2str( bins1(i)) ' - ' num2str( bins1(i+1)) 'deg/s'];
    end
end
if ( S.Saccade_Categories.Peak_Velocity_Min_binning )
    bins1 = [2 3 4 5 6 7 8 9 10 14 20 40 100 200];
    for i= 1:length(bins1)-1
        indexM = find(plotdat.saccade_props(:,enum.saccade_props.pkvel) > bins1(i));
        
        saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
        
        leg{end+1} = [ num2str( bins1(i)) ' - ' num2str( bins1(i+1)) 'deg/s'];
    end
end
if ( S.Saccade_Categories.Duration_binning )
    bins1 = [0 15 20 30 40 100];
    for i= 1:length(bins1)-1
        indexM = find(plotdat.saccade_props(:,enum.saccade_props.pre_event)==1 & plotdat.saccade_props(:,enum.saccade_props.duration) > bins1(i) & plotdat.saccade_props(:,enum.saccade_props.duration) <= bins1(i+1));
        
        saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
        
        
        leg{end+1} = [ num2str( bins1(i)) ' - ' num2str( bins1(i+1)) 'ms'];
    end
end

if ( S.Saccade_Categories.Magnitude_binning )
    bins1 = [0 1 3 5 10 50];
    % 	bins1 = [0 .05  0.1  0.2 0.5 1 3];
    %   bins1 = [0 .05  0.1    1  2 3];
    %     bins1 = [0 0.3  0.5 0.7  50];
    for i= 1:length(bins1)-1
        % plot only microsaccades that happen after another microsaccade
        % indexM = find(plotdat.saccade_props(:,enum.saccade_props.pre_event)==1 & plotdat.saccade_props(:,enum.saccade_props.magnitude) > bins1(i) & plotdat.saccade_props(:,enum.saccade_props.magnitude) <= bins1(i+1));
        indexM = plotdat.saccade_props(:,enum.saccade_props.magnitude) > bins1(i) & plotdat.saccade_props(:,enum.saccade_props.magnitude) <= bins1(i+1);
        
        saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
        mean(saccade_props{end}(:,enum.saccade_props.magnitude))
        
        leg{end+1} = [ num2str( bins1(i)) ' - ' num2str( bins1(i+1)) 'deg'];
    end
end
if ( S.Saccade_Categories.Magnitude_binning_ISI )
    %     bins1 = [0 1 3 5 10 50];
    bins1 = [0 0.4  0.8  50];
    for i= 1:length(bins1)-1
        for j= i:i
            
            %             plotdat.saccade_props = plotdat.saccade_props( CorrGui.filter_conditions(currexp, plotdat.saccade_props(:,enum.saccade_props.condition), 6,enum) ,:);
            
            indexM = find(plotdat.saccade_props(:,enum.saccade_props.magnitude) > bins1(i) & plotdat.saccade_props(:,enum.saccade_props.magnitude) <= bins1(i+1) & ...
                plotdat.saccade_props(:,enum.saccade_props.pre_event) == enum.event.USACC & ...
                plotdat.saccade_props(plotdat.saccade_props(:,enum.saccade_props.pre_event_index),enum.saccade_props.magnitude) > bins1(j) & ...
                plotdat.saccade_props(plotdat.saccade_props(:,enum.saccade_props.pre_event_index),enum.saccade_props.magnitude) <= bins1(j+1));
            number(i,j) = length(indexM);
            
            isimeans(i,j) = mean(plotdat.saccade_props(indexM,enum.saccade_props.pre_time_end));
            
            saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
            leg{end+1} = [ num2str( bins1(i)) ' - ' num2str( bins1(i+1)) 'deg'];
        end
    end
end

if ( S.Saccade_Categories.Direction_binning )
    bins1 = 0:30:360;
    for i= 1:length(bins1)-1
        indexM = find(plotdat.saccade_props(:,enum.saccade_props.direction) > bins1(i) & plotdat.saccade_props(:,enum.saccade_props.direction) <= bins1(i+1));
        
        saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
        
        
        leg{end+1} = [ num2str( bins1(i)) ' - ' num2str( bins1(i+1)) 'deg'];
    end
end



if ( S.Saccade_Categories.Start_binning )
    max_start = max(plotdat.saccade_props(:,enum.saccade_props.start_index));
    bins1 = 0:max_start/10:max_start;
    for i= 1:length(bins1)-1
        indexM = find(plotdat.saccade_props(:,enum.saccade_props.start_index) > bins1(i) & plotdat.saccade_props(:,enum.saccade_props.start_index) < bins1(i+1));
        
        saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
        
        leg{end+1} = [ num2str( bins1(i)) ' - ' num2str( bins1(i+1)) 'samp'];
    end
end


if ( S.Saccade_Categories.Binoculars )
    
    indexM = find(plotdat.saccade_flags(:,3)>0);
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'Binoculars';
    
end
if ( S.Saccade_Categories.Monoculars )
    indexM = find(plotdat.saccade_flags(:,3)<=0);
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'Monoculars';
    
end

if ( S.Saccade_Categories.Horizontal_Binoculars )
    
    saccade_directions = deg2rad( plotdat.saccade_props(:,enum.saccade_props.direction) );
    indexM = find(plotdat.saccade_flags(:,3) & abs(cos(saccade_directions)) < 0.5);
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'Horizontal Binoculars';
end
if ( S.Saccade_Categories.Horizontal_Monoculars )
    saccade_directions = deg2rad( plotdat.saccade_props(:,enum.saccade_props.direction) );
    indexM = find(~plotdat.saccade_flags(:,3)& abs(cos(saccade_directions)) < 0.5);
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'Horizontal Monoculars';
end

if ( S.Saccade_Categories.Vertical_Binoculars )
    
    saccade_directions = deg2rad( plotdat.saccade_props(:,enum.saccade_props.direction) );
    indexM = find(plotdat.saccade_flags(:,3) & abs(sin(saccade_directions)) < 0.5 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    leg{end+1} = 'Vertical Binoculars';
    
end
if ( S.Saccade_Categories.Vertical_Monoculars )
    saccade_directions = deg2rad( plotdat.saccade_props(:,enum.saccade_props.direction) );
    indexM = find(~plotdat.saccade_flags(:,3) & abs(sin(saccade_directions)) < 0.5 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
    
    
    leg{end+1} = 'Vertical Monoculars';
end

if ( S.Saccade_Categories.SWJ_Binoculars )
    
    indexM = find(plotdat.saccade_flags(:,3)>0 & plotdat.saccade_flags(:,1));
    if ( ~isempty( indexM ) )
        saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
        
        
        leg{end+1} = 'SWJ Binoculars';
    end
    
end
if ( S.Saccade_Categories.SWJ_Monoculars )
    indexM = find(~(plotdat.saccade_flags(:,3)>0) & plotdat.saccade_flags(:,1));
    if ( ~isempty( indexM ) )
        saccade_props{end+1} =  plotdat.saccade_props(indexM,:);
        
        
        leg{end+1} = 'SWJ Monoculars';
    end
end

% -- Horizontal -----------------------------------------------------------
if ( S.Saccade_Categories.To_Left )
    saccade_directions = deg2rad( plotdat.saccade_props(:,enum.saccade_props.direction) );
    indexH = find(abs(cos(saccade_directions)) < 0.5 & (sin(saccade_directions)) < -0.5 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexH,:);
    
    
    leg{end+1} = 'To_left';
end
% -- Vertical -------------------------------------------------------------
if ( S.Saccade_Categories.To_Right )
    saccade_directions = deg2rad( plotdat.saccade_props(:,enum.saccade_props.direction) );
    indexV = find(abs(cos(saccade_directions)) < 0.5 & (sin(saccade_directions)) > 0.5 );
    
    saccade_props{end+1} =  plotdat.saccade_props(indexV,:);
    
    
    leg{end+1} = 'To_right';
end
% -- Log pre time -------------------------------------------------------------
if ( S.Saccade_Categories.Pre_time_long )
    index = find( (...
        (plotdat.saccade_flags(:,3)>0) & (plotdat.saccade_props(:,enum.saccade_props.pre_time) >  100)) ...
        | ...
        ( (plotdat.saccade_props(:,enum.saccade_props.magnitude) > .5) & (plotdat.saccade_props(:,enum.saccade_props.pre_time) >  100) ));
    
    saccade_props{end+1} =  plotdat.saccade_props(index,:);
    
    
    leg{end+1} = 'Long pretime';
end
% -- Log pre time -------------------------------------------------------------
if ( S.Saccade_Categories.Pre_time_short )
    index = find((plotdat.saccade_flags(:,3)>0) & (plotdat.saccade_props(:,enum.saccade_props.pre_time) <=  100));
    
    saccade_props{end+1} =  plotdat.saccade_props(index,:);
    
    
    leg{end+1} = 'short pretime';
end

if ( S.Saccade_Categories.In_Peak )
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
        saccade_in_idx = zeros(length(plotdat.saccade_props(:,1)),1);
        for i = 1:length(plotdat.saccade_props(:,1))
            start = plotdat.saccade_props(i,enum.saccade_props.start_index);
            stop = plotdat.saccade_props(i,enum.saccade_props.end_index);
            
            saccade_in = sum(dat1.isInTrialPeak_Illus(start:stop)) > 0;% any(ismember(start:stop,idx));
            if saccade_in
                saccade_in_idx(k) = i;
                k=k+1;
            end
        end
        saccade_in_idx = saccade_in_idx(saccade_in_idx~=0);
        saccade_props{end+1} =  plotdat.saccade_props(saccade_in_idx,:);
        leg{end+1} = 'In_Peak';
    end
end
if ( S.Saccade_Categories.In_Trough )
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
        saccade_in_idx = zeros(length(plotdat.saccade_props(:,1)),1);
        for i = 1:length(plotdat.saccade_props(:,1))
            start = plotdat.saccade_props(i,enum.saccade_props.start_index);
            stop = plotdat.saccade_props(i,enum.saccade_props.end_index);
            
            saccade_in = sum(dat1.isInTrialTrough_Illus(start:stop)) > 0;% any(ismember(start:stop,idx));
            if saccade_in
                saccade_in_idx(k) = i;
                k=k+1;
            end
        end
        saccade_in_idx = saccade_in_idx(saccade_in_idx~=0);
        saccade_props{end+1} =  plotdat.saccade_props(saccade_in_idx,:);
        leg{end+1} = 'In_Trough';
    end
    
    
end
if ( S.Saccade_Categories.First_Half_Trials )
    trialNumMax = max( plotdat.saccade_props(:,enum.saccade_props.ntrial) );
    indexFirstHalf = plotdat.saccade_props(:,enum.saccade_props.ntrial)  <= 0.5*trialNumMax ;
    
    saccade_props{end+1} =  plotdat.saccade_props(indexFirstHalf,:);
    
    
    leg{end+1} = 'First Half of Trials';
end

if ( S.Saccade_Categories.Second_Half_Trials )
    trialNumMax = max( plotdat.saccade_props(:,enum.saccade_props.ntrial) );
    indexSecondHalf = plotdat.saccade_props(:,enum.saccade_props.ntrial)  > 0.5*trialNumMax ;
    
    saccade_props{end+1} =  plotdat.saccade_props(indexSecondHalf,:);
    
    
    leg{end+1} = 'Second Half of Trials';
end

if ( S.Saccade_Categories.First_Quarter_Trials )
    trialNumMax = max( plotdat.saccade_props(:,enum.saccade_props.ntrial) );
    indexFirstQuarter = plotdat.saccade_props(:,enum.saccade_props.ntrial)  <= 0.25*trialNumMax ;
    
    saccade_props{end+1} =  plotdat.saccade_props(indexFirstQuarter,:);
    
    
    leg{end+1} = 'First Quarter of Trials';
end

if ( S.Saccade_Categories.Second_Quarter_Trials )
    trialNumMax = max( plotdat.saccade_props(:,enum.saccade_props.ntrial) );
    indexSecondQuarter = plotdat.saccade_props(:,enum.saccade_props.ntrial)  > 0.25*trialNumMax &  plotdat.saccade_props(:,enum.saccade_props.ntrial)  <= 0.5*trialNumMax ;
    
    saccade_props{end+1} =  plotdat.saccade_props(indexSecondQuarter,:);
    
    
    leg{end+1} = 'Second Quarter of Trials';
end

if ( S.Saccade_Categories.Third_Quarter_Trials )
    trialNumMax = max( plotdat.saccade_props(:,enum.saccade_props.ntrial) );
    indexThirdQuarter = plotdat.saccade_props(:,enum.saccade_props.ntrial)  > 0.5*trialNumMax &  plotdat.saccade_props(:,enum.saccade_props.ntrial)  <= 0.75*trialNumMax ;
    
    saccade_props{end+1} =  plotdat.saccade_props(indexThirdQuarter,:);
    
    
    leg{end+1} = 'Third Quarter of Trials';
end

if ( S.Saccade_Categories.Fourth_Quarter_Trials )
    trialNumMax = max( plotdat.saccade_props(:,enum.saccade_props.ntrial) );
    indexFourthQuarter = plotdat.saccade_props(:,enum.saccade_props.ntrial)  > 0.75*trialNumMax  ;
    
    saccade_props{end+1} =  plotdat.saccade_props(indexFourthQuarter,:);
    
    
    leg{end+1} = 'Fourth Quarter of Trials';
end





function Saccade_Categories = get_categories()


Saccade_Categories.All						= { {'{0}', '1' } };
Saccade_Categories.NoSWJ					= { {'{0}', '1' } };
Saccade_Categories.SWJ						= { {'{0}', '1' } };
Saccade_Categories.Horizontal				= { {'{0}', '1' } };
Saccade_Categories.Vertical                 = { {'{0}', '1' } };
Saccade_Categories.WithOvershoot			= { {'{0}', '1' } };
Saccade_Categories.Less_than_04_deg         = { {'{0}', '1' } };
Saccade_Categories.More_than_04_deg         = { {'{0}', '1' } };
Saccade_Categories.Less_than_2_deg          = { {'{0}', '1' } };
Saccade_Categories.More_than_2_deg          = { {'{0}', '1' } };
Saccade_Categories.PKV_Less_than_10_degs	= { {'{0}', '1' } };
Saccade_Categories.PKV_More_than_10_degs	= { {'{0}', '1' } };
Saccade_Categories.Peak_Velocity_binning	= { {'{0}', '1' } };
Saccade_Categories.Peak_Velocity_Min_binning	= { {'{0}', '1' } };
Saccade_Categories.Duration_binning         = { {'{0}', '1' } };
Saccade_Categories.Magnitude_binning		= { {'{0}', '1' } };
Saccade_Categories.Magnitude_binning_ISI	= { {'{0}', '1' } };
Saccade_Categories.Direction_binning		= { {'{0}', '1' } };
Saccade_Categories.Binoculars				= { {'{0}', '1' } };
Saccade_Categories.Monoculars				= { {'{0}', '1' } };
Saccade_Categories.Horizontal_Binoculars	= { {'{0}', '1' } };
Saccade_Categories.Horizontal_Monoculars	= { {'{0}', '1' } };
Saccade_Categories.Vertical_Binoculars		= { {'{0}', '1' } };
Saccade_Categories.Vertical_Monoculars		= { {'{0}', '1' } };
Saccade_Categories.SWJ_Binoculars			= { {'{0}', '1' } };
Saccade_Categories.SWJ_Monoculars			= { {'{0}', '1' } };
Saccade_Categories.Start_binning            = { {'{0}', '1' } };
Saccade_Categories.To_Left                  = { {'{0}', '1' } };
Saccade_Categories.To_Right                 = { {'{0}', '1' } };
Saccade_Categories.Pre_time_long            = { {'{0}', '1' } };
Saccade_Categories.Pre_time_short           = { {'{0}', '1' } };
Saccade_Categories.Less_than_1_deg          = { {'{0}', '1' } };
Saccade_Categories.Less_than_3_deg          = { {'{0}', '1' } };
Saccade_Categories.Less_than_5_deg          = { {'{0}', '1' } };
Saccade_Categories.Less_than_10_deg         = { {'{0}', '1' } };
Saccade_Categories.Less_than_15_deg         = { {'{0}', '1' } };
Saccade_Categories.In_Peak                  = { {'{0}', '1' } };
Saccade_Categories.In_Trough                = { {'{0}', '1' } };
Saccade_Categories.First_Half_Trials        = { {'{0}', '1' } };
Saccade_Categories.Second_Half_Trials       = { {'{0}', '1' } };
Saccade_Categories.First_Quarter_Trials     = { {'{0}', '1' } };
Saccade_Categories.Second_Quarter_Trials    = { {'{0}', '1' } };
Saccade_Categories.Third_Quarter_Trials     = { {'{0}', '1' } };
Saccade_Categories.Fourth_Quarter_Trials    = { {'{0}', '1' } };
% Saccade_Categories.Mag_0_1_deg		= { {'{0}', '1' } };
% Saccade_Categories.Mag_1_3_deg		= { {'{0}', '1' } };
% Saccade_Categories.Mag_3_5_deg		= { {'{0}', '1' } };
% Saccade_Categories.Mag_5_10_deg		= { {'{0}', '1' } };
% Saccade_Categories.Mag_10_15_deg		= { {'{0}', '1' } };
% Saccade_Categories.Mag_15_deg		= { {'{0}', '1' } };


