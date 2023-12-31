function fig = plot_bar_stas( varargin )
% PLOT_BAR_STAS plots bar charts according to statistics of the data
% 
% Syntax:
%   out = plot_bar('get_options')
%   out = plot_bar([axis], data, [ylimit], [fig_title], [xlegends], [ylab], [options])
% 
% Input(s):
%   axis        - (optional) given axis to plot the bar plots
%   data        - (required) m x n x s array data for bar plots, where m is
%                 the number of columns (categories) in Bar function and n
%                 is the number of rows (number of items in one category)
%                 in Bar funciton and s is the number of statistics, which
%                 are [average,std,sem], for now.
%   ylimit      - (optional) limits of the y axis (if empty or max = min,
%                 the limit will be set according to data)
%   fig_tit     - (optional) title of the graph
%   xlegends    - (optional) legends of the x axis
%   ylab        - (optional) label of the y axis
%   options     - (optional) structure with GUI options for the plot
%
% Output:
%   fig         - handles of figure objects created
%
% Examples:
%   options = plot_mainsequence( 'get_options' )
%   plot_bar(data, ylimit)
% 
% Note:
%   To plot, at least two inputs.
% 
% References:
%
% See also .

% Copyright 2020 Richard J. Cui. Created: Tue 06/02/2020 12:23:48.309 PM
% $Revision: 0.1 $  $Date: Tue 06/02/2020 12:23:48.309 PM $
%
% Multimodal Neuroimaging Lab (Dr. Dora Hermes)
% Mayo Clinic St. Mary Campus
% Rochester, MN 55905, USA
%
% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)

% -------------------------------------------------------------------------
% get options
% -------------------------------------------------------------------------
if ( nargin == 1 )
    command = varargin{1};
    switch (command)
        case 'get_options'
            out = get_bar_options();
        case 'get_defaults'
            out = StructDlg(get_bar_options,'',[],[],'off');
        otherwise
            cprintf('SystemCommands', 'Unknown command\n')
            out = [];
    end
    if nargout > 0
        fig = out;
    end % if
    return
end

% -------------------------------------------------------------------------
%  check parameters
% -------------------------------------------------------------------------
p = check_parameters( varargin{:} );

data    = p.data;
ylmt    = p.ylimit;
figtit  = p.fig_title;
xleg    = p.xlegends;
ylab    = p.ylab;
S       = p.S;

[~, colors_array] = get_nice_colors;
[num_row, num_col] = size(data,[1 2]);

if ~isfield(p, 'fig') || isempty(p.fig)
    % if no axes is given create a new one
    out = set_axline_props(num_row, num_col, ylmt, colors_array, S);
else
    out = p.fig;
end

if isempty(xleg)
    xleg = num2cell(1:num_row);
end % if

% -------------------------------------------------------------------------
% plots
% -------------------------------------------------------------------------
for k = 1:num_col
    data_k = data(:,k,:); % k-th item
    h_k.hbar = out.hbars(k);
    h_k.herrbar = out.herrbars(k);
    [hbar_k, hebar_k] = plot_one_col(h_k, data_k, S);
    out.hbars(k)     = hbar_k;
    out.herrbars(k)  = hebar_k;
end % for
set(out.hfig, 'Visible', 'On')
set(out.hax, 'XTickLabel', xleg)
ylabel(out.hax, ylab);
title(out.hax, figtit)

% TODO horizontal or vertical bars

% output
% ------
if nargout > 0
    fig = out;
end % if

end

% =========================================================================
% subroutines
% =========================================================================
function [h_bar, h_errbar] = plot_one_col(h, data, S)
% data              - category x stats

h_bar   = h.hbar;
h_errbar = h.herrbar;

% -------------------------------------------------------------------------
% calculate mean and error bars
% -------------------------------------------------------------------------
num_cats = size(data,1);
avrg    = data(:,:,1); % average
estd    = data(:,:,2); % std
esem    = data(:,:,3); % sem

% -------------------------------------------------------------------------
% draw the bars
% -------------------------------------------------------------------------
xdata = 1:num_cats;
% bar
set(h_bar, 'XData', xdata, 'YData', avrg, 'Visible', 'On')
% error bar
switch S.error_type
    case 'SEM'
        ldata = esem;
        udata = esem;
    case 'STD'
        ldata = estd;
        udata = estd;
end % switch
switch S.error_dir
    case 'Outward'
        ldata(avrg >= 0) = 0;
        udata(avrg < 0)  = 0;
    case 'Inward'
        ldata(avrg < 0)  = 0;
        udata(avrg >= 0) = 0;
end % switch
if S.show_error
    h_errbar.Visible = 'On';
else
    h_errbar.Visible = 'Off';
end % if
drawnow
if isempty(h_bar.YOffset)
    ydata = avrg;
else
    ydata = avrg + h_bar.YOffset;
end % if
set(h_errbar, 'YData', ydata, 'LData', ldata, 'UData', udata)

end % function

function h = set_axline_props(num_row, num_col, ylmt, col_array, S)
% setup the properties of axes and lines of figures
% 
% Inputs:
%   num_row             - number of rows in data
%   num_col             - number of columns in data
%   ylmt
%   col_array
%   S                   - options
% 
% Output(s):
%   out                 - structure of figure handles

% -------------------------------------------------------------------------
% create the figure
% -------------------------------------------------------------------------
hfig = figure('Color', 'White', 'Visible', 'Off');
hax  = axes(hfig, 'Visible', 'on');
set(hax, 'Box', 'off', 'NextPlot', 'Add','XLim', [0, num_row + 1], ...
    'FontSize', S.font_size - 2, 'XTick', 1:num_row)
if ~isempty(ylmt) && diff(ylmt) > 0
    set(hax, 'YLim', ylmt)
else
    set(hax, 'YLimMode', 'auto')
end % if

% -------------------------------------------------------------------------
% create bar axes
% -------------------------------------------------------------------------
xdata = 1:num_row;
ydata = zeros(num_row, num_col);

% set handles of bars
% -------------------
switch S.bar_layout
    case 'Grouped'
        h_bars = bar(xdata, ydata, 'BarLayout', 'Grouped', 'Visible', 'On',...
            'BarWidth', S.bar_width, 'LineWidth', 1.5);
    case 'Stacked'
        h_bars = bar(xdata, ydata, 'BarLayout', 'Stacked','Visible', 'On',...
            'BarWidth', S.bar_width, 'LineWidth', 1.5);        
    case 'Overlay'
        h_bars = gobjects(1, num_col);
        for k = 1:num_col
            h_bars(k) = bar(xdata, ydata(:, k), 'BarWidth', S.bar_width * .8^k,...
                'Visible', 'On', 'LineWidth', 1.5);
        end % for
end % switch
% set errorbars and colors
% ------------------------
h_errbars = gobjects(1, num_col);
for k = 1:num_col
    drawnow
    x_k = h_bars(k).XData + h_bars(k).XOffset;
    h_errbars(k) = errorbar(x_k,...
        ydata(:, 1), ydata(:, 1), 'Visible', 'off', 'LineStyle', 'None',...
        'Marker', 'None', 'Color', col_array(k,:) * .5);
    set(h_bars(k), 'EdgeColor', col_array(k, :) * .5,...
        'FaceColor', col_array(k, :), 'Visible', 'Off')
end % for

h = struct('hfig', hfig, 'hax', hax', 'hbars', h_bars, 'herrbars', h_errbars);

end % function

function tf = check_fig(fig)

tf = isempty(fig) || (isfield(fig, 'hfig') && ishandle(fig.hfig));

end % function

function q = check_parameters( varargin )

% parse the input
if nargin >= 1
    p = inputParser;
    
    if check_fig(varargin{1}) == true
        p.addRequired('fig')
    end % if
    p.addRequired('data', @isnumeric)
    p.addOptional('ylimit', [], @(x)((isnumeric(x) && length(x) == 2) || isempty(x)))
    p.addOptional('fig_title', 'Bar Plot', @ischar)
    p.addOptional('xlegends', {}, @(x) iscell(x) || iscategorical(x))
    p.addOptional('ylab', 'Y', @ischar)
    p.addOptional('S', StructDlg(get_bar_options, '', [], [], 'off'), @isstruct)
    
    p.parse(varargin{:})
    q = p.Results;
else
    error('At least the data are needed.');
end % if

end % function

function bar_opts = get_bar_options()

bar_opts.font_size      = {14, 'Font Size'};
bar_opts.min_y          = {0, 'Minimum Y'};
bar_opts.max_y          = {3, 'Maximum Y'};
bar_opts.bar_width      = {.8, 'Bar Width'};
bar_opts.bar_layout     = {'{Grouped}|Stacked|Overlay', 'Bar Layout'};
bar_opts.show_error     = {{'0', '{1}'}, 'Show Error Bar'};
bar_opts.error_type     = { '{SEM}|STD', 'Error Type' };
bar_opts.error_dir      = {'{Outward}|Inward|Both', 'Error Bar Direction'};

end
