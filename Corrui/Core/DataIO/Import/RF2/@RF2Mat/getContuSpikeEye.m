function [EyePos,SpikeTime] = getContuSpikeEye(RM)
% GETCONTUSPIKEEYE Extract continous segments of eye movements and
%       corresponding spike times
% 
% Syntax:
%   [Time,EyePos,SpikeTime] = getContuSpikeEye(RM)
% 
% Input(s):
%   RM              - RF2Mat class
% 
% Output(s):
%   EyePos          - structure containing segments of continuous eye
%                     movements
%                     .time         : time stamps (ms)
%                     .eye_x        : x-axis in each segment (arcmin)
%                     .eye_y        : y-axis (arcmin)
%   SpikeTime       - time stamps of spikes (ms)
% 
% 
% See also readrf2chunks, RF2Mat.

% Copyright 2009-2010 Richard J. Cui. Created: 02/20/2010  5:06:00.500 PM
% $Revision: 0.2 $  $Date: 03/09/2010  2:21:27.534 PM $
% 
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
% 
% Email: jie@neurocorrleate.com

% =========================================================================
% parameters
% =========================================================================
num_chunk = RM.nChunkOfInt;     % number of imported chunks
chunks = RM.chunks;
% maxres = RM.getMaxRes;
maxres = RM.MaxRes;

para = RM.ParaDisp;
a = para.PixMaxRes;
A = [a,0;0,a]/maxres;

b1 = para.HorAngle;
b2 = para.VerAngle;
b3 = para.HorWidth;
b4 = para.VerWidth;
b = [b1/b3,b2/b4]*60;

B = [b(1),0;0,b(2)];

% =========================================================================
% extract all 'SpikeAndEye' chunks
% =========================================================================
eye_seg = []; 
time = [];
eye_x = [];
eye_y = [];
spike_time = [];

time_end_k = 0;
h = waitbar(0,'Please wait...');
for k = 1:num_chunk
    % ------------
    waitbar(k/num_chunk,h,sprintf('Processing chunk # %g of %g. Please wait...',...
        k,num_chunk));
    % ------------
    chunk_k = chunks(k);
    type = chunk_k.type;
    if strcmpi(type,'SpikeAndEye')
        sae_k = RM.parseSpikeAndEye(chunk_k);
        time_beg_k = sae_k.time(1);
        if time_beg_k == time_end_k+1  % continuous chunk
            time = cat(1,time,sae_k.time);
            % eye_x_k = sae_k.eye.x1*A(1,1)*B(1,1);
            % eye_y_k = sae_k.eye.y1*A(2,2)*B(2,2);
            eye_x_k = double(sae_k.eye.x1)*A(1,1)*B(1,1);
            eye_y_k = double(sae_k.eye.y1)*A(2,2)*B(2,2);
            eye_x = cat(1,eye_x,eye_x_k);
            eye_y = cat(1,eye_y,eye_y_k);
            spike_time_k = sae_k.spike_time;
            spike_time = cat(1,spike_time,spike_time_k);
            time_end_k = sae_k.time(end);
            if k == num_chunk   % the last chunk
                seg_k.time = time;
                seg_k.eye_x = eye_x;
                seg_k.eye_y = eye_y;
                seg_k.spike_time = spike_time;
                eye_seg = cat(1,eye_seg,seg_k);
            end%if
        elseif time_beg_k >= time_end_k+2 % not continuous
            if ~isempty(time)
                % save old segment
                seg_k.time = time;
                seg_k.eye_x = eye_x;
                seg_k.eye_y = eye_y;
                seg_k.spike_time = spike_time;
                eye_seg = cat(1,eye_seg,seg_k);
            end%if
            % begin a new segment
            time = sae_k.time;
            % eye_x = sae_k.eye.x1*A(1,1)*B(1,1);
            % eye_y = sae_k.eye.y1*A(2,2)*B(2,2);
            eye_x = double(sae_k.eye.x1)*A(1,1)*B(1,1);
            eye_y = double(sae_k.eye.y1)*A(2,2)*B(2,2);
            spike_time = sae_k.spike_time;
            time_end_k = time(end);
        end%if
    end%if
end%for
close(h)

% spiketimes
% ----------
timestamps = [];
timestamps = cat(1, timestamps, eye_seg.time);
spiketime = [];
spiketime   = cat(1,spiketime,eye_seg.spike_time);
spktime_idx = find_array_index(timestamps, spiketime);
SpikeTime = [spiketime, spktime_idx];

% =========================================================================
% output
% =========================================================================
EyePos = eye_seg;
EyePos = rmfield(EyePos,'spike_time');

RM.EyePos   = EyePos;
RM.SpikeTime = SpikeTime;

end%function

% [EOF]