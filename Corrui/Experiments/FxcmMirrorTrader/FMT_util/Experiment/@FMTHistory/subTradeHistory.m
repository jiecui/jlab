function int_tradehistory = subTradeHistory( this, int_datetime)
% SUBTRADEHISTORY (summary)
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

% Copyright 2014 Richard J. Cui. Created: Mon 12/01/2014 10:46:56.288 PM
% $Revision: 0.1 $  $Date: Mon 12/01/2014 10:46:56.298 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

date_start = int_datetime(1);
date_end = int_datetime(2);

trade_history = this.TradeHistory;

open_date = trade_history.OpenTime;
close_date = trade_history.CloseTime;
idx = open_date >= date_start & close_date <= date_end;

int_tradehistory = trade_history(idx, :);

end % function subTradeHistory

% [EOF]
