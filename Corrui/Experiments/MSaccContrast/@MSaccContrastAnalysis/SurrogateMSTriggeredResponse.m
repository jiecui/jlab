function result_dat = SurrogateMSTriggeredResponse(current_tag, name, S, dat)
% SURROGATEMSTRIGGEREDRESPONSE Surrogate (shuffled)-triggered cell response
% 
% Description:
%   This function uses surrogate MS to test the significance of ms-triggered response.
% 
% Syntax:
%   result_dat = SurrogateMSTriggeredResponse(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Tue 12/11/2012  5:08:36.411 PM
% $Revision: 0.1 $  $Date: Tue 12/11/2012  5:08:36.411 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
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
    % repeat time for an individual cell
    opt.repeat_num = {100 '' [1 1000]};
    opt.shuffle_method = {'Random MS|{Dissociated MS}', 'Shuffle Method'};    % ref: Meirovithz, 2011
    
    % paras for cutting usacc segment
    % Note: ref. the paras in UsaccTriggeredContrastResponse.m
    opt.post_onset_int = {300 '* (ms)' [0 1300]};   % post onset interval - time after contrast onset during which the usaccs are not selected
    opt.pre_ms_int = {175 '* (ms)' [0 1300]};       % pre-microsaccade interval - time interval examined before a usacc
    opt.post_ms_int = {375 '* (ms)' [0 1300]};      % post-microsaccade interval - time interval examined after a usacc
    
    % paras for cal. firing rate
    opt.win_width = {50 '* (ms)' [1 1000]};        % moving window width
    opt.win_step = {5 '* (ms)' [1 1000]};          % moving window step
    
    % opts for choosing methos of estimating firing rate
    opt.fr_method = { {'Chronux' '{PSTH}'}, 'Firing rate estimation method' };
    
    % opts for choosing normalization methods
    opt.norm_method = { {'{Firing rate difference}' 'Percentage change'}, 'Choose normalization method' };
    opt.norm_options.smt1_interval = {[-150 0] 'Smt1 interval (ms)' [-1000 0]};  % time relative to MS-onset, ms-onset = zero
    opt.norm_options.pmt1_interval = { [0 100] 'Pmt1 interval (ms)' [0 1000] };  % time relative to MS-onset, ms-onset = zero

    result_dat = opt;
    return
end % if


% =========================================================================
% Load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
            dat_var = { 'grattime', 'Left_UsaccXCond23_Start', ...
                        'Left_UsaccXCond23_end', 'FiringXCond23', 'NumberCycle'};
            result_dat = dat_var;
    return
end % if

% =========================================================================
% Data processing
% =========================================================================
% options and paras
% -----------------
repeat_num = S.Stage_2_Options.SurrogateMSTriggeredResponse_options.repeat_num; 
shuffle_method = S.Stage_2_Options.SurrogateMSTriggeredResponse_options.shuffle_method; 

grattime = dat.grattime;
post_onset = S.Stage_2_Options.SurrogateMSTriggeredResponse_options.post_onset_int;
pre_ms = S.Stage_2_Options.SurrogateMSTriggeredResponse_options.pre_ms_int;
post_ms = S.Stage_2_Options.SurrogateMSTriggeredResponse_options.post_ms_int;
win_width = S.Stage_2_Options.SurrogateMSTriggeredResponse_options.win_width;
win_step = S.Stage_2_Options.SurrogateMSTriggeredResponse_options.win_step;

paras.grattime = grattime;
paras.post_onset = post_onset;
paras.pre_ms = pre_ms;
paras.post_ms = post_ms;
paras.win_width = win_width;
paras.win_step = win_step;

fr_method = S.Stage_2_Options.SurrogateMSTriggeredResponse_options.fr_method;     % method for estimating firing rate

norm.method = S.Stage_2_Options.SurrogateMSTriggeredResponse_options.norm_method; % method for normalization
norm.smt1_interval = S.Stage_2_Options.SurrogateMSTriggeredResponse_options.norm_options.smt1_interval;
norm.pmt1_interval = S.Stage_2_Options.SurrogateMSTriggeredResponse_options.norm_options.pmt1_interval;

% shuffle
% -------
usacc_start = dat.Left_UsaccXCond23_Start;
usacc_end = dat.Left_UsaccXCond23_end;
num_cycle = dat.NumberCycle;
sig_len = grattime * 2;

spike_rate = [];
spike_rate_norm = [];
spike_rate_off = [];
spike_rate_norm_off = [];

h = waitbar(0, 'Calculating with surrogate MS. Please wait...');
for k = 1:repeat_num
    waitbar(k / repeat_num, h)
    dat_k = dat;
    switch shuffle_method
        case 'Random MS'
            [shuffled_usacc_start, shuffled_usacc_end] = shuffleRandomMS(usacc_start, ...
                usacc_end, num_cycle, sig_len);
        case 'Dissociated MS'
            [shuffled_usacc_start, shuffled_usacc_end] = shuffleDissociatedMS(usacc_start, ...
                usacc_end, num_cycle, sig_len);
    end % switch
    dat_k.Left_UsaccXCond23_Start = shuffled_usacc_start;
    dat_k.Left_UsaccXCond23_end = shuffled_usacc_end;
    
    % estimated the triggered firing rate
    utcresp_k = MSaccContrastAnalysis.UsaccTriggeredContrastResponse_2stages(dat_k, paras, fr_method, norm);
    
    spike_rate = cat(3, spike_rate, utcresp_k.SpikeRate);
    spike_rate_norm = cat(3, spike_rate_norm, utcresp_k.SpikeRate_Norm);
    spike_rate_off = cat(3, spike_rate_off, utcresp_k.SpikeRate_off);
    spike_rate_norm_off = cat(3, spike_rate_norm_off, utcresp_k.SpikeRate_Norm_off);
end % for
close(h)

utcresp.SpikeRate = mean(spike_rate, 3);
utcresp.SpikeRate_Norm = mean(spike_rate_norm, 3);
utcresp.SpikeRate_offset = mean(spike_rate_off, 3);
utcresp.SpikeRate_offset_Norm = mean(spike_rate_norm_off, 3);

% =========================================================================
% commit results
% =========================================================================
result_dat.SurrogateMSTriggeredResponse = utcresp;

end % function SurrogateMSTriggeredResponse

% =========================================================================
% subroutines
% =========================================================================
function [shuffled_start, shuffled_end] = shuffleRandomMS(ms_start, ms_end, num_cycle, sig_len)

N = length(ms_start);   % number of conditions
shuffled_start = cell(1, N);
for k = 1:N
    start_yn_k = pointtime2yn(ms_start{k}, num_cycle, sig_len);
    shuffled_start_yn_k = shuffleynpos(start_yn_k);
    shuffled_start{k} = yn2pointtime(shuffled_start_yn_k);
end % for

N = length(ms_start);   % number of conditions
shuffled_end = cell(1, N);
for k = 1:N
    end_yn_k = pointtime2yn(ms_end{k}, num_cycle, sig_len);
    shuffled_end_yn_k = shuffleynpos(end_yn_k);
    shuffled_end{k} = yn2pointtime(shuffled_end_yn_k);
end % for

end 

function [shuffled_start, shuffled_end] = shuffleDissociatedMS(ms_start, ms_end, num_cycle, sig_len)

N = length(ms_start);   % number of conditions
shuffled_start = cell(1, N);
for k = 1:N
    start_yn_k = pointtime2yn(ms_start{k}, num_cycle, sig_len);
    shuffled_start_yn_k = shuffletrlpos(start_yn_k);
    shuffled_start{k} = yn2pointtime(shuffled_start_yn_k);
end % for

N = length(ms_end);
shuffled_end = cell(1, N);
for k = 1:N
    end_yn_k = pointtime2yn(ms_end{k}, num_cycle, sig_len);
    shuffled_end_yn_k = shuffletrlpos(end_yn_k);
    shuffled_end{k} = yn2pointtime(shuffled_end_yn_k);
end % for

end 

function s_yn = shuffletrlpos(yn)

N = size(yn, 1);

idx = randperm(N);
s_yn = yn(idx, :);

end 

function s_yn = shuffleynpos(yn)

[N, M] = size(yn);
s_yn = false(N, M);
for k = 1:N
    p_k = sum(yn(k, :) == true);
    r_k = randperm(M);
    t_k = r_k(1:p_k);
    s_yn(k, t_k) = true;
end % for

end 

% [EOF]
