function out_enum = getEnum(enum)
% NEUSPIKE.GETENUM basic properties of spiketimes for all experiments
%
% Syntax:
%   spkt_enum = getEnum(enum)
% 
% Input(s):
%   enum        - old enum structure
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 05/30/2013  9:04:07.846 AM
% $Revision: 0.1 $  $Date: 05/30/2013  9:04:07.846 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com


if ~exist('enum', 'var')
    out_enum = [];
else
    out_enum = enum;
end

spiketimes.timestamps      = 1;
spiketimes.timeindex       = 2;
spiketimes.trial_seq       = 3;
spiketimes.trial_condition = 4;
out_enum.spiketimes = spiketimes;

end % function getEnum

% [EOF]
