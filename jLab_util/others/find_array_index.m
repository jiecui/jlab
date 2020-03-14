function c = find_array_index(a, b)
% FIND_ARRAY_INDEX (summary)
%
% Syntax:
%   c = find_array_index(a, b)
%   
% Input(s):
%   a       - an array
%   b       - an array to be found indexes of its element in array a
%   
% Output(s):
%   c       - indexes of element b in a. If cannot be found, NaN. If more
%             than one in a, choose the first one.
%   
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 11/16/2012  3:09:06.952 PM
% $Revision: 0.1 $  $Date: 11/16/2012  3:09:06.952 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

N = length(b);
c = zeros(N, 1);

for k = 1:N
    b_k = b(k);
    idx_k = find(a == b_k, 1, 'first');
    if isempty(idx_k)
        c(k) = NaN;
    else
        c(k) = idx_k;
    end % if
end % for
end % function find_array_index

% [EOF]
