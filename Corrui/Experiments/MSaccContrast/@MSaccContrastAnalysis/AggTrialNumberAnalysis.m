function result_dat = AggTrialNumberAnalysis(current_tag, name, S, dat)
% AGGTRIALNUMBERANALYSIS Analysis of post-onset response to step-contrast as a function of number of trials involved (archaic)
%
% Syntax:
%   result_dat = AggTrialNumberAnalysis(current_tag, name, S, dat)
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
% $Revision: 0.1 $  $Date: Tue 06/12/2012  3:07:14.181 PM $
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
    opt.post_onset_time = {500 '* (ms)' [0 2000]};
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'AggTrialNumAnalysisFR'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% -------------
% get the data
% -------------
trlfr     = dat.AggTrialNumAnalysisFR;
post_onset_time = S.Stage_2_Options.AggStepContrastAnalysis_options.post_onset_time;

% data from 'MSCagStepContResp'
% ----------------------------
sessname = 'MSCagStepContResp';
vars = {'AggWindowCenters', 'ConEnvVars', 'AggNoExcludeFR'};
data = CorruiDB.Getsessvars(sessname, vars);
envvar = data.ConEnvVars;
winc = data.AggWindowCenters;
all_fr = data.AggNoExcludeFR;

grattime = envvar.grattime;
idx1 = winc > grattime;
tmp_winc = winc(idx1);
step_winc = tmp_winc - (grattime + 1);
idx2 = step_winc >= grattime & step_winc <= grattime + post_onset_time;

% --------------------------------
% (1) step response for all trials
% --------------------------------
step_allfr = all_fr.mean(idx1, :);   % only cont1 & cont2

% post-onset mean fr rate
% -------------------------
post_allfr = step_allfr(idx2, :);
mean_post_allfr = mean(post_allfr);

mallfr = reshape(mean_post_allfr, 11, 11);
mean_mallfr = mean(mallfr, 2);
std_mallfr = std(mallfr, 1, 2);
sem_mallfr = std_mallfr/sqrt(11);

% -----------------------------------------
% (2) step response for number of 5 trials
% -----------------------------------------
fr5trl = squeeze(trlfr.max5trl(:,5,:,:));
step_fr5trl = mean(fr5trl(idx1, :, :), 3);
post_fr5trl = step_fr5trl(idx2, :);
mean_post_fr5trl = mean(post_fr5trl);

mfr5trl = reshape(mean_post_fr5trl, 11, 11);
mean_mfr5trl = mean(mfr5trl, 2);
std_mfr5trl = std(mfr5trl, 1, 2);
sem_mfr5trl = std_mfr5trl/sqrt(11);

% -----------------------------------------
% (3) step response for number of 1 trials
% -----------------------------------------
fr1trl = squeeze(trlfr.max5trl(:,1,:,:));
step_fr1trl = mean(fr1trl(idx1, :, :), 3);
post_fr1trl = step_fr1trl(idx2, :);
mean_post_fr1trl = mean(post_fr1trl);

mfr1trl = reshape(mean_post_fr1trl, 11, 11);
mean_mfr1trl = mean(mfr1trl, 2);
std_mfr1trl = std(mfr1trl, 1, 2);
sem_mfr1trl = std_mfr1trl/sqrt(11);

% -----------------------------------
% plot check points
% -----------------------------------
figure
contlevels = 0:10:100;
errorbar(contlevels, mean_mallfr, sem_mallfr,'-o', 'color', [0 0 1])
hold on
errorbar(contlevels, mean_mfr5trl, sem_mfr5trl,'-o', 'color', [0 0.5 0])
errorbar(contlevels, mean_mfr1trl, sem_mfr1trl,'-o', 'color', [1 0 0])
legend('Use All trials', 'Use 50%', 'Use 10%')
xlim([-5 105])

% =====================
% commit results
% =====================
result_dat.AggPostOnsetTrialNumAnalysis.All.mean = mean_mallfr;
result_dat.AggPostOnsetTrialNumAnalysis.All.std = std_mallfr;
result_dat.AggPostOnsetTrialNumAnalysis.All.sem = sem_mallfr;

result_dat.AggPostOnsetTrialNumAnalysis.FiveTrials.mean = mean_mfr5trl;
result_dat.AggPostOnsetTrialNumAnalysis.FiveTrials.std = std_mfr5trl;
result_dat.AggPostOnsetTrialNumAnalysis.FiveTrials.sem = sem_mfr5trl;

result_dat.AggPostOnsetTrialNumAnalysis.OneTrials.mean = mean_mfr1trl;
result_dat.AggPostOnsetTrialNumAnalysis.OneTrials.std = std_mfr1trl;
result_dat.AggPostOnsetTrialNumAnalysis.OneTrials.sem = sem_mfr1trl;

% result_dat = [];

end % function StepContrastAnalysis

% [EOF]