function maxres = getMaxRes(RM)
% GETMAXRES gets the max resolution of analog eye signals
% 
% Syntax:
%   maxres = getMaxRes(RM)
% 
% Input(s)
%   RM          - RF2Mat class
% 
% Output(s)
%   maxres      - maximum resolution
% 
% Example:
% 
% See also .

% Copyright 2010 Richard J. Cui. Created: 02/20/2010  5:25:15.211 PM
% $Revision: 0.1 $  $Date: 02/20/2010  5:25:15.211 PM $
% 
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
% 
% Email: jie@neurocorrleate.com

chunks = RM.chunks;

k = 1;
type = chunks(k).type;

% look for the 1st SpikeAndEye block
while ~strcmpi(type,'SpikeAndEye')
    k = k+1;
    type = chunks(k).type;
end%while

sae = chunks(k);
saedata = RM.parseSpikeAndEye(sae);

% output
maxres = double(saedata.max_eye_res);
RM.MaxRes = maxres;

end%function

% [EOF]