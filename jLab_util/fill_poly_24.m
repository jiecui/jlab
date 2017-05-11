function polygon_matrix = fill_poly_24(matrix_vertices, polygon_vertices, clr)
% polygon_matrix = fill_poly_24(matrix_vertices, polygon_vertices, clr)
%
%  receives matrix_vertices and polygon vertices, which are structs with x
%  and y members (vectors of x & y positions), and generates a sparse 
%  matrix, polygon matrix, with each
%  pixel value of the sparse matrix being equal to clr (a [r g b] or [0-1] vector)
%  if vertices are outside the matrix, they will be clipped appropriately
%  input polygon must have at least three sides
%
%   polygon_matrix   = 8 or 24-bit (m by n by 1 or 3) array of points making up the edges of
%                       the clipped polgon
%   polygon_vertices = struct with x and y members that contain the positions
%                        of each polygon vertex
%   matrix_vertices  = struct with x and y members that contain the positions
%                        of each output matrix's vertices
%   clr              = an [r g b] or [0-1] vector describing the color of each
%                        output point
% 
% Remarks by Jie Cui @ Sun 04/25/2010  2:37:46 PM
% ******
% ****** Outline of Scan-Conversion (scanline) Polygon Filling Algorithm
% ******
% Note: this algorithm has best performance for simple polygons (perhaps,
% edge numbers < 1000). Make sure that the input vertices are valid for a
% polygon
% 
% 1. draw the perimeter of the polygon
% 2. establish the edge table (ET) of the polygon
% 3. scan from the line of y_min to the line of y_max
% 4. at each scan line, creat active edge table (AET)
% 5. find the intersection points of the edges
% 6. check, if the intersection point is the end point of an edge (i.e.
%    y_scanlin = y_max of the edge), eliminate it from the list
% 7. sort the x-coordinates of intersection points from small to large
%    (i.e. x0 <= x1 <= x2,..., <= xn)
% 8. fill pixels between pairs of points (i.e. between (x0,x1),
%    (x2,x3),...,(xn-1,xn))
% END

% Fix some bugs of (c)2004 Stephen L. Macknik, All Rights Reserved
% 
% Copyright 2010 Richard J. Cui. Created: Sun 04/25/2010  1:03:10 PM
% $Revision: 0.2 $  $Date: Sun Tue 05/04/2010 12:07 38 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

%first, let draw_poly_24 draw the frame and create the edges
[polygon_matrix, clipped_polygon] = draw_poly_24(matrix_vertices, polygon_vertices, clr);

for m=1:length(clipped_polygon),
    num_points = 0;
    if (~isempty(clipped_polygon{m})) % in case there is no polygon after clipping
        %find the vertices of the polygon
        num_vert = length(clipped_polygon{m});  % number of vertices
        x_vertices = zeros(1,num_vert);
        y_vertices = zeros(1,num_vert);
        for n = 1:num_vert
            x_vertices(n) = clipped_polygon{m}{n}.x(1);
            y_vertices(n) = clipped_polygon{m}{n}.y(1);
            num_points = num_points + 1;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%  now make an edge list for the scan-conversion fill
        %%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % first describe every non-horizontal side
        horiz_edges=[];
        % num_horiz_edges = 0;
        edge = struct('ymin',[],'ymax',[],'x_ymin',[],'x_ymax',[],...
            'inverse_slope',[]);
        for n=1:num_points,
            % determine ymax and ymin, corresponding x locations, and slopes
            if n < num_points
                if y_vertices(n) < y_vertices(n+1)
                    edge(n).ymin   = y_vertices(n); edge(n).ymax   = y_vertices(n+1);
                    edge(n).x_ymin = x_vertices(n); edge(n).x_ymax = x_vertices(n+1);
                else    
                    edge(n).ymin   = y_vertices(n+1); edge(n).ymax   = y_vertices(n);
                    edge(n).x_ymin = x_vertices(n+1); edge(n).x_ymax = x_vertices(n);
                end
            else    
                if y_vertices(n) < y_vertices(1)
                    edge(n).ymin   = y_vertices(n); edge(n).ymax   = y_vertices(1);
                    edge(n).x_ymin = x_vertices(n); edge(n).x_ymax = x_vertices(1);
                else    
                    edge(n).ymin   = y_vertices(1); edge(n).ymax   = y_vertices(n);
                    edge(n).x_ymin = x_vertices(1); edge(n).x_ymax = x_vertices(n);
                end
            end
            if edge(n).ymax ~= edge(n).ymin
                edge(n).inverse_slope = (edge(n).x_ymax-edge(n).x_ymin)/(edge(n).ymax-edge(n).ymin);
            else %its a horizontal edge
                % num_horiz_edges = num_horiz_edges + 1;
                % horiz_edges(num_horiz_edges) = n;
                horiz_edges = cat(2,horiz_edges,n);
            end    
        end
        
        %now remove horizontal edges
        if ~isempty(horiz_edges)
            edge(horiz_edges) = [];
        end
        
        %now construct edge_list by row (cell number)
        % [ymins, edges] = sort([edge.ymin]);
        ymins = sort([edge.ymin]);
        edge_bottoms = unique(ymins);
        edge_list = struct('edges',[],'ymin',[]);
        for n=1:length(edge_bottoms),
            edge_list(n).edges = find([edge.ymin] == edge_bottoms(n));
            edge_list(n).ymin  = edge_bottoms(n);
        end    
        
        %now find top of edge_list
        edge_top = max([edge.ymax]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%  now fill polygon
        %%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        active_edges = [];
        % remove_from_active = [];
        end_of_edge = [];
        
        if ~isempty(edge_bottoms)
            for n=edge_bottoms(1):edge_top,
                %first, remove edges which are no longer active
                if ~isempty(active_edges)
                    remove_from_active = [];
                    end_of_edge = [];
                    for p=1:length(active_edges),
                        if n > edge(active_edges(p)).ymax
                            % remove_from_active = [remove_from_active p];
                            remove_from_active = cat(2,remove_from_active, p);
                        elseif n == edge(active_edges(p)).ymax
                            end_of_edge = cat(2,end_of_edge, active_edges(p));
                        end
                    end
                    active_edges(remove_from_active) = [];
                end
                
                %second, add edges which have now become active
                active_edges = [active_edges edge_list(find([edge_list.ymin] == n)).edges];
                
                %third, update x value for each edge
                if ~isempty(active_edges)
                    num_active_edges = length(active_edges);
                    for p=1:num_active_edges,
                        if ~isfield(edge(active_edges(p)),'current_x') || isempty(edge(active_edges(p)).current_x)
                            edge(active_edges(p)).current_x=edge(active_edges(p)).x_ymin;
                        else
                            edge(active_edges(p)).current_x=edge(active_edges(p)).current_x + edge(active_edges(p)).inverse_slope;
                        end
                    end
                    
                    %fourth, sort x positions of edges
                    [current_xs, edges] = sort([edge(active_edges).current_x]);
                    
                    %fifth, remove any doubly represented vertices (remarked by
                    %       Jie: not good, if the end point of an edge and the
                    %       beginning point of another edge is connected by a
                    %       horizontal line)
                    
                    %                 if ~isempty(end_of_edge)
                    %                     beginning_of_edges = find([edge(active_edges).ymin] == n);
                    %                     if ~isempty(beginning_of_edges)
                    %                         bad_edges = [];
                    %                         for r=1:length(end_of_edge),
                    %                             double_vertex = [];
                    %                             double_vertex = find([edge(active_edges(beginning_of_edges)).x_ymin] == edge(end_of_edge(r)).x_ymax);
                    %                             if ~isempty(double_vertex)
                    %                                 bad_edges = [bad_edges find(active_edges(edges) == end_of_edge(r))];
                    %                             end
                    %                         end
                    %                         if ~isempty(bad_edges)
                    %                             current_xs(bad_edges) = [];
                    %                         end
                    %                     end
                    %                 end
                    
                    % -- J. Cui @ Tue 05/04/2010 12:14 44 AM
                    % 5th remove the intersection points that are the end
                    %     points of eddges. Note that the algorithm must draw
                    %     the perimeter of the polygon beforehand (e.g. using
                    %     draw_poly_24.m)
                    if ~isempty(end_of_edge)
                        end_edges = [];
                        for r = 1:length(end_of_edge)
                            end_edges_r = find(active_edges(edges) == end_of_edge(r));
                            end_edges = cat(2,end_edges, end_edges_r);
                        end % for
                        if ~isempty(end_edges)
                            current_xs(end_edges) = [];
                        end % if
                    end % if
                    
                    %sixth, draw between pairs of active edges
                    for q=1:2:length(current_xs),
                        if q+1 <= length(current_xs)
                            polygon_matrix(n, round(current_xs(q)):round(current_xs(q+1)), 1:length(clr)) = clr;
                        end
                    end % for
                end
            end
        end % if
    end
end