function [xs, ys] = SharpEdge1D(x, y, up_idx, down_idx)
% SHARPEDGE1D sharpen the edges of 1-d signal
%
% Syntax:
%   [xs, ys] = SharpEdge1D(x, y, up_idx, down_idx)
% 
% Input(s):
%   x           - x data
%   y           - y data
%   up_idx      - vector of up edge indexes
%   down_idx    - down edges
% 
% Output(s):
%   xs, ys      - edge sharpened signal
% 
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Sat 08/20/2016 10:03:14.770 AM
% $Revision: 0.1 $  $Date: Sat 08/20/2016 10:03:14.814 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

up = up_idx(:)';
dw = down_idx(:)';
idx = 1:length(x);

xq = sort([idx, up - .1, dw + .1]);
yq = sort([idx, up - .9, dw + .9]);

xs = interp1(idx, x, xq, 'nearest');
ys = interp1(idx, y, yq, 'nearest');

end % function SharpEdge1D

% [EOF]
