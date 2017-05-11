function [grid,corner] = getFixGrid(this)
% FINDGRID gets the positions of grid of crosses from the dataset
% 
% Syntax:
%   grid = findGrid(this)
% 
% Input(s):
%   this          - RF2Mat class
% 
% Outout(s):
%   grid        - N x 2 array = [g_x,g_y] in arcmin
%   corner      - four corner coordinates, 4 x 2 array
%                 = [upper_left_x,upper_lefter_y;
%                    upper_right_x,upper_right_y;
%                    lower_right_x,lower_right_y;
%                    lower_left_x,lower_lefter_y]
% 
% Example:
% 
% See also readrf2chunks, parseDiag, parseCorners.

% Copyright 2010-2011 Richard J. Cui. Created: 01/28/2010 10:19:13.608 PM
% $Revision: 0.8 $  $Date: Thu 07/07/2011  5:14:39 PM $
% 
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
% 
% Email: jie@neurocorrleate.com

% =========================================================================
% Look for the chunk of stimulus type
% =========================================================================
stim_type = this.Stimulus.type;

chunks = this.chunks;
nChunks = length(chunks);

k = 1;
type = chunks(k).type;

while ~strcmpi(type,stim_type) && k <= nChunks
    type = chunks(k).type;
    k = k+1;
end%while

% if there is no grid info
if k > nChunks
    grid = 0;
    corner = 0;
    return
end % if

% =========================================================================
% Extract grid info
% =========================================================================
chunk = chunks(k);

switch upper(stim_type)
    case 'DIAG'
        data = this.parseDiag(chunk);
    case 'CORNERS'
        data = this.parseCorners(chunk);
    otherwise
        error('Unknown stimulus type %s.\n',stim_type)
end % switch

gx = data.fix.grid.X(:);
gy = data.fix.grid.Y(:);

% =========================================================================
% find the corner of the grid
% =========================================================================
min_x = min(gx);
max_x = max(gx);

min_y = min(gy);
max_y = max(gy);

corner = [min_x,max_y;
          max_x,max_y;
          min_x,min_y;
          max_x,min_y];

% =========================================================================
% Rotation of the grid
% =========================================================================
% rotation matrix
R = @(alpha) [cos(alpha),sin(alpha);-sin(alpha),cos(alpha)];

% the grid
grid = [gx,gy];

% grid center
cx = data.fix.grid.center.x;  % in pix
cy = data.fix.grid.center.y;  % in pix
gridc = [cx,cy];

angle = data.stim.angle;
% angle = data.fix.angle;   % always zero, doesn't make sense

% correct some errors in some sessions
fname = this.FileName;
switch fname
    case '051600J1.RF'
        angle = 90+angle;
end % swithc

switch angle
%     case 0
        
    case 90
        cor = corner;
        grid_pix = grid;
    case 180
        cor = corner;
        grid_pix = grid;
        
    case 270
        
    case -90
        cor = corner;
        grid_pix = grid;
        
    case -180
        cor = corner;
        grid_pix = grid;
        
    case -270
        
    otherwise
        % rotational matrix
        alpha = -angle * pi/180;
        
        % rotate grid matrix
        % ----------------------
        % transfer to grid coordinate
        ng = size(grid,1);
        g_gc = grid-gridc(ones(ng,1),:);
        % rotation wrt. center
        rg = g_gc*R(alpha);
        
        % transfer back to image coordinage
        grid_pix = rg+gridc(ones(ng,1),:);
        
        % rotate grid corners
        % -------------------
        ncor = size(corner,1);
        cor_cc = corner-gridc(ones(ncor,1),:);
        rc = cor_cc*R(alpha);
        cor = rc+gridc(ones(ncor,1),:);
        
end % switch

% =========================================================================
% convert to arcmin
% =========================================================================
%   B           - convert pixels --> arcmin
%                 B(1) = x-axis factor
%                 B(2) = y-axis factor
% para = this.ParaDisp;
% a = para.HorAngle;
% b = para.VerAngle;
% c = para.HorWidth;
% d = para.VerWidth;
% B = [a/c,b/d]*60;
% grid = [B(1),0; 0,B(2)]*[gx,gy]'; 
% grid = grid';

grid = this.ABSPix2Arcmin(grid_pix);    % --> arcmin
corner = this.ABSPix2Arcmin(cor);

% =========================================================================
% output
% =========================================================================
this.FixGrid = grid;
this.FixCorner = corner;

end%function

% [EOF]