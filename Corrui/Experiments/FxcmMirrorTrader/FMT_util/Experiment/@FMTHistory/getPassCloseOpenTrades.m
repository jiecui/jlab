function [ctrade, otrade, ptrade] = getPassCloseOpenTrades(this, intv)
% FMTHISTORY.GETPASSCLOSEOPENTRADES get infomation about Pass, Close, Open trades
% 
% Syntax:
%
% Input(s):
%   this        - FMTHistroy object
%   intv        - begin and end dates of the interval of interest
%
% Output(s):
%   ctrade      - trades that closed in the intv
%   otrade      - trades that opened but not closed in the intv
%   ptrade      - trades that pass the intv
%
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Mon 02/29/2016  9:48:42.594 PM
% $Revision: 0.1 $  $Date: Mon 02/29/2016  9:48:42.654 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% get trade history
t_his = this.TradeHistory;

% get trade open close info
trade_openclose = this.TradeOpenClose;

% identify pass trades
idx = t_his.OpenTime < intv(1) & t_his.CloseTime > intv(2);
ptrade = getTrades(t_his, idx);     % ???

% identify close trades

% identify open trades


end % function getPassCloseOpenTrades

% =========================================================================
% subroutines
% =========================================================================


% [EOF]
