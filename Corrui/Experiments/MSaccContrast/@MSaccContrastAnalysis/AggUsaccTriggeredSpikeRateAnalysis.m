function result_dat = AggUsaccTriggeredSpikeRateAnalysis(current_tag, name, S, dat)
% AGGUSACCTRIGGEREDSPIKERATEANALYSIS Average MS-triggered spike rate accross cells
% 
% Description:
%   This function calculates averaged spike rates and averaged normalized
%   spike rates across cells.
% 
% Syntax:
%   result_dat = AggUsaccTriggeredSpikeRateAnalysis(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also StepContrastResponseSorting, UsaccTriggeredContrastResponse_2stages, UsaccTriggeredContrastResponse.

% Copyright 2013 Richard J. Cui. Created: Wed 06/27/2012  8:49:25.794 AM
% $Revision: 0.4 $  $Date: Mon 03/04/2013  9:46:32.743 AM $
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
    %     opt.smooth_size = {40 '' [1 100]};
    %     opt.smooth_sigma = {10 '' [1 100]};
    
    %     opt.Usacc_rate_smoothing_Window_half_width = {100, '* (ms)', [1 2000]};     % 125
    % opt.Usacc_rate_option = {'Rate|{YN NPMovWin}|YN Locfit'};     

    opt.analysis_surrogate = { {'{0}','1'}, 'Surroage analysis' };
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'UsaccTriggeredSpikeRate', 'UsaccTriggeredSpikeRate_Norm', ...
                'UsaccTriggeredSpikeRateOff', 'UsaccTriggeredSpikeRateOff_Norm', ...
                'SurrogateUsaccTriggeredSpikeRate', 'SurrogateUsaccTriggeredSpikeRate_Norm', ...
                'SurrogateUsaccTriggeredSpikeRateOff', 'SurrogateUsaccTriggeredSpikeRateOff_Norm', ...
                'PreMSIntv', 'SpikeRateWinCenter'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% spike rate
% ----------
% A. ms-onset triggered
sr_norm = dat.UsaccTriggeredSpikeRate_Norm;
sr = dat.UsaccTriggeredSpikeRate;
% simple mean and sem
N = size(sr, 3);    % number of cells
sr_mean = mean(sr, 3);  % mean
sr_sem = std(sr, [], 3)/sqrt(N);
sr_mean_norm = mean(sr_norm, 3);
sr_sem_norm = std(sr_norm, [], 3) / sqrt(N);

% B. ms-offset triggered
sr_off_norm = dat.UsaccTriggeredSpikeRateOff_Norm;
sr_off = dat.UsaccTriggeredSpikeRateOff;
% simple mean and sem
N = size(sr_off, 3);    % number of cells
sr_off_mean = mean(sr_off, 3);  % mean
sr_off_sem = std(sr_off, [], 3)/sqrt(N);
sr_off_mean_norm = mean(sr_off_norm, 3);
sr_off_sem_norm = std(sr_off_norm, [], 3) / sqrt(N);

% spike rate using surrogate ms
% -----------------------------
analysis_sur = S.Stage_2_Options.AggUsaccTriggeredSpikeRateAnalysis_options.analysis_surrogate;
if analysis_sur
    % A. ms-onset triggered
    sursr_norm = dat.SurrogateUsaccTriggeredSpikeRate_Norm;
    sursr = dat.SurrogateUsaccTriggeredSpikeRate;
    % simple mean and sem
    N = size(sursr, 3);    % number of cells
    sursr_mean = mean(sursr, 3);  % mean
    sursr_sem = std(sursr, [], 3)/sqrt(N);
    sursr_mean_norm = mean(sursr_norm, 3);
    sursr_sem_norm = std(sursr_norm, [], 3) / sqrt(N);
    
    % B. ms-offset triggered
    sursr_off_norm = dat.SurrogateUsaccTriggeredSpikeRateOff_Norm;
    sursr_off = dat.SurrogateUsaccTriggeredSpikeRateOff;
    % simple mean and sem
    N = size(sursr_off, 3);    % number of cells
    sursr_off_mean = mean(sursr_off, 3);  % mean
    sursr_off_sem = std(sursr_off, [], 3)/sqrt(N);
    sursr_off_mean_norm = mean(sursr_off_norm, 3);
    sursr_off_sem_norm = std(sursr_off_norm, [], 3) / sqrt(N);
else
    sursr_mean = [];
    sursr_sem = [];
    sursr_mean_norm = [];
    sursr_sem_norm = [];
    
    sursr_off_mean = [];
    sursr_off_sem = [];
    sursr_off_mean_norm = [];
    sursr_off_sem_norm = [];
end % if

% difference between response at some contrast and at 0% contrast
% ---------------------------------------------------------------
sr_diff = zeros(size(sr));
sr_diff_norm = zeros(size(sr_norm));

sr_1 = sr(1, :, :);
sr_norm_1 = sr_norm(1, :, :);
M = size(sr, 1);    % number of contrast levels
for k = 1:M
    sr_k = sr(k, :, :);
    d_sr_k = sr_k - sr_1;
    sr_diff(k, :, :) = d_sr_k;
    
    sr_norm_k = sr_norm(k, :, :);
    d_sr_norm_k = sr_norm_k - sr_norm_1;
    sr_diff_norm(k, :, :) = d_sr_norm_k;
end % for

sr_diff_mean = mean(sr_diff, 3);
sr_diff_sem = std(sr_diff, [], 3) / sqrt(N);
sr_diff_mean_norm = mean(sr_diff_norm, 3);
sr_diff_sem_norm = std(sr_diff_norm, [], 3) / sqrt(N);


% peak values and correlation to contrast
% ----------------------------------------
% wc = dat.SpikeRateWinCenter;
% pre_ms = dat.PreMSIntv;
% ztime = pre_ms + 1;
% time = wc - ztime;

% win1_idx = time >= 25 & time <= 75;
% win2_idx = time >= 150 & time <= 200;

% [peak1_sr_mean, peak1_sr_sem] = getpeaks(win1_idx, sr_mean, sr_sem);
% [peak2_sr_mean, peak2_sr_sem] = getpeaks(win2_idx, sr_mean, sr_sem);

% [peak1_sr_mean_norm, peak1_sr_sem_norm] = getpeaks(win1_idx, sr_mean_norm, sr_sem_norm);
% [peak2_sr_mean_norm, peak2_sr_sem_norm] = getpeaks(win2_idx, sr_mean_norm, sr_sem_norm);

% trough values and correlation to contrast
% ----------------------------------------
% win3_idx = time >= 50 & time <= 150;
% [trough1_sr_mean, trough1_sr_sem] = gettroughs(win3_idx, sr_mean, sr_sem);
% [trough1_sr_mean_norm, trough1_sr_sem_norm] = gettroughs(win3_idx, sr_mean_norm, sr_sem_norm);

% =====================
% commit results
% =====================
result_dat.SpikeRateMean = sr_mean;
result_dat.SpikeRateMeanOff = sr_off_mean;
result_dat.SpikeRateSEM = sr_sem;
result_dat.SpikeRateSEMOff = sr_off_sem;

result_dat.SurrogateSpikeRateMean = sursr_mean;
result_dat.SurrogateSpikeRateMeanOff = sursr_off_mean;
result_dat.SurrogateSpikeRateSEM = sursr_sem;
result_dat.SurrogateSpikeRateSEMOff = sursr_off_sem;

result_dat.SpikeRateMean_Norm = sr_mean_norm;
result_dat.SpikeRateMeanOff_Norm = sr_off_mean_norm;
result_dat.SpikeRateSEM_Norm = sr_sem_norm;
result_dat.SpikeRateSEMOff_Norm = sr_off_sem_norm;

result_dat.SurrogateSpikeRateMean_Norm = sursr_mean_norm;
result_dat.SurrogateSpikeRateMeanOff_Norm = sursr_off_mean_norm;
result_dat.SurrogateSpikeRateSEM_Norm = sursr_sem_norm;
result_dat.SurrogateSpikeRateSEMOff_Norm = sursr_off_sem_norm;

result_dat.SpikeRateDiffMean = sr_diff_mean;
result_dat.SpikeRateDiffSEM = sr_diff_sem;
result_dat.SpikeRateDiffMean_Norm = sr_diff_mean_norm;
result_dat.SpikeRateDiffSEM_Norm = sr_diff_sem_norm;
% result_dat.PeakWindowIndex1 = win1_idx;
% result_dat.PeakWindowIndex2 = win2_idx;
% result_dat.SpikeRateMean_Peak1 = peak1_sr_mean;
% result_dat.SpikeRateSEM_Peak1 = peak1_sr_sem;
% result_dat.SpikeRateMean_Peak2 = peak2_sr_mean;
% result_dat.SpikeRateSEM_Peak2 = peak2_sr_sem;
% result_dat.SpikeRateMean_Norm_Peak1 = peak1_sr_mean_norm;
% result_dat.SpikeRateSEM_norm_Peak1 = peak1_sr_sem_norm;
% result_dat.SpikeRateMean_Norm_Peak2 = peak2_sr_mean_norm;
% result_dat.SpikeRateSEM_norm_Peak2 = peak2_sr_sem_norm;
% result_dat.SpikeRateMean_Trough1 = trough1_sr_mean;
% result_dat.SpikeRateSEM_Trough1 = trough1_sr_sem;
% result_dat.SpikeRateMean_Norm_Trough1 = trough1_sr_mean_norm;
% result_dat.SpikeRateSEM_norm_Trough1 = trough1_sr_sem_norm;

end % function 

% =====================
% subroutines
% =====================
% function [trough_mean, trough_sem] = gettroughs(win_idx, rt_mean, rt_sem)
% 
% t_mean = rt_mean(:, win_idx);
% [~, trough_idx] = min(t_mean, [], 2);
% trough_mean = diag(t_mean(:, trough_idx));
% 
% t_sem = rt_sem(:, win_idx);
% trough_sem = diag(t_sem(:, trough_idx));
% end 

% function [peak_mean, peak_sem] = getpeaks(win_idx, rt_mean, rt_sem)
% 
% p_mean = rt_mean(:, win_idx);
% [~, peak_idx] = max(p_mean, [], 2);
% peak_mean = diag(p_mean(:, peak_idx));
% 
% p_sem = rt_sem(:, win_idx);
% peak_sem = diag(p_sem(:, peak_idx));
% 
% end % funciton

% [EOF]