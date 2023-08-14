function hl = jl_plot_mean_error(axis_handle,time,sig_mean,sig_err,color,mean_line_width,options)
% JL_PLOT_MEAN_ERROR jLab plot mean and error area
%
% Syntax:
%   hl = jl_plot_mean_error(axis_handle,time,sig_mean,sig_err,color,mean_line_width,options)
% 
% Input(s):
%   options.flag_fill       - whether fill the error area
%   options.flag_showerr    - whether show the error limits
%
% Output(s):
%   hl                      - handle of the line
% 
% Example:
%
% See also .

% Copyright 2012-2020 Richard J. Cui. Created: 11/03/2012  7:29:07.954 PM
% $Revision: 0.5 $  $Date: Wed 06/03/2020  3:36:39.927 PM $
%
% Multimodel Neuroimaging Lab (Dr. Dora Hermes)
% Mayo Clinic St. Mary Campus
% Rochester, MN 55905, USA
%
% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)


if ~exist('mean_line_width', 'var')
    mean_line_width = 2;
end % if

if ~exist('options', 'var')
    options.flag_fill = true;
    options.flag_showerr = true;
end % if

if ~isfield(options, 'flag_fill')
    flag_fill = true;
else
    flag_fill = options.flag_fill;
end % if

t = time(:)';
sig_mean = sig_mean(:)';
sig_err  = sig_err(:)';
flag_showerr = options.flag_showerr;

axes(axis_handle)
if flag_fill
    X = [t, fliplr(t)];
    Y = [sig_mean + sig_err, fliplr(sig_mean - sig_err)];
    
    if ispc
        opengl software
    end % if
    
    fill(X, Y, color, 'EdgeColor', 'none', 'FaceAlpha', 0.3)
    hold on
    out = plot(t, sig_mean, 'color', color, 'LineWidth', mean_line_width);
    set(gca, 'Layer', 'top')
    drawnow
    
    if ispc
        opengl hardware
    end % if
else
    upper = sig_mean + sig_err;
    lower = sig_mean - sig_err;
    out = plot(t, sig_mean, 'color', color, 'LineWidth', mean_line_width);
    hold on
    if flag_showerr
        plot(t, upper, 'color', color, 'LineStyle', ':')
        plot(t, lower, 'color', color, 'LineStyle', ':')
    end % if
end % if

if nargout > 0
    hl = out;
end % if

end % function plot_mean_error

% [EOF]
