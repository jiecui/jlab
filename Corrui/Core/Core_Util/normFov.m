function nfov = normFov(fov)
% NORMFOV (summary)
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 10/23/2013 11:39:34.422 AM
% $Revision: 0.1 $  $Date: 10/23/2013 11:39:34.422 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

i_max = max(fov(:)) + eps;
i_min = min(fov(:));

nfov = (fov - i_min) / i_max;


end % function normFov

% [EOF]
