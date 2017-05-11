function star_image = renderDiag(RM,diagdata)
% RENDERDIAG renders the image of star
%
% Syntax
%   star_image = renderDiag(RM,diagdata)
%
% Input(s):
%   RM          - object of RF2Mat class
%   diagdata    - data structure in DIAG chunk
%
% Output(s):
%   star_image  - image of the star stimulus
%
% Remarks:
%   Adapted from 'renderstimulus.m' from rf2analysis.m
%
% Example:
%
% See also parseDiag, getFixGrid.

% Copyright 2010 Richard J. Cui. Created: 02/26/2010 10:35:10.621 AM
% $Revision: 0.1 $  $Date: 02/26/2010 10:35:10.652 AM $
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
hor_width   = RM.ParaDisp.HorWidth;
ver_width   = RM.ParaDisp.VerWidth;
gamma   = RM.ParaDisp.Gamma;    % harvard.gamma, see rf2analysis.m
image_vertices.x = [1 hor_width hor_width 1];
image_vertices.y = [1 1 ver_width ver_width];
% stimulus paras
backcolor   = diagdata.stim.backcolor;
danspread   = diagdata.stim.angle_spread;
dangle      = diagdata.stim.angle;
dinner_radius   = diagdata.stim.inner_rad;
dupperx     = diagdata.stim.upperx;
duppery     = diagdata.stim.uppery;
dvertices   = diagdata.stim.vertices;
edgelum     = diagdata.stim.edge_lum;
grades      = diagdata.stim.grades;
peaklum     = diagdata.stim.peak_lum;
usergamma   = diagdata.stim.user_gamma;
colorrange  = peaklum-edgelum;
radius      = danspread/2;

% =========================================================================
% main body
% =========================================================================
%initialize the stimulus image and set their value to the value of backcolor
stimulus = zeros(ver_width, hor_width);
stimulus = stimulus + round(PercentLuminanceFromGun(backcolor.red, ...
    usergamma, gamma)); %grayscale stim, so red=green=blue

% cal paras
if (grades - 1) > 0
    spreadstep = radius/grades;
    innerspreadstep = dinner_radius/grades;
    percent_lum_change_per_grade = colorrange/ (grades-1);
end

%convert 0 to north, 90 to east
%ang = -dangle + 45;
ang = -dangle;
if ang > 360
    ang = ang - 360;
end
ang = 360-ang;

wh = waitbar(0,'Rendering DIAG (Star) stimulus. Please wait...');
for n = 1:grades
    waitbar(n/grades);
    spr = radius - spreadstep*n; 
    innerspr = dinner_radius - (innerspreadstep *n);
    
    x = zeros(1,dvertices);
    y = zeros(1,dvertices);
    for o = 1:dvertices
        dang = ((ang - (360 - (360 * ((o-1)/dvertices) + 45))) * pi) / 180;
        sina = sin(dang);
        cosa = cos(dang);
        
        if o && mod(o,2)  %* if o is odd
            hsc = spr * cosa;
            hss = spr * sina;
        else    %if 0 is even
            hsc = innerspr * cosa;
            hss = innerspr * sina;
        end
        
        %a potential X/Y reversal!!!
        % polygon_vertices{n}.x(o) = round(hss); %these are the vertices
        % polygon_vertices{n}.y(o) = -round(hsc);
        x(o) = round(hss);
        y(o) = -round(hsc);
    end
    %     polygon_vertices{n}.x = x;
    %     polygon_vertices{n}.y = y;
    polygon_vertices_n.x = x;
    polygon_vertices_n.y = y;
    
    if n == 1 % the bottom polygon is the biggest, so get its dimensions
                % find the points starting with the first corner
                %                 dsmallx = polygon_vertices{n}.x(1);
                %                 dsmally = polygon_vertices{n}.y(1);
                %                 dbigx   = polygon_vertices{n}.x(1);
                %                 dbigy   = polygon_vertices{n}.y(1);
                %
                %                 for o=2:dvertices,
                %                     if(polygon_vertices{n}.x(o) < dsmallx)
                %                         dsmallx = polygon_vertices{n}.x(o);
                %                     end
                %                     if(polygon_vertices{n}.y(o) < dsmally)
                %                         dsmally = polygon_vertices{n}.y(o);
                %                     end
                %                     if(polygon_vertices{n}.x(o) > dbigx)
                %                         dbigx = polygon_vertices{n}.x(o);
                %                     end
                %                     if(polygon_vertices{n}.y(o) > dbigy)
                %                         dbigy = polygon_vertices{n}.y(o);
                %                     end
                %                 end
                % pv_x = polygon_vertices{n}.x;
                % pv_y = polygon_vertices{n}.y;
                pv_x = polygon_vertices_n.x;
                pv_y = polygon_vertices_n.y;
                dsmallx = min(pv_x);
                % dbigx = max(pv_x);
                dsmally = min(pv_y);
                % dbigy = max(pv_y);
    end
    
    %now translate vertices to correct position on screen
    %     polygon_vertices{n}.x = polygon_vertices{n}.x + abs(dsmallx) + dupperx;
    %     polygon_vertices{n}.y = 480-(polygon_vertices{n}.y + abs(dsmally) + duppery);
    polygon_vertices_n.x = polygon_vertices_n.x+ abs(dsmallx) + dupperx;
    polygon_vertices_n.y = ver_width - (polygon_vertices_n.y + abs(dsmally) + duppery);
    
    %check to make sure that polygon is bigger than single pixel
    %     if any(polygon_vertices{n}.x - polygon_vertices{n}.x(1)) || any(polygon_vertices{n}.y - polygon_vertices{n}.y(1))
    if any(polygon_vertices_n.x - polygon_vertices_n.x(1)) || any(polygon_vertices_n.y - polygon_vertices_n.y(1))
        % new_polygon = fill_poly_24(layer_vertices, polygon_vertices{n}, (edgelum + (percent_lum_change_per_grade * (n-1))));
        new_polygon = fill_poly_24(image_vertices, polygon_vertices_n, ...
            (edgelum + (percent_lum_change_per_grade * (n-1))));

        new_pixels = find(new_polygon > 0);
        stimulus(new_pixels) = new_polygon(new_pixels);
    end
end
close(wh)

star_image = stimulus;

end % function renderDiag

% [EOF]
