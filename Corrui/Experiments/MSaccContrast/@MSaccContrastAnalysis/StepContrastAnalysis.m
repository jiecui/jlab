function result_dat = StepContrastAnalysis(current_tag, name, S, dat)
% STEPCONTRASTANALYSIS Analysis of the response of the cell to step changes of contrast (archaic)
%
% Syntax:
%   result_dat = StepContrastAnalysis(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Tue 06/05/2012  9:30:04.910 AM
% $Revision: 0.3 $  $Date: Wed 06/20/2012  4:45:26.181 PM $
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
    % ref StructDlg.m
    opt.Excluding_events_window = {500 '* (ms)' [0 1300]};  % time window length for excluding eye events before and after contrast change
    opt.Moving_window_width = {250 '* (ms)' [10 1000]};     % moving window width for estimating firing rate
    opt.Moving_window_step =  {50 '* (ms)' [1 2000]};       % moving window step  for estimating firing rate
    % opt = [];
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'SpikeYN', 'BlinkYN', 'SaccadeYN', 'UsaccYN', ...
                'LastConChunk', 'EyeSignals'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
SpikeYN = dat.SpikeYN;
% BlinkYN = dat.BlinkYN;
UsaccYN = dat.UsaccYN;
LastConChunk = dat.LastConChunk;
% EyeSignals = dat.EyeSignals;

% time window length for excluding eye events before and after contrast change
exwin = S.Stage_2_Options.StepContrastAnalysis_options.Excluding_events_window;
winwidth = S.Stage_2_Options.StepContrastAnalysis_options.Moving_window_width;
winstep = S.Stage_2_Options.StepContrastAnalysis_options.Moving_window_step;

grattime = LastConChunk.ConEnvVars.grattime;   % time for the presentation of one stage of stimuli
[numCycles, SigLen, numConditions] = size(SpikeYN);

cont_time = grattime * 2;       % contrast change time
params.tapers = [3 ,5];     % not used now
mintime = 1; maxtime = SigLen;
params.minmaxtime = [mintime, maxtime];
movingwin = [winwidth, winstep];
tn=(mintime+movingwin(1)/2:movingwin(2):maxtime-movingwin(1)/2);
base_width = 500;
nR = zeros(length(tn), numConditions);        % normalized firing rate
NoExnR = nR;            % no excluding trials
noutR = nR;

% find the base rate for normalization
% ------------------------------------
% use base_width ms before the onset of 1st contrast from all trials
x = SpikeYN(:,(grattime - base_width + 1):grattime,:);
y = sum(x(:));
base_R = y/(base_width * numCycles * numConditions);

barh = waitbar(0, 'StepContrastAnalysis, please wait...');
for k = 1:numConditions
    waitbar(k / numConditions)
    spikeyn_k = SpikeYN(:, :, k);
    % --------------------------------------------------------------------
    % not select trials - firing rate estimated from all available trials
    % --------------------------------------------------------------------
    % data_whole_k = SpikeYN2ChronuxData(spikeyn_k);
    % [~,~,~,R_whole_k] = mtspecgrampt(data_whole_k, movingwin, params);
    [~, R_whole_k] = SpikeProcess.SpikeRateEstimation.ChronuxEst(spikeyn_k, movingwin, params);
    mR_whole_k = mean(R_whole_k,2);
    nmR_whole_k = (mR_whole_k - base_R) / base_R;
    NoExnR(:, k) = nmR_whole_k;

    % -------------------------------------------------------------
    % select trials depending on if there is eyemovement events in
    % excluding-event-windows or not
    % -------------------------------------------------------------
    usaccyn_k = UsaccYN(:, :, k);
    in_indx = true(numCycles,1);
    if exwin > 0
        peri = usaccyn_k(:,(cont_time - exwin):(cont_time + exwin));
        out_indx = (sum(peri,2) > 0);   % usacc trials only
        in_indx = ~(sum(peri,2) > 0);   % no usacc
    end % if
    spikeyn_out_k = spikeyn_k(out_indx, :);     % usacc trials in excluding-event-windows only
    spikeyn_in_k = spikeyn_k(in_indx, :);       % no usacc trials in excluding-event-windows only
    
    if ~isempty(spikeyn_in_k)
        [t, R_k] = SpikeProcess.SpikeRateEstimation.ChronuxEst(spikeyn_in_k, movingwin, params);
        % ********* normalization ***********
        mR_k = mean(R_k, 2);
        nR_k = (mR_k - base_R)/base_R;  % normalized firing rate
    else
        nR_k = NaN(length(tn),1);
    end %if
    
    if ~isempty(spikeyn_in_k)
        [t, outR_k] = SpikeProcess.SpikeRateEstimation.ChronuxEst(spikeyn_out_k, movingwin, params);
        % ********* normalization ***********
        moutR_k = mean(outR_k, 2);
        noutR_k = (moutR_k - base_R)/base_R;
    else
        noutR_k = NaN(length(tn),1);
    end %if
    
    noutR(:, k) = noutR_k;
    nR(:,k) = nR_k;
end % for
close(barh)

% =====================
% commit results
% =====================
result_dat.StepContrastAnalysisResult.WindowCenters = t;        % time of window centers for estimating firing rate
result_dat.StepContrastAnalysisResult.DynamicFiringRate  = nR;  % firing rate estimated only from the trials where there are NO usacc in excluding-event-windows
result_dat.StepContrastAnalysisResult.NoExcludeFR  = NoExnR;    % firing rate estimated from all available trials
result_dat.StepContrastAnalysisResult.UsaccOnlyTrialFR = noutR; % firing rate estimated only from the trials where there are usacc in excluding-event-windows

end % function StepContrastAnalysis

% [EOF]
