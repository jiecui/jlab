function [beginp,endp, len] = yn2be(yn)
% YN2BE converts a logic vector to begin and end points arrays
%
% Syntax:
%   [beginp,endp] = yn2be(yn)
% 
% Input(s):
%   yn      - logic vector
% 
% Output(s):
%   beginp      - interval begin positions
%   endp        - interval end positions
%   len         - segment length
% 
% Example:
%
% See also be2yn, lohi2idx, yn2onoff.

% Copyright 2010 Richard J. Cui. Created: 05/01/2010  4:19:00.263 PM
% $Revision: 0.1 $  $Date: 05/01/2010  4:19:00.264 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

xx = double(yn);
xx = xx(:);

yy = diff(xx);
low_idx = yy == 1;
hig_idx = yy == -1;
% beginp = find(low_idx);
beginp = find(low_idx) + 1;
endp = find(hig_idx);
if xx(1) == 1
     beginp = [1;beginp];
end % if
if xx(end) == 1
    endp = [endp;length(xx)];
end %if

len = endp - beginp + 1;

end % function yn2be

% [EOF]
