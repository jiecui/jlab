function spk_yn = get_1trial_spkyn(cycleidx, condidx, enum, ...
    spiketimes, grattime, NumberCondition, CondInCycle, trialMatrix)
% GET_1TRIAL_SPKYN get spike Y/N of a single trial
%
% Syntax:
%   spk_yn = get_1trial_spkyn(cycleidx, condidx, enum, ...
%     spiketimes, grattime, NumberCondition, CondInCycle, trialMatrix)
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 10/28/2012 12:53:38.183 PM
% $Revision: 0.1 $  $Date: 10/28/2012 12:53:38.183 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

spk_yn = [];
for k = 1:3
    spk_yn_k = MSaccContrast.get_1stage_spkyn(cycleidx, condidx, k, enum, spiketimes, ...
        grattime, NumberCondition, CondInCycle, trialMatrix);
    spk_yn = cat(1, spk_yn, spk_yn_k);
end % for

end % function get_1trial_spkyn

% [EOF]
