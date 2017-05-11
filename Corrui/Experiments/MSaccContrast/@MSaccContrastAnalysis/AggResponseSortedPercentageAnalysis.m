function result_dat = AggResponseSortedPercentageAnalysis(current_tag, name, S, dat)
% AGGRESPONSESORTEDPERCENTAGEANALYSIS Sorted responses of step-contrast responses using percentage change (archaic)
% 
% Syntax:
%   result_dat = AggResponseSortedUsaccRate(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also StepContrastResponseSorting.m.

% Copyright 2012 Richard J. Cui. Created: Wed 06/27/2012  8:49:25.794 AM
% $Revision: 0.1 $  $Date: Wed 06/27/2012  8:49:25.794 AM $
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
    
    %     opt.Usacc_rate_smoothing_Window_half_width = {100, '* (ms)', [1 2000]};     % 125
    opt.Usacc_rate_option = {'Rate|{YN NPMovWin}|YN Locfit'};     
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'ResponseSortedPercentage', 'SpikeRateWinCenter', 'UsaccRateWinCenter' };
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% -------------
% process
% -------------
% spike rate
sr = dat.ResponseSortedPercentage.SpikeRate;
[sr_mean, ~, sr_sem] = getstat(sr);
spk_c = dat.SpikeRateWinCenter;

% usacc rate
rate_method = S.Stage_2_Options.AggResponseSortedPercentageAnalysis_options.Usacc_rate_option;
switch rate_method
    case 'Use Rate'
        ur = dat.ResponseSortedPercentage.UsaccRate;
        [ur_mean, ~, ur_sem] = getstat(ur);
        usa_c = dat.UsaccRateWinCenter;
    case 'YN NPMovWin'
        usa_yn = dat.ResponseSortedPercentage.UsaccYN;
        [usa_c, ur_mean, ur_sem] = NPMovWinYN(usa_yn);
    case 'YN Locfit'
        usa_yn = dat.ResponseSortedPercentage.UsaccYN;
        [usa_c, ur_mean, ur_sem] = LocfitRateEstYN(usa_yn);
end % switch

% -----------------------------------
% plot check points
% -----------------------------------
t = usa_c - 2600;
l_mean = ur_mean(:,1);
m_mean = ur_mean(:,2);
l_sem = ur_sem(:,1);
m_sem = ur_sem(:,2);
figure
plot(t, [l_mean, m_mean]*1000, 'LineWidth', 2)
hold on
plot(t, (l_mean + l_sem)*1000, 'b:')
plot(t, (l_mean - l_sem)*1000, 'b:')
plot(t, (m_mean + m_sem)*1000, 'color', [0 0.5 0], 'LineStyle', ':')
plot(t, (m_mean - m_sem)*1000, 'color', [0 0.5 0], 'LineStyle', ':')
xlim([-600, 1200])
% ylim([1 3])
plot([0 0], ylim, 'r')

% spike rate
t = spk_c - 2600;
l_mean = sr_mean(:,1);
m_mean = sr_mean(:,2);
l_sem = sr_sem(:,1);
m_sem = sr_sem(:,2);
figure
plot(t, [l_mean, m_mean], 'LineWidth', 2)
hold on
plot(t, (l_mean + l_sem), 'b:')
plot(t, (l_mean - l_sem), 'b:')
plot(t, (m_mean + m_sem), 'color', [0 0.5 0], 'LineStyle', ':')
plot(t, (m_mean - m_sem), 'color', [0 0.5 0], 'LineStyle', ':')
xlim([-600, 1200])
ylim([-1 12])
plot([0 0], ylim, 'r')

% =====================
% commit results
% =====================

result_dat.AnalysisResult.Usacc.WinCenters = usa_c;
result_dat.AnalysisResult.Usacc.MeanRate = ur_mean;
result_dat.AnalysisResult.Usacc.SemRate = ur_sem;
result_dat.AnalysisResult.Spike.WinCenters = spk_c;
result_dat.AnalysisResult.Spike.MeanRate = sr_mean;
result_dat.AnalysisResult.Spike.SemRate = sr_sem;

end % function StepContrastAnalysis

% =====================
% subroutines
% =====================
function [t, ur_mean, ur_sem] = NPMovWinYN(usa_yn)
% Estimates rate using moving window
% 
% Inputs
%   usa_yn      - usacc YN
% 
% Output(s)
%   t           - time of mean ans sem
%   ur_mean     - usacc rate mean. ur_mean(:, 1) = mean of least response
%                 trials; ur_mean(:, 2) = mean of most response trials
%   ur_sem      - structure is the same as ur_mean, but for standard error
%                 of mean

[usayn_most, usayn_least] = getmostleastyn(usa_yn);

% disp info
% ---------
fprintf(sprintf('%d trials of strongest respose\n', size(usayn_most,1)));
fprintf(sprintf('%d trials of weakest respose\n', size(usayn_least,1)));

win_width = 200;
win_step = 10;
% most
[~, urm_mean, urm_sem] = EyeProcess.MicrosaccadeRateEstimation.NoneParaMovingWindowEst(usayn_most, win_width, win_step);
% least
[t, url_mean, url_sem] = EyeProcess.MicrosaccadeRateEstimation.NoneParaMovingWindowEst(usayn_least, win_width, win_step);

ur_mean = [url_mean(:), urm_mean(:)];
ur_sem  = [url_sem(:), urm_sem(:)];

end % fuction

function [t, ur_mean, ur_sem] = LocfitRateEstYN(usa_yn)
% Estimates rate using locfit()
% 
% Inputs
%   usa_yn      - usacc YN
% 
% Output(s)
%   t           - time of mean ans sem
%   ur_mean     - usacc rate mean. ur_mean(:, 1) = mean of least response
%                 trials; ur_mean(:, 2) = mean of most response trials
%   ur_sem      - structure is the same as ur_mean, but for standard error
%                 of mean

[usayn_most, usayn_least] = getmostleastyn(usa_yn);
x0 = 1; x1 = size(usayn_least, 2);

% most
[~, urm_mean, ~, urm_sem] = EyeProcess.MicrosaccadeRateEstimation.LocfitEst(usayn_most, [x0 x1], 'nn', 0.2);
% least
[t, url_mean, ~, url_sem] = EyeProcess.MicrosaccadeRateEstimation.LocfitEst(usayn_least, [x0 x1], 'nn', 0.2);

ur_mean = [url_mean(:), urm_mean(:)];
ur_sem  = [url_sem(:), urm_sem(:)];

end % fuction


function [mn, st, sem] = getstat(rate)

N = length(rate);

least_mean = [];
most_mean = [];
for k = 1:N
    least_mean = cat(2, least_mean, rate(k).LeastResponse(:,1));
    most_mean = cat(2, most_mean, rate(k).MostResponse(:,1));
end % for

l_mean = mean(least_mean, 2);
l_std = std(least_mean, 1, 2);
l_sem = l_std/sqrt(N);

m_mean = mean(most_mean, 2);
m_std = std(most_mean, 1, 2);
m_sem = m_std/sqrt(N);

mn = [l_mean, m_mean];
st = [l_std, m_std];
sem = [l_sem, m_sem];

end

function [most_yn, least_yn] = getmostleastyn(yn)

N = length(yn);

most_yn = [];
least_yn = [];
for k = 1:N
    
    m_k = yn(k).MostResponse;
    l_k = yn(k).LeastResponse;
    
    most_yn = cat(1, most_yn, m_k);
    least_yn = cat(1, least_yn, l_k);
    
end % for

end % fucntion

% [EOF]