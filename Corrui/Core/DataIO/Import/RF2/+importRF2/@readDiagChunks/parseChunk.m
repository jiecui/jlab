function chunkdata = parseChunk(this,pos)
% READDIAGCHUNKS.PARSECHUNK parses a single edgecomp chunk
%
% Syntax:
%   chunkdata = parseChunk(this, data)
% 
% Input(s):
%   this        - importRF2.readDiagChunks obj
%   pos         - chunk position in the RF file
% 
% Output(s):
%   cor_env_vars    - a structure of corners exp environment variables
%                       .gazebox
%                       .stimsize
%                       .spreadsize
%                       .dangle             : 'd' denotes Diag / Star
%                       .danspread          : = diameter
%                       .ddistance
%                       .forecolorr         : foreground color red, see rf2main.c
%                       .backcolorr         : in lcolor, low 8 bits = forecolor
%                       .forecolorg
%                       .backcolorg
%                       .forecolorb         : high 8 bits = backcolor
%                       .backcolorb
%                       .grades
%                       .peakcolor
%                       .edgecolor
%                       .dupperx
%                       .duppery
%                       .stimtime
%                       .gazetime
%                       .gridcenterx
%                       .gridcentery
%                       .fixr
%                       .fixg
%                       .fixb
%                       .usergammavalue
%                       .dvertices          : number of vertices
%                       .dinner_radius
%                       .gridsizex
%                       .gridsizey
%                       .fixangle
%
% Example:
%
% See also mxparseEdgecompChunk.c, mxparseCornersChunk.c, parseConChunk.c, rf2cont.c.

% Copyright 2013 Richard J. Cui. Created: Mon 06/03/2013 12:55:32.898 PM
% $Revision: 0.1 $  $Date: Mon 06/03/2013 12:55:32.898 PM $
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
dig_env_vars = mxparseDiagChunk(wholename, pos);

chunkdata.DigEnvVars = dig_env_vars;

end % function parseChunk

% [EOF]
