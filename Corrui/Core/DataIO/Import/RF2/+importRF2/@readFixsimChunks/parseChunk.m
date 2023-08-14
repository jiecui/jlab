function chunkdata = parseChunk(this,pos)
% READFIXSIMCHUNK.PARSECHUNK parses a single fixsim chunk
%
% Syntax:
%   chunkdata = parseChunk(this, data)
% 
% Input(s):
%   this        - importRF2.readFixsimChunks obj
%   pos         - chunk position in the RF file
% 
% Output(s):
%   fsm_env_vars    - a structure of fixsim environment variables
%                   .gazebox
%                   .stimsize
%                   .bangle		// note: b - bar
%                   .bwidth	
%                   .blength
%                   .lcolorsr	// see rf2main.c
%                   .lcolorsg
%                   .lcolorsb
%                   .locx
%                   .locy
%                   .gazetime
%                   .fixr
%                   .fixg
%                   .fixb
%                   .startchunk     // TS chunk number where the eye signals used starts
%                   .active         // flag: 1 = bar in active mode
%                   .infilename     // infile name
%                   .activetime     // time stamp when the bar/fix was set by the user in active mode
%                   .dataONtime  	// time stamp when the data was recorded
%                   .activetimestart    // time stamp when the bar/fix was actaully moving
% ----- The next four variables are empty for short(old) fixsim chunk -----
%                   .showbar        // flag: 1 = bar was shown
%                   .fixactive      // flag: 1 = fix spot in active mode
%                   .fixx           // x - fix spot location
%                   .fixy           // y - fix spot location
% 
% Example:
%
% See also mxparseFSMChunk.c, parseConChunk.c, rf2cont.c, parseBctChunk.c.

% Copyright 2014 Richard J. Cui. Created: Wed 01/22/2014  9:38:59.570 PM
% $Revision: 0.1 $  $Date:Wed 01/22/2014  9:38:59.570 PM $
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
EMPTY = 9999;

% ==================
% paras
% ==================
wholename = this.WholeName;

% ==================
% main
% ==================
fsm_env_vars = mxparseFSMChunk(wholename, pos);

% check if short/old format fixsim
showbar     = fsm_env_vars.showbar;
fixactive   = fsm_env_vars.fixactive;
fixx        = fsm_env_vars.fixx;
fixy        = fsm_env_vars.fixy;
if (showbar == EMPTY) && (fixactive == EMPTY) && (fixx == EMPTY) && (fixy == EMPTY)
    fsm_env_vars.showbar    = [];
    fsm_env_vars.fixactive  = [];
    fsm_env_vars.fixx       = [];
    fsm_env_vars.fixy       = [];
end % if

chunkdata = fsm_env_vars;

end % function parseChunk

% [EOF]
