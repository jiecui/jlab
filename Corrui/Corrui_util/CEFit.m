function ce = CEFit(xy)
% CEFIT fits the confidence ellipse using ALG_ELLIPSE_FIT
%
% Syntax:
%   ce = CEFit(xy)
% 
% Input(s):
%   xy   - observed points on the ellipse = [number of points, 2], column 1
%          = x position, and column 2 = y position
%
% Output(s):
%   ce  - coefficients of the confidence ellipse = [a, b, c, d, e, f], and
%         ax^2 + bxy + cy^2 + dx + ey + f = 0
%
% Example:
% 
% Reference:
%   Trucco, E., & Verri, A. (1998). Introductory techniques for 3-D
%   computer vision. Upper Saddle River, New Jersey: Prentice Hall, p.104.
%
% See also .

% Copyright 2011 Richard J. Cui. Created: 02/16/2012  4:18:48.946 PM
% $Revision: 0.1 $  $Date: 02/16/2012  4:18:48.961 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% Design matrix
% =======================
x = xy(:, 1);
y = xy(:, 2);

X = [x.*x, x.*y, y.*y, x, y, ones(length(x), 1)];

% Scatter matrix
% ==============
S = X' * X;

% Constraint matrix
% =================
C = [0 0 -2 0 0 0; 
     0 1  0 0 0 0;
    -2 0  0 0 0 0;
     0 0  0 0 0 0;
     0 0  0 0 0 0;
     0 0  0 0 0 0];
 
 % find the eigenvalue and the vector corresponding to the only negative
 % value
 % ======================================================================
 [V, D] = eig(S, C);
 
 d = diag(D);
 % get rid of Inf
 d(abs(d) == Inf) = NaN;
 ce = V(:, d == min(d));
 % if more than one (due to data noise), select the 1st one
 ce = ce(:, 1);

 % adjust direction
 if ce(1) <0
     ce = -ce;
 end % if
 
end % function CEFit

% [EOF]
