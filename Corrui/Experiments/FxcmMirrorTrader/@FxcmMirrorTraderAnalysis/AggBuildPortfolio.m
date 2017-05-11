function result_dat = AggBuildPortfolio(current_tag, sname, S, dat)
% FXCMMIRRORTRADERANALYSIS.AGGBUILDPORTFOLIO builds portfolio from the given asset universe
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%   Choose m assets from n given assets to build the opitmal portifolio
%   according to the given criterion.
% 
% See also .

% Copyright 2015 Richard J. Cui. Created: Mon 12/22/2014 12:15:22.994 PM
% $Revision: 0.2 $  $Date: Mon 02/23/2015  3:31:33.510 PM $
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
    % ---------------------------------------
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
    % -------------------------------------------------------
    opt.num_port_frontier   = { 100, 'Number of Port on Frontier', [1 Inf] };
    
    % creteria for building portfolio
    % --------------------------------
    opt.num_selassets       = { 8, 'Number of selected assets', [1 Inf] };
    opt.build_cret          = { {'{Weight ranking given return}' 'Max retrun given risk' ...
        'Min risk given return' 'Max Info-ratio'}, 'Criterion to choosing assets' };
    % target return & risk
    opt.target_ret          = { 3000, 'Target Return (annualized)', [0 Inf] };
    opt.target_risk         = { 1000, 'Target Risk (annualized)', [0 Inf] };
    
    % assignment of positions
    % -----------------------
    opt.target_pos           = { 500, 'Target positions (k)', [1 Inf] };
    
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
num_selassets     = S.Stage_2_Options.([mfilename, '_options']).num_selassets;
build_cret  = S.Stage_2_Options.([mfilename, '_options']).build_cret;
target_ret  = S.Stage_2_Options.([mfilename, '_options']).target_ret;
target_rsk  = S.Stage_2_Options.([mfilename, '_options']).target_risk;
target_pos   = S.Stage_2_Options.([mfilename, '_options']).target_pos;

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

% implement the Portfolio according to criterion
switch build_cret
    case 'Weight ranking given return'
        p = setWeiRankAtRetPortMV(p, num_selassets, date_start, date_end, ...
            sname, num_port_frontier, target_ret);
        
    case 'Max retrun given risk'
        p = setMaxRetAtRiskPortMV(p, num_selassets, date_start, date_end, ...
            sname, num_port_frontier, target_rsk);
        
    case 'Min risk given return'
        p = setMinRiskAtRetPortMV(p, num_selassets, date_start, date_end, ...
            sname, num_port_frontier, target_ret);
        
    case 'Max Info-ratio'
        p = setMaxInfoRatioPortMV(p, num_selassets, date_start, date_end, ...
            sname, num_port_frontier);
        
    otherwise
        error('FxcmMirrorTraderAnalysis:AggBuildPortfolio', 'Unknown criterion to buiding portfolio.')
        
end % switch

% Brief report
% -------------------
% (1) est efficient frontier
[p, Port, prsk, pret] = estEffFrontPortMV(p, num_port_frontier);

% (2) set the initial portfolio for comparison
p = setInitPort(p, 1/p.NumAssets);
[rsk_ip, ret_ip] = estimatePortMoments(p, p.InitPort);

% (3) portfolio with the targeted return
mon_targret = target_ret / 12;  % monthly target return
[wgt_tagret, rsk_tagret, ret_tagret] = estTargPortByReturn(p, mon_targret);
if ~isempty(wgt_tagret)
    [prop_tagret, realpos_tagret] = allocatePositions(p, target_pos, wgt_tagret);
    targret_table = array2table([wgt_tagret, p.AssetInfo.MaxNumPos, prop_tagret],...
        'RowNames', p.AssetList, 'VariableNames', { 'Portfolio' 'MaxNumPos' 'PosAmount' });
end % if

% (4) portfolio with a targeted risk
mon_targrsk = target_rsk / sqrt(12);  % monthly target risk
[wgt_tagrsk, rsk_tagrsk, ret_tagrsk] = estTargPortByRisk(p, mon_targrsk);
if ~isempty(wgt_tagrsk)
    [prop_tagrsk, realpos_tagrsk] = allocatePositions(p, target_pos, wgt_tagrsk);
    targrsk_table = array2table([wgt_tagrsk,  p.AssetInfo.MaxNumPos, prop_tagrsk], ...
        'RowNames', p.AssetList, 'VariableNames', { 'Portfolio' 'MaxNumPos' 'PosAmount'});
end % if

% (5) portfolio at maximum infomation ratio
info_ratio = pret ./ prsk * sqrt(12);
[~, idx] = max(info_ratio);
wgt_maxinforatio = Port(:, idx);
[rsk_mir, ret_mir] = estimatePortMoments(p, wgt_maxinforatio);
[prop_mir, realpos_mir] = allocatePositions(p, target_pos, wgt_maxinforatio);
mir_table = array2table([wgt_maxinforatio, p.AssetInfo.MaxNumPos, prop_mir], ...
    'RowNames', p.AssetList, 'VariableNames', { 'Portfolio' 'MaxNumPos' 'PosAmount' });

% -----------
% quick check
% -----------
% (1) visualization
figure
portfolioexamples_plot('Efficient Frontier', ...
	{'line', prsk, pret}, ...
    {'scatter', rsk_ip, ret_ip, {'Equal'}}, ...
    {'scatter', rsk_tagret, ret_tagret, {sprintf('%g Return',target_ret)}}, ...
    {'scatter', rsk_tagrsk, ret_tagrsk, {sprintf('%g Risk',target_rsk)}}, ...
    {'scatter', rsk_mir, ret_mir, {'MaxIR'}}, ...
    {'scatter', sqrt(diag(p.AssetCovar)), p.AssetMean, p.AssetList, '.r'});

figure
plot(pret * 12, info_ratio)
grid on
hold on
if isempty(ret_tagret)
    ret_tagret = NaN;
end % if
if isempty(ret_tagrsk)
    ret_tagrsk = NaN;
end % if
plot(12 * ones(2, 1) * [ret_ip, ret_tagret, ret_tagrsk, ret_mir], ylim' * ones(1, 4))
hold off
legend('InfoRatio', 'Equal', 'TRetrun', 'TRisk', 'MaxIR')
xlabel('Mean of Returns (Annualized)')
ylabel('Information Ratio')

% (2) report on targeted return
if ~isempty(wgt_tagret)
    cprintf('Text', '\nPortfolio and position of Targeted Retrun %g\n', target_ret)
    disp(targret_table)
    cprintf('Text', 'Target position: %g k\tReal position: %g k\n', target_pos, realpos_tagret)
end % if

% (3) report on targeted risk
if ~isempty(wgt_tagrsk)
    cprintf('Text', '\nPortfolio and position of Targeted Risk %g\n', target_rsk)
    disp(targrsk_table)
    cprintf('Text', 'Target position: %g k\tReal position: %g k\n', target_pos, realpos_tagrsk)
end % if

% (4) report on max info-ratio
cprintf('Text', '\nPortfolio and position of Max Info-Ratio\n')
disp(mir_table)
cprintf('Text', 'Target position: %g k\tReal position: %g k\n', target_pos, realpos_mir)

% =========================================================================
% output
% =========================================================================
result_dat.PortTargetReturn = targret_table;
result_dat.PortTargetRisk   = targrsk_table;
result_dat.PortMaxInfoRatio = mir_table;

end % function do_BalanceCurve

% =========================================================================
% subroutines
% =========================================================================
function [prop, real_pos] = allocatePositions(p, target_pos, wgt)

ass_info = p.AssetInfo;
max_pos = ass_info.MaxNumPos;

prop = round(target_pos * wgt ./ max_pos);     % k/position

real_pos = sum(prop .* max_pos);

end % function

function p = setMaxInfoRatioPortMV(p, num_selassets, date_start, date_end, ...
    sname, num_port_frontier)
% choose the portfolio that has the maximum info-ration

p_all = setPortMV(p, date_start, date_end, sname);
num_assets = p_all.NumAssets;
if num_assets < num_selassets
    cprintf([1 0.5 0], 'Total number of assets is smaller than the number of selected assets. Use all.\n')
    num_selassets = num_assets;
end % if

N = nchoosek(num_assets, num_selassets);
sel = nchoosek(1:num_assets, num_selassets);

mir = zeros(1, N);   % max info-ratio
wh = waitbar(0, 'Estimating selected portfolio...');
for k = 1:N
    waitbar((k - 1) / N, wh)
    
    sel_k = sel(k, :);
    p_k = setSubPortMV(p, sel_k, date_start, date_end, sname);
    [~, ~, rsk_k, ret_k] = estEffFrontPortMV(p_k, num_port_frontier);
    if isempty(rsk_k) || isempty(ret_k)
        mir(k) = NaN;
    else
        mir(k) = max(ret_k ./ rsk_k * sqrt(12));
    end % if
end % for
waitbar(1, wh)
close(wh)

% find the max of max info-ratio
[~, idx] = max(mir);

p = setSubPortMV(p, sel(idx, :), date_start, date_end, sname);

end % function

function p = setMinRiskAtRetPortMV(p, num_selassets, date_start, date_end, ...
    sname, num_port_frontier, target_ret)
% choose the portfolio to minimize the risk at given return

p_all = setPortMV(p, date_start, date_end, sname);
num_assets = p_all.NumAssets;
if num_assets < num_selassets
    cprintf([1 0.5 0], 'Total number of assets is smaller than the number of selected assets. Use all.\n')
    num_selassets = num_assets;
end % if
mon_targret = target_ret / 12;

N = nchoosek(num_assets, num_selassets);
sel = nchoosek(1:num_assets, num_selassets);

rsk = zeros(1, N);
wh = waitbar(0, 'Estimating selected portfolio...');
for k = 1:N
    waitbar((k - 1) / N, wh)
    
    sel_k = sel(k, :);
    p_k = setSubPortMV(p, sel_k, date_start, date_end, sname);
    p_k = estEffFrontPortMV(p_k, num_port_frontier);
    [~, rsk_k] = estTargPortByReturn(p_k, mon_targret);
    if isempty(rsk_k)
        rsk(k) = NaN;
    else
        rsk(k) = rsk_k;
    end % if
end % for
waitbar(1, wh)
close(wh)

% find the port with the min risk
[~, idx] = min(rsk);

p = setSubPortMV(p, sel(idx, :), date_start, date_end, sname);

end % function

function p = setMaxRetAtRiskPortMV(p, num_selassets, date_start, date_end, ...
    sname, num_port_frontier, target_rsk)
% choose the portolio to maximize the retrun at given risk

p_all = setPortMV(p, date_start, date_end, sname);
num_assets = p_all.NumAssets;
if num_assets < num_selassets
    cprintf([1 0.5 0], 'Total number of assets is smaller than the number of selected assets. Use all.\n')
    num_selassets = num_assets;
end % if
mon_targrsk = target_rsk / sqrt(12);

N = nchoosek(num_assets, num_selassets);
sel = nchoosek(1:num_assets, num_selassets);

ret = zeros(1, N);
wh = waitbar(0, 'Estimating selected portfolio...');
for k = 1:N
    waitbar((k - 1) / N, wh)
    
    sel_k = sel(k, :);
    p_k = setSubPortMV(p, sel_k, date_start, date_end, sname);
    p_k = estEffFrontPortMV(p_k, num_port_frontier);
    [~, ~, ret_k] = estTargPortByRisk(p_k, mon_targrsk);
    if isempty(ret_k)
        ret(k) = NaN;
    else
        ret(k) = ret_k;
    end % if
end % for
waitbar(1, wh)
close(wh)

% find the port with the max return
[~, idx] = max(ret);

p = setSubPortMV(p, sel(idx, :), date_start, date_end, sname);

end % function

function p = setSubPortMV(p, sub_idx, date_start, date_end, sname)

p_sel = p;
ass_info = p.AssetInfo;
p_sel.AssetInfo = ass_info(sub_idx, :);
p_sel.NumAssets = numel(sub_idx);
p_sel.LowerBound = numel(sub_idx);

p = setPortMV(p_sel, date_start, date_end, sname);

end % function

function p = setWeiRankAtRetPortMV(p, num_selassets, date_start, date_end, ...
    sname, num_port_frontier, target_ret)
% choose the portfolio according to the weight ranking at given retrun

p_all = setPortMV(p, date_start, date_end, sname);
p_all = estEffFrontPortMV(p_all, num_port_frontier);

mon_targret = target_ret / 12;  % monthly target return
wgt = estTargPortByReturn(p_all, mon_targret);

[~, idx] = sort(wgt, 'descend');
% p_sel = p_all;
% ass_info = p_all.AssetInfo;
% p_sel.AssetInfo = ass_info(idx(1:num_selassets), :);
% p_sel.NumAssets = num_selassets;
% p_sel.LowerBound = num_selassets;
% 
% p = setPortMV(p_sel, date_start, date_end, sname);
p = setSubPortMV(p, idx(1:num_selassets), date_start, date_end, sname);

end % function

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
