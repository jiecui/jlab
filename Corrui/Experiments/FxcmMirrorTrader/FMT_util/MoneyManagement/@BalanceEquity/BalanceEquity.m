classdef BalanceEquity < handle
    % Class BALANCEEQUITY balance and equity for money management
    
    % Copyright 2014-2016 Richard J. Cui. Created: Thu 11/20/2014 10:29:00.699 AM
    % $Revision: 0.9 $  $Date: Mon 02/29/2016  4:20:43.107 PM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com
    
    properties
        CurrencyPair            % the instrument
        DateIntervalOfInterest
        BalanceEquityPips       % in Pips
        BalanceEquityDollars    % in US dollaors
    end % properties
    
    properties (SetAccess = protected)
        BEVariableNames = { 'EventDate', 'Balance', 'CumHigh', 'CumLow' };
        FitType = 'poly1';      % model of fitting balance curve
    end % properties
    
    methods
        function this = BalanceEquity(date_interval, trade_openclose, all_end_trade, curr_pair)
            % Inputs:
            %   date_interval   - [begin date, end date], datetime type
            %   trade_openclose - TradeOpenClose table
            %   all_end_trade   - only count in the trade ending in this interval
            
            if ~exist('all_end_trade', 'var')
                all_end_trade = false;
            end % if
            
            if ~exist('curr_pair', 'var')
                curr_pair = ''; 
            end % if
            this.CurrencyPair = curr_pair;
            this.DateIntervalOfInterest = date_interval;
            
            [int_openclose, open_trades] = this.subTradeopenclose(trade_openclose, all_end_trade);
            % curve of balance-equity
            % -------------------------------
            %             if ~isempty(int_openclose)
            %                 [bal, gain, dd] = this.calBalGainDrawdown(int_openclose, open_trades);
            %                 t = table(bal, gain, dd);
            %                 bep = [int_openclose(:, { 'EventDate' }), t];
            %                 bep.Properties.VariableNames = this.BEVariableNames;
            %             else
            %                 bep = [];
            %             end % if
            %             this.BalanceEquityPips = bep;
            %
            %             % curve of gross balance-equity in USD
            %             % ------------------------------------
            %             if ~isempty(int_openclose)
            %                 [bal, gain, dd] = this.calBalanceEquityDollar(trade_openclose, open_trades);
            %                 t = table(bal, gain, dd);
            %                 bed = [int_openclose(:, { 'EventDate' }), t];
            %                 bed.Properties.VariableNames = this.BEVariableNames;
            %             else
            %                 bed = [];
            %             end % if
            %             this.BalanceEquityDollars = bed;
            
            if ~isempty(int_openclose)
                % in pips
                bep = getBalanceEquityPip(this, int_openclose, open_trades);
                bed = getBalanceEquityDollar(this, int_openclose, open_trades);
            else
                bep = [];
                bed = [];
            end % if
            this.BalanceEquityPips = bep;
            this.BalanceEquityDollars = bed;
        end
    end % methods
    
    methods
        [int_openclose, open_trades] = subTradeopenclose(this, int_openclose, all_end_trade)    % get partial TradeOpenClose
        [bal, gain, dd, unrel_gain, unrel_dd] = calBalGainDrawdown(this, int_openclose, open_trades)   % calculate balance, gain and drawdown at each event date
        [fitobj, gof] = fitBalanceCurve( this )     % fit Balance curve
        [bal, gain, dd, unrel_gain, unrel_dd] = calBalanceEquityDollar( this, trade_openclose, open_trades )    % cal balance-equity curve in USD
        bep = getBalanceEquityPip(this, int_openclose, open_trades) % get balance/equity in pips
        bed = getBalanceEquityDollar(this, int_openclose, open_trades) % get balance/equity in dollar
        be = BETable(this, bal, gain, dd, unrel_gain, unrel_dd, int_openclose) % construct balance/equity table
    end % methods
    
    methods (Static = true)
        cum_dif = calCumHighLow(trade_idx, dif)     % calculate cummulative high and low
    end % static methods
    
end % classdef

% =========================================================================
% subroutines
% =========================================================================

% [EOF]
