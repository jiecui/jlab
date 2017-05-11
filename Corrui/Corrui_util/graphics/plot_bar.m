function out = plot_bar( varargin )
% PLOT_BAR plots bar charts of general data
% 
% Syntax:
%   out = plot_bar('get_options')
%   out = plot_bar([axis], data, [ylimit], [fig_title], [xlegends], [ylab], [options])
% 
% Input(s):
%   axis        - (optional) given axis to plot the bar plots
%   data        - (required) m x n cell data for bar plots, where m is the
%                 number of columns in Bar fn and n is the number of rows
%                 in Bar fn
%   ylimit      - (optional) limits of the y axis (if empty or max = min,
%                 the limit will be set according to data)
%   fig_tit     - (optional) title of the graph
%   xlegends    - (optional) legends of the x axis
%   ylab        - (optional) label of the y axis
%   options     - (optional) structure with GUI options for the plot
%
% Output:
%   out         - handles of figure objects created
%
% Examples:
%   options = plot_mainsequence( 'get_options' )
%   plot_bar(data, ylimit)
% 
% Note:
%
% References:
%
% See also .

% Copyright 2013-2016 Richard J. Cui. Created: Thu 11/07/2013 12:39:36.402 PM
% $Revision: 0.8 $  $Date: Tue 11/01/2016  5:51:28.051 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

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
[num_row, num_col] = size(data);

if ~isfield(p, 'fig') || isempty(p.fig)
    % if no axes is given create a new one
    out = set_axline_props(num_row, num_col, ylmt, colors_array, S);
else
    out = p.fig;
end

% -------------------------------------------------------------------------
% plots
% -------------------------------------------------------------------------
for k = 1:num_col
    data_k = data(:, k);
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

end

% =========================================================================
% subroutines
% =========================================================================
function [h_bar, h_errbar] = plot_one_col(h, data, S)

h_bar   = h.hbar;
h_errbar = h.herrbar;

% -------------------------------------------------------------------------
% calculate mean and error bars
% -------------------------------------------------------------------------
num_cats = numel(data);
avrg = zeros(1, num_cats);
estd = zeros(1, num_cats);
esem = zeros(1, num_cats);
for k = 1:num_cats
    d_k = data{k};
    n_k = length(d_k);
    avrg(k) = nanmean(d_k);
    estd(k) = nanstd(d_k);
    esem(k) = estd(k) / sqrt(n_k); % ?
end % for

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
    case 'Up'
        ldata = zeros(1, num_cats);
    case 'Down'
        udata = zeros(1, num_cats);
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
    p.addRequired('data', @iscell)
    p.addOptional('ylimit', [0 3], @(x)((isnumeric(x) && length(x) == 2) || isempty(x)))
    p.addOptional('fig_title', 'Bar Plot', @ischar)
    p.addOptional('xlegends', {}, @iscell)
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
bar_opts.error_dir      = {'{Up}|Down|Both', 'Error Bar Direction'};

end
