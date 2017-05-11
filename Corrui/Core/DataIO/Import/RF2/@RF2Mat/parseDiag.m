function diagdata = parseDiag(RM,diag)
% PARSEDIAG extracts information from DIAG single chunk
% 
% Syntax:
%   diagdata = parseDiag(diag)
% 
% Input(s):
%   diag        - DIAG chunk (see chunk structure in readrf2chunks.m)
%                 .position     : postion of this chunk in raw RF data
%                 .type         : DIAG
%                 .length       : length of this chunk (bytes/uint8)
%                 .data         : data in this chunk (must be uint8)
%
% Output(s):
%   diagdata    - Parsed DIAG data structure
%                 .gaze         : information on gaze
%                       .box    : size of the gaze box (?)
%                       .time   : required gaze duration (ms ?)
%                 .stim         : information on stimulus
% 
%                 (......)
% 
% Remarks:
%   The structure of DIAG chunk:
%       OxFF            (1st Byte)
%       type            (2nd byte)
%       chunk length    (3-4 bytes)
%       data            (from 5th bytes)
% 
%   The structure of 'data' in DIAG:
%       gaze box        size of the gaze box (1-2 bytes)
%       (......)
% 
% Example:
% 
% 
% See also readrf2chunks, parseSpikeAndEye.

% Copyright 2009-2010 Richard J. Cui. Created: 12/13/2009  7:17:03.195 PM
% $Revision: 0.2 $  $Date: 02/25/2010  9:59:23.918 PM $
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
gamma   = RM.ParaDisp.Gamma;    % harvard.gamma, see rf2analysis.m
% gamma        = 2.171;       % harvard.gamma, see rf2analysis.m

% =========================================================================
% Main
% =========================================================================
% ---------------
% check validity
% ---------------
chunk_type = diag.type;

if ~strcmpi(chunk_type,'DIAG')
    error('Not a %s chunk!','DIAG')
end%if

% ---------------
% parse
% ---------------
data = diag.data;    % data in this chunk without the 4-byte head
% 1. gaze box
gaze_box        = double(typecast(data(1:2),'uint16'));     % gazebox
% 2. stimulus
stim_size       = double(typecast(data(3:4),'uint16'));     % stimsize
spread_size     = double(typecast(data(5:6),'uint16'));     % spreadsize
angle           = double(typecast(data(7:8),'uint16'));     % dangle - 'd' stands for 'diag'
angle_spread    = double(typecast(data(9:10),'uint16'));    % danspread
distance        = double(typecast(data(11:12),'uint16'));   % ddistance

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

dupper_x        = double(typecast(data(25:26),'int16'));    % dupperx (?)
dupper_y        = double(typecast(data(27:28),'int16'));    % duppery (?)

% 3. fix grid
stim_time       = double(typecast(data(29:30),'uint16'));   % * stimtime (fixation time?)
gaze_time       = double(typecast(data(31:32),'uint16'));   % gazetime(?)
grid_center_x   = double(typecast(data(33:34),'uint16'));   % gridcenterx
grid_center_y   = double(typecast(data(35:36),'uint16'));   % grid_center_x

fix_red         = double(typecast(data(37:38),'uint16'));   % ? fixation cross color
fix_green       = double(typecast(data(39:40),'uint16'));
fix_blue        = double(typecast(data(41:42),'uint16'));

user_gamma      = double(typecast(data(43:44),'uint16'));   % ?
vertices        = double(typecast(data(45:46),'uint16'));   % dvertices (number of vertices)
inner_rad       = double(typecast(data(47:48),'uint16'));   % dinner_radius
grid_size_x     = double(typecast(data(49:50),'uint16'));   % gridsizex (number of crosses along x-axis)
grid_size_y     = double(typecast(data(51:52),'uint16'));   % gridsizey (number of corsses along y-axis)
fix_angle       = double(typecast(data(53:54),'uint16'));   % fixangle (in deg) (?)

peak_lum        = RM.PercentLuminanceFromGun(peak_color,user_gamma,gamma);
edge_lum        = RM.PercentLuminanceFromGun(edge_color,user_gamma,gamma);

grid_number     = grid_size_x*grid_size_y;          % total num of crosses
fix_grid        = calFixGrid(grid_size_x,grid_size_y,...
    grid_center_x,grid_center_y,spread_size,fix_angle);

% ---------------
% output
% ---------------
diagdata.gaze.box       = gaze_box;
diagdata.gaze.time      = gaze_time;

diagdata.stim.size      = stim_size;
diagdata.stim.spread    = spread_size;
diagdata.stim.angle     = angle;
diagdata.stim.angle_spread = angle_spread;
diagdata.stim.distance  = distance;
diagdata.stim.forecolor.red     = forecolor_red;
diagdata.stim.forecolor.green   = forecolor_green;
diagdata.stim.forecolor.blue    = forecolor_blue;
diagdata.stim.backcolor.red     = backcolor_red;
diagdata.stim.backcolor.green   = backcolor_green;
diagdata.stim.backcolor.blue    = backcolor_blue;
diagdata.stim.grades    = grades;
diagdata.stim.peakcolor = peak_color;
diagdata.stim.edgecolor = edge_color;
diagdata.stim.upperx    = dupper_x;
diagdata.stim.uppery    = dupper_y;
diagdata.stim.user_gamma = user_gamma;
diagdata.stim.vertices  = vertices;
diagdata.stim.inner_rad = inner_rad;
diagdata.stim.peak_lum  = peak_lum;
diagdata.stim.edge_lum  = edge_lum;

diagdata.fix.time       = stim_time;    % ******
diagdata.fix.angle      = fix_angle;
diagdata.fix.color.red  = fix_red;
diagdata.fix.color.green = fix_green;
diagdata.fix.color.blue  = fix_blue;
diagdata.fix.grid.center.x = grid_center_x;
diagdata.fix.grid.center.y = grid_center_y;
diagdata.fix.grid.sizx  = grid_size_x;
diagdata.fix.grid.sizy  = grid_size_y;
diagdata.fix.grid.number = grid_number;
diagdata.fix.grid.X     = fix_grid.X;
diagdata.fix.grid.Y     = fix_grid.Y;
diagdata.fix.grid.sines = fix_grid.sines;
diagdata.fix.grid.cosines = fix_grid.cosines;
diagdata.fix.grid.hyp   = fix_grid.hyp;

% RM.DiagData = diagdata;
RM.Stimulus.data = diagdata;

end%function

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