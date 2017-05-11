function t_xy = translate2D(xy, t_vector)
% TRANSLATE2D translate 2-d points
%
% Syntax:
%   t_xy = translate2D(xy, t_vector)
% 
% Input(s):
%   xy          - [x, y], N x 2 array, where N is the number of points
%   t_vector    - translation vector = [vx, vy]
%
% Output(s):
%   t_xy        - translated points
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 05/27/2013  2:13:29.407 PM
% $Revision: 0.1 $  $Date: 05/27/2013  2:13:29.407 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

np = size(xy, 1);   % number of points
t_xy = xy + t_vector(ones(np, 1), :);

end % function translate2D

% [EOF]
