function result_dat = AggStepContrastAnalysis(current_tag, name, S, dat)
% AGGSTEPCONTRASTANALYSIS Analysis of the response to step changes of contrast (archaic)
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
    opt.post_onset_time = {500 '* (ms)' [0 2000]};
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'AggDynamicFiringRate', 'AggNoExcludeFR', 'AggWindowCenters',...
                'ConEnvVars', 'AggUsaccOnlyTrialFR'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% get the data
% -------------
dfr     = dat.AggDynamicFiringRate;
all_fr  = dat.AggNoExcludeFR;
uo_fr   = dat.AggUsaccOnlyTrialFR;
winc    = dat.AggWindowCenters;
envvar  = dat.ConEnvVars;

post_onset_time = S.Stage_2_Options.AggStepContrastAnalysis_options.post_onset_time;
% step response for selected cell
% -------------------------------
grattime = envvar.grattime;
idx = winc > grattime;
tmp_winc = winc(idx);
step_winc = tmp_winc - (grattime + 1);
step_dfr = dfr.mean(idx, :);      % just cont1 and cont2

% step response for all cell
% ---------------------------
step_allfr = all_fr.mean(idx, :);

% step response for trials with usacc only
% -----------------------------------------
step_uofr = uo_fr.mean(idx, :);


% -------------------------
% step-z score
% -------------------------
% selected
idx1 = step_winc >= 1 & step_winc <= grattime;
cont1_dfr = step_dfr(idx1, :);
m1_dfr = mean(cont1_dfr);

idx2 = step_winc >= grattime+1 & step_winc <= grattime * 2;
cont2_dfr = step_dfr(idx2, :);
m2_dfr = mean(cont2_dfr);
stepz_dfr = (m1_dfr - m2_dfr)./(m1_dfr + m2_dfr);   % step response z-score

% all
cont1_allfr = step_allfr(idx1, :);
m1_allfr = mean(cont1_allfr);
cont2_allfr = step_allfr(idx2, :);
m2_allfr = mean(cont2_allfr);
stepz_allfr = (m1_allfr - m2_allfr)./(m1_allfr + m2_allfr);


% -------------------------
% compare post-onset mean fr rate
% -------------------------
idx = step_winc >= grattime & step_winc <= grattime + post_onset_time;
post_dfr = step_dfr(idx, :);
mpost_dfr = mean(post_dfr);
mdfr = reshape(mpost_dfr, 11, 11);
mean_mdfr = mean(mdfr, 2);
std_mdfr = std(mdfr, 1, 2);
sem_mdfr = std_mdfr/sqrt(11);

post_allfr = step_allfr(idx, :);
mean_post_allfr = mean(post_allfr);
mallfr = reshape(mean_post_allfr, 11, 11);
mean_mallfr = mean(mallfr, 2);
std_mallfr = std(mallfr, 1, 2);
sem_mallfr = std_mallfr/sqrt(11);

post_uofr = step_uofr(idx, :);
mean_post_uofr = mean(post_uofr);
muofr = reshape(mean_post_uofr, 11, 11);
mean_muofr = mean(muofr, 2);
std_muofr = std(muofr, 1, 2);
sem_muofr = std_muofr/sqrt(11);


% =====================
% commit results
% =====================
result_dat.StepDynamicFiringRate = step_dfr;
result_dat.StepNoExcludeFr = step_allfr;
result_dat.StepUsaccOnlyFr = step_uofr;
result_dat.StepWinCenter = step_winc;
result_dat.StepZ_DFR = stepz_dfr;
result_dat.StepZ_AllFR = stepz_allfr;
result_dat.PostOnsetFRForSelectedTrials.mean = mean_mdfr;
result_dat.PostOnsetFRForSelectedTrials.std = std_mdfr;
result_dat.PostOnsetFRForSelectedTrials.sem = sem_mdfr;
result_dat.PostOnsetFRForAllTrials.mean = mean_mallfr;
result_dat.PostOnsetFRForAllTrials.std = std_mallfr;
result_dat.PostOnsetFRForAllTrials.sem = sem_mallfr;
result_dat.PostOnsetFRForUsaccOnly.mean = mean_muofr;
result_dat.PostOnsetFRForUsaccOnly.std = std_muofr;
result_dat.PostOnsetFRForUsaccOnly.sem = sem_muofr;

end % function StepContrastAnalysis

% [EOF]
