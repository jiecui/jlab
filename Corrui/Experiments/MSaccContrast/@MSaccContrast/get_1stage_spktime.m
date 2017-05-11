function spktimes = get_1stage_spktime(cycleidx, condidx, stageidx, enum, spiketimes)
% GET_1STAGE_SPKTIME gets the spike times from a single stage of spike
%       recording, given the cycle number, condition number and stage number
%
% Syntax:
%   spktimes = get_1stage_spktime(cycleidx, condidx, stageidx, enum, spiketimes)
%
% Input(s):
%   cycleidx        - index of cycle number (i.e., 1, 2,...)
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 10/28/2012 11:35:17.334 AM
% $Revision: 0.1 $  $Date: 10/28/2012 11:35:17.413 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% find the position of desired spike times
% ----------------------------------------
yn_cycle = spiketimes(:, enum.spiketimes.cycle_index) == cycleidx;
yn_cond = spiketimes(:, enum.spiketimes.trial_condition) == condidx;
yn_stage = spiketimes(:, enum.spiketimes.trial_stage) == stageidx;
yn_idx = yn_cycle & yn_cond & yn_stage;

% find the spike times
% --------------------
spktimes = spiketimes(yn_idx, enum.spiketimes.timeindex);

end % function get_1stage_spktime

% [EOF]
