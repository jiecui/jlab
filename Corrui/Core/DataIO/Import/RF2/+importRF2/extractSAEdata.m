function output_data = extractSAEdata(this)
% EXTRACTMSCDATA extracts spike and eye data (TS chunks) from RF2 data
%
% Syntax:
%   output_data = extractSAEdata(this)
% 
% Input(s):
%   this        - experiment import class object
%
% Output(s):
%   output_data - raw experimental parameters and recorded data
% 
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: Sun 08/05/2012 11:40:28.961 AM
% $Revision: 0.5 $  $Date: Thu 04/17/2014  9:54:48.401 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

NOSIGNAL = NaN;

% ------------
% Main
% ------------
seadata = this.SAEChunkData;
ep = seadata.Data;

chunkinfo = seadata.ChunkInfo;
numchunk = length(chunkinfo.sequence);  % number of chunks

timestamps = [];
spiketimes = [];
eye_x1 = [];
eye_y1 = [];
eye_x2 = [];
eye_y2 = [];
stim_tON1   = [];
stim_x1     = [];
stim_y1     = [];

wh = waitbar(0, 'Now extract TS chunk signals, please wait...');
for k = 1:numchunk
    waitbar(k / numchunk, wh)
    % weird things happened
    % ---------------------
    if ~isempty(timestamps) && timestamps(end) == ep(k).time(1)     % if repeat the time in different chunks
        time_k = ep(k).time(2:end);
                
        % eye_x1_k = ep(k).eye_x1(1:length(time_k));
        % eye_y1_k = ep(k).eye_y1(1:length(time_k));
        % eye_x2_k = ep(k).eye_x2(1:length(time_k));
        % eye_y2_k = ep(k).eye_y2(1:length(time_k));
    else
        time_k = ep(k).time;
    end
    
    eye_x1_k = ep(k).eye_x1;
    if isempty(eye_x1_k)
        fprintf('eye_x1 has no signal in chunk %g\n', k)
        eye_x1_k = NOSIGNAL;
    end
    
    eye_y1_k = ep(k).eye_y1;
    if isempty(eye_y1_k)
        fprintf('eye_y1 has no signal in chunk %g\n', k)
        eye_y1_k = NOSIGNAL;
    end
    
    eye_x2_k = ep(k).eye_x2;
    if isempty(eye_x2_k)
        % fprintf('eye_x2 has no signal in chunk %g\n', k)
        eye_x2_k = NOSIGNAL * ones(size(eye_x1_k));
    end
    
    eye_y2_k = ep(k).eye_y2;
    if isempty(eye_y2_k)
        % fprintf('eye_y2 has no signal in chunk %g\n', k)
        eye_y2_k = NOSIGNAL * ones(size(eye_y1_k));
    end
    
    stim_tON1_k = ep(k).stim_tON1;
    stim_x1_k   = ep(k).stim_x1;
    stim_y1_k   = ep(k).stim_y1;
    
    timestamps = cat( 1, timestamps, time_k );
    spiketimes = cat(1, spiketimes, ep(k).spike_time);
    eye_x1 = cat( 1, eye_x1, eye_x1_k);
    eye_y1 = cat( 1, eye_y1, eye_y1_k);
    eye_x2 = cat( 1, eye_x2, eye_x2_k);
    eye_y2 = cat( 1, eye_y2, eye_y2_k);
    stim_tON1   = cat(1, stim_tON1, stim_tON1_k);
    stim_x1     = cat(1, stim_x1, stim_x1_k);
    stim_y1     = cat(1, stim_y1, stim_y1_k);
    
end % for
close(wh)

% weird things happen
% ---------------------
% make unique
% [timestamps,b] = unique(timestamps);
% eye_x1 = eye_x1(b);
% eye_y1 = eye_y1(b);

% make the data contiuous
% times = (timestamps(1):timestamps(end))';
% 
% x1 = interp1(timestamps, eye_x1, times);
% y1 = interp1(timestamps, eye_y1, times);

% do nothing now
% --------------
times = timestamps;     % not necessarily unique in a session!!
x1 = eye_x1;
if sum(isnan(x1)) == length(x1)
    fprintf('eye_x1 has no signal\n')
end % if
y1 = eye_y1;
if sum(isnan(y1)) == length(y1)
    fprintf('eye_y1 has no signal\n')
end % if

x2 = eye_x2;
if sum(isnan(x2)) == length(x2)
    fprintf('eye_x2 has no signal\n')
end % if
y2 = eye_y2;
if sum(isnan(y2)) == length(y2)
    fprintf('eye_y2 has no signal\n')
end % if

% -------------
% cal. samples
% -------------
maxres = double(ep(1).max_eye_res);
HorAngle = this.HorAngle;
VerAngle = this.VerAngle;


samples(:,1) = times;
samples(:,2) = x1 * HorAngle / maxres - HorAngle/2; % centered
samples(:,3) = y1 * HorAngle / maxres - VerAngle/2; % centered
samples(:,4) = x2 * HorAngle / maxres - HorAngle/2; % centered
samples(:,5) = y2 * HorAngle / maxres - VerAngle/2; % centered

% -------------
% detect blinks
% -------------
blinkYesNo = get_coil_blinkYesNo( samples(:,2), samples(:,3) ); % TODO: move to process stage_0

% --------------------------
% time index of spike-times
% --------------------------
st = spiketimes(:);

% N = length(st);
% st_ind = zeros(N,1);
% 
% wh = waitbar(0, 'Now extract spike signals, please wait...');
% for k = 1:N
%     waitbar(k / N, wh)
%     st_k = st(k);
%     st_ind_k = find(times == st_k);
%     if length(st_ind_k) > 1
%         st_ind_k = st_ind_k(1);
%         warning('More than one spike indexes corresponds to one spike time. Use the first one.')
%     end % if
%     st_ind(k) = st_ind_k;
% end % for
% close(wh)

st_ind = Spike.getSpktimeInd(times, st, this.samplerate);
spiketimes = [st, st_ind];

% --------------------------
% stim1 (ts, x, y)
% --------------------------
stim1 = [stim_tON1, stim_x1, stim_y1];

% output
% ------
output_data.timestamps = times;
output_data.samples    = samples;
output_data.spiketimes = spiketimes;
output_data.blinkYesNo = blinkYesNo;
output_data.stim1      = stim1;

end % function extractSAEdata


% [EOF]
