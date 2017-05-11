function spkidx = getSpktimeInd(timestamps, spiketimes, Fs)
% GETSPKTIMEIND finds the corresponding indexes of the spiketimes
%       This function gets the sequence indexes of the spiketimes in the
%       time series of timestamps, which attemps a faster way when deal
%       with large amount of timestamps and spiketimes.
%
% Syntax:
%
% Input(s):
%   timestamps      - machine time stamp values (ms). Assume it is a
%                     non-decreasing function
%   spiketimes      - machine time stamp value (ms) when a spike is detected
%   Fs              - sampling frequency (Hz)
%
% Output(s):
%   spkidx          - sequence index of spiketime. if NaN, no corresponding
%                     timestamp can be found for the spiketime.
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 06/08/2013  3:28:47.195 PM
% $Revision: 0.2 $  $Date: Tue 10/29/2013  5:02:04.058 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% Normalize Fs to 1
% -----------------
Ts = 1000 / Fs;     % in ms
spiketimes = floor(spiketimes ./ Ts);
timestamps = floor(timestamps ./ Ts);

% check the valididty of timestamps
% ---------------------------------
M = length(timestamps);

[ts, ts_order] = sort(timestamps);
if length(unique(ts)) < M
    error('Timestamps values must be unique.')
end % if

% check the validity of spiketimes
% ---------------------------------
N = length(spiketimes);     % number of spiketimes
[st, st_order] = sort(spiketimes);
u_ts = unique(st);
u_N = length(u_ts);
if u_N < N
    warning('Spike:getSpiketimeInd', ...
        'Spiketimes values are not unique. %g repeated spiketimes are detected', N - u_N)
end % if    

% main
% ----
% find continuous time blocks
ts_yn = pointtime2yn(ts, 1, ts(end));
[cts_b, cts_e] = yn2be(ts_yn);      % continous time blocks begin/end timestamps (Fs = 1)
b_idx = getTPIndex(cts_b, ts);

% assign spiketimes to different CTS (continous time blocks)
st_assign = assignST(st, cts_b, cts_e);

st_ind = zeros(N, 1);   % index of spike time
M = length(cts_b);
wh = waitbar(0, 'Search time indexes of spike times, please wait...');
for k = 1:M
    waitbar(k / M, wh)
    
    k_idx = st_assign == k;
    st_k = st(k_idx);
    
    if ~isempty(st_k)
        st_ind(k_idx) = st_k - cts_b(k) + b_idx(k);
    end % if
end % for
close(wh)

st_pos(st_order) = 1:N;
st_spkidx = st_ind(st_pos);
nan_idx = isnan(st_spkidx);
spkidx = NaN(size(st_spkidx));
spkidx(~nan_idx) = ts_order(st_spkidx(~nan_idx));

end % function getSpktimeInd

% =========================================================================
% subroutines
% =========================================================================
function st_assigned = assignST(st, block_b, block_e)
% assign Stpiketimes to different continous blocks

M = length(st);
st_assigned = zeros(M, 1);

N = length(block_b);
for k = 1:N
    b_k = block_b(k);
    e_k = block_e(k);
    
    delta_b = st - b_k;
    delta_e = -(st - e_k);
    
    block_k_idx = delta_b .* delta_e >= 0;
    if ~isempty(block_k_idx)
        st_assigned(block_k_idx) = k;
    end % if
end % for

end % function

function tp_ind = getTPIndex(tp, timestamp)
% get timepoint index in timestamp
% 
% tp    - time points

M = length(timestamp);
N = length(tp);
tp_ind = zeros(N, 1);   % index of spike time
for k = 1:N         % find the index one by one

    % set the initial timestamp interval to search
    if k == 1
        idx0 = 1;
        tp_km1 = timestamp(1);         % 1st timestamp
    else
        idx0 = tp_ind(k - 1) + 1;
        tp_km1 = tp(k - 1);     % prevous spiketime
    end % if
    if isnan(idx0) || idx0 < 1
        idx0 = 1;
    end % if
    
    if k == N
        idx1 = M;
    else
        tp_kp1 = tp(k + 1);
        % idx1 = round((st_kp1 - ts(1)) * Fs / 1000);     % in ms
        idx1 = (tp_kp1 - tp_km1) + idx0;
    end % if
    if idx1 > M
        idx1 = M;
    end % if

    tp_k = tp(k);
    tp_ind_k = findStIdx(idx0, idx1, timestamp, tp_k);     % look for in an interval
    tp_ind(k) = tp_ind_k;
    
end % for

end % function

function st_ind = findStIdx(idx0, idx1, timestamps, st)

% half size approach
% ------------------
len_thres = 1000;   % length threshold

time_int = timestamps(idx0:idx1);
if length(time_int) <= len_thres
    idx = find(time_int == st);
    if isempty(idx)
        idx = NaN;
    end % if
    st_ind = idx0 + idx - 1;
else
    mid_idx = round(mean([idx0, idx1]));
    ts_mid = timestamps(mid_idx);
    if st == ts_mid    % direct hit
        st_ind = mid_idx;
    elseif st < ts_mid
        idx1 = mid_idx;
        st_ind = findStIdx(idx0, idx1, timestamps, st);
    else    % st > ts_mid
        idx0 = mid_idx;
        st_ind = findStIdx(idx0, idx1, timestamps, st);
    end % if
end % if

% now easy job
% ------------
% time_int = timestamps(idx0:idx1);
% idx = find(time_int == st);
% if isempty(idx)
%     idx = NaN;
% end % if
% st_ind = idx0 + idx - 1;

end % funciton

% [EOF]
