function data = SpikeYN2ChronuxData(X)
% SPIKEYN2CHRONUXDATA converts a matrix of spike Yes/No (logical) to the
%       data structure of Poisson point process of spike times in Chronux.
%
% Syntax:
%   data = SpikeYN2ChronuxData(X)
% 
% Input(s):
%   X       - the spike Y/N logical 1-d array or matrix. If matrix, rows
%             are trials/channels and columns are signals = [number of
%             trials, signal length]
%
% Output(s):
%   data    - structure array of spike times with dimension channels/trials
%
% Example:
%
% See also getSessInfo, mtspecgrampt.

% Copyright 2012 Richard J. Cui. Created: 06/07/2012 11:20:16.988 AM
% $Revision: 0.1 $  $Date: 06/07/2012 11:20:16.988 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

[R, C] = size(X);
if R == 1 || C == 1
    % data = X;     % bugs
    data = find(X);
else
    data = struct([]);
    for k = 1:R     % trial by trial
        x_k = X(k, :);
        t_k = find(x_k);
        data(k).times = t_k;
    end %for
end % if

end % function SpikeYN2ChronuxData

% [EOF]
