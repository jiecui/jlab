function usacc_props = getprops( this, general_usacc_props, isInTrialNumber, isInTrialCond, isInCycle, isInTrialStage )
% MSCUSACC.GETPROPS MSC specified usacc properties
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

[eyeusaccenum, num_props_new] = this.getEnum();
[num_usacc, num_props_old] = size(general_usacc_props);
usacc_props = [general_usacc_props, zeros(num_usacc, num_props_new - num_props_old)];

usacc_props(:,eyeusaccenum.ntrial)      = double(isInTrialNumber(usacc_props(:,eyeusaccenum.start_index)));
usacc_props(:,eyeusaccenum.condition)   = double(isInTrialCond(usacc_props(:,eyeusaccenum.start_index)));
usacc_props(:,eyeusaccenum.cycle) = double(isInCycle(general_usacc_props(:,eyeusaccenum.start_index)));
usacc_props(:,eyeusaccenum.start_in_stage) = double(isInTrialStage(general_usacc_props(:, eyeusaccenum.start_index)));
usacc_props(:,eyeusaccenum.end_in_stage) = double(isInTrialStage(general_usacc_props(:, eyeusaccenum.end_index)));

end % function getprops

% [EOF]
