function chunkdata = parseChunk(this,pos)
% READEDGECOMPCHUNKS.PARSECHUNK parses a single edgecomp chunk
%
% Syntax:
%   chunkdata = parseChunk(this, data)
% 
% Input(s):
%   this        - importRF2.readEdgecompChunks obj
%   pos         - chunk position in the RF file
% 
% Output(s):
%   cor_env_vars    - a structure of corners exp environment variables
%                       .gazebox
%                       .stimsize
%                       .spreadsize
%                       .eangle         : 'e' denotes edgecomp
%                       .eanspread
%                       .edistance
%                       .forecolorr     : foreground color red, see rf2main.c
%                       .backcolorr     : in lcolor, low 8 bits = forecolor
%                       .forecolorg
%                       .backcolorg
%                       .forecolorb       : high 8 bits = backcolor
%                       .backcolorb
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
% See also mxparseCornersChunk.c, parseConChunk.c, rf2cont.c.

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
egc_env_vars = mxparseEdgecompChunk(wholename, pos);

chunkdata.EgcEnvVars = egc_env_vars;

end % function parseChunk

% [EOF]
