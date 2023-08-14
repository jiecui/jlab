function getLastBctChunk(this)
% READBLANKCTRLCHUNKS.GETLASTBCTCHUNK gets the last Blankctrl Chunk
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

% Copyright 2013 Richard J. Cui. Created: Sun 05/05/2013 12:46:56.040 PM
% $Revision: 0.1 $  $Date: Sun 05/05/2013 12:46:56.040 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

data = this.Data;
this.LastBctChunk = data(length(data));

end % function getLastConChunk

% [EOF]
