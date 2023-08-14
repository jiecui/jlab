function dxy = denWtXy(xy,wname,level,sorh,thres)
% DENWTXY denoise signal using stationary wavelets
%
% Syntax:
%   dxy = denWtXy(xy,wname,level,sorh,thres)
% 
% Input(s):
%   xy          - real N x 2 = [x,y] signal
%   wname       - wavelet name (see wavenames.m)
%   level       - decompsotion level (default = 5)
%   sorh        - soft or hard threshold (default = 'h')
%   thres       - 1 x level vector, threshold values for each level. the length
%                 of thres must be the same as 'level'.
%
% Output(s):
%   dxy         - denoised xy
% 
% Example:
%
% See also .

% Copyright 2010-2016 Richard J. Cui. Created: 02/12/2011 12:31:32.535 AM
% $Revision: 0.2 $  $Date: Wed 08/03/2016 12:53:29.385 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

if ~exist('level', 'var')
    level = 5;
end % if

% check the consistency of level and thres
if exist('thres', 'var') && level ~= length(thres)
    error('The number of thresholds must be same as level number.')
end % if

if ~exist('sorh', 'var')
    sorh = 'h';
end % if

Xmean = mean(xy);
csig = xy-Xmean(ones(size(xy,1),1),:);

if ~exist('thres','var')
    cds = denswt(csig,wname,level,sorh);
else
    cds = denswt(csig,wname,level,sorh,thres);
end % if

dxy = cds+Xmean(ones(size(xy,1),1),:);

end % function denWtXy

% [EOF]
