function stim_time = getStimTime(this)
% GETSTIMTIME gets the stimulus time from the experiment
% 
% Syntax:
%   stim_time = getStimTime(RF2Mat_object)
% 
% Input(s):
%   this          - object of RF2Mat class
% 
% Output(s):
%   stim_time   - the stimulus time specified in the dataset. If there are
%                 more than one time specified, stim_time is an array.
% 
% Example:
% 
% See also readrf2chunks, RF2Mat.

% Copyright 2010 Richard J. Cui. Created: 02/19/2010 10:53:20.934 PM
% $Revision: 0.2 $  $Date: 03/10/2010  4:13:45.526 PM PM $
% 
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
% 
% Email: jie@neurocorrleate.com

% =========================================================================
% chunk by chunk
% =========================================================================
nchunk = this.nChunkOfInt;    % number of chunks
chunks = this.chunks;
stimtype = this.Stimulus.type;

stimtime = [];
for k = 1:nchunk
    chunk_k = chunks(k);
    type = chunk_k.type;
    if strcmpi(stimtype,type)
        switch stimtype
            case 'DIAG'
                data_k = this.parseDiag(chunk_k);
            case 'CORNERS'
                data_k = this.parseCorners(chunk_k);
            otherwise
                error('Not known stimulus type %s.',stimtype)
        end % switch
        stimtime_k = data_k.fix.time;  % stim_time
        stimtime = cat(1,stimtime,stimtime_k);
    end%if
end%for

if isempty(stimtime)
    fprintf('\t<!> cannot find the stimulus time.')
end % if

% =========================================================================
% output
% =========================================================================
% stim_time = unique(sort(stimtime));
stim_time = stimtime;
this.StimTime = stimtime;

end%function

% [EOF]