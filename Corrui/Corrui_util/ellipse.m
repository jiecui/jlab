function varargout = ellipse(varargin)
% ELLIPSE - draw an ellipse on specified or current axis
%
% ELLIPSE(X,Y,RX,RY) draws an ellipse at (X,Y) with radii RX and RY on the
% current axes.
% 
% ELLIPSE(AX,...) draws on the axes AX
%
% RY can be omitted in the above two cases, in which case RX is used (thus
% a circle is drawn)
%
% ELLIPSE(...,PLOT) draws the ellipse, if PLOT is true. Default = true
%
% ELLIPSE(...,TILT) tilts the x axis of the ellipse be TILT, in radians.
% Note: TILT is the angle between the x-axis and the major axis of the ellipse.
% 
% ELLIPSE(...,TILT,N), where N is a scalar uses N points to draw the ellipse.
%
% ELLIPSE(...,TILT,THETA), where THETA is a two-element vector, draws the
% arc from angle THETA(1) to THETA(2), relative to the ellipse's x axis, in radians
%
% ELLIPSE(...,TILT,N,THETA) or ELLIPSE(...,TILT,THETA,N) are equivalent.
%
% Ellipse(...,NAME1,VALUE1,NAME2,VALUE2,...), where NAME1 is a string,
% passes the NAME/VALUE parameter pairs to the PLOT function.
%
% H = ELLIPSE(...,PLOT = TRUE,...) returns a handle to the plotted ellipse / arc.
%
% [H, Ex, Ey] = ELLIPSE(..., PLOT = TRUE, ...) returns the coordinates of the points on the
% ellipse
% 
% Author: Andrew Schwartz
% Harvard/MIT SHBT program
% Version 1.0.1, 10/28/2009
%
% Recent changes:
% 1.0.1 - Changed specifying axes using 'Parent' property in plot()
% Added comments
% 1.0.2 - Fix the computation of tilt

% Copyright 2012 Richard J. Cui. Created: Thu 02/16/2012 11:52:20.132 AM
% $Revision: 1 $  $Date: Thu 02/16/2012 11:52:20.132 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com


%% parse input

%determine if first argument is axes
a = varargin{1};
if ishandle(a) && isfield(get(a),'Type') && isequal(get(a,'Type'),'axes')
    ax = a;
    varargin(1) = [];
else
    ax = gca;
end

%parse x,y,rx,ry
if length(varargin)<3, error('Not enough input arguments'); end
if length(varargin)==3, varargin{4} = varargin{3}; end
[x y rx ry] = deal(varargin{1:4});
varargin(1:4) = [];

% whether draw the ellipse
pellipse = true;
if ~isempty(varargin) && islogical(varargin{1})
    pellipse = varargin{1};
    varargin(1) = [];
end % if

%ellipse tilt in radians, deafult 0
t = 0;
if ~isempty(varargin) && isnumeric(varargin{1})
    t = varargin{1};
    varargin(1)=[];
end

%Number of points, arc start*end angles (in radians)
N = 100;        %default: 100 points
th = [0 2*pi];  %default: full ellipse
while ~isempty(varargin) && isnumeric(varargin{1})
    a = varargin{1};
    if length(a)==1
        N = a;
    else
        th = a;
    end
    varargin(1) = [];
end

%% Done parsing inputs, compute points & plot

%distribute N points between arc start & end angles
th = linspace(th(1),th(2),N);

%calculate x and y points
% x = x + rx*cos(th)*cos(t) - ry*sin(th)*sin(t);
% y = y + ry*cos(th)*sin(t) + ry*sin(th)*cos(t);

% 0. get the center coordinates
cx = x;
cy = y; 
% 1. cal the ellipse with 0 tilt
x1 = rx*cos(th);
y1 = ry*sin(th);
% 2. tilt it
xy2 = [cos(t), -sin(t); sin(t), cos(t)] * [x1;y1];
% 3. translation
Ex = xy2(1,:) + cx;
Ey = xy2(2,:) + cy;

%plot
if pellipse == true
    h = plot(Ex,Ey,varargin{:},'Parent',ax);
    varargout{1} = h;
    varargout{2} = Ex(:);
    varargout{3} = Ey(:);
else
    varargout{1} = Ex(:);
    varargout{2} = Ey(:);
end % if

end 

% [EOF]