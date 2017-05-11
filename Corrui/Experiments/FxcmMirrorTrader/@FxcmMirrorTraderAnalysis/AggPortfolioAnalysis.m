function result_dat = AggPortfolioAnalysis(current_tag, sname, S, dat)
% FXCMMIRRORTRADERANALYSIS.AGGPORTFOLIOANALYSIS portfolio analysis of a given asset universe
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

% Copyright 2014-2015 Richard J. Cui. Created: Mon 12/22/2014 12:15:22.994 PM
% $Revision: 0.2 $  $Date: Tue 02/24/2015  2:38:54.712 PM $
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
    
    % number of portofolio to estimate on efficient frontier
    opt.num_port_frontier   = { 100, 'Number of Port on Frontier', [1 Inf] };
    
    % target return & risk
    opt.target_ret          = { 3000, 'Target Return (annualized)', [0 Inf] };
    opt.target_risk         = { 1000, 'Target Risk (annualized)', [0 Inf] };
    
    % assignment of positions
    opt.total_pos           = { 500, 'Total positions (k)', [1 Inf] };
    
    result_dat = opt;
    
    return
end % if

% =========================================================================
% Load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'MonthlyReturn' 'Property' 'concatenated_vars' };
    
    result_dat = dat_var;
    
    return
end % if

% =========================================================================
% Data and options
% =========================================================================
% options and paras
% -----------------
abs_rel     = S.Stage_2_Options.([mfilename, '_options']).abs_rel;
start_MM    = S.Stage_2_Options.([mfilename, '_options']).Absolute.start_MM;
start_dd    = S.Stage_2_Options.([mfilename, '_options']).Absolute.start_dd;
start_yyyy  = S.Stage_2_Options.([mfilename, '_options']).Absolute.start_yyyy;
end_MM      = S.Stage_2_Options.([mfilename, '_options']).Absolute.end_MM;
end_dd      = S.Stage_2_Options.([mfilename, '_options']).Absolute.end_dd;
end_yyyy    = S.Stage_2_Options.([mfilename, '_options']).Absolute.end_yyyy;
rel_int     = S.Stage_2_Options.([mfilename, '_options']).Relative.rel_int;
num_port_frontier = S.Stage_2_Options.([mfilename, '_options']).num_port_frontier;
target_ret  = S.Stage_2_Options.([mfilename, '_options']).target_ret;
target_rsk  = S.Stage_2_Options.([mfilename, '_options']).target_risk;
total_pos   = S.Stage_2_Options.([mfilename, '_options']).total_pos;

% data
% ----
monthly_ret     = dat.MonthlyReturn;
property        = dat.Property;
conct_vars      = dat.concatenated_vars;

% get interval of time
% ---------------------
switch abs_rel
    case 'Absolute'
        date_start = datetime(start_yyyy, start_MM, start_dd, 0, 0, 0);
        date_end   = datetime(end_yyyy, end_MM, end_dd, 24, 0, 0) - seconds(0.01);
        
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
                date_start = getDateRange(AssetInfo, mon_return);                
        end % switch
end % switch

% =========================================================================
% Main process
% =========================================================================
% protfolio analysis
% -------------------
% create the Portfolio Object
p = FMTPortfolio(property, monthly_ret, conct_vars);

% implement the Portfolio
p = setPortMV(p, date_start, date_end, sname);

% set the initial portfolio
p = setInitPort(p, 1/p.NumAssets );
[ersk, eret] = estimatePortMoments(p, p.InitPort);

% est efficient frontier
[p, ~, prsk, pret] = estEffFrontPortMV(p, num_port_frontier);
info_ratio = pret ./ prsk * sqrt(12);

% Find portfolio with a targeted return or a targeted risk
mon_targret = target_ret / 12;  % monthly target return
mon_targrsk = target_rsk / sqrt(12);  % monthly target risk

[awgt, arsk, aret] = estTargPortByReturn(p, mon_targret);
[bwgt, brsk, bret] = estTargPortByRisk(p, mon_targrsk);

% get porportion of positions
aprop = total_pos * awgt;
bprop = total_pos * bwgt;


% -----------
% quick check
% -----------
figure
portfolioexamples_plot('Efficient Frontier', ...
	{'line', prsk, pret}, ...
    {'scatter', ersk, eret, {'Equal'}}, ...
    {'scatter', arsk, aret, {sprintf('%g Return',target_ret)}}, ...
    {'scatter', brsk, bret, {sprintf('%g Risk',target_rsk)}}, ...
    {'scatter', sqrt(diag(p.AssetCovar)), p.AssetMean, p.AssetList, '.r'});

% targeted risk and return
targrsk_table = array2table([bwgt, bprop], 'RowNames', p.AssetList, ...
    'VariableNames', { 'Portfolio' 'Position'});
fprintf('\nPortfolio and position of Targeted Risk %g\n', target_rsk)
disp(targrsk_table)

% targret_table = array2table(awgt', 'VariableName', p.AssetList);
targret_table = array2table([awgt, aprop], 'RowNames', p.AssetList, ...
    'VariableNames', { 'Portfolio' 'Position'});
fprintf('\nPortfolio and position of Targeted Return %g\n', target_ret)
disp(targret_table)

figure
plot(pret * 12, info_ratio)
grid on
hold on
plot(target_ret * ones(1,2), ylim, 'r')
hold off
xlabel('Mean of Returns (Annualized)')
ylabel('Information Ratio')

% =========================================================================
% output
% =========================================================================
result_dat.PortMV = p;

end % function do_BalanceCurve

% =========================================================================
% subroutines
% =========================================================================
function [earliest_date, latest_date] = getDateRange(asset_info, mon_return)

num_sess = height(asset_info);
asset_names = asset_info.AssetName;
start_date = datetime(zeros(num_sess, 1), 'ConvertFrom', 'datenum');
end_date = start_date;

for k = 1:num_sess
    startdate_k = mon_return.(asset_names{k}).StartDate(1);
    enddate_k = mon_return.(asset_names{k}).EndDate(end);
    
    start_date(k) = startdate_k;
    end_date(k) = enddate_k;
    
end % for

earliest_date = min([start_date; end_date]);
latest_date = max([start_date; end_date]);

end % function

% [EOF]
