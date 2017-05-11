function hline = DrawCircle(ax, x, y, r, nseg, varargin)
% DrawCircle Draw a circle on the current figure using ploylines
% 
% Syntax:
%   hline = DrawCircle(ax, x, y, r, nseg, varargin)
% 
% Input(s):
%   ax      - axes to draw
%   x, y    - Center of the circle
%   r       - Radius of the circle
%   nseg    - Number of segments for the circle
%   S       - line properties, such as Colors, plot symbols, line types
%
% Output(s):
%   hline   - handle of the line ojbect
% 
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Fri 08/12/2016  4:23:57.702 PM
% $Revision: 0.1 $  $Date: Wed 08/17/2016  1:02:07.825 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com


theta = 0 : (2 * pi / nseg) : (2 * pi);
pline_x = r * cos(theta) + x;
pline_y = r * sin(theta) + y;

line_h = line(ax, [0 1], [0 1], 'Visible', 'off', varargin{:});
set(line_h, 'XData', pline_x, 'YData', pline_y, 'Visible', 'on')

if nargout > 0, hline = line_h; end % if

end % function

% [EOF]
