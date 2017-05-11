function result_dat = AggMSRateDiffLum(current_tag, name, S, dat)
% MSCLEDANALYSIS.AGGANAMSTRIGMLDRESP analyzes MS rate at different luminance levels
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

% Copyright 2013 Richard J. Cui. Created: Tue 05/07/2013 10:19:30.351 PM
% $Revision: 0.2 $  $Date: Mon 09/02/2013  9:48:38.172 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% input parameters
% =========================================================================
% specific options for the current process
if strcmpi(current_tag,'get_options')
    opt = [];
    
    result_dat = opt;
    return
end % if

% =========================================================================
% load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'left_usacc_props', 'trial_props', 'trialtime', ...
                'sessions', 'enum'};
    
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% options

% data
enum                = dat.enum;
trialtime           = dat.trialtime;
sessions            = dat.sessions;
left_usacc_props    = dat.left_usacc_props;
trial_props         = dat.trial_props;

% number of lumi
% Note: here is one condition only

num_cell = length(sessions);
conds = trial_props{1}(:, enum.trial_props.CondIndex);
num_lumi = max(conds);
num_usacc = zeros(num_lumi, num_cell);
num_trial = zeros(num_lumi, num_cell);
for j = 1:num_lumi
    for k = 1:num_cell
        left_usacc_props_k = left_usacc_props{k};
        trial_props_k = trial_props{k};
        num_usacc_kj = sum(left_usacc_props_k(:, enum.usacc_props.condition) == j);
        num_trials_kj = sum(trial_props_k(:, enum.trial_props.CondIndex) == j);
        num_usacc(j, k) = num_usacc_kj;
        num_trial(j, k) = num_trials_kj;
    end % for
end % for

% ms-rate
rate_mean_cell  = num_usacc ./ (num_trial * trialtime);
ms_rate_mean    = mean(rate_mean_cell);
ms_rate_std     = std(rate_mean_cell, [], 2);
ms_rate_sem     = ms_rate_std / sqrt(num_cell);
ms_rate = [ms_rate_mean, ms_rate_std, ms_rate_sem];

% =========================================================================
% commit
% =========================================================================
result_dat.MSRateDiffLum = ms_rate;

end % function AggAnaMSTrigResp

% =========================================================================
% subroutines
% =========================================================================

% [EOF]
