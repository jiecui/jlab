function [int_openclose, open_trades] = subTradeopenclose(this, trade_openclose, all_endtrade)
% BALANCEEQUITY.SUBTRADEOPENCLOSE get subset of TradeOpenClose according to interval
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

% Copyright 2014 Richard J. Cui. Created: Thu 11/20/2014 10:49:29.437 AM
% $Revision: 0.4 $  $Date: Mon 02/29/2016  4:32:41.115 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

if ~exist('all_endtrade', 'var')
    all_endtrade = false;
end % if

date_interval = this.DateIntervalOfInterest;
begin_date = date_interval(1);
end_date = date_interval(2);

event_date = trade_openclose.EventDate;
idx = event_date >= begin_date & event_date <= end_date;

if sum(idx) > 0     % events in this interveral
    beg_idx = yn2be(idx);
    int_trade_idx = trade_openclose.TradeHistoryIndex(idx);
    int_trade_type = trade_openclose.EventType(idx);
    partial_idx = PartialTradeIdx(int_trade_idx, int_trade_type, beg_idx, all_endtrade);
    idx(partial_idx) = false;
end % if

int_openclose = trade_openclose(idx, :);

% check the trades that started before DOI and ended after DOI
event_type = trade_openclose.EventType;
thi = trade_openclose.TradeHistoryIndex;
open_idx = event_date < begin_date & event_type == 'Open';
open_thi = thi(open_idx);
% check the close time
long_open_idx = false(height(trade_openclose), 1);
if ~isempty(open_thi)
    u_thi = unique(open_thi);
    for k = 1:length(u_thi)
        idx_k = event_date > end_date & event_type == 'Close' & thi == u_thi(k);
        long_open_idx = long_open_idx | idx_k;
    end % for
end % if
open_trades = trade_openclose(long_open_idx, :);

end % function subTradeopenclose

% =========================================================================
% subroutines
% =========================================================================
function [partial_idx, partial_close_idx, partial_open_idx] = PartialTradeIdx(trade_idx, event_type, beg_idx, all_endtrade)
% get index that is the open or close event of partial trade

p_c_idx = [];   % partial close idx
p_o_idx = [];   % partial open idx

u_idx = unique(trade_idx);
N = length(u_idx);
for k = 1:N
    idx_k = u_idx(k);
    p_k = find(trade_idx == idx_k);
    
    % if length(p_k) ~= 2 && (~all_endtrade || event_type(p_k) == 'Open') %#ok<STCMP>
    %         p_idx = cat(1, p_idx, p_k(:));
    % end % if
    
    if length(p_k) == 1 
        if strcmp(event_type(p_k), 'Close') == true     % partial close
            p_c_idx = cat(1, p_c_idx, p_k(:));
        elseif strcmp(event_type(p_k), 'Open') == true  % partial open
            p_o_idx = cat(1, p_o_idx, p_k(:));
        end % if
    end % if
end % for

% partial_idx = p_idx + beg_idx - 1;
partial_close_idx = p_c_idx + beg_idx - 1;
partial_open_idx = p_o_idx + beg_idx - 1;
if all_endtrade
    partial_idx = partial_open_idx;
else
    partial_idx = [partial_open_idx; partial_close_idx];
end % if

end % fucntion

% [EOF]
