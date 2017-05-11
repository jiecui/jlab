function dog_cont = DogContrast(fov, paras)
% DOGCONTRAST local contrast using DOG filter
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

% Copyright 2013 Richard J. Cui. Created: 11/14/2013 11:30:47.578 AM
% $Revision: 0.1 $  $Date: 11/14/2013 11:30:47.578 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% paras of DOG filter
rs = paras.rs;
rc = paras.rc;
rw = paras.rw;

% construct DOG filter
[m, n] = size(fov);
xv = -floor(n/2):n-floor(n/2)-1;
yv = -floor(m/2):m-floor(m/2)-1;
[x, y] = meshgrid(xv, yv);
gc = 1 / (2 * pi * rc^2) * exp(-(x.^2 + y.^2) / 2 / rc^2);
gs = 1 / (2 * pi * rs^2) * exp(-(x.^2 + y.^2) / 2 / rs^2);
dog = rw * gc - gs;

% dog contrast
a = fov .* dog;
dog_cont = sum(a(:));

end % function DogContrast

% [EOF]
