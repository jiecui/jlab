function yn = be2yn(beginp,endp,sigLen)
% BE2YN convers begin and end pair of intervals to a vector of true or
%       false logic
%
% Syntax:
%   yn = be2yn(begins,ends,sigLen)
% 
% Input(s):
%   beginp      - interval begin positions
%   endp        - interval end positions
%   sigLen      - length of the signal
% 
% Output(s):
%   yn          - ture/false logic vector
% 
% Example:
%
% See also lohi2idx, yn2be.

% Copyright 2010 Richard J. Cui. Created: 05/01/2010  3:51:05.413 PM
% $Revision: 0.2 $  $Date: Mon 05/03/2010  4:38:43 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

beginp = double(beginp(:));
endp   = double(endp(:));

yn = false(sigLen,1);
yn(lohi2idx(beginp,endp)) = true;

end % function be2yn

% [EOF]
