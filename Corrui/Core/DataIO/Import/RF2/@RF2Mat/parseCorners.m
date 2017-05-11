function cornersdata = parseCorners(this,corners)
% PARSECORNERS extracts information from CORNERS single chunk
%
% Syntax:
%   cornersdata = parseCorners(this,corners)
%
% Input(s):
%   this        - object class
%   corners     - CORNERS chunk (see chunk structure in readrf2chunks.m)
%                 .position     : postion of this chunk in raw RF data
%                 .type         : CORNERS
%                 .length       : length of this chunk (bytes/uint8)
%                 .data         : data in this chunk (must be uint8)
%
% Output(s):
%   cornersdata - Parsed DIAG data structure
%                 .gaze         : information on gaze
%                       .box    : size of the gaze box (?)
%                       .time   : required gaze duration (ms ?)
%                 .stim         : information on stimulus
% 
%                 (......)
% 
% 
%
% Example:
%
% See also readrf2chunks, parseSpikeAndEye.

% Copyright 2010 Richard J. Cui. Created: 03/06/2010 12:44:19.813 AM
% $Revision: 0.1 $  $Date: 03/09/2010  9:09:36.284 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% paramerters
% =========================================================================
gamma   = this.ParaDisp.Gamma;  % harvard.gamma, see rf2analysis.m

% =========================================================================
% Main
% =========================================================================
% ---------------
% check validity
% ---------------
chunk_type = corners.type;

if ~strcmpi(chunk_type,'CORNERS')
    error('Not a %s chunk!','CORNERS')
end%if

% ---------------
% parse
% ---------------
data = corners.data;    % data in this chunk without the 4-byte head

% 1. gaze box
gaze_box        = double(typecast(data(1:2),'uint16'));     % gazebox - size of gaze box (?)

% 2. stimulus
stim_size       = double(typecast(data(3:4),'uint16'));     % stimsize
spread_size     = double(typecast(data(5:6),'uint16'));     % spreadsize
% angle           = double(typecast(data(7:8),'uint16'));     % cangle - 'c' stands for 'corners'
angle           = double(typecast(data(7:8),'int16'));      % cangle - 'c' stands for 'corners', rotational angle of CORNERS stimulus
angle_spread    = double(typecast(data(9:10),'int16'));     % canspread (? possibly negative)
distance        = double(typecast(data(11:12),'uint16'));   % cdistance

color_red       = typecast(data(13:14),'uint16');
forecolor_red   = double(bitand(color_red,255));            % forecolor.red
backcolor_red   = double(bitand(bitshift(color_red,8,16),255));     % backcolor.red (? in loadchunks.m)
color_green     = typecast(data(15:16),'uint16');
forecolor_green = double(bitand(color_green,255));          % forecolor.green
backcolor_green = double(bitand(bitshift(color_green,8,16),255)); % backcolor.green (? in loadchunks.m)
color_blue      = typecast(data(17:18),'uint16');
forecolor_blue  = double(bitand(color_blue,255));
backcolor_blue  = double(bitand(bitshift(color_blue,8,16),255));  % backcolor.blue (? in loadchunks.m)

grades          = double(typecast(data(19:20),'uint16'));   % grades - number of steps of gray changes
peak_color      = double(typecast(data(21:22),'uint16'));   % peakcolor
edge_color      = double(typecast(data(23:24),'uint16'));   % edgecolor

upper_x         = double(typecast(data(25:26),'int16'));    % cupperx (?)
upper_y         = double(typecast(data(27:28),'int16'));    % cuppery (?)

% 3. fix grid
stim_time       = double(typecast(data(29:30),'uint16'));   % * stimtime (fixation time?)
gaze_time       = double(typecast(data(31:32),'uint16'));   % gazetime(?)
grid_center_x   = double(typecast(data(33:34),'uint16'));   % grid_center_x
grid_center_y   = double(typecast(data(35:36),'uint16'));   % grid_center_y

fix_red         = double(typecast(data(37:38),'uint16'));   % fixr - ? fixation cross color
fix_green       = double(typecast(data(39:40),'uint16'));   % fixg
fix_blue        = double(typecast(data(41:42),'uint16'));   % fixb

user_gamma      = double(typecast(data(43:44),'uint16'));   % ?
grid_size_x     = double(typecast(data(45:46),'uint16'));   % gridsizex (number of crosses along x-axis)
grid_size_y     = double(typecast(data(47:48),'uint16'));   % gridsizey (number of corsses along y-axis)
fade_dist       = double(typecast(data(49:50),'uint16'));   % cfadedist (?)
width           = double(typecast(data(51:52),'uint16'));   % cwidth (?)
size            = double(typecast(data(53:54),'uint16'));   % csize (?)
depth           = double(typecast(data(55:56),'int16'));    % cdepth (?)
fix_angle       = double(typecast(data(57:58),'uint16'));   % fixangle (in deg) (why always zero?, doesn't make sense)

peak_lum        = this.PercentLuminanceFromGun(peak_color,user_gamma,gamma);
edge_lum        = this.PercentLuminanceFromGun(edge_color,user_gamma,gamma);

grid_number     = grid_size_x*grid_size_y;          % total num of crosses

fix_grid        = calFixGrid(grid_size_x,grid_size_y,...
    grid_center_x,grid_center_y,spread_size,fix_angle);

% =========================================================================
% output
% =========================================================================
% parameters of gaze boxes
% ------------------------
cornersdata.gaze.box       = gaze_box;  % size of gaze box (pixel)
cornersdata.gaze.time      = gaze_time; % at least this amount of time for rewarding

% parameters of stimulus 
% ----------------------
cornersdata.stim.size      = stim_size;     % 
cornersdata.stim.spread    = spread_size;
cornersdata.stim.angle     = angle;         % rotation of the corners stimulus,
                                            % center at the center of the first layer
                                            % called edge layer
cornersdata.stim.angle_spread = angle_spread;
cornersdata.stim.distance  = distance;
cornersdata.stim.forecolor.red     = forecolor_red;
cornersdata.stim.forecolor.green   = forecolor_green;
cornersdata.stim.forecolor.blue    = forecolor_blue;
cornersdata.stim.backcolor.red     = backcolor_red;
cornersdata.stim.backcolor.green   = backcolor_green;
cornersdata.stim.backcolor.blue    = backcolor_blue;
cornersdata.stim.grades    = grades;
cornersdata.stim.peakcolor = peak_color;
cornersdata.stim.edgecolor = edge_color;
cornersdata.stim.upperx    = upper_x;
cornersdata.stim.uppery    = upper_y;
cornersdata.stim.user_gamma = user_gamma;
cornersdata.stim.fadedist  = fade_dist;
cornersdata.stim.width     = width;
cornersdata.stim.size      = size;
cornersdata.stim.depth     = depth;

cornersdata.stim.peak_lum  = peak_lum;
cornersdata.stim.edge_lum  = edge_lum;

% grid of fixation crosses
% ------------------------
cornersdata.fix.time       = stim_time;     % for fixtime, cross stay time
cornersdata.fix.angle      = fix_angle;     % rotational angle of grid, relative to grid center
cornersdata.fix.color.red  = fix_red;
cornersdata.fix.color.green = fix_green;
cornersdata.fix.color.blue  = fix_blue;
cornersdata.fix.grid.center.x = grid_center_x;  % screen image coordinates (pixels)
cornersdata.fix.grid.center.y = grid_center_y;
cornersdata.fix.grid.sizx  = grid_size_x;
cornersdata.fix.grid.sizy  = grid_size_y;
cornersdata.fix.grid.number = grid_number;
cornersdata.fix.grid.X     = fix_grid.X;
cornersdata.fix.grid.Y     = fix_grid.Y;
cornersdata.fix.grid.sines = fix_grid.sines;
cornersdata.fix.grid.cosines = fix_grid.cosines;
cornersdata.fix.grid.hyp   = fix_grid.hyp;

this.Stimulus.data = cornersdata;

end % function parseCorners

% =========================================================================
% subroutines
% =========================================================================
function fix_grid = calFixGrid(size_x,size_y,center_x,center_y,spread_size,fix_angle)
%   Returns a matrix of fixation point positions based on gridsizex,
%   gridsizey, gridcenterx, gridcentery, and fixangle
% 
% adapted from Calculate_Fixation_Grid

grid_theta = fix_angle*pi/180;      % convert to arc

% first, make a grid with the right dimensions and proportions (centered around, (0,0))
[grid_x,grid_y] = meshgrid(linspace(-size_x/2,size_x/2,size_x),...
    linspace(-size_y/2,size_y/2,size_y));

% second, calculate the correct hypotenuses with the given spreadsize
hyp = sqrt(((grid_x * spread_size).^2)+((grid_y * spread_size).^2));

% third, calculate the sines and cosines for each point
sines   = sin(grid_theta + atan2(grid_x, grid_y));
cosines = cos(grid_theta + atan2(grid_x, grid_y));

% fourth, calculate position and translate
X = center_x + (hyp.*sines);
Y = center_y + (hyp.*cosines);

% outputs
fix_grid.X = X;     % x,y positions of crosses
fix_grid.Y = Y;

fix_grid.sines = sines;
fix_grid.cosines = cosines;

fix_grid.hyp = hyp;

end%function

% [EOF]
