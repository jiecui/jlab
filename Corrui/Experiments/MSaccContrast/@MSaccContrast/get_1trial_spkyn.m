function [spk12_yn, spk23_yn] = get_1trial_spkyn(cycleidx, condidx, enum, ...
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
%   spk12_yn    - spike Y/N from stage1 to stage2
%   spk23_yn    - spike Y/N from stage 2 to stage 3
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

% get spike times
% ---------------
[spktimes12, spktimes23, start12, end12, start23, end23] = MSaccContrast.get_1trial_spktime(cycleidx, condidx, ...
    trialMatrix, NumberCondition, CondInCycle, grattime, enum, spiketimes);

% get the raster
% --------------
spk12_yn = false(1, end12 - start12 + 1);
spk23_yn = false(1, end23 - start23 + 1);

if ~isempty(spktimes12)
    idx12 = spktimes12 - start12 + 1;
    spk12_yn(idx12) = true;
end % if

if ~isempty(spktimes23)
    idx23 = spktimes23 - start23 + 1;
    spk23_yn(idx23) = true;
end % if


end % function get_1trial_spkyn

% [EOF]
