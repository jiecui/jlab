function fixation_props = getprops( this, general_fixation_props, isInTrialNumber, isInTrialCond, isInCycle, isInTrialStage )
% MSCFIXATION.GETPROPS MSC specified usacc properties
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

[enum, num_props_new] = this.getEnum();
[num_fix, num_props_old] = size(general_fixation_props);
fixation_props = [general_fixation_props, zeros(num_fix, num_props_new - num_props_old)];

fixation_props(:,enum.ntrial) = double(isInTrialNumber(fixation_props(:,enum.start_index)));
fixation_props(:,enum.condition) = double(isInTrialCond(fixation_props(:,enum.start_index)));
fixation_props(:,enum.cycle) = double(isInCycle(fixation_props(:,enum.start_index)));
fixation_props(:,enum.start_in_stage) = double(isInTrialStage(fixation_props(:, enum.start_index)));
fixation_props(:,enum.end_in_stage) = double(isInTrialStage(fixation_props(:, enum.end_index)));

end % function getprops

% [EOF]
