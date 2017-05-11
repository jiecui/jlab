function totaltime = get_totaltime( this, sname, filter )
% GET_TOTALTIME (summary)
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: 03/24/2014 10:31:08.611 PM
% $Revision: 0.1 $  $Date: 03/24/2014 10:31:08.612 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com


% -------------------------------------------------------------------------
% make iterative
% -------------------------------------------------------------------------
num_filters = length(filter);
if num_filters > 1
    totaltime = zeros(1, num_filters);
    for k = 1:num_filters
        totaltime(k) = get_totaltime(this, sname, filter(k));
    end % for
    return
end % if

% -------------------------------------------------------------------------
% main for single filter
% -------------------------------------------------------------------------
plotdat = this.db.get_plotdat( [], sname, { 'trial_props' 'enum' });

% version compatibility
trial_props = plotdat.trial_props;
enum = plotdat.enum;
if isfield(enum.trial_props, 'condition')
    trials_included =  CorrGui.filter_conditions(this, trial_props(:,enum.trial_props.condition), filter, plotdat.enum, sname);
elseif isfield(enum.trial_props, 'CondIndex')
    % trials_included =  CorrGui.filter_conditions(this,plotdat.trial_props(:,plotdat.enum.trial_props.CondIndex), filter, plotdat.enum, sname);
    trials_included =  CorrGui.filter_conditions(this, trial_props(:, enum.trial_props.CondIndex), filter, plotdat.enum, sname);
else
    error('EyeMovements:get_totaltime', 'No condition index of trials')
end % if

if isfield(enum.trial_props, 'duration')
    trialLengths = plotdat.trial_props(trials_included, enum.trial_props.duration);
elseif isfield(enum.trial_props, 'Duration')
    trialLengths = plotdat.trial_props(trials_included, enum.trial_props.Duration);
    % trialLengths = (plotdat.trial_props(trials_included,plotdat.enum.trial_props.left_fixtime) + plotdat.trial_props(trials_included,plotdat.enum.trial_props.right_fixtime))/2;
else
    error('EyeMovements:get_totaltime', 'No duration index of trials')
end

totaltime = sum( trialLengths );

end % function get_totaltime

% [EOF]