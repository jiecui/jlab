function result_dat = AggBalanceCurve(current_tag, sname, S, dat)
% AGGBALANCECURVE accumulated balance curve of realized trades of single pair per strategry
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

% Copyright 2014 Richard J. Cui. Created: Thu 11/27/2014 11:59:13.724 AM
% $Revision: 0.2 $  $Date: Mon 12/01/2014 10:35:45.864 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% Input parameters and options
% =========================================================================
% specific options for the current process
if strcmpi(current_tag,'get_options')
    % get option of date interval of interest  
    
    % absolute interval, relative interval
    opt.abs_rel = { '{Relative}|Absolute', 'Interval type' };
    % relative interval dates
    opt.Relative.rel_int    = { {'7 days', '14 days', '30 days', '60 days', ...
        '90 days', '180 days', '12 months', '{24 months}', 'Inception' }, 'In the last' };
    
    % absolute interval dates
    opt.Absolute.start_MM    = { 1, 'Start Month', [1 12] };
    opt.Absolute.start_dd    = { 1, 'Start Day', [1 31] };
    opt.Absolute.start_yyyy  = { 2010, 'Start Year', [2000, Inf] };
    
    t = datetime('now');
    opt.Absolute.end_MM     = { t.Month, 'End Month', [1 12] };
    opt.Absolute.end_dd     = { t.Day, 'End Day', [1 31] };
    opt.Absolute.end_yyyy   = { t.Year, 'End Year', [2000, Inf] };    
    
    result_dat = opt;
    
    return
end % if

% =========================================================================
% Load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'History' };
    
    result_dat = dat_var;
    
    return
end % if

% =========================================================================
% Data and options
% =========================================================================
% options and paras
abs_rel     = S.Stage_2_Options.([mfilename, '_options']).abs_rel;
start_MM    = S.Stage_2_Options.([mfilename, '_options']).Absolute.start_MM;
start_dd    = S.Stage_2_Options.([mfilename, '_options']).Absolute.start_dd;
start_yyyy  = S.Stage_2_Options.([mfilename, '_options']).Absolute.start_yyyy;
end_MM      = S.Stage_2_Options.([mfilename, '_options']).Absolute.end_MM;
end_dd      = S.Stage_2_Options.([mfilename, '_options']).Absolute.end_dd;
end_yyyy    = S.Stage_2_Options.([mfilename, '_options']).Absolute.end_yyyy;
rel_int     = S.Stage_2_Options.([mfilename, '_options']).Relative.rel_int;

% data
trade_his   = dat.History;

% =========================================================================
% Main process
% =========================================================================
% trade open close
% ----------------
t = trade_his.OpenTime;
[~, idx] = sort(t);
trade_history = trade_his(idx, :);
fmth_p = FMTHistory(height(trade_history));
fmth_p.TradeHistory = trade_history;
trade_openclose = fmth_p.setTradeOpenClose;

% get interval of time
% ---------------------
switch abs_rel
    case 'Absolute'
        date_start = datetime(start_yyyy, start_MM, start_dd, 0, 0, 0);
        date_end   = datetime(end_yyyy, end_MM, end_dd, 24, 0, 0);
        
    case 'Relative'
        date_end   = datetime('now');
        switch rel_int
            case '7 days'
                date_start = date_end - days(6);
            case '14 days'
                date_start = date_end - days(13);
            case '30 days'
                date_start = date_end - days(29);
            case '60 days'
                date_start = date_end - days(59);
            case '90 days'
                date_start = date_end - days(89);
            case '180 days'
                date_start = date_end - days(179);
            case '12 months'
                date_start = date_end - calmonths(11);
            case '24 months'
                date_start = date_end - calmonths(23);
            case 'Inception'
                date_start = trade_history{1, 'OpenTime'};                
        end % switch
end % switch

% fit balance curve in the interval
balequ = BalanceEquity([date_start, date_end], trade_openclose);
[fit_date_accbal, gof] = balequ.fitBalanceCurve;

% quick output
rs = gof.rsquare;
rou = 1 - rs;

date1 = datenum(date_start);
date2 = datenum(date_end);
delta_pl  = fit_date_accbal(date2) - fit_date_accbal(date1);
dur_month = calmonths(between(date_start, date_end));
k = delta_pl / dur_month;

fmout = 'mm/dd/yyyy';
fprintf('\n%s - %s\n', datestr(date_start, fmout), datestr(date_end, fmout))
fprintf('------------------------------------------------------------------\n')
fprintf('1 - r^2\t= %g\n', rou)
fprintf('k(p/m)\t= %g\n', k)
fprintf('\n')

% assemble output
ret_risk.k = k;   % pips/month
ret_risk.rou = rou;   % 1-r^2
BalanceCurve.ReturnRisk = ret_risk;
BalanceCurve.LinearFit  = fit_date_accbal;
BalanceCurve.GOF        = gof;
BalanceCurve.BalanceEquityPips = balequ.BalanceEquityPips;

% =========================================================================
% output
% =========================================================================
result_dat.BalanceCurve = BalanceCurve;

end % function do_BalanceCurve

% [EOF]
