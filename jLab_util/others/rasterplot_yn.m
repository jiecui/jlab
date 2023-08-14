function rasterplot_yn(point_yn, figh, fs, showtimescale, ztime)
% RASTERPLOT_YN rasterplots spike Y/N
%
% Syntax:
%   rasterplot_yn(point_yn, hresp, fs, showtimescale, ztime)
% 
% Input(s):
%   spike_yn    - M x N, where M = number of trials, N = trial length
%   figh        - figure handle
%   
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 10/30/2012 11:20:39.176 AM
% $Revision: 0.2 $  $Date: Thu 01/17/2013  3:47:53.171 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

if ~exist('hresp', 'var')
    figure
    figh = gca;
end 

if ~exist('fs', 'var')
    fs = 1000;
end % if

if ~exist('showtimescale', 'var')
    showtimescale = true;
end % if

if ~exist('ztime', 'var')
    ztime = 1;
end % if

[M, N] = size(point_yn);
x = point_yn';
T = find(x(:));
rasterplot(T, M, N, figh, fs, showtimescale, ztime);

end % function rasterplot_yn

% [EOF]
