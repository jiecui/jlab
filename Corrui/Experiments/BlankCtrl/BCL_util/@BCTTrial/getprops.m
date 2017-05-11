function trial_props = getprops( timestamps, isInTrialCond, isInTrialSequence )
% BCTTRIAL.GETPROPS (summary)
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

% Copyright 2013 Richard J. Cui. Created: Tue 05/07/2013 10:13:37.414 AM
% $Revision: 0.2 $  $Date: Mon 09/02/2013  9:19:11.806 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

enum = BCTTrial.getEnum();
fnames = fieldnames(enum);
num_fileds = length(fnames);
total_trial = max(isInTrialSequence);

% =========================================================================
% process trial
% =========================================================================
trial_props = [];
for k = 1:total_trial
    trial_props_k = zeros(1, num_fileds);
    
    trial_k_idx = isInTrialSequence == k;
    if sum(trial_k_idx) > 0
        start_ind = find(trial_k_idx, 1, 'first');
        end_ind = find(trial_k_idx, 1, 'last');
        start_ts = timestamps(start_ind);
        end_ts = timestamps(end_ind);
        cond = isInTrialCond(start_ind);
    else    % this trial is aborted
        start_ind   = NaN;
        end_ind     = NaN;
        start_ts    = NaN;
        end_ts      = NaN;
        cond        = NaN;
    end 
    trial_props_k(enum.StartIndex)      = start_ind;
    trial_props_k(enum.EndIndex)        = end_ind;
    trial_props_k(enum.StartTS)         = start_ts;
    trial_props_k(enum.EndTS)           = end_ts;
    trial_props_k(enum.CondIndex)       = cond;
    trial_props_k(enum.Sequence)        = k;
    trial_props_k(enum.Duration)        = end_ts - start_ts + 1;
    
    trial_props = cat(1, trial_props, trial_props_k);
    
end % for


end % function getprops

% =========================================================================
% subroutines
% =========================================================================


% [EOF]
