function [y_op, y_op_mean, y_op_sem] = function_paired_obs(x_input, x_var, x_obs, x_model, y_var, y_obs, y_model)
% FUNCTION_PAIRED_OBS seeks numerically the function between the paired
%       observations.  The solution is the ordered pairs.
%
% Syntax:
%   [y_op, y_op_mean, y_op_sem] = function_paired_obs(x_input, x_var, x_obs, x_model, y_var, y_obs, y_model)
% 
% Input(s):
%   x_input         - x points to observe y points
%   x_var           - x variables at which the observations were obtained
%   x_obs           - x observations for estimating the funciton, where rows
%                     are the observations and columns are the variables,
%                     i.e. observations x variables
%   y_var           - x varialbes
%   y_obs           - y observations
%   x_model         - model name for the x observation
%   y_model         - model name for the y observation
%
% Output(s):
%   y_op            - y ordered pair
%
% Note:
%   This version requires a paired observation.  That is, the number of
%   observations of x and y must be the same.
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 01/01/2013  7:02:18.809 PM
% $Revision: 0.1 $  $Date: 01/01/2013  7:02:18.825 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% decide fittype
% =========================================================================
switch x_model
    case 'Linear polynomial curve'
        x_fittype = 'poly1';
    case 'Piecewise linear interpolation'
        x_fittype = 'linearinterp';
end % switch

switch y_model
    case 'Linear polynomial curve'
        y_fittype = 'poly1';
    case 'Piecewise linear interpolation'
        y_fittype = 'linearinterp';
end % switch

% =========================================================================
% find function
% =========================================================================
N = size(x_obs, 1);     % number of observation
y_op = zeros(length(x_input), N);
for k = 1:N     % observation by observation
    x_obs_k = x_obs(k, :)';
    f_x = fit(x_var(:), x_obs_k, x_fittype);
    
    y_obs_k = y_obs(k, :)';
    invf_y = fit(y_obs_k, y_var(:), y_fittype);
    
    y_input = f_x(x_input);
    y_op_k = invf_y(y_input);
    y_op(:, k) = y_op_k;
end % for

y_op_mean = mean(y_op, 2);
y_op_sem  = std(y_op, [], 2) / sqrt(N);

end % function function_paired_obs

% [EOF]
