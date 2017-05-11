function saedata = parseChunk(~,data,~)
% PARSECHUNK extracts information from SpikeAndEye single chunk
% 
% Syntax:
%   saedata = parseSpikeAndEye(this,sae)
% 
% Input(s):
%   data        - data in SpikeAndEye chunk (see chunk structure in readrf2chunks.m)
% 
% Output(s):
%   saedata     - Parsed SpikeAndEye data structure
%                 .time         : time instants of data_unit
%                 .stim_type    : stimulus type (?)
%                 .data_info    : data info (?)
%                 .max_eye_res  : maxiumn eye resolution - max # units
%                                 (both horizontal and vertical)
%                 .spike_time   : time stamps of spikes
%                 .eye_x1       : 1st eye x-position
%                 .eye_y1       : 1st eye y-pos
%                 .eye_x2       : 2nd eye x-pos
%                 .eye_y2       : 2nd eye y-pos
%                 .stim_x1      : 1st stim x-pos (dancing? rf2intr.c,
%                                 rf2intr.h)
%                 .stim_y1      : 1st stim y-pos
%                 .stim_tON1    : 1st stim ON time
%                 .stim_tOFF1   : 1st stim OFF time
%                 .stim_x2      : 2nd stim x-pos
%                 .stim_y2      : 2nd stim y-pos
%                 .stim_tON2    : 2nd stim ON time
%                 .stim_tOFF2   : 2nd stim OFF time
%                 .plainbar_x   : x range/position of plain bar (?)
%                 .plainbar_y   : y range/position of plain bar
%                 .periodidx    : period index (phase) of (Gabor) gratings
% 
% Remarks:
%   The structure of SpikeAndEye chunk:
%       OxFF            (1st Byte)
%       type            (2nd byte)
%       chunk length    (3-4 bytes)
%       data            (from the 5th bytes)
% 
%   The structure of 'data' in SpikeAndEye:
%       datastartbyte:  Spike and eye data-unit start address. This is an
%                       offset from the beginning of chunk.
%                       (1st-2nd bytes/uint8)
%       long_flag:      whether the type of data is coded in long words (4
%                       bytes) or short words (2 bytes).
%                       = 1, using 4 bytes
%                       = 0, using 2 bytes
%                       (3rd-4th bytes)
%       stim_type:      type of stimulus (5th-6th bytes)
%       data_info:      informatio of the data (?)
%                       (7-8 bytes)
%       max_eye_res:    maximum resolution of eye position (?)
%                       (17-18 bytes)
% 
%   The structure of 'data-unit' in SpikeAneEye
%       time:           time of data (1-4 bytes)
%       data_type:      type of data (5-6 or 5-8 bytes, depending on
%                       long_flag)
%       data:           (length will depend on data_type)
%       
% 
% Example:
% 
% See also readrf2chunks.

% Copyright 2009-2011 Richard J. Cui. Created: 12/09/2009  8:41:31.388 AM
% $Revision: 0.6 $  $Date: Sun 11/20/2011  5:00:56.872 PM $
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
% ---------------
% data_type (defined in rf2intr.h)
% ---------------
% rf2intr.h --> The format of TS data is:
% 
% long time  in milliseconds (4 bytes) short flag  what type of data (2
% bytes) 
% 
% -> NOTE this can be changed to a long (4 bytes) by setting 4th
% short in chunk any number of shorts of data
% 
% The #defines start with 'C' for Continuous recording. The number of
% following data in shorts start with 'CN'

CEYE1 			= 10;   % 1st eye position (x,y coordinates)
CEYE2 			= 6;    % 1st eye position (Xoana: keep compatible with doris)
% CNEYE 			= 2;    % 2 shorts of data of CEYE1 and CEYE2

CSPIKEA 		= 20;   % one spike detected from electrode A
CSPIKEB 		= 21;   % one spike detected from electrode B
% CNSPIKEA 		= 0;    % no data, just the flag, record the time stamp
% CNSPIKEB  		= 0;    % ditto

CSTIMON1 		= 30;   % 1st stimulus room for multi stims
% CNSTIMON1 		= 2;    % location of stim
CSTIMOFF1 		= 40;
% CNSTIMOFF1 		= 0;
CSTIMON2 		= 31;   %
% CNSTIMON2 		= 2;    % 
CSTIMOFF2		= 41;
% CNSTIMOFF2 	    = 0;

CBARXY          = 50;   % x,y position of plainbar stimulus
% CNBARXY         = 2;    % number of shorts of CBAXY data

CGRATPERIDX     = 60;   % period index of (Gabor) grating
% CNBRATPERIDX    = 1;    % number of shorts

% =========================================================================
% main
% =========================================================================
% ---------------
% parse
% ---------------
% data = sae;    % data in this chunk without the 4-byte head
% datastartbyte = typecast(data(1:2),'uint16');
datastartbyte = uint16(shortfrombytes(double(data(1:2))));
% (-4, because we get rid of the first 4 byes in chunk)
data_start = datastartbyte-4+1;             % data start position 
% saedata.data_start = data_start;

% data_length = sae.length-4-data_start+1;    % length of data
% saedata.data_length = data_length;
data_length = length(data);

% long_flag = logical(typecast(data(3:4),'uint16'));
long_flag = logical(shortfrombytes(double(data(3:4))));

% saedata.long_flag = long_flag;

% stim_type = typecast(data(5:6),'uint16')+1;
stim_type = uint16(shortfrombytes(double(data(5:6))))+1;
saedata.stim_type = stim_type;

% data_info = typecast(data(7:8),'uint16');        % ?
data_info = uint16(shortfrombytes(double(data(7:8))));        % ?
saedata.data_info = data_info;

% max_eye_res = typecast(data(17:18),'uint16');
max_eye_res = uint16(shortfrombytes(double(data(17:18))));
saedata.max_eye_res = max_eye_res;

% prepare to extract information from data_unit
time        = [];   % time of recorded data
spike_time  = [];   % time of spikes
eye_x1      = [];   % 1st eye position x-axis
eye_y1      = [];   % 1st eye position y-axis
eye_x2      = [];   % 2nd eye position x-axis
eye_y2      = [];   % 2nd eye position y-axis
stim_x1     = [];   % 1st stimulus position x-axis (for stimuli that change over 
                    % time, like DANCE and FIXSIM)
stim_y1     = [];   % 1st stimulus position y-axis
stim_tON1   = [];   % 1st stimulus ON time
stim_tOFF1  = [];   % 1st stimulus OFF time
stim_x2     = [];   % 2nd stimulus position x-axis (for stimuli that change over 
                    % time, like DANCE and FIXSIM)
stim_y2     = [];   % 2nd stimulus position y-axis
stim_tON2   = [];   % 2nd stimulus ON time
stim_tOFF2  = [];   % 2ndimulus OFF time
plainbar_x  = [];   % x position of plain bar
plainbar_y  = [];   % y position of plain bar
periodidx   = [];   % period index (phase) of (Gabor) gratings

last_time = 0;      % for checking the changes of time stamps

discard_chunk = false;  % flag to discard chunk
k = data_start;     % data pointer
while (k < data_length) && (~discard_chunk)
    % (1) current time instant
    % time_k = typecast(data(k:k+3),'uint32');    % current time
    time_k = uint32(longfrombytes(double(data(k:k+3))));    % current time
    k = k+4;                        % move pointer to the next section
    if time_k ~= last_time
        time = cat(1,time,time_k);      % record time
        last_time = time_k;
    end%if
    % (2) current data type
    if true(long_flag)
        % data_type_k = typecast(data(k:k+3),'uint32');
        data_type_k = uint32(longfrombytes(double(data(k:k+3))));
        k = k+4;    % move pointer to the next section
    else
        % data_type_k = typecast(data(k:k+1),'uint16');
        data_type_k = uint16(shortfrombytes(double(data(k:k+1))));
        k = k+2;    % move pointer to the next section
    end%if
    % (3) extract data info according to data_type_k
    switch data_type_k
        case CBARXY
            plainbar_x_k = uint16(shortfrombytes(double(data(k:k+1))));
            k = k + 2;
            plainbar_y_k = uint16(shortfrombytes(double(data(k:k+1))));
            k = k + 2;
            
            plainbar_x = cat(1, plainbar_x, plainbar_x_k);
            plainbar_y = cat(1, plainbar_y, plainbar_y_k);
            
        case CGRATPERIDX
            periodidx_k = uint16(shortfrombytes(double(data(k:k+1))));
            k = k + 2;
            
            periodidx = cat(1, periodidx, periodidx_k);
            
        case CEYE1      % 1st eye movements
            eye_x1_k = uint16(shortfrombytes(double(data(k:k+1))));
            k = k+2;
            eye_y1_k = uint16(shortfrombytes(double(data(k:k+1))));
            k = k+2;
            
            eye_x1 = cat(1,eye_x1,eye_x1_k);
            eye_y1 = cat(1,eye_y1,eye_y1_k);
        case CEYE2      % 2nd eye movements
            % just skip it
            k = k+4;
        case CSPIKEA    % spike info from electrode A
            spike_time = cat(1,spike_time,time_k);
            % because there is no additional data in this data_unit, there
            % is no need to move pointer here.
        case CSPIKEB    % spike info from electrode B
            % just ignore it now
        case CSTIMON1   % 1st stimulus room for multi stims
            % (1) record time
            stim_tON1 = cat(1,stim_tON1,time_k);
            % (2) record x,y position
            % stim_x1_k = typecast(data(k:k+1),'uint16');
            stim_x1_k = uint16(shortfrombytes(double(data(k:k+1))));
            stim_x1 = cat(1,stim_x1,stim_x1_k);
            k = k+2;
            
            % stim_y1_k = typecast(data(k:k+1),'uint16');
            stim_y1_k = uint16(shortfrombytes(double(data(k:k+1))));
            stim_y1 = cat(1,stim_y1,stim_y1_k);
            k = k+2;
        case CSTIMON2   % 2nd stimulus room for multi stims
            % (1) record time
            stim_tON2 = cat(1,stim_tON2,time_k);
            % (2) record x,y position
            % stim_x2_k = typecast(data(k:k+1),'uint16');
            stim_x2_k = uint16(shortfrombytes(double(data(k:k+1))));
            stim_x2 = cat(1,stim_x2,stim_x2_k);
            k = k+2;
            
            % stim_y2_k = typecast(data(k:k+1),'uint16');
            stim_y2_k = uint16(shortfrombytes(double(data(k:k+1))));
            stim_y2 = cat(1,stim_y2,stim_y2_k);
            k = k+2;
        case CSTIMOFF1
            stim_tOFF1 = cat(1,stim_tOFF1,time_k);
            % no additional data
        case CSTIMOFF2
            stim_tOFF2 = cat(1,stim_tOFF2,time_k);
            % no additional data
        % case CNEYE || CNSPIKEA || CNSPIKEB || CNSTIMON1 || CNSTIMOFF1 || CNSTIMON2 || CNSTIMOFF2
        %     error('Encounter data type that cannot be processed presetnly!')
        otherwise
            % error('Unexpected data type!')
            warning('ParseSpikeAndEye:unknowtype','Unexpected data type! Data chunk is discarded..')
            discard_chunk = true;
            break
    end%switch
        
end%while

% ------------------------------
% sometimes weird things happen,
% check here
% ------------------------------
% make unique
time = unique(time);
% check length of times and eye positions
time_len = length(time);
x1_len   = length(eye_x1);

if time_len ~= x1_len
    warning('parseSpikeAndEye:lengtherror','Time length is not consistent with eye signal length.');
    if time_len < x1_len
        eye_x1 = eye_x1(1:time_len);
        eye_y1 = eye_y1(1:time_len);
    elseif time_len > x1_len
        time = time(1:x1_len);
    end % if
    
end % if

% ---------------
% output parsed
% ---------------
if discard_chunk == true
    saedata = [];
else
    saedata.time        = time;
    saedata.spike_time  = spike_time;
    
    saedata.eye_x1      = eye_x1;
    saedata.eye_y1      = eye_y1;
    saedata.eye_x2      = eye_x2;
    saedata.eye_y2      = eye_y2;
    
    saedata.stim_x1     = stim_x1;
    saedata.stim_y1     = stim_y1;
    saedata.stim_tON1   = stim_tON1;
    saedata.stim_tOFF1   = stim_tOFF1;
    
    saedata.stim_x2     = stim_x2;
    saedata.stim_y2     = stim_y2;
    saedata.stim_tON2   = stim_tON2;
    saedata.stim_tOFF2   = stim_tOFF2;
    
    saedata.plainbar_x     = plainbar_x;
    saedata.plainbar_y     = plainbar_y;
    saedata.periodidx      = periodidx;

end % if

end%function

% [EOF]