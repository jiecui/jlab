function [allfixation_props, alltotaltimes, alllegends] = get_fixation_properties(current_tag, snames, S , filters_to_use )

allfixation_props = {};
alltotaltimes  = {};
alllegends = {};

if ( nargin == 1 )
	command = current_tag;
	switch (command)
		case 'get_categories'
			allfixation_props = get_categories();
	end
	return
end
if ( ~exist( 'filters_to_use' ) )
    filters_to_use = 0;  %% all trials
end

% select the eyes to use in the plot
if ( ~isfield( S, 'Which_Eyes_To_Use' ) )
    % specially for aggregated sessions where there is no
    % left and right
    S.Which_Eyes_To_Use = 'Unique';
end

for i= 1:length(snames) %% for each session
    % sname = snames{i};
    sname = snames;
    
    [fixation_props , totaltimes, leg_trial, leg_fixation] = get_fixation_properties_session_trial(current_tag, sname, S , filters_to_use);
    allfixation_props{i} = fixation_props;
    alltotaltimes{i} = totaltimes;
    
    alllegends{1}{i} = sname;
    alllegends{2} = leg_trial;
    alllegends{3} = leg_fixation;
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BY TRIAL CONDITIONS
function [allfixation_props, alltotaltimes, leg_trial, leg_fixation] = get_fixation_properties_session_trial(current_tag, sname, S, filters_to_use)

enum	= sessdb('getsessvar', sname, 'enum' );

curr_exp = CorrGui.CheckTag(current_tag);

% get all the fixation properties for the session
[fixation_props, leg_fixation] = get_fixation_properties_session( current_tag, sname, S, enum );

allfixation_props = {};
alltotaltimes  = {};
leg_trial       = {};

%-- for each type of trial conditions  apply a filter to the fixation properties of the session
for i= 1:length(filters_to_use)  
    filter = filters_to_use(i);
    
    % get the legend associated with the condition
    condition_names = CorrGui.filter_conditions('get_condition_names', current_tag);
    leg_trial{i} = condition_names{filter};

    % for each type of microfixation
    for j = 1:length(fixation_props)
        % get microfixations that are part of the trials
        fixation_included      = CorrGui.filter_conditions(current_tag,fixation_props{j}(:,enum.fixation_props.condition), filter, enum,sname);
        allfixation_props{i}{j}= fixation_props{j}(fixation_included, :);
        %         alltotaltimes{i}{j} = get_totaltime( current_tag, sname, S.Which_Eyes_To_Use, filter);
        alltotaltimes{i}{j} = curr_exp.get_totaltime( sname, filter);
    end
end





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BY USACC CATEGORY
function [fixation_props, leg] = get_fixation_properties_session( current_tag, sname, S,enum )

curr_exp = CorrGui.CheckTag(current_tag);

FIXATION_TIME = 0;

fixation_props = {};
totaltimes	= [];
leg			= {};

if ( strcmp( S.Which_Eyes_To_Use, 'Both' ) )
    S.Which_Eyes_To_Use = 'Concat';
end
if curr_exp.is_Avg
    S.Which_Eyes_To_Use = 'Unique';
end

plotdat = get_plotdat( [], sname, {'fixation_props'},S.Which_Eyes_To_Use );
check_plotdat(plotdat, {'fixation_props'} );


% -- All ------------------------------------------------------------------
% plotdat.fixation_props = plotdat.fixation_props( find(plotdat.fixation_props(:,enum.fixation_props.nusaccs)>0),:)
    fixation_props{end+1} =  plotdat.fixation_props;
	leg{end+1} = 'All';    
    
    fixation_props{end+1} =  plotdat.fixation_props( find(plotdat.fixation_props(:,enum.fixation_props.nusaccsbin)>0),:);
	leg{end+1} = 'With usacc';





% % -- If both eyes 
% if ( lrb == 2 )
% 	if ( ~isempty(plotdat.left_totaltime) && ~isempty(plotdat.right_totaltime) )
% 		totaltime = plotdat.left_totaltime + plotdat.right_totaltime;
% 	else
% 		totaltime = 2*sum(plotdat.isInTrial)/plotdat.samplerate*1000;
% 	end
% 	% -- Concatenated (3) instead of averaged (2)
% 	lrb = 3;
% elseif ( lrb == 4 )
% 	totaltime = plotdat.totaltime;
% else
%     if ( ~FIXATION_TIME )
%         totaltime = sum(plotdat.isInTrial)/plotdat.samplerate*1000;
%     else
%         totaltime = 0;
%         %% left eye
%         dat = get_plotdat( [], sname, { 'left_eyeflags' 'right_eyeflags'});
%         if ( ~isempty(dat.left_eyeflags))
%             infix = dat.left_eyeflags(:,1) & ~dat.left_eyeflags(:,3) & ~dat.left_eyeflags(:,4) ;
%             totaltime = totaltime + sum(infix)/plotdat.samplerate*1000;
%         end
%         if (  ~isempty(dat.right_eyeflags))
%             infix = dat.right_eyeflags(:,1) & ~dat.right_eyeflags(:,3) & ~dat.right_eyeflags(:,4) ;
%             totaltime = totaltime + sum(infix)/plotdat.samplerate*1000;
%         end
%     end
% end
% 
% if ( isempty( totaltime ) )
% 	stats		= plotdat.stats;
% 	totaltime	= sum( struct2array(stats, 'totaltime') )*1000;
% end
% if ( isempty( totaltime ) )
% 	stats		= plotdat.stats;
% 	totaltime	= sum( struct2array(stats, 'totaltime') )*1000;
% end




function [fix_cat, cat_legends] = get_categories()



