function chunkdata = parseChunk(this,pos)
% READBLANKCTRLCHUNK.PARSECHUNK parses a single blankctrl chunk
%
% Syntax:
%   chunkdata = parseChunk(this, data)
% 
% Input(s):
%   this        - importRF2.readBlankctrlChunks obj
%   pos         - chunk position in the RF file
% 
% Output(s):
%   bct_env_vars    - a structure of blankctrl environment variables
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
%                   .trialtime
%                   .lcolorsr	// see rf2main.c
%                   .lcolorsg
%                   .lcolorsb
% 
%   sess_stim   - a [NUMCOND NUMTRIAL] matrix of stiminfo structure,
%                 where NUMRCOND is the number of liminance levels
%                 presented on a screen (i.e. 5), NUMTRIAL is the number of
%                 trials issued uncer a condtion (i.e. one of the luminances),
%                 and 'stiminfo' is a structure having the following fields:
%                   stiminfo.starttime  - start time of the trial
%                   stiminfo.lumpercent - percentage of the maixmum luminance
%                   stiminfo.lumindex   - index of luminance (0 - 255)
% 
%   sess_trial  - a [NUMCOND 1] array of 'trialinfo' structure, where
%                 NUMRCOND is the number of conditions, and 'trialinfo' is a
%                 stucture with the following fields:
%                   trialinfo.numtried  - total number of tried
%                   trialinfo.numsucc   - number of successful trials
%
% Example:
%
% See also parseConChunk.c, rf2cont.c, parseBctChunk.c.

% Copyright 2013 Richard J. Cui. Created: 11/02/2011 11:03:48.062 AM
% $Revision: 0.1 $  $Date: Sun 05/05/2013 12:46:56.040 PM $
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
[bct_env_vars, sess_stim, sess_trial] = parseBctChunk(wholename, pos);

chunkdata.BctEnvVars = bct_env_vars;
chunkdata.SessStim = sess_stim;
chunkdata.SessTrial = sess_trial;

end % function parseChunk

% [EOF]
