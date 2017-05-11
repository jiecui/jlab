function saedata = parseChunk( this, pos )
% PARSECHUNK extracts information from SpikeAndEye single chunk
% 
% Syntax:
%   saedata = parseChunk(this,~,pos)
% 
% Input(s):
%   this        - importRF2.readSpikeAndEyeChunks obj
%   pos         - chunk position in the RF file
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
%                 .stim_tON1    : 1st stim ON time
%                 .stim_tOFF1   : 1st stim OFF time
%                 .stim_x1      : 1st stim x-pos (dancing? rf2intr.c,
%                                 rf2intr.h)
%                 .stim_y1      : 1st stim y-pos
%                 .stim_tON2    : 2nd stim ON time
%                 .stim_tOFF2   : 2nd stim OFF time
%                 .stim_x2      : 2nd stim x-pos
%                 .stim_y2      : 2nd stim y-pos
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

% Copyright 2009-2014 Richard J. Cui. Created: 12/09/2009  8:41:31.388 AM
% $Revision: 0.7 $  $Date: Wed 01/22/2014  1:33:38.373 PM $
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
wholename = this.WholeName;

saedata = mxparseSpikeAndEye(wholename, pos);

end%function

% [EOF]