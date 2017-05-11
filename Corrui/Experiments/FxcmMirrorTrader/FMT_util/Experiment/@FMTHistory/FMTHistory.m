classdef FMTHistory < handle
    % Class FMTHISTORY trading history of a MirrorTrader strategy for a currenty pair
    
    % Copyright 2014-2015 Richard J. Cui. Created: Wed 11/19/2014 11:18:41.408 AM
    % $Revision: 0.3 $  $Date: Sat 01/30/2016  1:21:48.138 PM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com
    
    properties
        StrategyProperty    % strategy properties: name, pair, amount, max #pos
        TradeHistory        % trading history of this strategy on this current pair
        TradeOpenClose      % table of open and close of trades
        MonthlyPnLPip       % monthly profit/loss in pip
        MonthlyPnLDollar    % monthly profit/loss in dollar
    end % properties
    
    properties (SetAccess = protected)
        DateFormat = 'eee MM/dd/yyyy HH:mm:ss';
        TradeVariableNames = { 'Ticket', 'OrderType', 'OpenTime', 'OpenPrice', ...
            'CloseTime', 'ClosePrice', 'High', 'Low', ...
            'Rollover', 'GrossProfitLoss', 'Pips' };
        TradeVairableUnits = { '', '', '', '', '', '', 'Pip', 'Pip', ...
            'Dollar', 'Dollar', 'Pip' };
        TradeVariableDescription = { 'Trade ticket', 'Buy or Sell order', ...
            'Open time of the trade', 'Open price of the trade', ...
            'Close time of the trade', 'Close price of the trade', ...
            'Highest profit during the trade', 'Worst drawdown during the trade', ...
            'Rollover fee', 'Gross profit or loss', ...
            'Gross profit or loss in pips' };
        MonthlyPipsVariableNames = { 'StartDate', 'EndDate', 'Pips', ...
            'CumHigh', 'CumLow', 'UnRelCumHigh', 'UnRelCumLow' };
        MonthlyDollarsVariableNames = { 'StartDate', 'EndDate', 'Dollars', ...
            'CumHigh', 'CumLow', 'UnRelCumHigh', 'UnRelCumLow' };
    end % properties (protected)
    
    methods     % the constructor
        function this = FMTHistory(num_trades, strat_prop)
            % initialize StrategyProperty
            if ~exist('strat_prop', 'var')
                strat_prop.StrategyName = '';
                strat_prop.CurrencyPair = '';
                strat_prop.MaxNumPos    = 0;
                strat_prop.Amount       = 0;
            end % if
            this.StrategyProperty   = strat_prop;
            
            % initialize TradeHistory
            if ~exist('num_trades', 'var') || num_trades == 0   % empty history
                trades = table;
            else
                A = zeros(num_trades, 1);
                
                ticket = A;
                order_type  = categorical(A, [0 1], {'Sell', 'Buy'});
                open_time   = datetime(A, 'ConvertFrom', 'datenum', 'Format', this.DateFormat);
                open_price  = A;
                close_time  = open_time;
                close_price = open_price;
                high_gain   = A;
                low_drawdown = A;
                rollover    = A;
                grosspl     = A;
                pips        = A;
                trades = table(ticket, order_type, open_time, open_price, ...
                                close_time, close_price, high_gain, low_drawdown, ...
                                rollover, grosspl, pips);
                
                trades.Properties.VariableNames = this.TradeVariableNames;
                trades.Properties.VariableUnits = this.TradeVairableUnits;
                trades.Properties.VariableDescriptions = this.TradeVariableDescription;
            end % if
            this.TradeHistory = trades;
            
        end
    end % methods
    
    methods
        trade_openclose = setTradeOpenClose( this )     % get table of TradeOpenClose
        int_tradehistory = subTradeHistory( this, int_datetime)     % get trade history in the date interval
        [pl_pip, pl_dollar] = setMonthlyProfitLoss( this )     % get monthly profit loss
        [ctrade, otrade, ptrade] = getPassCloseOpenTrades(this, intv)   % get infomation about Pass, Close, Open trades
    end % methods
    
end % classdef

% [EOF]
