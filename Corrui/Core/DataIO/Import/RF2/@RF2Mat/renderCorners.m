function [corners_image,poly_vert] = renderCorners(this,cornersdata)
% RENDERCORNERS renders the image of the corners
%
% Syntax:
%   corners_image = renderCorners(this,cornersdata)
%
% Input(s):
%   this        - object class
%   cornersdata - data structure in CORNERS chunk (see parseCorners.m)
%
% Output(s):
%   corners_image   - image of the corners
%   poly_vert   - vertices of polygons
%
% Remarks:
%   Adapted from 'renderstimulus.m' from rf2analysis.m
%
% Example:
%
% See also parseCorners, getFixGrid.

% Copyright 2010 Richard J. Cui. Created: 03/08/2010  2:36:06.733 PM
% $Revision: 0.2 $  $Date: Fri 04/23/2010  2:54:55 PM $
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
% display paras
hor_width   = this.ParaDisp.HorWidth;
ver_width   = this.ParaDisp.VerWidth;
halfx = hor_width/2;
halfy = ver_width/2;
gamma   = this.ParaDisp.Gamma;    % harvard.gamma, see rf2analysis.m
image_vertices.x = [1 hor_width hor_width 1];
image_vertices.y = [1 1 ver_width ver_width];
% stimulus paras
angle       = cornersdata.stim.angle;
anspread    = cornersdata.stim.angle_spread;
backcolor   = cornersdata.stim.backcolor;
depth       = cornersdata.stim.depth;
distance    = cornersdata.stim.distance;
edgelum     = cornersdata.stim.edge_lum;
fadedist    = cornersdata.stim.fadedist;
grades      = cornersdata.stim.grades;
peaklum     = cornersdata.stim.peak_lum;
size        = cornersdata.stim.size;
usergamma   = cornersdata.stim.user_gamma;
upperx      = cornersdata.stim.upperx;
uppery      = cornersdata.stim.uppery;
width       = cornersdata.stim.width;

%convert 0 to north, 90 to east
% ang = -cangle + 45;
% ang = -angle; % under test!! use + or - cangle matters for X (xgt oct'05)
ang = 360+angle;
if ang > 360
    ang = ang - 360;
end

colorrange  = peaklum-edgelum;
radius      = anspread/2;

% =========================================================================
% main body
% =========================================================================
% cal paras
if (grades - 1) > 0
    spreadstep = fadedist/(grades-1);
    percent_lum_change_per_grade = colorrange/ (grades-1);
end

% initialize the stimulus image 
stimulus = zeros(ver_width, hor_width);
% stimulus = stimulus + round(this.PercentLuminanceFromGun(backcolor.red, ...
%     usergamma, gamma)); %grayscale stim, so red=green=blue
if colorrange >= 0 % intensifying, set their value to the value of backcolor
    stimulus = stimulus+round(this.PercentLuminanceFromGun(backcolor.red, ...
        usergamma, gamma)); %grayscale stim, so red=green=blue
else
    stimulus = stimulus+round(this.PercentLuminanceFromGun(edgelum, ...
        usergamma, gamma)); %grayscale stim, so red=green=blue
end % if

dang = ang * pi /180;   % in Rad
sina = sin(dang);
cosa = cos(dang);

if (radius ~= 0 || width ~= 0)
    internalthetaleft  = atan2(-radius, width) + dang;
    internalthetaright = atan2( radius, width) + dang;
    farsinaleft  = sin(internalthetaleft);
    farcosaleft  = cos(internalthetaleft);
    farsinaright = sin(internalthetaright);
    farcosaright = cos(internalthetaright);
    halfhyp = sqrt(width^2 + radius^2);
else
    return
end

if (size ~= 0 || depth ~= 0)
    cornerthetaleft  = atan2(-((distance/2.0)+(size/2.0)), depth) + dang;
    cornerthetaright = atan2( ((distance/2.0)+(size/2.0)),-depth) + dang;
    cornersinaleft  = sin(cornerthetaleft);
    cornercosaleft  = cos(cornerthetaleft);
    cornersinaright = sin(cornerthetaright);
    cornercosaright = cos(cornerthetaright);
    cornerhyp = sqrt(depth^2 + ((distance/2.0)+(size/2.0))^2);
else
    return
end

poly_vert = [];
wh = waitbar(0,'Rendering CORNERS stimulus. Please wait...');
for n = 1:grades
    waitbar((n+1)/grades);
    % drawnow;
    %determine centerpoint
    spr     = spreadstep * n;
    hsc     = spr * cosa;
    hss     = spr * sina;
    % add halfx and halfy like in freebar - xgt oct'05
    centerx = halfx + upperx + (hss+0.5);
    centery = halfy - uppery - (hsc+0.5);
    
    leftx   = centerx - ((radius * cosa)+0.5);
    lefty   = centery - ((radius * sina)+0.5);
    rightx  = centerx + ((radius * cosa)+0.5);
    righty  = centery + ((radius * sina)+0.5);
    
    farcornerleftx   = centerx + ((halfhyp *  farsinaleft)-0.5);
    farcornerlefty   = centery - ((halfhyp *  farcosaleft)+0.5);
    farcornerrightx  = centerx + ((halfhyp *  farsinaright)+0.5);
    farcornerrighty  = centery - ((halfhyp *  farcosaright)+0.5);
    
    cornerinnerleftx  = centerx - ((( distance/2.0)        * cosa)+0.5);
    cornerinnerlefty  = centery - ((( distance/2.0)        * sina)+0.5);
    cornerouterleftx  = centerx - ((((distance/2.0)+size) * cosa)+0.5);
    cornerouterlefty  = centery - ((((distance/2.0)+size) * sina)+0.5);
    cornerinnerrightx = centerx + ((( distance/2.0)        * cosa)+0.5);
    cornerinnerrighty = centery + ((( distance/2.0)        * sina)+0.5);
    cornerouterrightx = centerx + ((((distance/2.0)+size) * cosa)+0.5);
    cornerouterrighty = centery + ((((distance/2.0)+size) * sina)+0.5);
    
    cornerpointleftx   = centerx + ((cornerhyp *  cornersinaleft)-0.5);
    cornerpointlefty   = centery - ((cornerhyp *  cornercosaleft)+0.5);
    cornerpointrightx  = centerx + ((cornerhyp *  cornersinaright)+0.5);
    cornerpointrighty  = centery - ((cornerhyp *  cornercosaright)+0.5);
    
    polygon_vertices.x(1)  = centerx;
    polygon_vertices.y(1)  = ver_width-centery; % 480 - centery;
    polygon_vertices.x(2)  = cornerinnerleftx;
    polygon_vertices.y(2)  = ver_width-cornerinnerlefty;    % 480 - cornerinnerlefty;
    polygon_vertices.x(3)  = cornerpointleftx;
    polygon_vertices.y(3)  = ver_width - cornerpointlefty;  % 480 - cornerpointlefty;
    polygon_vertices.x(4)  = cornerouterleftx;
    polygon_vertices.y(4)  = ver_width - cornerouterlefty;  % 480 - cornerouterlefty;
    polygon_vertices.x(5)  = leftx;
    polygon_vertices.y(5)  = ver_width - lefty; % 480 - lefty;
    polygon_vertices.x(6)  = farcornerleftx;
    polygon_vertices.y(6)  = ver_width - farcornerlefty;
    polygon_vertices.x(7)  = farcornerrightx;
    polygon_vertices.y(7)  = ver_width - farcornerrighty;
    polygon_vertices.x(8)  = rightx;
    polygon_vertices.y(8)  = ver_width - righty;
    polygon_vertices.x(9)  = cornerouterrightx;
    polygon_vertices.y(9)  = ver_width - cornerouterrighty;
    polygon_vertices.x(10) = cornerpointrightx;
    polygon_vertices.y(10) = ver_width - cornerpointrighty;
    polygon_vertices.x(11) = cornerinnerrightx;
    polygon_vertices.y(11) = ver_width - cornerinnerrighty;
    
    poly_vert = cat(1,poly_vert,polygon_vertices);
    
    %check to make sure that polygon is bigger than single pixel
    if any(polygon_vertices.x - polygon_vertices.x(1)) || any(polygon_vertices.y - polygon_vertices.y(1))
        new_polygon = fill_poly_24(image_vertices, polygon_vertices, (edgelum + (percent_lum_change_per_grade * (n-1))));
        new_pixels = find(new_polygon > 0);
        stimulus(new_pixels) = new_polygon(new_pixels);
    end
        
end
close(wh)

% check edge and peak luminance for poly_vert
% -------------------------------------------
if peaklum < edgelum
    poly_vert = turnVert(poly_vert);
end % if

corners_image = stimulus;

end % function renderCorners

% [EOF]
