function [lower,upper] = binsearch(R,K)
% binsearch.m
% Binary search of an ordered table.
%
% B1. Initialize
lower = 1;
upper = length(R);
%
% B2. Get midpoint
while (upper >= lower)
    mid = floor(0.5*(lower+upper));
    %
    % B3. Compare
    if (K < R(mid))
        %
        % B4. Adjust upper
        upper = mid-1;
    elseif (K > R(mid))
        %
        % B5. Adjust lower
        lower = mid+1;
    else
        break
    end
end
temp = lower;
lower = upper;
upper = temp;