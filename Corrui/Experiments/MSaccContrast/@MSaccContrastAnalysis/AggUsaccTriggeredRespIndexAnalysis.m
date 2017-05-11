function result_dat = AggUsaccTriggeredRespIndexAnalysis(current_tag, name, S, dat)
% AGGUSACCTRIGGEREDRESPINDEXANALYSIS Microsaccade-triggered activities indexes (archaic)
% 
% Syntax:
%   result_dat = AggUsaccTriggeredRespIndexAnalysis(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also StepContrastResponseSorting.m.

% Copyright 2012 Richard J. Cui. Created: Thu 08/16/2012  6:16:26.422 PM
% $Revision: 0.1 $  $Date: Thu 08/16/2012  6:16:26.422 PM $
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
    
    opt.pre_interval = {300 '* (ms)' [0 2000]};     % time interval before MS onset for averaging FR
    opt.post_interval = {300 '* (ms)' [0 2000]};    % time interval after MS onset for averaging FR
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'SpikeRateWinCenter', 'UsaccTriggeredSpikeRate', 'PreMSIntv' };
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% -------------
% get the data
% -------------
sr = dat.UsaccTriggeredSpikeRate;   % spike rate
spk_c = dat.SpikeRateWinCenter;
pre_ms = dat.PreMSIntv;         % time for checking activity before usacc onset
N = size(sr, 3);                % number of cells

% get parameters
% --------------
pre_int = S.Stage_2_Options.AggUsaccTriggeredRespIndexAnalysis_options.pre_interval;
pos_int = S.Stage_2_Options.AggUsaccTriggeredRespIndexAnalysis_options.post_interval;

% response index
% --------------------
t = spk_c - pre_ms;        
idx_pre = t < 0 & t >= -pre_int;
idx_pos = t >= 0 & t <  pos_int;

sr_pre = sr(:, idx_pre, :);
sr_pos = sr(:, idx_pos, :);

% mean of individual cells at different contrast levels
msr_pre = squeeze(mean(sr_pre, 2));
msr_pos = squeeze(mean(sr_pos, 2));

% delta
dsr = msr_pos - msr_pre;
dsr_mean = mean(dsr, 2);
dsr_std = std(dsr, [], 2);
dsr_sem = dsr_std / sqrt(N);

% -----------------------------------
% plot check points
% -----------------------------------
cont = 0:10:100;
% bar
figure
bar(cont, dsr_mean);
xlim([-10, 110])

% errorbar
figure
errorbar(cont, dsr_mean, dsr_sem)
xlim([-10, 110])
hold on
plot(xlim, [0 0], 'g')

% =====================
% commit results
% =====================
result_dat.UsaccTriggeredRespIndex.mean = dsr_mean;
result_dat.UsaccTriggeredRespIndex.std = dsr_std;
result_dat.UsaccTriggeredRespIndex.mean = dsr_sem;

end % function StepContrastAnalysis

% =====================
% subroutines
% =====================


% [EOF]