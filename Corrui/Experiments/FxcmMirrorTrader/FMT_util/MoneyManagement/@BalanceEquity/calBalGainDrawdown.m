function [bal, gain, dd, unrel_gain, unrel_dd] = calBalGainDrawdown(this, int_openclose, open_trades)
% BALANCEEQUITY.CALBALGAINDRAWDOWN calculates balance, gain and drawdown
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014-2016 Richard J. Cui. Created: Thu 11/20/2014 11:49:37.916 AM
% $Revision: 0.5 $  $Date: Thu 01/21/2016  4:12:27.801 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

if ~isempty(int_openclose)
    % balance
    pips = int_openclose.Pips;
    bal = cumsum(pips);
    
    trade_idx = int_openclose.TradeHistoryIndex;
    % maximum possible gain
    high_pips = int_openclose.High;
    gain = this.calCumHighLow(trade_idx, high_pips);
    
    % maximum possible drawdown
    low_pips = int_openclose.Low;
    dd = this.calCumHighLow(trade_idx, low_pips);    % dd - drawdown
else
    bal = 0;
    gain = 0;
    dd = 0;
end % if

% need to consider the trades that did not close in this interval
if isempty(open_trades)     % no open trades
    unrel_gain = 0;     % unrealized gain (floating profit)
    unrel_dd = 0;       % unrealized drawdown (floating loss)
else    % exit open trades
    unrel_gain = sum(open_trades.High);
    unrel_dd  = sum(open_trades.Low);
end % if

end % function calBalGainDrawdown

% =========================================================================
% subroutines
% =========================================================================

% [EOF]
