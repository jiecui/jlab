function result_dat = AggSpecPortAnalysis(current_tag, sname, S, dat)
% FXCMMIRRORTRADERANALYSIS.AGGSPECPORTANALYSIS analysis of user specified portfolio
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

% Copyright 2014 Richard J. Cui. Created: Mon 12/29/2014  6:59:43.400 PM
% $Revision: 0.1 $  $Date: Mon 12/29/2014  6:59:43.444 PM $
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
    % assignment of positions
    opt.total_pos   = { 100, 'Total positions (k)', [1 Inf] };
    
    % user specified portfolio
    opt.spwght      = {0, 'Weights of specified portfolio', [0 1]};
    
    result_dat = opt;
    
    return
end % if

% =========================================================================
% Load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'MonthlyReturn' 'Property' 'concatenated_vars' 'PortMV' };
    
    result_dat = dat_var;
    
    return
end % if

% =========================================================================
% Data and options
% =========================================================================
% options and paras
total_pos   = S.Stage_2_Options.([mfilename, '_options']).total_pos;
spwght      = S.Stage_2_Options.([mfilename, '_options']).spwght;

% data
monthly_ret     = dat.MonthlyReturn;
property        = dat.Property;
conct_vars      = dat.concatenated_vars;
portmv          = dat.PortMV;

% =========================================================================
% Main process
% =========================================================================
% set the object of portfolio
if isempty(portmv)
    p = FMTPortfolio(property, monthly_ret, conct_vars);
else
    p = portmv;
end % if

% efficient frontier
efport = estimateFrontier( p, 100 );
[prsk, pret] = estimatePortMoments(p, efport);

% initial portfolio
[irsk, iret] = estimatePortMoments(p, p.InitPort);

% get risk and retrun of user specified portfolio
spprop = total_pos * spwght;
num_asset = p.NumAssets;
if length(spwght) ~= num_asset
    error('The dimension of the specified portfolio is not correct.')
end % if

[sprsk, spret] = estimatePortMoments(p, spwght);
conf95 = (spret + 2 * sprsk * [-1 1]) * num_asset;    % 95% confidence interval
conf99 = (spret + 3 * sprsk * [-1 1]) * num_asset;    % 99% confidence interval

% quick check
figure
portfolioexamples_plot('Efficient Frontier', ...
	{'line', prsk, pret}, ...
    {'scatter', irsk, iret, {'Initial'}}, ...
    {'scatter', sprsk, spret, {'Specified'}});

spport_table = array2table([spwght, spprop], 'RowNames', p.AssetList,...
    'VariableNames', { 'Portfolio' 'Position' });
fprintf('\nThe specified portfolio\n')
disp(spport_table)
fprintf('Risk (Annualized) = %g\tReturn (Annualized) = %g\n', ...
    sprsk * sqrt(12), spret * 12)

fprintf('95%% confidence interval (monthly): (%0.2f, %0.2f)\n', conf95(1), conf95(2));
fprintf('99%% confidence interval (monthly): (%0.2f, %0.2f)\n\n', conf99(1), conf99(2));

% =========================================================================
% output
% =========================================================================
result_dat = [];

end % function AggSpecPortAnalysis

% [EOF]
