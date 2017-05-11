function cum_dif = calCumHighLow(trade_idx, dif)
% BALANCEEQUITY.CALCUMHIGHLOW calculate cummulative high and low
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Sat 01/16/2016  9:52:53.230 AM
% $Revision: 0.1 $  $Date: Sat 01/16/2016  9:52:53.235 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

u_idx = unique(trade_idx);
N = length(u_idx);
num_event = length(trade_idx);
C = zeros(num_event, N);

for k = 1:N
    be_k = find(trade_idx == u_idx(k));
    
    % if just end of a trade
    if length(be_k) == 1;
        a = be_k;
        be_k = [1, a];
    end % if
    
    yn_k = be2yn(be_k(1), be_k(2), num_event);
    dif_k = dif(be_k(2));
    cum_k = yn_k * dif_k;
    
    C(:, k) = cum_k;
    
end % for

cum_dif = sum(C, 2);

end % function calCumHighLow

% [EOF]
