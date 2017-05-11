function varargout = PlotCircle(center_x, center_y, radius, n)
% PLOTCIRCLE: plots a circle
%
%     Usage: plotcircle({radius},{n})
%
%     radius = optional radius of circle [default = 1].
%     n =      optional number of plotted points [default = 100].
%

% Copyright 2014 Richard J. Cui. Created: Tue 03/18/2014 11:06:44.843 AM
% $Revision: 0.2 $  $Date: Wed 12/26/2012  4:06:57.524 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

if (nargin < 3)
    radius = 1;
end

if (nargin < 4)
    n = 100;
end

theta = linspace(0, 2*pi, n);

x = radius .* cos(theta) + center_x;
y = radius .* sin(theta) + center_y;

h = plot(x,y);

if nargout == 1
    varargout{1} = h;
end % if

return;
