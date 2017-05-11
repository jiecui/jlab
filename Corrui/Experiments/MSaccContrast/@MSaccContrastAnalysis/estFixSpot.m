function result_dat = estFixSpot(current_tag, name,  S, dat)
% ESTFIXSPOT Estimates of the fixation spot in each Cycle
%
% Syntax:
%   result_dat = estFixSpot(current_tag, name,  S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat.FixSpot      - number of Cycle x 2
%                             [x,y] coordinates of the estimated fixation
%                             spot of each cycle
%
% Example:
% 
% Reference:
%   Leopold, D. A. and N. K. Logothetis (1996). "Activity changes in early
%   visual cortex reflect monkeys' percepts during binocular rivalry."
%   Nature 379(6565): 549-553.
%
% See also .

% Copyright 2011 Richard J. Cui. Created: 02/11/2012  4:03:56.462 PM
% $Revision: 0.2 $  $Date: Mon 02/13/2012  5:48:39.506 PM $
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
    
    
    opt = [];
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'mSaccConSig'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
mSaccConSig = dat.mSaccConSig;

% find the condition number where 100% contrast was presented
% -----------------------------------------------------------
cond1 = zeros(11,1);    % 100% at Contrast 1, 11 in total
cond2 = zeros(10,1);    % 100% at Contrast 2, 10 in total

for k = 1:11
    cont_k = (k-1)*10; 
    cond1(k) = Cont2Condnum(100, cont_k);
end % for

for k = 1:10
    cont_k = (k-1)*10;
    cond2(k) = Cont2Condnum(cont_k, 100);
end % for

signal1_x = [];
signal1_y = [];
time1 = [];
spiketime1 = [];
for k1 = 1:11
    
    % eye position
    signal1_xk = mSaccConSig(cond1(k1), 2).eye_position.signal(:,:,1);
    signal1_yk = mSaccConSig(cond1(k1), 2).eye_position.signal(:,:,2);
    
    signal1_x = cat(3, signal1_x, signal1_xk);
    signal1_y = cat(3, signal1_y, signal1_yk);
    
    % time indexes
    time1_k = mSaccConSig(cond1(k1), 2).eye_position.time_index;
    time1 = cat(3, time1, time1_k);
    
    % spike times
    spiketime1_k = mSaccConSig(cond1(k1), 2).spikes;
    spiketime1 = cat(2, spiketime1, spiketime1_k);
    
end % for

signal2_x = [];
signal2_y = [];
time2 = [];
spiketime2 = [];
for k2 = 1:10
    
    % eye position
    signal2_xk = mSaccConSig(cond2(k2), 3).eye_position.signal(:,:,1);
    signal2_yk = mSaccConSig(cond2(k2), 3).eye_position.signal(:,:,2);
    
    signal2_x = cat(3, signal2_x, signal2_xk);
    signal2_y = cat(3, signal2_y, signal2_yk);
    
    % time index
    time2_k = mSaccConSig(cond2(k2), 3).eye_position.time_index;
    time2 = cat(3, time2, time2_k);
    
    % spike times
    spiketime2_k = mSaccConSig(cond2(k2), 3).spikes;
    spiketime2 = cat(2, spiketime2, spiketime2_k);
    
end % for

signal_x = cat(3, signal1_x, signal2_x);
signal_y = cat(3, signal1_y, signal2_y);
time = cat(3, time1, time2);
spiketime = cat(2, spiketime1, spiketime2);

% estimate firing rate
% --------------------
numCycle = size(mSaccConSig(1).blink, 1);
sig_length = size(signal_x, 1);
nCon = size(signal_x, 3);

winlen = 200;   % moving window length (ms)
step = 40;      % window width (ms)
% nwin = floor((sig_length - winlen)/step);

FixSpot = zeros(numCycle,2);   % estimated points to 'centers' the stimulus within the RF

for k = 1:numCycle
    
    % avgFR = zeros(1, nwin);
    spikes = zeros(sig_length, nCon);
    
    for p = 1:nCon
    
        t0_kp = time(1, k, p);
        spk_t = spiketime{k, p};
        if spk_t(1,1) ~= 0
            index = spk_t - t0_kp + 1;
            spikes(index, p) = 1;
        end % if
        
    end % for
    
    % estimate FR
    % 1. remove the first 300 ms
    % 2. cal. average FR in a 200 ms stepping at 40 ms = 20 windows
    % -------------------------------------------------------------
    steady_spike = spikes(301:end, :);
    avgFR = calAvgFR(steady_spike, winlen, step);
    mR = mean(avgFR);       % mean
    sigma_R = std(avgFR);   % std
    R_ind = avgFR > (mR + sigma_R);     % find those windows having significantly higher FR
    
    % estimate eye position
    steady_x = squeeze(signal_x(301:end, k, :));
    steady_y = squeeze(signal_y(301:end, k, :));
    avgxy = calAvgEyePos(steady_x, steady_y, winlen, step);
    
    % etimate the 'center' point
    select_xy = avgxy(R_ind, :);
    FixSpot(k, :) = mean(select_xy);
    
end % for

% commit the results
% ==================
result_dat.FixSpot = FixSpot;

end % function estFixSpot

% ======================
% subroutines
% ======================
function avgfr = calAvgFR(spikes, winlen, step)
% output:
%   avgfr   - average firing rate [number of windows x 1]

[sig_length, nCond] = size(spikes);
nwin = floor((sig_length - winlen)/step);   % number of windows
avgfr = zeros(1, nwin);

for k = 1:nwin
    
    t0 = floor((k - 1) * step) + 1;
    t1 = t0 + winlen - 1;
    
    spike_k = spikes(t0:t1,:);
    avg_k = sum(spike_k(:))/(nCond * winlen) * 1000;    % FR = spikes/second
    avgfr(k) = avg_k;
    
end % for

end % function

function avg_xy = calAvgEyePos(x, y, winlen, step)
% Output:
%   avg_xy  - [numwin, 2], where col. 1 = x, column 2 = y

sig_length = size(x,1);
nwin = floor((sig_length - winlen)/step);   % number of windows
avg_xy = zeros(nwin, 2);

for k = 1:nwin
    
    t0 = floor((k - 1) * step) + 1;
    t1 = t0 + winlen - 1;
    
    x_k = x(t0:t1,:);
    y_k = y(t0:t1,:);
    avgx_k = mean(x_k(:));
    avgy_k = mean(y_k(:));
    
    avg_xy(k,:) = [avgx_k,avgy_k];
    
end % for

end % function

% [EOF]
