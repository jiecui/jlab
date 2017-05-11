function s_xy = scale2D(xy, s)
% SCALE2D scales two-d data points
%
% Syntax:
%   s_xy = scale2D(xy, scale_factor)
%
% Input(s):
%   xy      - [x, y], N x 2 array, where N is the number of points
%   s       - scaling factor ( > 0)
%
% Output(s):
%   s_xy    - scaled xy
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 05/27/2013  2:02:48.274 PM
% $Revision: 0.1 $  $Date: 05/27/2013  2:02:48.293 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

if ~isreal(s) || s < 0
    error('Scale factor must be a positive real number.')
end % if

s_xy = s * xy;

end % function scale2D

% [EOF]
