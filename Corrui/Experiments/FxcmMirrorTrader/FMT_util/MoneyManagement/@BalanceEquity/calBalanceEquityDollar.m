function [bal, gain, dd, unrel_gain, unrel_dd] = calBalanceEquityDollar( this, int_openclose, open_trades )
% BALANCEEQUITY.CALBALANCEEQUITYDOLLAR calculate gross profit in USD
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
%   Use the gross P/L provided by the broker.
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Tue 11/24/2015 12:29:39.129 PM
% $Revision: 0.4 $  $Date: Fri 01/22/2016  4:30:08.840 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

if ~isempty(int_openclose)
    % balance
    % -------
    gross_prof = int_openclose.GrossProfitLoss;
    cum_gprof = cumsum(gross_prof);
    
    rollover = int_openclose.Rollover;
    cum_rover = cumsum(rollover);
    bal = cum_gprof + cum_rover;
    
    % maximum gain/dd
    % ---------------
    % get exchange rate
    int_ex = int_openclose.GrossProfitLoss ./ int_openclose.Pips;   % dollar per pip
    int_ex(isnan(int_ex)) = 1;
    
    trade_idx = int_openclose.TradeHistoryIndex;
    % maximum possible gain
    high_dollar = int_openclose.High .* int_ex;
    gain = this.calCumHighLow(trade_idx, high_dollar);
    
    % maximum possible drawdown
    low_dollar = int_openclose.Low .* int_ex;
    dd = this.calCumHighLow(trade_idx, low_dollar);    % dd - drawdown
else
    bal = 0;
    gain = 0;
    dd = 0;
end % if

% need to consider the trades that did not close in this interval
if isempty(open_trades)     % no open trades
    unrel_gain = 0;     % unrealized gain (floating profit)
    unrel_dd = 0;       % unrealized drawdown (floating loss)
else    % exist open trades
    % get exchange rate
    open_ex = open_trades.GrossProfitLoss ./ open_trades.Pips;   % dollar per pip
    open_ex(isnan(open_ex)) = 1;
    
    unrel_gain = sum(open_trades.High .* open_ex);
    unrel_dd  = sum(open_trades.Low .* open_ex);
end % if

end % function calBalanceEquityDollar

% =========================================================================
% subroutines
% =========================================================================

% [EOF]
