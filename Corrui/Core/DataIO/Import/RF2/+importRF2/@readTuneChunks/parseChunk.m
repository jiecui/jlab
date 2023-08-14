function chunkdata = parseChunk(this,pos)
% READTUNECHUNKS.PARSECHUNK parses a single tune chunk
%
% Syntax:
%   chunkdata = parseChunk(this, data)
% 
% Input(s):
%   this        - importRF2.readTuneChunks obj
%   pos         - chunk position (in bytes) in the RF file
% 
% Output(s):
%   tunehead    - Information on tune chunk
%                 .totalpoints  : total number of points per 360 deg
%                 .maxtries     : maximum number of tries
%                 .spare        : no use now
%   truehits    - 1 x totalpoints array, standardized hits = hits *
%                 maxtries / tries, where 'hits' is the number of hits at
%                 each point, 'maxtries' is the maximum number of tries,
%                 and 'tries' is the number of tries at each point.
%   semerr      - std. err. of mean * 256
%
% Example:
%
% See also parseConChunk.c, rf2tune.c, mxparseTuneChunk.c.

% Copyright 2012 Richard J. Cui. Created: Tue 05/22/2012  1:54:27.143 PM
% $Revision: 0.1 $  $Date: Tue 05/22/2012  1:54:27.143 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% ==================
% paras
% ==================
wholename = this.WholeName;

% ==================
% main
% ==================
[tunehead, truehits, semerr] = mxparseTuneChunk(wholename, pos);

chunkdata.TuneHead = tunehead;
chunkdata.TrueHits = truehits;
chunkdata.SemErr = semerr;

end % function parseChunk

% [EOF]
