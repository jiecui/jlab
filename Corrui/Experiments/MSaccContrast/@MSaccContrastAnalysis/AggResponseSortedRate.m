function result_dat = AggResponseSortedRate(current_tag, name, S, dat)
% AGGRESPONSESORTEDRATE Rates of spikes and microsaccades of the trials sorted by response to contrast change (archaic)
%
% Syntax:
%   result_dat = AggResponseSortedRate(current_tag, name, S, dat)
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
% $Revision: 0.2 $  $Date: Tue 07/03/2012 10:13:01.555 AM $
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
    
    opt.Usacc_rate_smoothing_Window_half_width = {100, '* (ms)', [1 2000]};     % 125
    opt.Spike_rate_smoothing_Window_half_width = {125, '* (ms)', [1 2000]};     % 125
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'SpikeRateLeastResponseTrials', 'SpikeRateMostResponseTrials', 'SpikeRateWinCenter',...
                'UsaccRateLeastResponseTrials', 'UsaccRateMostResponseTrials', 'UsaccRateWinCenter',...
                'UsaccYNLeastResponseTrials', 'UsaccYNMostResponseTrials'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% -------------
% get the data
% -------------
spk_least = dat.SpikeRateLeastResponseTrials;
spk_most  = dat.SpikeRateMostResponseTrials;
spk_winc  = dat.SpikeRateWinCenter;

% spkyn_least = dat.SpikeYNLeastResponseTrials;
% spkyn_most = dat.SpikeYNMostResponseTrials;

usa_least = dat.UsaccRateLeastResponseTrials;
usa_most  = dat.UsaccRateMostResponseTrials;
usa_winc  = dat.UsaccRateWinCenter;

usayn_least = dat.UsaccYNLeastResponseTrials;
usayn_most = dat.UsaccYNMostResponseTrials;

% sessname = 'MSCagStepContResp';
% vars = {'AggWindowCenters', 'ConEnvVars', 'AggNoExcludeFR'};
% data = CorruiDB.Getsessvars(sessname, vars);

usa_halfwidth = S.Stage_2_Options.AggResponseSortedRate_options.Usacc_rate_smoothing_Window_half_width;
spk_halfwidth = S.Stage_2_Options.AggResponseSortedRate_options.Spike_rate_smoothing_Window_half_width;

% --------------------------------
% microsaccade rates
% --------------------------------
[ur_least_mean, ur_least_std, ur_least_sem] = estrates(usa_winc, usa_least, usa_halfwidth);
[ur_most_mean, ur_most_std, ur_most_sem] = estrates(usa_winc, usa_most, usa_halfwidth);

% --------------------------------
% firing rates
% --------------------------------
[spk_least_mean, spk_least_std, spk_least_sem] = estrates(spk_winc, spk_least, spk_halfwidth);
[spk_most_mean, spk_most_std, spk_most_sem] = estrates(spk_winc, spk_most, spk_halfwidth);

% -----------------------------------
% plot check points
% -----------------------------------
ur_least = [ur_least_mean', ur_least_std', ur_least_sem'] * 1000;   % change unit to 1/s
ur_most =  [ur_most_mean', ur_most_std', ur_most_sem'] * 1000;   % change unit to 1/s
plotrates(usa_winc, ur_least, ur_most, true)

spk_least = [spk_least_mean', spk_least_std', spk_least_sem'];
spk_most =  [spk_most_mean', spk_most_std', spk_most_sem'];
plotrates(spk_winc, spk_least, spk_most, false)

% =====================
% commit results
% =====================

result_dat.UsaccRate.LeastResponse = ur_least / 1000;
result_dat.UsaccRate.MostResponse  = ur_most / 1000;
result_dat.SpikeRate.LeastResponse = spk_least;
result_dat.SpikeRate.MostResponse = spk_most;
result_dat.UsaccYN.LeastResponse = usayn_least;
result_dat.UsaccYN.MostResponse = usayn_most;

end % function StepContrastAnalysis

% =====================
% subroutines
% =====================
function [rate_mean, rate_std, rate_sem] = estrates(t, rate, halfwidth)

t = t(:);
N = size(rate, 1);              % nubmer of trials involved
sm_rate = zeros(size(rate));    % smoothed rate

for k = 1:N
    rate_k = rate(k, :)';
    sm_rate_k = lfsmooth(t, rate_k, 'h', halfwidth);
    sm_rate(k, :) = sm_rate_k';
end % for

% average and confidence band
rate_mean = mean(sm_rate);
rate_std = std(sm_rate);
rate_sem = rate_std/sqrt(N);

end

function plotrates(t, least, most, flageye)

t = t-2600;     % shit zero to contrast onset
l_mean = least(:, 1);
l_sem  = least(:, 3);

m_mean = most(:, 1);
m_sem  = most(:, 3);

figure
set(gcf, 'Position', [120 418 560 165])

plot(t, l_mean(:,1), 'b', 'LineWidth', 2)
hold on
plot(t, l_mean + l_sem, 'b:')
plot(t, l_mean - l_sem, 'b:')

plot(t, m_mean, 'color', [0 0.5 0], 'LineWidth', 2)
plot(t, m_mean + m_sem, 'color', [0 0.5 0], 'LineStyle', ':')
plot(t, m_mean - m_sem, 'color', [0 0.5 0], 'LineStyle', ':')

xlim([-600, 1200])
if flageye
   
    ylim([0 6]);
else
    ylim([-1 20])
end
plot([0 0]*2, ylim, 'r')
set(gca, 'box', 'off', 'FontSize', 12)

end 

% [EOF]