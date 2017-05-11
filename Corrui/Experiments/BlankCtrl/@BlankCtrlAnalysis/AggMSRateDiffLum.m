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
% $Revision: 0.3 $  $Date: Thu 10/31/2013  9:55:28.833 AM $
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
ms_rate = zeros(num_lumi, 3);   % mean, std, sem
for k = 1:num_lumi
    num_usacc_k = num_usacc(k, :);
    num_trial_k = num_trial(k, :);
    ms_rate_k = num_usacc_k ./ (num_trial_k * trialtime);
    rate_mean_k = mean(ms_rate_k);
    rate_std_k = std(ms_rate_k(:));
    rate_sem_k = rate_std_k / sqrt(num_cell);
    
    ms_rate(k, :) = [rate_mean_k, rate_std_k, rate_sem_k];
end % for

% =========================================================================
% commit
% =========================================================================
result_dat.MSRateDiffLum = ms_rate;

end % function AggAnaMSTrigResp

% =========================================================================
% subroutines
% =========================================================================

% [EOF]
