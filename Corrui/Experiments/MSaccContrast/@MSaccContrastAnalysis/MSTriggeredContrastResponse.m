function result_dat = MSTriggeredContrastResponse(current_tag, sname, S, dat)
% MSTRIGGEREDCONTRASTRESPONSE Individual cell MS-triggered response at different contrast level
% 
% Description:
%   This function calculates MS-triggered response of individual cell.  The
%   results are averaged spike rate at each contrast level.  The averaged
%   spike rate can be either absolute spike rates or normalized one,
%   according to the choices. Modified from
%   UsaccTriggeredContrastResponse.m
% 
% Syntax:
%   result_dat = MSTriggeredContrastResponse(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also .

% Copyright 2012-2014 Richard J. Cui. Created: Mon 06/18/2012  5:23:49.112 PM
% $Revision: 1.1 $  $Date: Sun 10/19/2014 10:58:06.083 AM $
%
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
    % trigger signal
    % ---------------
    opt.trig_signal = { '{MS onset}|MS end', 'Trigger signal' };
    
    % paras for cutting spiketime segment
    % -----------------------------------
    opt.pre_ms_int = {175 'Pre-MS interval (ms)' [0 1300]};     % pre-microsaccade interval - time interval examined before a usacc
    opt.post_ms_int = {375 'Post-MS interval (ms)' [0 1300]};   % post-microsaccade interval - time interval examined after a usacc
    
    % paras for cal. firing rate
    % ---------------------------
    opt.win_width = {30 'Moving-win width (ms)' [1 1000]};      % moving window width
    opt.win_step = {5 'Moving-win step (ms)' [1 1000]};         % moving window step
    % opts for choosing methos of estimating firing rate
    opt.fr_method = { {'Chronux' '{PSTH}'}, 'Firing rate estimation method' };
    
    % opts for normalization
    % ---------------------------------------
    opt.norm_method = { {'{Firing rate difference}', 'Percentage change'}, 'Choose normalization method' }; 
    opt.norm_method_options.baselin_method = { 'Simple average|{Bootstrap}' };   % method to cal baseline mean and s.d., bootstrap c.f. Reappas, 2002
    opt.norm_method_options.nboot = {1000, 'Number of bootstraps', [100 1000]};
    opt.norm_method_options.bs_time_shuffle = { {'0','{1}'}, 'Time shuffle for bootstrap' }; 
    % the inverval that used to cal baseline activity, time relative to MS-onset, ms-onset = zero
    opt.norm_method_options.baselin_interval = {[-200 -50] 'baseline interval (ms)' [-1000 0]};       % c.f. Reppas, 2002
    opt.norm_method_options.baselin_win_width = {10 'Moving-win width (ms)' [1 1000]};      % moving window width
    opt.norm_method_options.baselin_win_step = {10 'Moving-win step (ms)' [1 1000]};        % moving window step, default nonoverlap
    opt.norm_method_options.baselin_exclude_ms = { {'{0}','1'}, 'Exclude MS in baseline interval' };    % wheter exclude MS in the interval for cal. baseline activity
    opt.norm_method_options.baselin_exclude_length = {300, 'MS forbidden interval length', [1, 1000] }; % time length of interval before MS where no MS happens 
    
    % opts for modulation analysis
    % -----------------------------
    opt.modulation_options.threshold = {2.5, 'Threshold (S.D.)', [0 10]};   % the threshold for a single bin to excced
    opt.modulation_options.bin_num = {5, 'Number of cons. bins', [0 100]};  % lower lim of number of consecutive bins
    opt.modulation_options.interval_whole_signal = {[-75 355], 'Interval for checking significance', [-1000, 20000]};
    opt.modulation_options.interval_1 = {[-75 140], 'Special interval 1', [-1000, 20000]};
    opt.modulation_options.interval_2 = {[140 355], 'Special interval 2', [-1000, 20000]};
    
    result_dat = opt;
    return
end % if


% =========================================================================
% Load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'SelectedMSProps', 'SelectedSpiketimes', 'timestamps', 'enum'};
    result_dat = dat_var;
    
    return
end % if

% =========================================================================
% Data and options
% =========================================================================
% data
usacc = dat.SelectedMSProps;
spiketimes = dat.SelectedSpiketimes;
timestamps = dat.timestamps;
enum = dat.enum;

% options and paras
trig_signal = S.Stage_2_Options.([mfilename, '_options']).trig_signal;
pre_ms      = S.Stage_2_Options.([mfilename, '_options']).pre_ms_int;
post_ms     = S.Stage_2_Options.([mfilename, '_options']).post_ms_int;
win_width   = S.Stage_2_Options.([mfilename, '_options']).win_width;
win_step    = S.Stage_2_Options.([mfilename, '_options']).win_step;

fr_method = S.Stage_2_Options.([mfilename, '_options']).fr_method;     % method for estimating firing rate
norm.norm_method = S.Stage_2_Options.([mfilename, '_options']).norm_method; % method for normalization
norm.baselin_interval = S.Stage_2_Options.([mfilename, '_options']).norm_method_options.baselin_interval;
norm.baselin_method = S.Stage_2_Options.([mfilename, '_options']).norm_method_options.baselin_method;
norm.nboot = S.Stage_2_Options.([mfilename, '_options']).norm_method_options.nboot;
norm.bs_time_shuffle = S.Stage_2_Options.([mfilename, '_options']).norm_method_options.bs_time_shuffle;
norm.baselin_win_width = S.Stage_2_Options.([mfilename, '_options']).norm_method_options.baselin_win_width;
norm.baselin_win_step = S.Stage_2_Options.([mfilename, '_options']).norm_method_options.baselin_win_step;
norm.baselin_exclude_ms = S.Stage_2_Options.([mfilename, '_options']).norm_method_options.baselin_exclude_ms;
norm.baselin_exclude_length = S.Stage_2_Options.([mfilename, '_options']).norm_method_options.baselin_exclude_length;

modulation.threshold = S.Stage_2_Options.([mfilename, '_options']).modulation_options.threshold;
modulation.bin_num = S.Stage_2_Options.([mfilename, '_options']).modulation_options.bin_num;
modulation.interval_whole_signal = S.Stage_2_Options.([mfilename, '_options']).modulation_options.interval_whole_signal;
modulation.interval_1 = S.Stage_2_Options.([mfilename, '_options']).modulation_options.interval_1;
modulation.interval_2 = S.Stage_2_Options.([mfilename, '_options']).modulation_options.interval_2;

paras.parallel_process = S.Parallel_Process;
paras.trig_signal = trig_signal;
paras.pre_ms = pre_ms;
paras.post_ms = post_ms;
paras.win_width = win_width;
paras.win_step = win_step;
paras.fr_method = fr_method;
paras.norm = norm;
paras.modulation = modulation;

% =========================================================================
% Data processing
% =========================================================================
curr_exp = CorrGui.CheckTag(current_tag);

% sort microsaccades into different contrast levels
% -------------------------------------------------
[sorted_usacc, usacc_num] = sortMSContLevel(curr_exp, sname, usacc, paras);      % sort usacc into different contrast level

% spike raster at different contrast levels
% -----------------------------------------
[spk_raster, trial_length, trial_num] = cutSpikeRaster(sorted_usacc, spiketimes, timestamps, paras, enum);
paras.trial_length = trial_length;
paras.trial_num = trial_num;

% estimate firing rate for each contrast levels
% ----------------------------------------------
% trial_num = usacc_num
[win_c, fr_level] = estFRContLevel(curr_exp, sname, spk_raster, trial_num, trial_length, paras);

% find baseline activity per contrast level
% -----------------------------------------
[fr_base_mean, fr_base_sd] = getBaselinFR(curr_exp, sname, sorted_usacc, timestamps, paras);
baselin.Mean = fr_base_mean;
baselin.SD   = fr_base_sd;

% normalized spike rate
% ---------------------
fr_level_norm = normSpikeRate(fr_level, fr_base_mean, paras);

% modulation analysis
% --------------------
[~, is_sig_mod_level] = checkSigMod(win_c, fr_level_norm, baselin, paras);         % to see if this cell is significantly modulated
intv = paras.modulation.interval_whole_signal;
[supp_idx_intv, enha_idx_intv, supp_seq_intv, enha_seq_intv] = getModIdx(win_c, fr_level_norm, intv, baselin, paras);   % get modulation index in a specified interval
intv1 = paras.modulation.interval_1;
[supp_idx_intv1, enha_idx_intv1, supp_seq_intv1, enha_seq_intv1] = getModIdx(win_c, fr_level_norm, intv1, baselin, paras);   % get modulation index in a specified interval
intv2 = paras.modulation.interval_2;
[supp_idx_intv2, enha_idx_intv2, supp_seq_intv2, enha_seq_intv2] = getModIdx(win_c, fr_level_norm, intv2, baselin, paras);   % get modulation index in a specified interval
modulation.SigLevel = is_sig_mod_level;
modulation.ModIndex.WholeSignal.Suppression.Index = supp_idx_intv;
modulation.ModIndex.WholeSignal.Suppression.Sequence = supp_seq_intv;
modulation.ModIndex.WholeSignal.Enhancement.Index = enha_idx_intv;
modulation.ModIndex.WholeSignal.Enhancement.Sequence = enha_seq_intv;
modulation.ModIndex.Interval1.Suppression.Index = supp_idx_intv1;
modulation.ModIndex.Interval1.Suppression.Sequence = supp_seq_intv1;
modulation.ModIndex.Interval1.Enhancement.Index = enha_idx_intv1;
modulation.ModIndex.Interval1.Enhancement.Sequence = enha_seq_intv1;
modulation.ModIndex.Interval2.Suppression.Index = supp_idx_intv2;
modulation.ModIndex.Interval2.Suppression.Sequence = supp_seq_intv2;
modulation.ModIndex.Interval2.Enhancement.Index = enha_idx_intv2;
modulation.ModIndex.Interval2.Enhancement.Sequence = enha_seq_intv2;

% other interesting measure
% -------------------------
ms_duration = findMSDur(sorted_usacc, enum);  % find ms duration in each level, 11 x 2, each row [mean, std]
                   
% =====================
% commit results
% =====================
msresp.SortedUsaccProps     = sorted_usacc;     % 1 x 11 cells, each cell: selected usacc_props under that contrast level
msresp.MSNumber             = usacc_num;        % number of MS involved in each level
msresp.SpikeTimes           = spk_raster;       % 1 x 11 cells, spike times relative to the beginning of 1st trial under that contrast level
msresp.SpikeRateWinCenter   = win_c;            % times of window centers for calculating firing rates
msresp.SpikeRate            = fr_level;         % mean activity, 11 x number of windows, each row for each contrast level
msresp.SpikeRateNormalized  = fr_level_norm;    % normalized mean firing rate
msresp.Baseline             = baselin;          % mean spike rate per contrast level
msresp.MSDuration           = ms_duration;      % 11 x 2, each row [mean, std]
msresp.Modulation           = modulation;       % modulaiton significance and indexes
msresp.Paras                = paras;            % parameters and options

result_dat.MSTriggeredContrastResponse = msresp;

end % function StepContrastAnalysis

% =====================
% subroutines
% =====================
function [supp_area_level, enha_area_level, supp_seq_level, enha_seq_level] = getSuppEnhArea(time, fr_level, intv, bin_width)

nlevel = size(fr_level, 1);
supp_area_level = zeros(1, nlevel);
enha_area_level = zeros(1, nlevel);
supp_seq_level = cell(1, nlevel);
enha_seq_level = cell(1, nlevel);

intv_idx = time >= intv(1) & time <= intv(2);
signal_seq = find(intv_idx > 0);
for k = 1:nlevel
    
    fr_k = fr_level(k, :);
    fr_intv_k = fr_k(intv_idx);
    
    supp_intv_idx_k = fr_intv_k < 0;
    supp_intv_seq_k = signal_seq(supp_intv_idx_k);
    supp_seq_level{k} = supp_intv_seq_k;
    supp_area_level(k) = abs(sum(fr_k(supp_intv_seq_k))) * bin_width;
    
    enha_intv_idx_k = fr_intv_k >= 0;
    enha_intv_seq_k = signal_seq(enha_intv_idx_k);
    enha_seq_level{k} = enha_intv_seq_k;
    enha_area_level(k) = sum(fr_k(enha_intv_seq_k)) * bin_width;
end % for

end 

function [supp_idx_level, enha_idx_level, supp_seq_level, enha_seq_level] = getModIdx(win_c, fr_level, intv, baseline, paras)
% idx_level     - suppression/enhancement index of each level
% seq_level     - suppression/enhancement signal position of the f.r. of
%                 each level

% area under baselin
% ------------------
base_mean = baseline.Mean;
baselin_interval = paras.norm.baselin_interval;
base_width = baselin_interval(2) - baselin_interval(1) + 1;
base_area = base_mean * base_width;

pre_ms = paras.pre_ms;
win_step = paras.win_step;
time = win_c - round(pre_ms + paras.win_width / 2);
bin_width = win_step;

% suppression and enhancement area of signal
[supp_area_level, enha_aera_level, supp_seq_level, enha_seq_level] = getSuppEnhArea(time, fr_level, intv, bin_width);
supp_idx_level = supp_area_level ./ base_area;  % normalized suppression
enha_idx_level = enha_aera_level ./ base_area;  % normalized enhancement

end % function

% function [win_c, fr_level] = getFR_sig_mod(sname, sorted_usacc, spiketimes, timestamps, paras, enum)
% 
% % change stepping window paras
% paras.win_width = paras.norm.baselin_win_width;
% paras.win_step = paras.norm.baselin_win_step;
% 
% [spk_raster, trial_length, trial_num] = cutSpikeRaster(sorted_usacc, spiketimes, timestamps, paras, enum);
% 
% % estimate firing rate for each contrast levels
% % ----------------------------------------------
% [win_c, fr_level] = estFRContLevel(sname, spk_raster, trial_num, trial_length, paras);
% 
% 
% end 

function sig_level = sigCheck(win_c, fr_level, baseline, paras)

threshold = paras.modulation.threshold;
bin_num = paras.modulation.bin_num;

sd = baseline.SD;
cut_line = threshold * sd;

interval = paras.modulation.interval_whole_signal;
pre_ms = paras.pre_ms;
time = win_c - pre_ms;
t_idx = time >= interval(1) & time <= interval(2);

nlevel = size(fr_level, 1);
sig_level = zeros(1, nlevel);

for k = 1:nlevel
    cut_line_k = cut_line(k);
    fr_k = fr_level(k, :);
    p_k = abs(fr_k(t_idx)) >= cut_line_k;  % 
    [~, ~, seg_length] = yn2be(p_k);
    max_length = max(seg_length);
    if ~isempty(seg_length) && max_length >= bin_num
        sig_level(k) = 1;
    end % if
end % for

end

function [is_sig, is_sig_level] = checkSigMod(win_c, fr_level, baseline, paras)

% check if significant
is_sig_level = sigCheck(win_c, fr_level, baseline, paras);

is_sig = sum(is_sig_level) > 0;

end 


function fr_level_norm = normSpikeRate(fr_level, fr_level_base, paras)

sig_len = size(fr_level, 2);
base = repmat(fr_level_base(:), 1, sig_len);
norm_method = paras.norm.norm_method;
fr_level_norm = size(fr_level);

switch norm_method
    case 'Firing rate difference'
        fr_level_norm = fr_level - base;
    case 'Percentage change'
        fr_level_norm = (fr_level - base) ./ base;
end % switch


end % funciton


function selected_ms = selectUsacc(usacc_props, timestamps, paras, enum)
% select usacc

baselin_exclude_ms = paras.norm.baselin_exclude_ms;

if baselin_exclude_ms
    trig_signal = paras.trig_signal;
    thres = paras.norm.baselin_exclude_length;
    switch trig_signal
        case 'MS onset'
            trig_timeidx = usacc_props(:, enum.usacc_props.start_index);
        case 'MS end'
            trig_timeidx = usacc_props(:, enum.usacc_props.end_index);            
    end % switch
    trig_timestamps = timestamps(trig_timeidx);
    trig_yn = pointtime2yn(trig_timestamps, 1, max(trig_timestamps));
    [next_b, e] = yn2be(trig_yn);  % note: next_b can be different from trig_timestamps
    last_e = [1; e(1:end-1)];
    good_trig_idx = (next_b - last_e) > thres;
    
    selected_ms = usacc_props(good_trig_idx, :);
else
    selected_ms = usacc_props;
end % if

end % function

function [spk_raster, trl_len] = getBaseSpkRaster(curr_exp, sname, usacc_props, timestamps, paras)

base_intv = paras.norm.baselin_interval;
pre_ms = -base_intv(1);
post_ms = base_intv(2);
S.win_width = paras.win_width;
S.pre_ms = pre_ms;
S.post_ms = post_ms;
S.trig_signal = paras.trig_signal;

Spike = MSCSpike(curr_exp, sname);
enum = Spike.enum;
spiketimes = Spike.spiketimes;

selected_ms = selectUsacc(usacc_props, timestamps, paras, enum);

[spk_raster, trl_len] = getSpkRaster(selected_ms, spiketimes, timestamps, S, enum);

end % funciton

function [spk_raster, trl_len, trl_num] = cutBaseSpkRaster(curr_exp, sname, sorted_usacc, timestamps, paras)

nlevel = length(sorted_usacc);
spk_raster = cell(1, nlevel);
tlen = zeros(1, nlevel);
trl_num = zeros(1, nlevel);

for k = 1:nlevel
    ms_k = sorted_usacc{k};
    [spk_raster_k, tlen_k] = getBaseSpkRaster(curr_exp, sname, ms_k, timestamps, paras);
    
    spk_raster{k} = spk_raster_k;
    trl_num(k) = size(ms_k, 1);
    tlen(k) = tlen_k;
end % for

% check trial length
x = diff(tlen);
if norm(x) > 0
    warning('Trial lengthes are not equal.')
end

trl_len = tlen(1);

end % funciton

function [fr_mean, fr_sd, fr_winc, fr_level] = SpkRateSimpleAverage(sname, spk_raster, trial_length, trial_num, paras)
% sname     - session name

[fr_winc, fr_level] = estFRContLevel(sname, spk_raster, trial_num, trial_length, paras);

fr_mean = mean(fr_level, 2);     % each row -- contrast level, in spikes / ms
fr_sd = std(fr_level, [], 2);

end % funciton

function fr_mean = PSTHEstBootstrp(spkyn, trl_num, trl_len, win_width, win_step, Spike)

spkt = yn2pointtime(spkyn);
[~, ~, fr_mean] = Spike.PSTHEst(spkt, trl_num, trl_len, win_width, win_step);

end

function fr_mean = ChronuxEstBootstrp(spkyn, win_width, win_step, Spike)

params.Fs = Spike.samplerate;
params.tapers = [3, 5];
[~, fr_mean] = Spike.ChronuxEst(spkyn, [win_width, win_step], params);


end % function

function [fr_winc, fr_level] = estFRContLevelBootstrp(curr_exp, sname, spk_raster, trl_len, trl_num, paras)

Spike = MSCSpike(curr_exp, sname);    % MSC spike object
nlevel = length(spk_raster);
fr_method = paras.fr_method;
win_width = paras.win_width;
win_step = paras.win_step;
nboot = paras.norm.nboot;
UseParallel = paras.parallel_process;
bs_opt = statset('UseParallel', UseParallel);
bs_time_shuffle = paras.norm.bs_time_shuffle;

fr_winc = estmovingwin(win_width, win_step, trl_len);

fr_level = [];
disp('Bootstraping...')
for k = 1:nlevel
    spkt_k = spk_raster{k};
    
    if isempty(spkt_k)
        tic
        fr_k = zeros(1, length(fr_winc));
        toc
    else
        trl_num_k = trl_num(k);
        spkyn_k = pointtime2yn(spkt_k, trl_num_k, trl_len);
        
        % time shuffle
        if bs_time_shuffle
            p = randperm(trl_len);
            spkyn_k = spkyn_k(:, p);
        end
        
        switch fr_method
            case 'PSTH'
                psthbt = @(yn) PSTHEstBootstrp(yn, trl_num_k, trl_len, win_width, win_step, Spike);
                tic
                stats_fr_k = bootstrp(nboot, psthbt, spkyn_k, 'Options', bs_opt);
                toc
            case 'Chronux'
                chronuxbt = @(yn) ChronuxEstBootstrp(yn, win_width, win_step, Spike);
                tic
                stats_fr_k = bootstrp(nboot, chronuxbt, spkyn_k, 'Options', bs_opt);
                toc
        end % switch
        
        fr_k = mean(stats_fr_k);
    end % if
    
    fr_level = cat(1, fr_level, fr_k);
end % for

end % funciton

function [fr_mean, fr_sd, fr_winc, fr_level] = SpkRateBootstrap(curr_exp, sname, spk_raster, trial_length, trial_num, paras)

[fr_winc, fr_level] = estFRContLevelBootstrp(curr_exp, sname, spk_raster, trial_length, trial_num, paras);

fr_mean = mean(fr_level, 2);     % each row -- contrast level, in spikes / ms
fr_sd = std(fr_level, [], 2);

end % function

function [fr_base_mean, fr_base_sd, fr_base_winc, fr_base_fr] = getBaselinFR(curr_exp, sname, sorted_usacc, timestamps, paras)
% baseline fring rate meand and s.d.

% get baseline spike time raster
[spk_raster, trial_length, trial_num] = cutBaseSpkRaster(curr_exp, sname, sorted_usacc, timestamps, paras);

% baseline stats
baselin_method = paras.norm.baselin_method;

% baseline win_width and win_step
paras.win_width = paras.norm.baselin_win_width;
paras.win_step = paras.norm.baselin_win_step;

switch baselin_method
    case 'Simple average'
        [fr_base_mean, fr_base_sd, fr_base_winc, fr_base_fr] = SpkRateSimpleAverage(sname, spk_raster, trial_length, trial_num, paras);
    case 'Bootstrap'
        [fr_base_mean, fr_base_sd, fr_base_winc, fr_base_fr] = SpkRateBootstrap(curr_exp, sname, spk_raster, trial_length, trial_num, paras);
end % switch

fr_base_mean = fr_base_mean(:).';
fr_base_sd = fr_base_sd(:).';
fr_base_winc = fr_base_winc(:).';

end % function

function ms_duration = findMSDur(sorted_usacc, enum)
% mean & std of usacc duration at each contrast level

nlevel = length(sorted_usacc);

d = zeros(nlevel, 1);
s = zeros(nlevel, 1);
for k = 1:nlevel
    usacc_k = sorted_usacc{k};
    dur_k = usacc_k(:, enum.usacc_props.duration);
    
    d(k) = mean(dur_k);
    s(k) = std(dur_k);
end % for

ms_duration = [d, s];

end 

function [win_center, fr_level] = estFRContLevel(curr_exp, sname, spk_raster, trl_num, trl_len, paras)

Spike = MSCSpike(curr_exp, sname);    % MSC spike object
nlevel = length(spk_raster);
fr_method = paras.fr_method;
win_width = paras.win_width;
win_step = paras.win_step;

fr_level = [];
for k = 1:nlevel
    spkt_k = spk_raster{k};
    trl_num_k = trl_num(k);
    switch fr_method
        case 'PSTH'
            [wc, ~, fr_k] = Spike.PSTHEst(spkt_k, trl_num_k, trl_len, win_width, win_step);
        case 'Chronux'
            spkyn_k = pointtime2yn(spkt_k, trl_num_k, trl_len);
            params.Fs = Spike.samplerate;
            params.tapers = [3, 5];
            [wc, fr_k] = Spike.ChronuxEst(spkyn_k, [win_width, win_step], params);
    end % switch    
    fr_level = cat(1, fr_level, fr_k);
end % for

win_center = wc;

end

function [spk_raster_time, trial_length] = getSpkRaster(usacc_props, spiketimes, timestamps, paras, enum)

spk_timestamps = spiketimes(:, enum.spiketimes.timestamps);

N = size(usacc_props, 1);   % total number of ms
cut_pre = round(paras.pre_ms + paras.win_width / 2);         % cut time before MS
cut_post = round(paras.post_ms + paras.win_width / 2);       % cut time interval after usacc
trial_length = cut_pre + cut_post;  % each trial length in ms
trial_yn = zeros(N, trial_length);

switch paras.trig_signal
    case 'MS onset'
        trig_timeidx = usacc_props(:, enum.usacc_props.start_index);
    case 'MS end'
        trig_timeidx = usacc_props(:, enum.usacc_props.end_index);
        
end % switch

trig_timestamp = timestamps(trig_timeidx);
trial_start = trig_timestamp - cut_pre;
trial_end   = trig_timestamp + cut_post - 1;
for k = 1:N
    spk_idx = spk_timestamps >= trial_start(k) & spk_timestamps <= trial_end(k);
    spk_timestamp_k = spk_timestamps(spk_idx);
    if ~isempty(spk_timestamp_k)
        spk_pos = spk_timestamp_k - trial_start(k) + 1;
        trial_yn(k, spk_pos) = 1;
    end % if
end % for

spk_raster_time = yn2pointtime(trial_yn);

end % function

function [spk_raster, trial_length, trial_num] = cutSpikeRaster(sorted_usacc, spiketimes, timestamps, paras, enum)

nlevel = length(sorted_usacc);
spk_raster = cell(1, nlevel);
tlen = zeros(1, nlevel);
trial_num = zeros(1, nlevel);       % number of trials / usacc number per contrast level
for k = 1:nlevel
    ms_k = sorted_usacc{k};
    [spk_raster_k, tlen_k] = getSpkRaster(ms_k, spiketimes, timestamps, paras, enum);
    
    spk_raster{k} = spk_raster_k;
    trial_num(k) = size(ms_k, 1);
    tlen(k) = tlen_k;
end % for

% check trial length
x = diff(tlen);
if norm(x) > 0
    warning('Trial lengthes are not equal.')
end

trial_length = tlen(1);

end

function sorted_ms = sortMS(usacc_props, cond, stage, cycle, enum, paras)

trig_sig = paras.trig_signal;
criteria = [cond, stage, cycle];
M = length(cond);

N = size(usacc_props, 1);   % total number of usacc
ms_cond = usacc_props(:, enum.usacc_props.condition);

switch trig_sig
    case 'MS onset'
        ms_stage = usacc_props(:, enum.usacc_props.start_in_stage);
    case 'MS end'
        ms_stage = usacc_props(:, enum.usacc_props.end_in_stage);
end % switch

ms_cyc = usacc_props(:, enum.usacc_props.cycle);

ms_space = [ms_cond, ms_stage, ms_cyc];

% check to see if any of the element in ms_space satitisfy criteria
sorted_ms_pos = [];
for k = 1:N
    ms_k = ms_space(k, :);
    d = criteria - ones(M, 1) * ms_k;
    p = d(:, 1).^2 + d(:, 2).^2 + d(:, 3).^2;
    
    if sum(p == 0) > 0
        sorted_ms_pos = cat(1, sorted_ms_pos, k);
    end % if
end % for

sorted_ms = usacc_props(sorted_ms_pos, :);

end

function [sorted_ms, ms_num] = sortMSContLevel(curr_exp, sname, usacc, paras)

Trial = MSCTrial(curr_exp, sname);
enum = Trial.enum;
cont_level = Trial.ContrastLevel;
nlevel = length(cont_level);

sorted_ms = cell(1, nlevel);
ms_num = zeros(1, nlevel);
for k = 1:nlevel
    cont_level_k = cont_level(k);
    [cond_k, stage_k, cyc_k] = Trial.Contrast2CycleCondStage(cont_level_k);
    sorted_usacc_k = sortMS(usacc, cond_k, stage_k, cyc_k, enum, paras);
    
    sorted_ms{k} = sorted_usacc_k;
    ms_num(k) = size(sorted_usacc_k, 1);
end % for

end

% [EOF]
