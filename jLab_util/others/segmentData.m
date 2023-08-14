function Y = segmentData(X, L, step)
% SEGMENTDATA segment data into non/overlapping data segments
%
% Syntax:
%   seg_x = segmentData(X, L)
% 
% Input(s):
%   X       - import data: signal length x number of variables
%   L       - segment length
%   step    - step of L segment; if step = 0, find the minimum number of
%             segments to cover the length of signal
% 
% Output(s):
%   Y       - segmented data: segment length x number of segments x number
%             of variables
% Example:
%
% See also .

% Copyright 2015 Richard J. Cui. Created: Fri 02/06/2015  5:16:09.699 PM
% $Revision: 0.1 $  $Date: Fri 02/06/2015  5:16:09.708 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

if ~exist('step', 'var') || step < 0
    step = 0;
end % if

if isrow(X)
    X = X(:);
end % if

N = size(X, 1);

if N < L
    Y = [];
    return
end % if

seg_start = getSegStartPos(N, L, step);

y = [];
M = numel(seg_start);
for k = 1:M
    start_k = seg_start(k);
    end_k = start_k + L - 1;
    
    y_k = X(start_k:end_k, :);
    y = cat(3, y, y_k);
end % for

Y = permute(y, [1, 3, 2]);

end % function segmentData

% =========================================================================
% subroutines
% =========================================================================
function seg_start = getSegStartPos(N, L, step)
% get start positions of segments

n = floor(N / L);
m = rem(N, L);

if step > 0
    k = floor(N / step);
    p = 1:k;
    seg_start = step * (p - 1) + 1;
else
    p = 1:n;
    s = L * (p - 1) + 1;
    if m > 0
        seg_start = [s, N - L + 1];
    else
        seg_start = s;
    end % if
end % if

end % function

% [EOF]
