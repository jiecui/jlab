function [onsetyn, offsetyn] = yn2onoff(yn)
% YN2ONOFF Converts yes/no trials to onset trial and offest trials
%
% Syntax:
%
% Input(s):
%   yn      - Yes/No trials. rows = trials
%
% Output(s):
%   onsetyn   - onset trials. rows = trials
%   onffsetyn - offset trials. rows = trials
%
% Example:
%
% See also yn2be.

% Copyright 2012 Richard J. Cui. Created: 07/03/2012  1:24:16.097 PM
% $Revision: 0.1 $  $Date: 07/03/2012  1:24:16.113 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

[T, S] = size(yn);

onsetyn = zeros(T, S);
offsetyn = onsetyn;

for k = 1:T     % trial by trial
    
    yn_k = yn(k, :);
    [begin_k, end_k] = yn2be(yn_k);
    onsetyn(k, begin_k) = 1;
    offsetyn(k, end_k) = 1;
    
end % for


end % function yn2onset

% [EOF]
