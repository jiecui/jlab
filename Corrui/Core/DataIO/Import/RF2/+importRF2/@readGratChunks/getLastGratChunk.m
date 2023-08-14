function getLastGratChunk(this)
% GETLASTGRATCHUNK gets the last grating chunks during grating testing
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

% Copyright 2012 Richard J. Cui. Created: Thu 05/24/2012 10:21:05.226 AM
% $Revision: 0.1 $  $Date: Thu 05/24/2012 10:21:05.226 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

data = this.Data;
this.LastGratChunk = data(length(data));

end % function getLastConChunk

% [EOF]
