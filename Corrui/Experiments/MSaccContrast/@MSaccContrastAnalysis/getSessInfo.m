function result_dat = getSessInfo(current_tag, name,  S, dat)
% GETSESSINFO Necessary preparation for mSacc-contrast exp data propcessing
%
% Syntax:
%   result_dat = getSessInfo(current_tag, name,  S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat.TrialTime    : delivery times of each condition per trial
%                             = maxRepeat x 3 x numConditions,
%                             where maxRepeat = Cycles, 3 = blank time index,
%                             contrast1 start time index and contrast2 starts
%                             time index, numConditions = 121.
%   result_dat.TrialCondition: the Condition number of each trial, e.g.
%                              TrialCondition(k) = m means the condition
%                              number of the kth trial is m.
%   result_dat.mSaccConSig  : data of mSaccade contrast signal
%                             = 121 x 3 structure
%   .SpikeYN                : whether spikes occurred at the specified time
%                             instance, logical array = number of cycles x
%                             trial length (include 3 stages) x number of
%                             conditions (121).
%   .EyeSingals             : x, y eye position signals = number of cycles
%                             x trial length x hor/ver x number of
%                             conditions
%
% Example:
%
% See also .

% Copyright 2011-12 Richard J. Cui. Created: 01/18/2012  5:48:23.507 PM
% $Revision: 0.5 $  $Date: Wed 10/17/2012  9:19:20.794 AM $
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
%     result_dat = opt;

    opt.Moving_window_width = {250 '* (ms)' [10 1000]};
    opt.Moving_window_step =  {25 '* (ms)' [1 2000]};
    opt.Base_width_for_baseline_rate = {500, '* (ms)', [1 2000]};
    opt.Moving_widow_width_for_usacc_rate = {250 '* (ms)' [10 1000]};
    opt.Moving_widow_step_for_usacc_rate = {25 '* (ms)' [1 1000]};
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'LastConChunk', 'timestamps', 'left_eyedat'...
                'left_blink_props', 'left_saccade_props', 'left_usacc_props'...
                'spiketimes'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% Trail condition specification
% -----------------------------
LastConChunk = dat.LastConChunk;
timestamps = dat.timestamps;
spiketime = dat.spiketimes;
grattime = LastConChunk.ConEnvVars.grattime;   % time for the presentation of one stage of stimuli

left_eyedat = dat.left_eyedat;
left_blink_props = dat.left_blink_props;
left_saccade_props = dat.left_saccade_props ;
left_usacc_props = dat.left_usacc_props ;

% Stimulus information of the session
% --------------------------------------
% use the info in the last one
SessStim = LastConChunk.SessStim;
maxCycles= size(SessStim, 1);
numConditions = size(SessStim, 2) - 1;   % last condition is used for coding, don't account it
TrialTime = zeros(maxCycles, 3, numConditions);
badcycle = [];

% =================================
% Find TrialTime
% =================================
for m = 1:maxCycles
    for n = 1:numConditions     % number of trials = number of conditions
        stim = SessStim(m, n);
        con1 = Michelson(stim.mingray1, stim.maxgray1);     % find the contrast 1 in stage 2
        con2 = Michelson(stim.mingray2, stim.maxgray2);     % find the contrast 2 in stage 3
        % find Condition number from con1 & con2
        numCond = Cont2Condnum(con1, con2);                 % numCond = condition number
        oddeven = mod(numCond, 2) == 1 || mod(numCond ,2) == 0;
        if ~oddeven || numCond < 1 || numCond > 121
            badcycle = cat(1, badcycle, m);
            break
        end % if
        
        % Blank start time index
        time0 = stim.thistime0;
        time0_ind = find(timestamps == time0);  % have to use 'find', cuz timestamps are not continuous
        if isempty(time0_ind)
            badcycle = cat(1, badcycle, m);
            break
        end % if
        TrialTime(m, 1, numCond) = time0_ind;
        
        % cont1 start time
        time1 = stim.thistime1;
        time1_ind = find(timestamps == time1);
        if isempty(time1_ind)
            badcycle = cat(1, badcycle, m);
            break
        end % if
        TrialTime(m, 2, numCond) = time1_ind;
        % cont2 start time
        time2 = stim.thistime2;
        time2_ind = find(timestamps == time2);
        if isempty(time2_ind)
            badcycle = cat(1, badcycle, m);
            break
        end % if
        TrialTime(m, 3, numCond) = time2_ind;
        
    end % for
end % for
disp('--> TrialTime done')

% =================================
% Find TrialCondition
% =================================
TrialCondition = zeros(1, numConditions);
for n = 1:numConditions     % trial sequence
    stim = SessStim(1, n);
    con1 = Michelson(stim.mingray1, stim.maxgray1);     % find the contrast 1 at stage 2
    con2 = Michelson(stim.mingray2, stim.maxgray2);     % find the contrast 2 at stage 3
    % find Condition number from con1 & con2
    numCond = Cont2Condnum(con1, con2);
    TrialCondition(n) = numCond;
end %for

% get rid of those cycles where timestamps have not been recorded
% ---------------------------------------------------------------
badc = unique(badcycle);
if ~isempty(badc)
    TrialTime(badc, :, :) = [];
end % if
disp('--> TrialCondition done')


% =================================
% mSaccConSig
% =================================
stage = struct('eye_position', [], 'blink', [], 'saccade', [],...
               'usacc', [], 'spikes', []);
eye_position = struct('signal', [], 'time_index', []);
mSaccConSig = [];
numCycles = size(TrialTime,1);
for c = 1:numConditions     % condition index
    for s = 1:3     % stage index
        % initialize
        signal = zeros(grattime, numCycles, 2); % 1- horizontal, 2 - vertical
        time_index = zeros(grattime, numCycles);
        blink = {}; % if there is no event, there will be a [0] cell
        saccade = {};
        usacc = {};
        sptm = {};  % spiketime
        
        for k = 1:numCycles     % cycles
            % -- eye position signals
            time_idx = TrialTime(k, s, c);
            eye_hor = left_eyedat(time_idx:(time_idx + grattime - 1), 1);
            eye_ver = left_eyedat(time_idx:(time_idx + grattime - 1), 2);
            signal(:, k, 1) = eye_hor;
            signal(:, k, 2) = eye_ver;
            
            % eye position time indexes
            t0 = time_idx;
            t1 = time_idx + grattime - 1;
            time_index(:, k) = (t0:t1)';
            
            % -- blink
            blink_k = collectEvent([t0, t1], left_blink_props);
            if isempty(blink_k)
                blink = cat(1, blink, false);
            else
                blink = cat(1, blink, blink_k);
            end % if
            
            % -- Saccade
            saccade_k = collectEvent([t0, t1], left_saccade_props);
            if isempty(saccade_k)
                saccade = cat(1, saccade, false);
            else
                saccade = cat(1, saccade, saccade_k);
            end % if
            
            % -- uSacc
            usacc_k = collectEvent([t0, t1], left_usacc_props);
            if isempty(usacc_k)
                usacc = cat(1, usacc, false);
            else
                usacc = cat(1, usacc, usacc_k);
            end % if
            
            % -- spiketime
            spt_idx = spiketime(:,2);
            sptm_k = spiketime(spt_idx >= t0 & spt_idx <= t1,2);
            if isempty(sptm_k)
                sptm = cat(1, sptm, false);
            else
                sptm = cat(1, sptm, sptm_k);
            end % if
        end % for
        
        eye_position.signal = signal;
        eye_position.time_index = time_index;
        stage(s).eye_position = eye_position;
        stage(s).blink = blink;
        stage(s).saccade = saccade;
        stage(s).usacc = usacc;
        stage(s).spikes = sptm;
        
    end % for
    
    mSaccConSig = cat(1, mSaccConSig, stage);
    
end % for
disp('--> mSaccConSig done')

% =================================
% SpikeYN
% =================================
trial_length = 3 * grattime;    % trial length includes thress stages
SpikeYN = zeros(numCycles, trial_length, numConditions);   % num cycles x trial length x 121

for k = 1:numConditions     % number of conditions
    % Stage 1 - Blank
    stage_blank = mSaccConSig(k, 1);
    % Stage 2 - Contrast 1
    stage_cont1 = mSaccConSig(k, 2);
    % stage 3 - contrast 2
    stage_cont2 = mSaccConSig(k, 3);
    
    spikeYN_m = [];
    for m = 1:numCycles     % number of cycles
        spikeYN_trial = [];
        % Spike YN of stage 1 - blank
        % ---------------------------
        % blank_begin = stage_blank.eye_position.time_index(1, m);
        blank_begin = TrialTime(m, 1, k);
        % spike time
        blank_spiketime = stage_blank.spikes{m};
        spikeYN_Blankm = zeros(1, grattime);
        if blank_spiketime(1) ~= 0
            spike_idx = blank_spiketime - blank_begin + 1;
            spike_idx(spike_idx <= 0) = [];
            spikeYN_Blankm(spike_idx) = 1;
        end
        
        % (2) spike YN of stage 2 - Contrast1
        % -----------------------------------
        % cont1_begin = stage_cont1.eye_position.time_index(1, m);
        cont1_begin = TrialTime(m, 2, k);
        % spike time
        cont1_spiketime = stage_cont1.spikes{m};
        spikeYN_Cont1m = zeros(1, grattime);
        if cont1_spiketime(1) ~= 0
            spike_idx = cont1_spiketime - cont1_begin + 1;
            spike_idx(spike_idx <= 0) = [];
            spikeYN_Cont1m(spike_idx) = 1;
        end
        
        % (3) spike YN of stage 3 - Contrast1
        % -----------------------------------
        % cont2_begin = stage_cont2.eye_position.time_index(1, m);
        cont2_begin = TrialTime(m, 3, k);
        % spike time
        cont2_spiketime = stage_cont2.spikes{m};
        spikeYN_Cont2m = zeros(1, grattime);
        if cont2_spiketime(1) ~= 0
            spike_idx = cont2_spiketime - cont2_begin + 1;
            spike_idx(spike_idx <= 0) = [];
            spikeYN_Cont2m(spike_idx) = 1;
        end
        
        spikeYN_trial = cat(2, spikeYN_trial, spikeYN_Blankm, spikeYN_Cont1m, spikeYN_Cont2m);
        spikeYN_m = cat(1, spikeYN_m, spikeYN_trial);
    end % for
    
    SpikeYN(:, :, k) = spikeYN_m;
end % for
disp('--> SpikeYN done')

% =================================
% EyeSignals
% =================================
EyeSignals = zeros(numCycles, trial_length, 2, numConditions);   % num cycles x trial length x hor/ver x 121

for k = 1:numConditions
    % Stage 1 - Blank
    stage_blank = mSaccConSig(k, 1);
    % Stage 2 - Contrast 1
    stage_cont1 = mSaccConSig(k, 2);
    % stage 3 - contrast 2
    stage_cont2 = mSaccConSig(k, 3);
    
    EyeSignals_mx = [];
    EyeSignals_my = [];

    for m = 1:numCycles
        % eye signals of stage 1 - blank
        % ------------------------------
        eye_blank_x = stage_blank.eye_position.signal(:, m, 1);
        eye_blank_y = stage_blank.eye_position.signal(:, m, 2);
        
        % eye signals of stage 2 - contrast 1
        % ------------------------------------
        eye_cont1_x = stage_cont1.eye_position.signal(:, m, 1);
        eye_cont1_y = stage_cont1.eye_position.signal(:, m, 2);
        
        % eye signals of stage 3 - contrast 2
        % ------------------------------------
        eye_cont2_x = stage_cont2.eye_position.signal(:, m, 1);
        eye_cont2_y = stage_cont2.eye_position.signal(:, m, 2);
        
        eye_kmx = [eye_blank_x', eye_cont1_x', eye_cont2_x'];
        eye_kmy = [eye_blank_y', eye_cont1_y', eye_cont2_y'];
        EyeSignals_mx = cat(1, EyeSignals_mx, eye_kmx);
        EyeSignals_my = cat(1, EyeSignals_my, eye_kmy);
        
    end % for
    
    EyeSignals(:, :, 1, k) = EyeSignals_mx;
    EyeSignals(:, :, 2, k) = EyeSignals_my;
    
end % for
disp('--> EyeSignals done')

% =================================
% SaccadeYN
% =================================
SaccadeYN = zeros(numCycles, trial_length, numConditions);   % num cycles x trial length x 121

for k = 1:numConditions     % number of conditions
    % Stage 1 - Blank
    stage_blank = mSaccConSig(k, 1);
    % Stage 2 - Contrast 1
    stage_cont1 = mSaccConSig(k, 2);
    % stage 3 - contrast 2
    stage_cont2 = mSaccConSig(k, 3);
    
    SaccadeYN_m = [];
    for m = 1:numCycles     % number of cycles
        % Saccade YN of stage 1 - blank
        % -----------------------------
        blank_begin = TrialTime(m, 1, k);
        % saccade time
        blank_saccade = stage_blank.saccade{m};
        saccadeYN_Blankm = zeros(1, grattime);
        if blank_saccade(1,1) ~= 0
            blank_saccade_time = blank_saccade(:,1:2) - blank_begin +1;
            blank_saccade_begin = blank_saccade_time(:,1);
            blank_saccade_begin(blank_saccade_begin < 1) = 1;
            blank_saccade_end = blank_saccade_time(:,2);
            blank_saccade_end(blank_saccade_end > grattime) = grattime;
            saccadeYN_Blankm = be2yn(blank_saccade_begin, blank_saccade_end, grattime);
            saccadeYN_Blankm = saccadeYN_Blankm';
        end
        
        % (2) saccade YN of stage 2 - Contrast1
        % -----------------------------------
        cont1_begin = TrialTime(m, 2, k);
        % saccade time
        cont1_saccade = stage_cont1.saccade{m};
        saccadeYN_cont1m = zeros(1, grattime);
        if cont1_saccade(1,1) ~= 0
            cont1_saccade_time = cont1_saccade(:,1:2) - cont1_begin +1;
            cont1_saccade_begin = cont1_saccade_time(:,1);
            cont1_saccade_begin(cont1_saccade_begin < 1) = 1;
            cont1_saccade_end = cont1_saccade_time(:,2);
            cont1_saccade_end(cont1_saccade_end > grattime) = grattime;
            saccadeYN_cont1m = be2yn(cont1_saccade_begin, cont1_saccade_end, grattime);
            saccadeYN_cont1m = saccadeYN_cont1m';
        end
        
        % (3) saccade YN of stage 3 - Contrast2
        % -----------------------------------
        cont2_begin = TrialTime(m, 3, k);
        % saccade time
        cont2_saccade = stage_cont2.saccade{m};
        saccadeYN_cont2m = zeros(1, grattime);
        if cont2_saccade(1,1) ~= 0
            cont2_saccade_time = cont2_saccade(:,1:2) - cont2_begin +1;
            cont2_saccade_begin = cont2_saccade_time(:,1);
            cont2_saccade_begin(cont2_saccade_begin < 1) = 1;
            cont2_saccade_end = cont2_saccade_time(:,2);
            cont2_saccade_end(cont2_saccade_end > grattime) = grattime;
            saccadeYN_cont2m = be2yn(cont2_saccade_begin, cont2_saccade_end, grattime);
            saccadeYN_cont2m = saccadeYN_cont2m';
        end
        
        saccadeYN_trial = [saccadeYN_Blankm, saccadeYN_cont1m, saccadeYN_cont2m];
        SaccadeYN_m = cat(1, SaccadeYN_m, saccadeYN_trial);
    end % for
    
    SaccadeYN(:, :, k) = SaccadeYN_m;
end % for
disp('--> SaccadeYN done')

% =================================
% UsaccYN
% =================================
UsaccYN = zeros(numCycles, trial_length, numConditions);   % num cycles x trial length x 121
AllUsacc = cell(numCycles, 3, numConditions);       % all usacc includes those that part of the usacc is included in the trial

for k = 1:numConditions     % number of conditions
    % Stage 1 - Blank
    stage_blank = mSaccConSig(k, 1);
    % Stage 2 - Contrast 1
    stage_cont1 = mSaccConSig(k, 2);
    % stage 3 - contrast 2
    stage_cont2 = mSaccConSig(k, 3);
    
    UsaccYN_m = [];
    for m = 1:numCycles     % number of cycles
        % Usacc YN of stage 1 - blank
        % -----------------------------
        blank_begin = TrialTime(m, 1, k);
        % saccade time
        blank_usacc = stage_blank.usacc{m};
        AllUsacc(m, 1, k) = {[]};
        usaccYN_Blankm = zeros(1, grattime);
        if blank_usacc(1,1) ~= 0
            AllUsacc(m, 1, k) = {blank_usacc};    % there may be one usacc crossing over two stages
            blank_usacc_time = blank_usacc(:,1:2) - blank_begin +1;
            blank_usacc_begin = blank_usacc_time(:,1);
            blank_usacc_begin(blank_usacc_begin < 1) = 1;
            blank_usacc_end = blank_usacc_time(:,2);
            blank_usacc_end(blank_usacc_end > grattime) = grattime;
            usaccYN_Blankm = be2yn(blank_usacc_begin, blank_usacc_end, grattime);
            usaccYN_Blankm = usaccYN_Blankm';
        end
        
        % (2) usacc YN of stage 2 - Contrast1
        % -----------------------------------
        cont1_begin = TrialTime(m, 2, k);
        % saccade time
        cont1_usacc = stage_cont1.usacc{m};
        AllUsacc(m, 2, k) = {[]};
        usaccYN_cont1m = zeros(1, grattime);
        if cont1_usacc(1,1) ~= 0
            AllUsacc(m, 2, k) = {cont1_usacc};
            cont1_usacc_time = cont1_usacc(:,1:2) - cont1_begin +1;
            cont1_usacc_begin = cont1_usacc_time(:,1);
            cont1_usacc_begin(cont1_usacc_begin < 1) = 1;
            cont1_usacc_end = cont1_usacc_time(:,2);
            cont1_usacc_end(cont1_usacc_end > grattime) = grattime;
            usaccYN_cont1m = be2yn(cont1_usacc_begin, cont1_usacc_end, grattime);
            usaccYN_cont1m = usaccYN_cont1m';
        end
        
        % (3) usacc YN of stage 3 - Contrast2
        % -----------------------------------
        cont2_begin = TrialTime(m, 3, k);
        % saccade time
        cont2_usacc = stage_cont2.usacc{m};
        AllUsacc(m, 3, k) = {[]};
        usaccYN_cont2m = zeros(1, grattime);
        if cont2_usacc(1,1) ~= 0
            AllUsacc(m, 3, k) = {cont2_usacc};
            cont2_usacc_time = cont2_usacc(:,1:2) - cont2_begin +1;
            cont2_usacc_begin = cont2_usacc_time(:,1);
            cont2_usacc_begin(cont2_usacc_begin < 1) = 1;
            cont2_usacc_end = cont2_usacc_time(:,2);
            cont2_usacc_end(cont2_usacc_end > grattime) = grattime;
            usaccYN_cont2m = be2yn(cont2_usacc_begin, cont2_usacc_end, grattime);
            usaccYN_cont2m = usaccYN_cont2m';
        end
        
        usaccYN_trial = [usaccYN_Blankm, usaccYN_cont1m, usaccYN_cont2m];
        UsaccYN_m = cat(1, UsaccYN_m, usaccYN_trial);
    end % for
    
    UsaccYN(:, :, k) = UsaccYN_m;
end % for
disp('--> UsaccYN, AllUsacc done')


% =================================
% BlinkYN
% =================================
BlinkYN = zeros(numCycles, trial_length, numConditions);   % num cycles x trial length x 121

for k = 1:numConditions     % number of conditions
    % Stage 1 - Blank
    stage_blank = mSaccConSig(k, 1);
    % Stage 2 - Contrast 1
    stage_cont1 = mSaccConSig(k, 2);
    % stage 3 - contrast 2
    stage_cont2 = mSaccConSig(k, 3);
    
    BlinkYN_m = [];
    for m = 1:numCycles     % number of cycles
        % Blink YN of stage 1 - blank
        % -----------------------------
        blank_begin = TrialTime(m, 1, k);
        % blink time
        blank_blink = stage_blank.blink{m};
        blinkYN_Blankm = zeros(1, grattime);
        if blank_blink(1,1) ~= 0
            blank_blink_time = blank_blink(:,1:2) - blank_begin +1;
            blank_blink_begin = blank_blink_time(:,1);
            blank_blink_begin(blank_blink_begin < 1) = 1;
            blank_blink_end = blank_blink_time(:,2);
            blank_blink_end(blank_blink_end > grattime) = grattime;
            blinkYN_Blankm = be2yn(blank_blink_begin, blank_blink_end, grattime);
            blinkYN_Blankm = blinkYN_Blankm';
        end
        
        % (2) blink YN of stage 2 - Contrast1
        % -----------------------------------
        cont1_begin = TrialTime(m, 2, k);
        % saccade time
        cont1_blink = stage_cont1.blink{m};
        blinkYN_cont1m = zeros(1, grattime);
        if cont1_blink(1,1) ~= 0
            cont1_blink_time = cont1_blink(:,1:2) - cont1_begin +1;
            cont1_blink_begin = cont1_blink_time(:,1);
            cont1_blink_begin(cont1_blink_begin < 1) = 1;
            cont1_blink_end = cont1_blink_time(:,2);
            cont1_blink_end(cont1_blink_end > grattime) = grattime;
            blinkYN_cont1m = be2yn(cont1_blink_begin, cont1_blink_end, grattime);
            blinkYN_cont1m = blinkYN_cont1m';
        end
        
        % (3) blink YN of stage 3 - Contrast2
        % -----------------------------------
        cont2_begin = TrialTime(m, 3, k);
        % saccade time
        cont2_blink = stage_cont2.blink{m};
        blinkYN_cont2m = zeros(1, grattime);
        if cont2_blink(1,1) ~= 0
            cont2_blink_time = cont2_blink(:,1:2) - cont2_begin +1;
            cont2_blink_begin = cont2_blink_time(:,1);
            cont2_blink_begin(cont2_blink_begin < 1) = 1;
            cont2_blink_end = cont2_blink_time(:,2);
            cont2_blink_end(cont2_blink_end > grattime) = grattime;
            blinkYN_cont2m = be2yn(cont2_blink_begin, cont2_blink_end, grattime);
            blinkYN_cont2m = blinkYN_cont2m';
        end
        
        blinkYN_trial = [blinkYN_Blankm, blinkYN_cont1m, blinkYN_cont2m];
        BlinkYN_m = cat(1, BlinkYN_m, blinkYN_trial);
    end % for
    
    BlinkYN(:, :, k) = BlinkYN_m;
end % for
disp('--> BlinkYN done')

% =================================
% SpikeRate
% =================================
winwidth = S.Stage_2_Options.getSessInfo_options.Moving_window_width;
winstep = S.Stage_2_Options.getSessInfo_options.Moving_window_step;
base_width = S.Stage_2_Options.getSessInfo_options.Base_width_for_baseline_rate;

params.tapers = [3 ,5];     % not used now
mintime = 1; maxtime = trial_length;
params.minmaxtime = [mintime, maxtime];
movingwin = [winwidth, winstep];

grattime = dat.LastConChunk.ConEnvVars.grattime;   % time for the presentation of one stage of stimuli
x = SpikeYN(:,(grattime - base_width + 1):grattime,:);
y = sum(x(:));
base_rate = y/(base_width * numCycles * numConditions);

SpikeRate = [];

for k = 1:numConditions
    
    spkyn_k = SpikeYN(:, :, k);
    [spktimes_k, num_trl, trl_len] = yn2pointtime(spkyn_k);
    % [SpikeRateWinCenter, spkrate_k] = SpikeProcess.SpikeRateEstimation.ChronuxEst(spkyn_k, movingwin, params);
    % norm_spk_k = (spkrate_k' - base_rate) / base_rate;
    [SpikeRateWinCenter, spkrate_k] = SpikeProcess.SpikeRateEstimation.PSTHEst(spktimes_k, num_trl, trl_len, movingwin(1), movingwin(2));
    % normalization
    norm_spk_k = (spkrate_k - base_rate) / base_rate;
    SpikeRate = cat(3, SpikeRate, norm_spk_k);
    
end % for
disp('--> SpikeRate done')

% =================================
% UsaccRate
% =================================
win_width = S.Stage_2_Options.getSessInfo_options.Moving_widow_width_for_usacc_rate;
win_step = S.Stage_2_Options.getSessInfo_options.Moving_widow_step_for_usacc_rate;

UsaccRate = [];
for k = 1:numConditions
    
    usaccyn_k = UsaccYN(:, :, k);
    % [UsaccWinCenter, ~, usaccrate_k] = EyeProcess.MicrosaccadeRateEstimation.NoneParaMovingWindowEst(usaccyn_k, win_width, win_step);
    d = diff([zeros(size(usaccyn_k, 1), 1), usaccyn_k], 1, 2);
    usaccyn_onset_k = false(size(usaccyn_k));
    usaccyn_onset_k(d == 1) = true;
    [usacctimes_k, numtrl, trllen] = yn2pointtime(usaccyn_onset_k);
    [UsaccWinCenter, ~, usaccrate_k] = EyeProcess.MicrosaccadeRateEstimation.PSTHEst(usacctimes_k, numtrl, trllen, win_width, win_step);
    
    UsaccRate = cat(3, UsaccRate, usaccrate_k);
    
end % for
disp('--> UsaccRate done')


% =================================
% commit the results
% =================================
result_dat.TrialTime        = TrialTime;
result_dat.TrialCondition   = TrialCondition;
result_dat.mSaccConSig      = mSaccConSig;
result_dat.SpikeYN          = SpikeYN;
result_dat.SpikeRate        = SpikeRate;
result_dat.SpikeRateWinCenter = SpikeRateWinCenter;
result_dat.EyeSignals       = EyeSignals;
result_dat.SaccadeYN        = SaccadeYN;
result_dat.UsaccYN          = UsaccYN;
result_dat.UsaccRate        = UsaccRate;
result_dat.UsaccRateWinCenter   = UsaccWinCenter;
result_dat.BlinkYN          = BlinkYN;
result_dat.AllUsacc         = AllUsacc;

end % function getSessInfo

% ===========================
% sub-routines
% ===========================
function eye_event = collectEvent(time_range, event_props)
% collect eye movement events, i.e. blinks, saccade and mSacc
% 
% Input(s):
%   time_range      - [begin time index, end time index]
%   event_props     - see left/right_'event'_props variables
% 
% Output(s):
%   eye_event       - collected event

start_ind = event_props(:, 1);  % event start_index
end_ind   = event_props(:, 2);  % event end_index

% include the event, if either its start and/or its end falls in this time
% range
event_start = start_ind >= time_range(1) & start_ind <= time_range(2);
event_end = end_ind >= time_range(1) & end_ind <= time_range(2);
eye_event = event_props(event_start | event_end,:);

end % function

% function blink = collectblink(time_range, left_blink_props)
% % time_range = [begin time index, end time index]
% 
% start_ind = left_blink_props(:, 1); % blink start_index
% 
% % ind = start_ind >= time_idx & start_ind <= time_idx + grattime -1;
% ind = start_ind >= time_range(1) & start_ind <= time_range(2);
% blink = left_blink_props(ind,:);
% 
% end % function
% 
% function sacc = collectsacc(time_range, left_saccade_props)
% % time_range = [begin time index, end time index]
% 
% start_ind = left_saccade_props(:, 1); % saccade start_index
% ind = start_ind >= time_range(1) & start_ind <= time_range(2);
% 
% sacc = left_saccade_props(ind,:);
% 
% end % function
% 
% function usacc = collectusacc(time_range, left_usaccade_props)
% 
% start_ind = left_usaccade_props(:, 1); % usaccade start_index
% ind = start_ind >= time_range(1) & start_ind <= time_range(2);
% 
% usacc = left_usaccade_props(ind,:);
% 
% end % function

% [EOF]
