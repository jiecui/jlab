function [winc, fr] = ChronuxEst(SpikeYN, movingwin, params)
% CHRONUXEST estimates firing rate using Chronux toolbox
%
% Syntax:
%   [winc, fr] = ChronuxEst(SpikeYN, movingwin, params)
% 
% Input(s):
%   SpikeYN         - logical Y/N at each point = trials x Y/N
%   movingwin       - [winwidth, winstep], where winwidth is shifting
%                     window width, winstep is step of shifting window
%   params          - see mtspecgrampt.m for the details
% 
% Output(s):
%   winc            - window centers
%   fr              - estimated firing rate at each window
%   
% Example:
%
% See also mtspecgrampt.

% Copyright 2012 Richard J. Cui. Created: 06/11/2012 10:09:42.545 AM
% $Revision: 0.3 $  $Date: Sat 06/23/2012  3:57:26.847 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% covert Spike Y/N to spike times
data = SpikeYN2ChronuxData(SpikeYN);
if isempty(data)
    spkyn = ones(size(SpikeYN));
    data = SpikeYN2ChronuxData(spkyn);
    [~, winc] = mtspecgrampt(data, movingwin, params);
    fr = zeros(size(winc));
else
    [~,winc,~,fr] = mtspecgrampt(data, movingwin, params);
end

end % function ChronuxEst

% [EOF]
