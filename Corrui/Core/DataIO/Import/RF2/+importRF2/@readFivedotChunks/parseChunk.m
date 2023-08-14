function chunkdata = parseChunk(this,pos)
% READEFIVEDOTCHUNKS.PARSECHUNK parses a single edgecomp chunk
%
% Syntax:
%   chunkdata = parseChunk(this, data)
% 
% Input(s):
%   this        - importRF2.readFivedotChunks obj
%   pos         - chunk position in the RF file
% 
% Output(s):
%   cor_env_vars    - a structure of corners exp environment variables
%                       .picnumber
%                       .stimsize
%                       .spreadsize
%                       .spare0
%                       .spare1
%                       .spare2
%                       .forecolorr     : foreground color red, see rf2main.c
%                       .backcolorr     : in lcolor, low 8 bits = forecolor
%                       .forecolorg
%                       .backcolorg
%                       .forecolorb     : high 8 bits = backcolor
%                       .backcolorb
%                       .spare3
%
% Example:
%
% See also mxparseCornersChunk.c, parseConChunk.c, rf2cont.c.

% Copyright 2014 Richard J. Cui. Created: Tue 04/08/2014  9:06:32.336 PM
% $Revision: 0.1 $  $Date: Tue 04/08/2014  9:06:32.336 PM $
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
fdt_env_vars = mxparseFivedotChunk(wholename, pos);

chunkdata.FdtEnvVars = fdt_env_vars;

end % function parseChunk

% [EOF]
