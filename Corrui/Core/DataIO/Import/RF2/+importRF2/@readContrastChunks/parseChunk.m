function chunkdata = parseChunk(this,pos)
% READCONTRASTCHUNKS.PARSECHUNK parses a single contrast chunk
%
% Syntax:
%   chunkdata = parseChunk(this, data)
% 
% Input(s):
%   this        - importRF2.readContrastChunks obj
%   pos         - chunk position in the RF file
% 
% Output(s):
%   con_env_vars    - a structure of contrast environment variables
%                   .gazebox
%                   .stimsize
%                   .fixx
%                   .fixy
%                   .fixr
%                   .fixg
%                   .fixb
%                   .gazetime
%                   .bangle		// note: b - bar, but actually the grating
%                   .bwidth	
%                   .blength
%                   .locx
%                   .locy
%                   .period
%                   .speed
%                   .mingray
%                   .maxgray
%                   .grattime
%                   .lcolorsr	// see rf2main.c
%                   .lcolorsg
%                   .lcolorsb
% 
%   sess_stim   - a [NUMREPEAT NUMTRIAL] matrix of stiminfo structure,
%                 where NUMREPEAT is the maximum number of repeated cycles
%                 defined in a session (i.e. 10), NUMTRIAL is the number of
%                 conditions (trials) issued in a cycle (i.e. 11 x 11 + 1 = 122),
%                 and 'stiminfo' is a structure having the following fields:
%                   stiminfo.cyclenum   - the number of current cycle
%                   stiminfo.trialnum   - current condition/trial number
%                   stiminfo.thistime0  - blank (0% contrast) start time
%                   stiminfo.mingray0   - minimum gray for blank (255)
%                   stiminfo.maxgray0   - maximum gray for blank (255)
%                   stiminfo.thistime1  - contrast1 start time
%                   stiminfo.mingray1   - minimum gray for contrast1 
%                   stiminfo.maxgray1   - maximum gray for contrast1 
%                   stiminfo.thistime2  - contrast2 start time
%                   stiminfo.mingray2   - minimum gray for contrast2 
%                   stiminfo.maxgray2   - maximum gray for contrast2 
% 
%   sess_trial  - a [NUMREPEAT 1] array of 'trialinfo' structure, where
%                 NUMREPEAT is the maximum number of repeated cycles
%                 defined in a session (i.e. 10), and 'trialinfo' is a
%                 stucture with the following fields:
%                   trialinfo.numtried  - total number of tried
%                   trialinfo.numsucc   - number of successful trials
%
% Example:
%
% See also parseConChunk.c, rf2cont.c.

% Copyright 2011-12 Richard J. Cui. Created: 11/02/2011 11:03:48.062 AM
% $Revision: 0.3 $  $Date: Mon 05/21/2012  2:24:13.942 PM $
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
[con_env_vars, sess_stim, sess_trial] = parseConChunk(wholename, pos);

chunkdata.ConEnvVars = con_env_vars;
chunkdata.SessStim = sess_stim;
chunkdata.SessTrial = sess_trial;

end % function parseChunk

% [EOF]
