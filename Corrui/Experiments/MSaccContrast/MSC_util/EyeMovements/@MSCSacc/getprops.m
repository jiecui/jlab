function saccade_props = getprops( this, general_saccade_props, isInTrialNumber, isInTrialCond, isInCycle, isInTrialStage )
% MSCSACC.GETPROPS MSC specified saccade properties
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

[saccpropsenum, num_props_new] = this.getEnum();
[num_sacc, num_props_old] = size(general_saccade_props);
saccade_props = [general_saccade_props, zeros(num_sacc, num_props_new - num_props_old)];

saccade_props(:,saccpropsenum.ntrial)      = double(isInTrialNumber(saccade_props(:,saccpropsenum.start_index)));
saccade_props(:,saccpropsenum.condition)   = double(isInTrialCond(saccade_props(:,saccpropsenum.start_index)));
saccade_props(:,saccpropsenum.cycle) = double(isInCycle(saccade_props(:,saccpropsenum.start_index)));
saccade_props(:,saccpropsenum.start_in_stage) = double(isInTrialStage(saccade_props(:, saccpropsenum.start_index)));
saccade_props(:,saccpropsenum.end_in_stage) = double(isInTrialStage(saccade_props(:, saccpropsenum.end_index)));

end % function getprops

% [EOF]
