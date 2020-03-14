function plot_mean_error(axis_handle, time, sig_mean, sig_err, color, mean_line_width, options)
% PLOT_MEAN_ERROR (summary)
%
% Syntax:
%   plot_mean_error(axis_handle, time, sig_mean, sig_err, color, mean_line_width, options)
% 
% Input(s):
%   options.flag_fill       - whether fill the error area
%   options.flag_showerr    - whether show the error limits
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 11/03/2012  7:29:07.954 PM
% $Revision: 0.4 $  $Date: Wed 10/30/2013  4:35:23.566 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com


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
    plot(t, sig_mean, 'color', color, 'LineWidth', mean_line_width)
    set(gca, 'Layer', 'top')
    drawnow
    
    if ispc
        opengl hardware
    end % if
else
    upper = sig_mean + sig_err;
    lower = sig_mean - sig_err;
    plot(t, sig_mean, 'color', color, 'LineWidth', mean_line_width)
    hold on
    if flag_showerr
        plot(t, upper, 'color', color, 'LineStyle', ':')
        plot(t, lower, 'color', color, 'LineStyle', ':')
    end % if
end % if

end % function plot_mean_error

% [EOF]
