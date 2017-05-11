function trialnum = cyc_cond_2_trialnum(cycleidx, condidx, NumberCondition, CondInCycle)
% CYC_COND_2_TRIALNUM finds the trialnumber giving cycle index and
%       condition index, number of conditions in one cycle and the sequence
%       of conditions in one cycle
%
% Syntax:
%   trialnum = cyc_cond_2_trialnum(cycleidx, condidx, NumberCondition, CondInCycle)
% 
% Input(s):
%   cycleidx        - index of cycle number
%   condidx         - index of condition number
%   NumberCondition - number of conditons in one cycle
%   CondInCycle     - condition sequence in one cycle
%
% Output(s):
%   trialnum        - the sequence of trial in the whole experiments
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 10/28/2012 12:04:19.678 PM
% $Revision: 0.1 $  $Date: 10/28/2012 12:04:19.678 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

n = (cycleidx - 1) * NumberCondition;
m = find(CondInCycle == condidx);
trialnum = n + m;

end % function cyc_cond_2_trialnum

% [EOF]
