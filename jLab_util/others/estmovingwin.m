function [win_centers, num_win] = estmovingwin(win_width, win_step, sig_len)
% ESTMOVINGWIN Estimates moving window centers and number of windows needed
%
% Syntax:
%   [win_centers, num_win] = estmovingwin(win_width, win_step, sig_len)
% 
% Input(s):
%   win_width       - the width of the window (unit samples)
%   win_step        - step for moving the window (samples)
%   sig_len         - length of the signal (samples)
% 
% Output(s):
%   win_centers     - position of the window centers (samples)
%   num_win         - number of windows
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 06/25/2012 10:48:53.446 AM
% $Revision: 0.1 $  $Date: 06/25/2012 10:48:53.446 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

win_range = win_width - 1;
win_centers = (1 + win_range/2):win_step:(sig_len - win_range/2);
num_win = length(win_centers);

end % function estmovingwin

% [EOF]
