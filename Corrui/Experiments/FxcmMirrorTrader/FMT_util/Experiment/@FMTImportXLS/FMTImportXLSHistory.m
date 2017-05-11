function [strategy_prop, history] = FMTImportXLSHistory(this)
% FMTIMPORTXLS.FMTIMPORTXLSHISTORY imports history XLS data from MirrorTrader
%
% Syntax:
%   [strategy_prop, history] = FMTImportXLSHistory(this, wholename)
% 
% Input(s):
%   this        - FMTImportXLS object
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: Sun 11/09/2014 12:01:20.154 AM
% $Revision: 0.2 $  $Date: Wed 11/19/2014 10:53:26.935 PM $
%
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com


% reading the raw data
% --------------------
wholename = lower(this.WholeName);
[~, ~, raw] = xlsread(wholename);

his_enum = this.HistoryEnum;
fmthistory = FMTHistory;

% Properties
% ----------
% Strategy
strategy = raw{2, his_enum.strategy};

% currency pair
cur_pair = raw{2, his_enum.symbol};

% max number of positions
max_numpos = this.MaxNumPos;

% Amount
amount = raw{2, his_enum.amount};

strategy_prop.StrategyName = strategy;
strategy_prop.CurrencyPair = cur_pair;
strategy_prop.MaxNumPos    = max_numpos;
strategy_prop.Amount       = amount;

% convert to table
% ----------------
os_type     = this.OSType;
num_tick    = size(raw, 1) - 1;    % number of tickets
A           = zeros(num_tick, 1);    % ticket number

ticket      = A;    % ticket number
order_type  = categorical(A, [0 1], {'Sell', 'Buy'});       % buy or sell
open_time   = datetime(A, 'ConvertFrom', 'datenum', 'Format', fmthistory.DateFormat); % open time
open_price  = zeros(num_tick, 1);    % open price
close_time  = open_time;           % close time
close_price = zeros(num_tick, 1);   % close price
highpips   = zeros(num_tick, 1);    % highest pips relative to open price during the trade
lowpips    = zeros(num_tick, 1);    % lowest pips during the trade
rollover   = zeros(num_tick, 1);
gross_pl   = zeros(num_tick, 1);    % gross profit/loss
pips       = zeros(num_tick, 1);    % realized pips

wh = waitbar(0, 'Reading history data, please wait...');
for k = 1:num_tick
    waitbar(k / num_tick, wh)
    
    raw_k = raw(k + 1, :);
    
    % ticket
    ticket_k = raw_k{his_enum.ticket};
    ticket(k) = ticket_k;
    
    % buy/sell
    buy_k = raw_k{his_enum.buysell};
    switch buy_k
        case 'Buy'
            order_type(k) = 'Buy';
        otherwise
            order_type(k) = 'Sell';
    end % switch
    
    % open time
    opent_k = raw_k{his_enum.open_time};
    % opentime_k = opent_k + date_error;
    open_time(k) = GetTimeInfo(opent_k, os_type);
    
    % open price
    openp_k = raw_k{his_enum.open_price};
    open_price(k) = openp_k;
    
    % close time
    closet_k = raw_k{his_enum.close_time};
    % closetime_k = closet_k + date_error;
    close_time(k) = GetTimeInfo(closet_k, os_type);
    
    % close price
    closep_k = raw_k{his_enum.close_price};
    close_price(k) = closep_k;    
    
    % high/low
    hl_k = raw_k{his_enum.high_low};
    if ischar(hl_k)
        slash_p = regexp(hl_k, '/', 'ONCE');
        if isempty(slash_p)
            high_k = str2double(hl_k);
            low_k = 0;
        else
            high_k = str2double(hl_k(1:slash_p - 1));
            low_k = str2double(hl_k(slash_p + 1:end));
        end % if
    else
        high_k = hl_k;
        low_k = 0;
    end % if
    highpips(k) = high_k;
    lowpips(k) = low_k;
    
    % rolloever
    ro_k = raw_k{his_enum.rollover};
    rollover(k) = ro_k;
    
    % gross profit/loss
    gpl_k = raw_k{his_enum.gross_pl};
    gross_pl(k) = gpl_k;
    
    % pips
    pips_k = raw_k{his_enum.pips};
    pips(k) = pips_k;
    
end % for
close(wh)

history = table(ticket, order_type, open_time, open_price, close_time, close_price, ...
                highpips, lowpips, rollover, gross_pl, pips);
history.Properties.VariableNames = fmthistory.TradeVariableNames;  

% sort history by open_time
open_time = history.OpenTime;
[~, idx] = sort(open_time);
history = history(idx, :);

end % function FMTImportXLSHistory

% =========================================================================
% subroutines
% =========================================================================
function date_out = GetTimeInfo(date_in, os_type)

switch os_type
    case 'WIN'
        date_out = datenum(date_in, 'mm/dd/yyyy HH:MM:SS AM');
    case 'MAC'
        date_out = datetime(date_in, 'ConvertFrom', 'excel');
        
end % switch
end % function

% [EOF]
