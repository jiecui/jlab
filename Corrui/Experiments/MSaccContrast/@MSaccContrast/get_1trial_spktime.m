function [spktimes12, spktimes23, start12, end12, start23, end23] = get_1trial_spktime(cycleidx, condidx, ...
    trialMatrix, NumberCondition, CondInCycle, grattime, enum, spiketimes)
% GET_1TRIAL_SPKTIME gets the spike times from a single trial of spike
%       recording, given the cycle number, condition number, etc. the
%       spikes are around the onsets of contrast 1 and contrast 2 within
%       +/- grattime.
%
% Syntax:
%   spktimes = get_1stage_spktime(cycleidx, condidx, stageidx, enum, spiketimes)
%
% Input(s):
%   cycleidx        - index of cycle number (i.e., 1, 2,...)
%
% Output(s):
%   spktimes12      - from stage 1 to stage 2, aligned at contrast 1 onset
%   spktimes23      - from stage 2 to stage 3, aligned at contrast 2 onset
%   start/end12/23  - start/end time index
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Tue 10/30/2012 10:17:23.536 AM
% $Revision: 0.1 $  $Date: Tue 10/30/2012 10:17:23.536 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% find the position of desired spike times
% ----------------------------------------
trilnum = MSaccContrast.cyc_cond_2_trialnum(cycleidx, condidx, NumberCondition, CondInCycle);
yn_cycle = spiketimes(:, enum.spiketimes.cycle_index) == cycleidx;
yn_cond = spiketimes(:, enum.spiketimes.trial_condition) == condidx;
yn_idx = yn_cycle & yn_cond;
spktimes = spiketimes(yn_idx, enum.spiketimes.timeindex);

% from stage 1 to stage 2 spike times
% -----------------------------------
stage2_start = trialMatrix(enum.trialMatrix.trialStage2StartIndex, trilnum);
start12 = stage2_start - grattime;
end12 = stage2_start + grattime - 1;
idx = (spktimes >= start12) & (spktimes <= end12);
spktimes12 = spktimes(idx);

% from stage 2 to stage 3 spike times
% -----------------------------------
stage3_start = trialMatrix(enum.trialMatrix.trialStage3StartIndex, trilnum);
start23 = stage3_start - grattime;
end23 = stage3_start + grattime - 1;
idx = (spktimes >= start23) & (spktimes <= end23);
spktimes23 = spktimes(idx);

end % function get_1trial_spktime

% [EOF]
