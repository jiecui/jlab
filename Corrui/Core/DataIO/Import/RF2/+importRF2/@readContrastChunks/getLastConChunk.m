function getLastConChunk(this)
% GETLASTCONCHUNK gets the last Contrast Chunk
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

% Copyright 2011 Richard J. Cui. Created: 01/19/2012  5:37:31.455 PM
% $Revision: 0.1 $  $Date: 01/19/2012  5:37:31.470 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

data = this.Data;
this.LastConChunk = data(length(data));

end % function getLastConChunk

% [EOF]
