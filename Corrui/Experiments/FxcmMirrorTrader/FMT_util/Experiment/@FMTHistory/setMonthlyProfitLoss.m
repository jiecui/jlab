function [pl_pip, pl_dollar] = setMonthlyProfitLoss( this )
% FMTHISTORY.SETMONTHLYPROFITLOSS calculates the acummulated proft/loss of each month
%
% Syntax:
%
% Input(s):
%
% Output(s):
%   pl_pip      - profit/loss in pips
%   pl_dollar   - profit/loss in dollar
%
% Example:
%
% See also .

% Copyright 2014-2016 Richard J. Cui. Created: Tue 12/02/2014 10:37:27.569 PM
% $Revision: 0.8 $  $Date: Sat 01/30/2016  1:30:24.859 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

curr_pair = this.StrategyProperty.CurrencyPair;
trade_openclose = this.TradeOpenClose;
event_date = trade_openclose.EventDate;

first_date = event_date(1);
last_date  = event_date(end);

% find the begin and end date of each month 
month_int = getMonthStartEnd(first_date, last_date);

% cal monthly profit/loss
% -----------------------
M = size(month_int, 1);     % number of monthes
mon_pips = zeros(M, 1);
mon_cumhigh_pips = zeros(M, 1);
mon_cumlow_pips = zeros(M, 1);
mon_unrel_cumhigh_pips = zeros(M, 1);
mon_unrel_cumlow_pips = zeros(M, 1);

mon_dollars = zeros(M, 1);
mon_cumhigh_dollars = zeros(M, 1);
mon_cumlow_dollars = zeros(M, 1);
mon_unrel_cumhigh_dollars = zeros(M, 1);
mon_unrel_cumlow_dollars = zeros(M, 1);

for k = 1:M
    mint_k = month_int(k, :);   % kth month interval
    [ctrade_k, otrade_k, ptrade_k] = this.getPassCloseOpenTrades(mint_k);
    be_k = BalanceEquity(mint_k, trade_openclose, false, curr_pair);

    % gain in pips
    bep_k = be_k.BalanceEquityPips;
    if ~isempty(bep_k)
        pips_k = bep_k.Realized.Balance;
        cumhigh_pips_k  = bep_k.Realized.CumHigh;
        cumlow_pips_k   = bep_k.Realized.CumLow;
        unrel_cumhigh_pips_k  = bep_k.UnRealized.CumHigh;
        unrel_cumlow_pips_k   = bep_k.UnRealized.CumLow;
    else
        pips_k = 0;
        cumhigh_pips_k = 0;
        cumlow_pips_k = 0;
        unrel_cumhigh_pips_k  = 0;
        unrel_cumlow_pips_k   = 0;
    end % if
    mon_pips(k) = pips_k(end);
    mon_cumhigh_pips(k) = cumhigh_pips_k(end);
    mon_cumlow_pips(k) = cumlow_pips_k(end);
    mon_unrel_cumhigh_pips(k) = unrel_cumhigh_pips_k;
    mon_unrel_cumlow_pips(k) = unrel_cumlow_pips_k;

    % gain in dollars
    bed_k = be_k.BalanceEquityDollars;
    if ~isempty(bed_k)
        dollars_k = bed_k.Realized.Balance;
        cumhigh_dollars_k = bed_k.Realized.CumHigh;
        cumlow_dollars_k = bed_k.Realized.CumLow;
        unrel_cumhigh_dollars_k = bed_k.UnRealized.CumHigh;
        unrel_cumlow_dollars_k = bed_k.UnRealized.CumLow;
    else
        dollars_k = 0;
        cumhigh_dollars_k = 0;
        cumlow_dollars_k = 0;
        unrel_cumhigh_dollars_k = 0;
        unrel_cumlow_dollars_k = 0;        
    end % if
    mon_dollars(k) = dollars_k(end);
    mon_cumhigh_dollars(k) = cumhigh_dollars_k(end);
    mon_cumlow_dollars(k) = cumlow_dollars_k(end);
    mon_unrel_cumhigh_dollars(k) = unrel_cumhigh_dollars_k;
    mon_unrel_cumlow_dollars(k) = unrel_cumlow_dollars_k;
end % for

% submit the table
% -----------------
% in pips
pl_pip = table(month_int(:, 1), month_int(:, 2), mon_pips, ...
    mon_cumhigh_pips, mon_cumlow_pips, mon_unrel_cumhigh_pips, mon_unrel_cumlow_pips);
pl_pip.Properties.VariableNames = this.MonthlyPipsVariableNames;
this.MonthlyPnLPip = pl_pip;

% in dollars
pl_dollar = table(month_int(:, 1), month_int(:, 2), mon_dollars, ...
    mon_cumhigh_dollars, mon_cumlow_dollars, mon_unrel_cumhigh_dollars, mon_unrel_cumlow_dollars);
pl_dollar.Properties.VariableNames = this.MonthlyDollarsVariableNames;
this.MonthlyPnLDollar = pl_dollar;

end % function setMonthlyProfitLoss

% =========================================================================
% subroutines
% =========================================================================
function month_int = getMonthStartEnd(first_date, last_date)

y0 = first_date.Year;   % start year
m0 = first_date.Month;  % start month

y1 = last_date.Year;    % end year
m1 = last_date.Month;   % end month

% num_mon = calmonths(between(first_date, last_date));
num_mon = (m1 - m0 + 1) + 12 * (y1 - y0);

month_int = [];
s0 = datetime(y0, m0, 1, 0, 0, 0);
for m = 1:num_mon
    d0 = s0 + calmonths(m - 1);
    d1 = s0 + calmonths(m) - seconds(0.1);
    int_k = [d0, d1];
    month_int = cat(1, month_int, int_k);
end % for

end % function

% [EOF]
