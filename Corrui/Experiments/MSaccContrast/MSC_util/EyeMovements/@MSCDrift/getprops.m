function drift_props = getprops( this, general_drift_props, isInTrialNumber, isInTrialCond, isInCycle, isInTrialStage )
% MSCDRIFT.GETPROPS MSC specified saccade properties
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Thu 08/04/2016  3:29:47.359 PM
% $Revision: 0.1 $  $Date: Thu 08/04/2016  3:29:47.371 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

[driftpropsenum, num_props_new] = this.getEnum();
[num_sacc, num_props_old] = size(general_drift_props);
drift_props = [general_drift_props, zeros(num_sacc, num_props_new - num_props_old)];

drift_props(:,driftpropsenum.ntrial)      = double(isInTrialNumber(drift_props(:,driftpropsenum.start_index)));
drift_props(:,driftpropsenum.condition)   = double(isInTrialCond(drift_props(:,driftpropsenum.start_index)));
drift_props(:,driftpropsenum.cycle) = double(isInCycle(drift_props(:,driftpropsenum.start_index)));
drift_props(:,driftpropsenum.start_in_stage) = double(isInTrialStage(drift_props(:, driftpropsenum.start_index)));
drift_props(:,driftpropsenum.end_in_stage) = double(isInTrialStage(drift_props(:, driftpropsenum.end_index)));

end % function getprops

% [EOF]
