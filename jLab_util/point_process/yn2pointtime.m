function [pointtimes, numtrial, length] = yn2pointtime( pointyn )
% YN2POINTTIME converts point Y/N logics to point event timess
%
% Syntax:
%   [pointtimes, numtrial, length] = yn2pointtime( pointyn )
%
% Input(s):
%   pointyn     - logic Y/N matrix = numtrial x length
%
% Output(s):
%   pointtimes  - times (indexes) of point events
%   numtrial    - number of trials
%   length      - signal length of each trial
%
% Example:
%
% See also pointtime2yns, yn2onoff, yn2be, be2yn.

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

[numtrial, length] = size(pointyn);

x = pointyn';
pointtimes = find(x(:));

end % function pointtime2yn

% [EOF]
