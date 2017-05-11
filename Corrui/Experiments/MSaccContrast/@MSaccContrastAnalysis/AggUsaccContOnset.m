function result_dat = AggUsaccContOnset(current_tag, name, S, dat)
% AGGUSACCCONTONSET For sorted response in response to step-contrast change (archaic) 
%
% Syntax:
%   result_dat = AggStepContrastAnalysis(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Tue 06/12/2012  3:07:14.181 PM
% $Revision: 0.2 $  $Date: Thu 06/21/2012 12:09:07.516 PM $
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
%     opt.tfmethod = {'{affine}|lwm'};
%     opt.Latency = {30 '* (ms)' [0 1000]};
%     opt.spike_map_threshold = {3 '* (std)' [1 10]}; % Spike map thres. The spikes mapped
%         % outside the fix grid more than SMThres * STDs will be discarded
%     opt.normalized_spike_map = { {'{0}','1'} };
%     opt.smooth_size = {40 '' [1 100]};
%     opt.smooth_sigma = {10 '' [1 100]};

%     opt.smoothed_image = {{'0','{1}'}};

    % opt = [];
    opt.Classify_threshold = {30 '* (%)' [1 50]};
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'FiringXCondRaster23', 'Left_UsaccXCondRaster23_Start', ...
                'SortedTrialNum23', 'concatenated_vars', 'sessions'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% get the data
% -------------
thres = S.Stage_2_Options.AggUsaccContOnset_options.Classify_threshold;
fxcr23 = dat.FiringXCondRaster23;
l_uxcr23_s = dat.Left_UsaccXCondRaster23_Start;
sort_num23 = dat.SortedTrialNum23;  % from weak to strong in each session
cat_vars = dat.concatenated_vars;
sessions = dat.sessions;

% process
N = length(sessions);       % number of sessions
M = size(fxcr23, 3);        % number of conditions
strong_spike_yn = [];
weak_spike_yn = [];

strong_usacc_yn = [];
weak_usacc_yn = [];

for k = 1:N
    sess_idx_k = cat_vars.SortedTrialNum23.sessionflag == k;
    num_cyc_k = sum(sess_idx_k);    % number of cycles
    num_involved = round(num_cyc_k * thres / 100);
    
    fxcr23_k = fxcr23(sess_idx_k, :, :);
    l_uxcr23_s_k = l_uxcr23_s(sess_idx_k, :, :);
    
    strong_spk_k = [];
    weak_spk_k = [];
    strong_usa_k = [];
    weak_usa_k = [];
    for c = 1:M
        sort_idx_k = sort_num23(sess_idx_k, c);
        weak_idx_k = sort_idx_k(1:num_involved);
        strong_idx_k = sort_idx_k(end-num_involved+1:end);
        
        strong_spk_kc = fxcr23_k(strong_idx_k, :, c);
        weak_spk_kc = fxcr23_k(weak_idx_k, :, c);
        strong_usa_kc = l_uxcr23_s_k(strong_idx_k, :, c);
        weak_usa_kc = l_uxcr23_s_k(weak_idx_k, :, c);
        
        strong_spk_k = cat(3, strong_spk_k, strong_spk_kc);
        weak_spk_k = cat(3, weak_spk_k, weak_spk_kc);
        strong_usa_k = cat(3, strong_usa_k, strong_usa_kc);
        weak_usa_k = cat(3, weak_usa_k, weak_usa_kc);
    end % for
    
    strong_spike_yn = cat(1, strong_spike_yn, strong_spk_k);
    weak_spike_yn = cat(1, weak_spike_yn, weak_spk_k);
    strong_usacc_yn = cat(1, strong_usacc_yn, strong_usa_k);
    weak_usacc_yn = cat(1, weak_usacc_yn, weak_usa_k);
end % for

% =====================
% commit results
% =====================
result_dat.StrongSpikeYN = strong_spike_yn;
result_dat.WeakSpikeYN = weak_spike_yn;
result_dat.StrongUsaccYN = strong_usacc_yn;
result_dat.WeakUsaccYN = weak_usacc_yn;
end % function StepContrastAnalysis

% [EOF]
