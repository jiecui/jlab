function rms_cont = RmsContrast(fov)
% RMSCONTRAST Root-mean-square local contrast
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

% Copyright 2013 Richard J. Cui. Created: 10/23/2013 11:20:56.064 AM
% $Revision: 0.1 $  $Date: 10/23/2013 11:20:56.064 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

fov_norm = normFov(fov);   % nromalize FOV
[m, n] = size(fov_norm);

f = fov_norm(:);
f_mean = mean(f);

a = sum((f - f_mean).^2);
b = a / (m * n);
rms_cont = 2 * sqrt(b);

end % function RmsContrast

% [EOF]
