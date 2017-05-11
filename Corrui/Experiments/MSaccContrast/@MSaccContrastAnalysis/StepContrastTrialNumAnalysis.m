function result_dat = StepContrastTrialNumAnalysis(current_tag, name, S, dat)
% STEPCONTRASTTRIALNUMANALYSIS Analysis of changes of contrast as a function of number of trials involved (archaic)
% 
% Description:
%       It investigates whether the reduction of step contrast response is
%       due to the reduction of trial numbers.
%
% Syntax:
%   result_dat = StepContrastTrialNumAnalysis(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Mon 06/18/2012  5:23:49.112 PM
% $Revision: 0.1 $  $Date: Mon 06/18/2012  5:23:49.112 PM $
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

    opt.Excluding_events_window = {500 '* (ms)' [0 1300]};    % time window length for excluding eye events before and after contrast change
    opt.Moving_window_width = {250 '* (ms)' [10 1000]};
    opt.Moving_window_step =  {50 '* (ms)' [1 2000]};
    opt.Number_of_repeats = {5 '' [1 100]};
    % opt = [];
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'SpikeYN', 'SaccadeYN', 'UsaccYN', ...
                'LastConChunk'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
SpikeYN = dat.SpikeYN;
% BlinkYN = dat.BlinkYN;
% UsaccYN = dat.UsaccYN;
LastConChunk = dat.LastConChunk;
% EyeSignals = dat.EyeSignals;

% time window length for excluding eye events before and after contrast change
% exwin = S.Stage_2_Options.StepContrastAnalysis_options.Excluding_events_window;
winwidth = S.Stage_2_Options.StepContrastTrialNumAnalysis_options.Moving_window_width;
winstep = S.Stage_2_Options.StepContrastTrialNumAnalysis_options.Moving_window_step;
numRep = S.Stage_2_Options.StepContrastTrialNumAnalysis_options.Number_of_repeats;

grattime = LastConChunk.ConEnvVars.grattime;   % time for the presentation of one stage of stimuli
[numCycles, SigLen, numConditions] = size(SpikeYN);

% cont_time = grattime * 2;       % contrast change time
params.tapers = [3 ,5];     % not used now
mintime = 1; maxtime = SigLen;
params.minmaxtime = [mintime, maxtime];
movingwin = [winwidth, winstep];
tn=(mintime+movingwin(1)/2:movingwin(2):maxtime-movingwin(1)/2);
base_width = 500;

nR = zeros(length(tn), numCycles, numConditions); % normalized firing rate = window number x number of trials involved x condition number

% find the base rate for normalization
% ------------------------------------
% use base_width ms before the onset of 1st contrast from all trials
x = SpikeYN(:,(grattime - base_width + 1):grattime,:);
y = sum(x(:));
base_R = y/(base_width * numCycles * numConditions);

% -------------------------------------------------
% find the response from selected number of trials
% condition by condition
% -------------------------------------------------
h = waitbar(0, 'Please wait...');
for k = 1:numConditions
    waitbar(k/numConditions);
    % obtain spike YN for specified condition
    spikeyn_k = SpikeYN(:, :, k);   % trial number x spike Y/N
    
    % choose number of cycles involved
    for m = 1:numCycles
        % choose number of repeats
        fr_k = [];
        for n = 1:numRep
            p = randperm(numCycles);
            q = p(1:m);
            spk = spikeyn_k(q,:);
            fr_n = zeros(length(tn), 1);
            if sum(spk(:)) ~= 0
                try
                    [t, fr_n] = SpikeProcess.SpikeRateEstimation.ChronuxEst(spk, movingwin, params);
                catch
                    pause
                end
            end
            fr_k = cat(2, fr_k, mean(fr_n, 2));
        end % for
        mfr_k = mean(fr_k, 2);
        nmfr_k = (mfr_k - base_R) / base_R;
        nR(:, m, k) = nmfr_k(:);
    end % for
    
    
end % for
delete(h)

% =====================
% commit results
% =====================
result_dat.WindowCenters = t;
result_dat.TrialNumAnalysisFR  = nR;
% result_dat.NoExcludeFR  = NoExnR;

end % function StepContrastAnalysis

% [EOF]
