function fig = plot_bar( varargin )
% PLOT_BAR plots bar charts according to raw data
% 
% Syntax:
%   out = plot_bar('get_options')
%   out = plot_bar([axis], data, [ylimit], [fig_title], [xlegends], [ylab], [options])
% 
% Input(s):
%   axis        - (optional) given axis to plot the bar plots
%   data        - (required) m x n cell data for bar plots, where m is the
%                 number of columns (categories) in Bar function and n is
%                 the number of rows (number of items in one category) in
%                 Bar fn
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

% Copyright 2013-2020 Richard J. Cui. Created: Thu 11/07/2013 12:39:36.402 PM
% $Revision: 1.1 $  $Date: Tue 06/02/2020 11:05:50.828 AM $
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

% -------------------------------------------------------------------------
% estimate the statistics
% -------------------------------------------------------------------------
[num_row, num_col] = size(data);
data_sta = zeros(num_row,num_col,3); % category x items x stats (mean,std,sem)
for m = 1:num_row
    for n = 1:num_col
        d_mn = data{m,n};
        n_mn = length(d_mn); % number data points
        data_sta(m,n,1) = nanmean(d_mn);
        data_sta(m,n,2) = nanstd(d_mn);
        data_sta(m,n,3) = nanstd(d_mn)/sqrt(n_mn);
    end % for
end % for

% -------------------------------------------------------------------------
% plots
% -------------------------------------------------------------------------
out = plot_bar_stas(data_sta,ylmt,figtit,xleg,ylab,S);

% -------------------------------------------------------------------------
% output
% -------------------------------------------------------------------------
if nargout > 0
    fig = out;
end % if

end

% =========================================================================
% subroutines
% =========================================================================
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

bar_opts = plot_bar_stas('get_options');

end

% [EOF]