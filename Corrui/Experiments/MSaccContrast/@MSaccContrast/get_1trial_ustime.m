function [us_start_times12, us_end_times12, us_start_times23, us_end_times23, ...
    start12, end12, start23, end23] = get_1trial_ustime(cycleidx, condidx, trialMatrix, ...
    NumberCondition, CondInCycle, grattime, enum, usacc_props)
% GET_1TRIAL_USTIME gets the usacc times from a signel trial of usacc
%       recording, around +/- grattime
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 10/30/2012  1:11:56.106 PM
% $Revision: 0.1 $  $Date: 10/30/2012  1:11:56.106 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% find the position
% -----------------
trilnum = MSaccContrast.cyc_cond_2_trialnum(cycleidx, condidx, NumberCondition, CondInCycle);
yn_cycle = usacc_props(:, enum.usacc_props.cycle) == cycleidx;
yn_cond  = usacc_props(:, enum.usacc_props.condition) == condidx;
yn_idx = yn_cycle & yn_cond;
us_start_times = usacc_props(yn_idx, enum.usacc_props.start_index);
us_end_times = usacc_props(yn_idx, enum.usacc_props.end_index);

% stage1 --> stage 2
stage2_start = trialMatrix(enum.trialMatrix.trialStage2StartIndex, trilnum);
start12 = stage2_start - grattime;
end12 = stage2_start + grattime - 1;
start_idx = (us_start_times >= start12) & (us_start_times <= end12);
us_start_times12 = us_start_times(start_idx);
end_idx = (us_end_times >= start12) & (us_end_times <= end12);
us_end_times12 = us_end_times(end_idx);

% stage2 --> stage 3
stage3_start = trialMatrix(enum.trialMatrix.trialStage3StartIndex, trilnum);
start23 = stage3_start - grattime;
end23 = stage3_start + grattime - 1;
start_idx = (us_start_times >= start23) & (us_start_times <= end23);
us_start_times23 = us_start_times(start_idx);
end_idx = (us_end_times >= start23) & (us_end_times <= end23);
us_end_times23 = us_end_times(end_idx);

end % function get_1trial_ustime

% [EOF]
