function r_xy = rotate2D(xy, theta, t_vect)
% ROTATE2D rotate 2-D points
%
% Syntax:
%   r_xy = rotate2D(xy, theta)
%
% Input(s):
%   xy      - [x, y], N x 2 array, where N is the number of points
%   theta   - rotational angle in rad (0 to east, north = 90 deg)
%   t_vect  - [x, y], translation vector
%
% Output(s):
%   r_xy    - rotated points
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 05/27/2013  2:08:40.727 PM
% $Revision: 0.2 $  $Date: Sun 07/28/2013  4:04:14.418 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% rotation matrix
R = @(alpha) [cos(alpha),sin(alpha);-sin(alpha),cos(alpha)];

% parse input
if ~exist('t_vect', 'var')
    t_vect = [0 0];
end % if

% translate to rotation point
t_xy = translate2D(xy, t_vect);
% rotation
tr_xy = t_xy * R(theta);
% translate back
r_xy = translate2D(tr_xy, -t_vect);

end % function rotate2D

% [EOF]
