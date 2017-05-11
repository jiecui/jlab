function trade_openclose = setTradeOpenClose( this )
% FMHISTORY.SETTRADEOPENCLOSE get table of TradeOpenClose
%
% Syntax:
%   trade_openclose = setTradeOpenClose( this )
% 
% Input(s):
%   this        - FMTHistory object
% 
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014-2015 Richard J. Cui. Created: Wed 11/19/2014  9:41:50.640 PM
% $Revision: 0.4 $  $Date: Mon 02/29/2016 12:23:49.181 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

trade_history = this.TradeHistory;

num_trades = height(trade_history);
trade_idx = (1:num_trades)';

% open table
open_table1 = trade_history(:, { 'OpenTime', 'OrderType' });
open_table1.Properties.VariableNames{1} = 'EventDate';

event_type = categorical(zeros(num_trades, 1), 0, {'Open'});
open_table2 = table(trade_idx, event_type);
open_table2.Properties.VariableNames = { 'TradeHistoryIndex', 'EventType' };

open_table = [open_table1, open_table2];

% close table
close_table1 = trade_history(:, { 'CloseTime', 'OrderType' });
close_table1.Properties.VariableNames{1} = 'EventDate';

event_type = categorical(ones(num_trades, 1), 1, { 'Close' });
close_table2 = table(trade_idx, event_type);
close_table2.Properties.VariableNames = { 'TradeHistoryIndex', 'EventType' };

close_table = [close_table1, close_table2];


% TradeOpenClose
toc = [open_table; close_table];
toc = toc(:, { 'EventDate', 'EventType', 'OrderType', 'TradeHistoryIndex' });

event_date = toc.EventDate;
[~, idx] = sort(event_date);

trade_openclose = toc(idx, :);
this.TradeOpenClose = trade_openclose;

end % function setTradeOpenClose

% [EOF]
