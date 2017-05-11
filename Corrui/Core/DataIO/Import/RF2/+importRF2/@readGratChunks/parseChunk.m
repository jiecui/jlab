function gratdata = parseChunk(this,pos)
% READGRATCHUNKS.PARSECHUNK parses a single grating chunk
%
% Syntax:
%   chunkdata = parseChunk(this, data)
% 
% Input(s):
%   this        - importRF2.readTuneChunks obj
%   pos         - chunk position (in bytes) in the RF file
% 
% Output(s):
%   GratEnvVar  - a structure of grating test environment variables (see
%                 mxparseGratingChunk.c and rf2grat.c for the details)
%                 .gazebox		// the picnumber
%                 .stimsize		// size of fixation cross
%                 .bangle
%                 .bwidth
%                 .blength
%                 .lcolorsr		// see rf2main.c
%                 .lcolorsg
%                 .lcolorsb		// combination of foreground / background color
%                 .locx
%                 .locy
%                 .speed
%                 .gazetime
%                 .fixx
%                 .fixy
%                 .fixr
%                 .fixg
%                 .fixb
%                 .period
%                 .mingray
%                 .maxgray
% 
%   TrialStartEnd   - start ane end time stamps of trials
%                     a structure matrix of [number of conditions, max
%                     repeat number], each element is a structure showing
%                     the start and end time stamps of a trial
%                     TrialStartEnd(i,j).start  - start time stamp
%                     TrialStartEnd(i,j).end    - end time stamp
%   MeanRateA       - mean rates from channel A
%                     column    : at different spatial frequency
%                     row       : at different speed
%   StdRateA        - std. of rates from channel A
%                     same setup of matrix as MeanRateA
%   GratCondition   - speed-period pair values during grating testing
%                     [1, num of condition] each element is the speed and
%                     period values used for that condition
%   SpeedPeriodIdx  - indexes of speed-period pair
%                     [num of condition, 2]
%                     SpeedPeriodIdx[k, 1] = speed index (row of MeanRateA)
%                     at kth condition; 
%                     SpeedPeriodIdx[k, 2] = spatial freq index (col of MeanRateA)
%                     at kth condition; 
% 
% Example:
%
% See also parseConChunk.c, rf2tune.c, mxparseGratChunk.c, rf2grat.c.

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
[gratenvvar, trlstartend, meanratea, stdratea, gratcond, spidx] = mxparseGratingChunk(wholename, pos);

gratdata.GratEnvVar     = gratenvvar;
gratdata.TrialStartEnd  = trlstartend;
gratdata.MeanRateA      = meanratea;
gratdata.StdRateA       = stdratea;
gratdata.GratCondition  = gratcond;
gratdata.SpeedPeriodIndx = spidx;

end % function parseChunk

% [EOF]
