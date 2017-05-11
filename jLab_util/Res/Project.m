% PROJECT:  Given a set of points specified by vectors x,y and a line 
%           specified by its slope and intercept, projects the points onto 
%           the line, returning a column vector of centered scores and the
%           point coordinates of the projected points.
%
%       Usage: [scores,crds] = project(x,y,slope,intcpt,{nocenter})
%
%         x,y =       vectors of point coordinates for n points.
%         slope =     slope of reference line.
%         intcpt =    intercept of reference line.
%         nocenter =  optional boolean flag indicating, if true, that scores
%                       are not to be centered [default = 0 = false].
%         ------------------------------------------------------------------
%         scores =   [n x 1] vector of scores.
%         crds =     [n x 1] matrix of point coordinates.
%

% Bookstein et al. 1985. Morphometrics in Evolutionary Biology, appendix A.1.11.
%   Note: A.1.11 is wrong -- don't square term in denominator.

% RE Strauss, 1/20/98
%   3/14/02 -  added 'nocenter' option, improved documentation.
%   11/16/04 - return point coordinates as well as scores.

function [scores,crds] = project(x,y,slope,intcpt,nocenter)
  if (nargin < 5) nocenter = []; end;
  
  if (isempty(nocenter))
    nocenter = 0;
  end;
  
  x = x(:); 
  y = y(:);
  
  lenx = length(x);
  leny = length(y);
  if (lenx ~= leny)
    error('  Project: vectors of X,Y coordinates must be same length');
  end;

  m1 = slope;                         % Target line
  m2 = -1;
  m3 = intcpt;
  dm = sqrt(m1*m1 + m2*m2);
  dmp = (x*m1 + y*m2 + m3)/dm;        % Distance from point to target line
  dr = dmp./dm;

  l1 = -1/slope;                      % Line orthogonal to target line, thru origin
  l2 = -1;
  l3 = 0;
  dl = sqrt(l1*l1 + l2*l2);
  dlp = (x*l1 + y*l2 + l3)/dl;        % Distance from point to orthogonal line
  
  scores = -dlp;                      % Distances from points to orthogonal line
  crds = [x-m1*dr, y-m2*dr];          % Projections of points onto target line
  
  if (~nocenter)
    scores = scores - mean(scores);
  end;

  return;
