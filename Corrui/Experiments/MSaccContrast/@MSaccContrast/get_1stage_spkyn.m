function spk_yn = get_1stage_spkyn(cycleidx, condidx, stageidx, enum, ...
    spiketimes, grattime, NumberCondition, CondInCycle, trialMatrix)
% get_1stage_spkyn gets the spikes Y/N from a single stage of spike
%       recording, given the cycle number, condition number and stage
%       number.
%
% Syntax:
%   spk_yn = get_1stage_spkyn(cycleidx, condidx, stageidx, enum, ...
%     spiketimes, grattime, NumberCondition, CondInCycle, trialMatrix)
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 10/28/2012 11:48:52.624 AM
% $Revision: 0.1 $  $Date: 10/28/2012 11:48:52.640 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% find the spiketimes of the stage
% ---------------------------------
spktimes = MSaccContrast.get_1stage_spktime(cycleidx, condidx, stageidx, enum, spiketimes);

% convert to raster / spkyn
% -------------------------
trlnum = MSaccContrast.cyc_cond_2_trialnum(cycleidx, condidx, NumberCondition, CondInCycle);
spk_yn = false(grattime, 1);
switch stageidx
    case 1
        stage_start = trialMatrix(enum.trialMatrix.trialStage1StartIndex, trlnum);
    case 2
        stage_start = trialMatrix(enum.trialMatrix.trialStage2StartIndex, trlnum);
    case 3    
        stage_start = trialMatrix(enum.trialMatrix.trialStage3StartIndex, trlnum);
end % switch

spk_idx = spktimes - stage_start + 1;
spk_yn(spk_idx) = true;

end % get_1stage_spkyn

% [EOF]
