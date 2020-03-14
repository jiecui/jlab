function y = truncdec(varargin)
%TRUNCDEC Truncate to a specified number of decimals.
%
%   Y = TRUNCDEC(X, N) truncates the elements of X to N decimals.
%
%   For instance, truncdec(10*sqrt(2) + i*pi/10, 4) returns
%   14.1421 + 0.3141i
%
%   See also: FIX, FLOOR, CEIL, ROUND, FIXDIG, ROUNDDEC, ROUNDDIG.

%   Author:      Peter J. Acklam
%   Time-stamp:  2006-10-04 08:37:59 +02:00
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   y = fixdec(varargin{:});
