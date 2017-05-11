function result_dat = UsaccTriggered1stPeakAnalysis(current_tag, name, S, dat)
% USACCTRIGGERED1STPEAKANALYSIS Analysis of 1st peak of MS-triggered response of individual cell
% 
% Description:
%   This function analyzes the first peak after MS-onset of the
%   MS-triggered response.  Spike rates are obtianed from
%   UsaccTriggeredContrastResponse.m.
% 
% Syntax:
%   result_dat = PMT1(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also UsaccTriggeredContrastResponse.

% Copyright 2013 Richard J. Cui. Created: Mon 03/04/2013  2:03:31.893 PM
% $Revision: 0.1 $  $Date: Mon 03/04/2013  2:03:31.893 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% Input parameters and options
% =========================================================================
% specific options for the current process
if strcmpi(current_tag,'get_options')
    % *********************************************************************
    % Method: Spike rate difference - average signal --> analysis
    %   1. get spike rate difference at each contrast level of each cell
    %   2. aggregate results of each cell
    %   3. get average response at each contrast across cells in aggregated
    %      data set
    %   4. find max value and corresponding SEM in the predefined interval
    %      at each contrast.
    % *********************************************************************
    opt.spkrate_diff = {{'0', '{1}'}, 'Spike Rate Difference'};
    opt.Spike_rate_diff_options.s1 = {[-150 0] 'Baseline interval (ms)' [-500 0]};   % for sustained response 1
    
    % *********************************************************************
    % Method: Baseline and Variance - individual cell --> analysis -->
    %         statistic
    %   1. for each cell, find the baseline activity and variance of the
    %      baseline (Reppas, J. B., Usrey, W. M., & Reid, R. C. (2002).
    %      Saccadic eye movements modulate visual responses in the lateral
    %      geniculate nucleus. Neuron, 35(5), 961-974.)
    %   2. check in the predefined interval: enhance, suppression, no
    %      effect relative to the baseline
    %   3. get the measure of this interval for each cell
    %   4. assemble data and get statistics across cells
    % *********************************************************************
    opt.baselin_var = {{'0', '{1}'}, 'Baseline and Variance'};
    opt.baseline_and_var_options.spk_type = { 'Absolute|{Difference}', 'Spike rate type' };
    opt.baseline_and_var_options.s1 = {[-150 0] 'Baseline interval (ms)' [-500 0]};   % for sustained response 1
    opt.baseline_and_var_options.var_thres = { 95 '(% Poisson cut-off)' [0 100] };    % threshold of baseline variance
    opt.baseline_and_var_options.pk1st_intv = {[0 100] 'Interval (ms)' [-1000 1000]}; % interval for peak 1st 
    
    result_dat = opt;
    return
end % if


% =========================================================================
% Load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    
    dat_var = { 'UsaccTriggeredContrastResponse' };
    result_dat = dat_var;
    
    return
end % if

% =========================================================================
% Data processing
% =========================================================================
% options and paras
% ------------------
spkdiff_flag = S.Stage_2_Options.UsaccTriggered1stPeakAnalysis_options.spkrate_diff;
intv_s1 = S.Stage_2_Options.UsaccTriggered1stPeakAnalysis_options.Spike_rate_diff_options.s1;

baselin_var_flag = S.Stage_2_Options.UsaccTriggered1stPeakAnalysis_options.baselin_var;
baselin_var_spk_type = S.Stage_2_Options.UsaccTriggered1stPeakAnalysis_options.baseline_and_var_options.spk_type;
baselin_var_s1 = S.Stage_2_Options.UsaccTriggered1stPeakAnalysis_options.baseline_and_var_options.s1;
baselin_var_thres = S.Stage_2_Options.UsaccTriggered1stPeakAnalysis_options.baseline_and_var_options.var_thres;
baselin_var_pk1st_intv = S.Stage_2_Options.UsaccTriggered1stPeakAnalysis_options.baseline_and_var_options.pk1st_intv;

% get data
% --------
time = dat.UsaccTriggeredContrastResponse.SpikeRateWinCenter;   % center of windows
spk  = dat.UsaccTriggeredContrastResponse.SpikeRate;            % averaged spike rate at each contrast: levels x signal
pre_ms = dat.UsaccTriggeredContrastResponse.Paras.PreMSIntv;    % time length before MS


% +++++++++++++++++++++++++++++++++
% response of spike rate difference
% +++++++++++++++++++++++++++++++++
if spkdiff_flag
    base_idx = (time >= intv_s1(1) + pre_ms ) & (time <= intv_s1(2) + pre_ms);
    smt1 = mean(spk(:, base_idx), 2);
    spkdiff = spk - repmat(smt1, [1, size(spk, 2)]);
    Pmt1.SpikeRateDiff = spkdiff;
end % if

% +++++++++++++++++++++++++++++++++
% Baseline and var
% +++++++++++++++++++++++++++++++++
if baselin_var_flag
    % get baseline Poisson cut-off
    % ----------------------------
    [low_cut, high_cut] = blstat(pre_ms, baselin_var_s1, time, spk, baselin_var_thres);
    
    % decide type in pk1st interval
    % ------------------------------
    int_type = intvtype(low_cut, high_cut, pre_ms, baselin_var_pk1st_intv, time, spk);
    
    % estimates in pk1st interval 
    % ---------------------------
    est = estintv(int_type);
    
end % if



% =====================
% commit results
% =====================
result_dat.UsaccTriggered1stPeak = Pmt1;
result_dat.Estimate1stPeak = est;

end % function StepContrastAnalysis

% =========================================================================
% subroutines
% =========================================================================
function int_type = intvtype(trough_thres, peak_thres, pre_ms, intv, time, spk)
% decide the type of interval of interest
% 
% inputs:
%   trough_thres    - lower threshold of spike count
%   peak_thres      - higher threshold of spike count
%   intv            - time interval for checking
%   time            - in ms
%   spk             - absolute spike rate
%   
% outputs:
%   int_type        - type of the interval: 0 = flat, 1 = peak, 2 = trough

% get spk in the intv
% --------------------
chk_intv = pre_ms + intv;
chk_idx = time >= chk_intv(1) & time <= chk_intv(2);
chk_spk = spk(:, chk_idx);
chk_n = round(chk_spk * 1000);  % spike count at each time

% check type at each level
% -------------------------
N = size(chk_n, 1);
int_type = zeros(N, 1);

for k = 1:N
    n_k = chk_n(k, :);  % spike count at kth level
    n_p = n_k - peak_thres(k);
    p_area = sum(n_p(n_p >= 0));
    
    n_t = trough_thres(k) - n_k;
    t_area = sum(n_t(n_t >= 0));
    
    if p_area > t_area
        int_type(k) = 1;
    elseif p_area < t_area
        int_type(k) = 2;
    else
        int_type(k) = 0;
    end % if
    
end % for
 

end % function


function [low_cut, high_cut] = blstat(pre_ms, baselin_var_s1, time, spk, baselin_var_thres)
% find baseline statistics
% 
% outputs:
%   low_cut         - spike count lower end (for low_p)
%   hight_cut       - spike count higher end (for high_p)

% get baseline spike count at each level
% ---------------------------------------
bl_intv = pre_ms + baselin_var_s1;  % baseline interval
bl_idx = time >= bl_intv(1) & time <= bl_intv(2);
bl_spk = spk(:, bl_idx);        % absolute baseline spike rates
bl_n = round(bl_spk * 1000);    % spike count in 1s window, levels x time

% get critical value of counts
% ------------------------------
high_p = baselin_var_thres / 100;
low_p = 1 - high_p;
N = size(bl_n, 1);      % number of contrast levels
low_cut = zeros(N, 1);
high_cut = zeros(N, 1);
for k = 1:N     % use poisson fit and find critical value
    spkn_k = bl_n(k, :);    % baseline spike count for level k
    lbdhat = poissfit(spkn_k);  % mean spike count
    low_cut_k = poissinv(low_p, lbdhat);
    high_cut_k = poissinv(high_p, lbdhat);
    
    low_cut(k) = low_cut_k;
    high_cut(k) = high_cut_k;
end % for

end % function


% [EOF]
