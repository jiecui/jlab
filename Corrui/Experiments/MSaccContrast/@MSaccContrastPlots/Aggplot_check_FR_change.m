function options = Aggplot_check_FR_change(current_tag, snames, S)
% AGGPLOT_CHECK_FR_CHANGE plots the results of function AggMSCFRChange.
%
% Syntax:
%
% Input(s):
%   current_tag         - current tag
%   snames              - session names, in cells
%   S                   - options
%
% Output(s):
%
% Example:
%
% See also AggMSCFRChange.

% Copyright 2012 Richard J. Cui. Created: Mon 10/15/2012  3:18:32.945 PM
% $Revision: 0.1 $  $Date: Mon 10/15/2012  3:18:32.945 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% ========================
% options
% ========================
if ( nargin == 1 )
    if ( strcmp( current_tag, 'get_options' ) )
        
        % options.Something   = { {'0','{1}'} };
        % options.Condition_number = {1 '' [1 121]};
        options = [];
        return
    end
end

% ========================
% get data wanted
% ========================
dat_var = {'sessions', 'SlopeConfInt', 'Slope'};
dat = CorruiDB.Getsessvars(snames{1},dat_var);
sessnames = dat.sessions;
ci = dat.SlopeConfInt;
slope = dat.Slope;

upoutlier_idx = ci(:,1) > 0;
lwoutlier_idx = ci(:,2) < 0;    % if ci does not include zero
upout_slope = slope(upoutlier_idx);
lwout_slope = slope(lwoutlier_idx);
upout_ci = ci(upoutlier_idx, :);
lwout_ci = ci(lwoutlier_idx, :);
upout_sess = sessnames(upoutlier_idx);
lwout_sess = sessnames(lwoutlier_idx);

% ========================
% plot
% ========================
% confidence interval
% -------------------
figure
plot(ci(:,1), ci(:,2), 'k+')
hold on
plot(upout_ci(:, 1), upout_ci(:, 2), 'o', 'MarkerEdgeColor', [0 .5 0])
plot(lwout_ci(:, 1), lwout_ci(:, 2), 'ro')
axis square
plot(xlim, [0 0], 'k:')
plot([0 0], ylim, 'k:')
xlabel('Lower bound')
ylabel('Upper bound')

disp('------ Outliers of significant increase of firing rate ------')
N = length(upout_sess);
for k = 1:N
    fprintf('Session: %s, slope = %g, ConfIn = [%g, %g]\n', ...
            upout_sess{k}, upout_slope(k,1), upout_ci(k,1), upout_ci(k,2))
end % for

disp('------ Outliers of significant decrease of firing rate ------')
N = length(lwout_sess);
for k = 1:N
    fprintf('Session: %s, slope = %g, ConfIn = [%g, %g]\n', ...
            lwout_sess{k}, lwout_slope(k,1), lwout_ci(k,1), lwout_ci(k,2))
end % for

end % function Spike_raster_and_rate

% [EOF]
