function blink_props = getprops( this, general_blink_props,  isInTrialNumber, isInTrialCond, isInCycle, isInTrialStage )
% MSCBLINK.GETPROPS MSC specified usacc properties
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
[num_blinks, num_props_old] = size(general_blink_props);
blink_props = [general_blink_props, zeros(num_blinks, num_props_new - num_props_old)];

blink_props(:,enum.ntrial) = double(isInTrialNumber(blink_props(:,enum.start_index)));
blink_props(:,enum.condition) = double(isInTrialCond(blink_props(:,enum.start_index)));
blink_props(:,enum.cycle) = double(isInCycle(blink_props(:,enum.start_index)));
blink_props(:,enum.start_in_stage) = double(isInTrialStage(blink_props(:, enum.start_index)));
blink_props(:,enum.end_in_stage) = double(isInTrialStage(blink_props(:, enum.end_index)));

end % function getprops

% [EOF]
