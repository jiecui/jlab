function chunkdata = parseChunk(this,pos)
% READCORNERSCHUNKS.PARSECHUNK parses a single corner chunk
%
% Syntax:
%   chunkdata = parseChunk(this, data)
% 
% Input(s):
%   this        - importRF2.readCornersChunks obj
%   pos         - chunk position in the RF file
% 
% Output(s):
%   cor_env_vars    - a structure of corners exp environment variables
%                       .gazebox
%                       .stimsize
%                       .spreadsize
%                       .cangel         : 'c' denotes corners
%                       .canspread
%                       .cdistance
%                       .lcolorsr       : see rf2main.c
%                       .lcolorsg       : in lcolor, low 8 bits = forecolor
%                       .lcolorsb       : high 8 bits = backcolor
%                       .grades
%                       .peakcolor
%                       .edgecolor
%                       .cupperx
%                       .cuppery
%                       .stimtime
%                       .gazetime
%                       .gridcenterx
%                       .gridcentery
%                       .fixr
%                       .fixg
%                       .fixb
%                       .usergammavalue
%                       .gridsizex
%                       .gridsizey
%                       .cfadedist
%                       .cwidth
%                       .csize
%                       .cdepth
%                       .fixangle
%
% Example:
%
% See also mxparseCorChunk.c, parseConChunk.c, rf2cont.c.

% Copyright 2013 Richard J. Cui. Created: Sat 05/25/2013  5:40:20.810 PM
% $Revision: 0.1 $  $Date: Sat 05/25/2013  5:40:20.810 PM $
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
cor_env_vars = mxparseCornersChunk(wholename, pos);

chunkdata.CorEnvVars = cor_env_vars;

end % function parseChunk

% [EOF]
