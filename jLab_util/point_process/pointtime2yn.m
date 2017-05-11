function pointyn = pointtime2yn(pointtimes, numtrial, length)
% POINTTIME2YN converts point event times to point Y/N logics
%
% Syntax:
%   pointyn = pointtime2yn(pointtimes, numtrial, length)
%
% Input(s):
%   pointtimes  - times (indexes) of point events
%   numtrial    - number of trials
%   length      - signal length of each trial
%
% Output(s):
%   pointyn     - logic Y/N matrix = numtrial x length
%
% Example:
%
% See also yn2pointtime.

% Copyright 2012 Richard J. Cui. Created: 11/02/2012  3:55:17.890 PM
% $Revision: 0.1 $  $Date: 11/02/2012  3:55:17.890 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% TODO: assume Fs = 1 kHz; other Fs

pointyn = false(numtrial, length);

x = pointyn';
y = x(:);
y(pointtimes) = true;

z = reshape(y, length, numtrial);
pointyn = z';

end % function pointtime2yn

% [EOF]
