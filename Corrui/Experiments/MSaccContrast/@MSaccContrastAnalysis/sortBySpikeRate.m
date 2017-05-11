function sorted_trialnum = sortBySpikeRate(fr_yn, cont_onset, intv, numCondition)
% SORTBYSPIKERATE (archaic)
%
% Syntax:
%
% Input(s):
%   numCondition    - number condition indexes range
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 10/31/2012  3:58:58.398 PM
% $Revision: 0.2 $  $Date: Thu 11/01/2012  8:50:09.750 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

if ~exist('numCondition', 'var')
    error('Please input number indexes of condtions')
end % if

N = length(numCondition);
M = size(fr_yn, 1);
sorted_trialnum = zeros(M, N);

for k = 1:N
    cond_k = numCondition(k);
    x_k = squeeze(fr_yn(:, cont_onset:cont_onset + intv -1, cond_k));
    fr_k = sum(x_k, 2);     % number of spikes in the interval
    [~, idx_k] = sort(fr_k);    % from week to strong
    
    sorted_trialnum(:, k) = idx_k;
end % for

end % function sortBySpikeRate

% [EOF]
