function [polygon_matrix, clipped_polygon] = draw_poly_24(matrix_vertices, polygon_vertices, clr)
% [polygon_matrix, clipped_polygon] = draw_poly_24(matrix_vertices, polygon_vertices, clr)
%
%  receives matrix_vertices and polygon vertices, which are structs with x
%  and y members (vectors of x Y y positions), and generates a sparse 
%  matrix, polygon_matrix, with each
%  pixel value of the sparse matrix being equal to clr (a [r g b] vector)
%  if vertices are outside the matrix, they will be clipped appropriately
%  input polygon must have at least three sides
%
%   polygon_matrix   = 8- or 24-bit (m by n by 1 or 3) array of points making up the edges of
%                       the clipped polgon
%   clipped_polygon  = clipped polygon edge list:
%                       clipped_polygon{a}{b}.x&y
%                       where a = num polygons and
%                             b = num sides/polgon
%   polygon_vertices = struct with x and y members that contain the positions
%                        of each polygon vertex
%   matrix_vertices  = struct with x and y members that contain the positions
%                        of each output matrix's vertices
%   clr              = either an [r g b] or [0-1] vector describing the color of each
%                        output point
%
%
%    (c)2004 Stephen L. Macknik, All Rights Reserved

% make sure that vertices are round numbers
matrix_vertices.x = round(matrix_vertices.x);
matrix_vertices.y = round(matrix_vertices.y);
polygon_vertices.x = round(polygon_vertices.x);
polygon_vertices.y = round(polygon_vertices.y);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%      make sure that polygon has at least three sides
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_points = length(polygon_vertices.x);
if num_points < 3
    error_handle = errordlg('polygon must have at least three sides','invalid polygon');
    pause(0.1);
    return;
end            
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%             Check that inputs are valid
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(matrix_vertices)
    extent_y = (max(matrix_vertices.y) - min(matrix_vertices.y)) + 1;
    extent_x = (max(matrix_vertices.x) - min(matrix_vertices.x)) + 1;
else    
    error_handle = errordlg('matrix_vertices are invalid','Bad matrix');
    pause(0.1);
    return;
end            

if (length(clr) ~= 3) & (length(clr) ~= 1)
    %not an 8 or 24 bit matrix, so error
    error_handle = errordlg('clr is invalid','Bad color');
    pause(0.1);
    return;
end            

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  get the pixels for each side of the polygon and matrix
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

polygon_sides = get_polygon_sides(polygon_vertices);
matrix_sides  = get_polygon_sides(matrix_vertices);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  clip polygon
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clipped_polygon_vertices_vect = polyclip([polygon_vertices.x' polygon_vertices.y'], [matrix_vertices.x' matrix_vertices.y']);

if(~isempty(clipped_polygon_vertices_vect))
    clipped_polygon_vertices.x = round(clipped_polygon_vertices_vect(:,1));
    clipped_polygon_vertices.y = round(clipped_polygon_vertices_vect(:,2));
    clipped_polygon{1} = get_polygon_sides(clipped_polygon_vertices); % because we are using the Sutherland algorithm
                                                                      % to clip the output will always be only                                                                 % cli
                                                                      % one polygon                                                                      % 
else
   clipped_polygon{1} = [];
   clipped_polygon{1} = [];
end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  convert clipped_polygon to sparse matrix with each
%%%%%%%%%%%%%%%%%%%  pixel == clr
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%now draw the pixels!
polygon_matrix = zeros(extent_y, extent_x, length(clr));

if(~isempty(clipped_polygon{1}))
    [garbage, num_clipped_polygons] = size(clipped_polygon);
    
    for m=1:num_clipped_polygons,
        [garbage, num_sides] = size(clipped_polygon{m});    
        for n=1:num_sides,  
            for p=1:length(clipped_polygon{m}{n}.y) % one for each pixel
                polygon_matrix(clipped_polygon{m}{n}.y(p), clipped_polygon{m}{n}.x(p), 1:length(clr)) = clr;
            end    
        end
    end    
end
