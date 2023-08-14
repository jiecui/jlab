function stim_type = getStimType(RM)
% GETSTIMTYPE gets the type of the stimulus
%
% Syntax
%   stim_type = getStimType(RM)
% 
% Input(s):
%   RM          - object of RF2Mat class
% 
% Output(s):
%   stim_type   - type of the stimulus = {'DANCE', 'FIVEDOT', 'TUNING',
%                 'HERMANN', 'DIAG', 'CORNERS', 'EDGECOMP', 'FREEBAR'})
% 
% Remarks:
%   Assume that one session has only one type of stimulus
%
% Example:
%
% See also RF2Mat.

% Copyright 2010 Richard J. Cui. Created: 02/26/2010  9:49:19.820 AM
% $Revision: 0.1 $  $Date: 02/26/2010  9:49:19.867 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

chunks = RM.chunks;
known_type = RM.knownStimType;

type = [chunks.type];

[start_idx,end_idx] = regexpi(type,known_type);

nKnowType = length(known_type);

k = 1;
idx_k = start_idx{k};

while isempty(idx_k) && k <= nKnowType
    k = k+1;
    idx_k = start_idx{k};
end % while

si = start_idx{k};
ei = end_idx{k};

stim_type = type(si(1):ei(1));

RM.Stimulus.type = stim_type;


end % function getStimType

% [EOF]
