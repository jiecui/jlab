function options = Plot_response_sorted_percentage_analysis(current_tag, snames, S)
% PLOT_RESPONSE_SORTED_PERCENTAGE_ANALYSIS plots the results of AggResponseSortedPercentageAnalysis.
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
% See also AggResponseSortedPercentageAnalysis.

% Copyright 2012 Richard J. Cui. Created: Fri 06/08/2012  4:22:08.402 PM
% $Revision: 0.2 $  $Date: Thu 07/12/2012  3:14:25.929 PM $
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
dat_var = {'AnalysisResult'};
dat = CorruiDB.Getsessvars(snames{1},dat_var);
ar = dat.AnalysisResult;

% smooth usacc data
% -----------------
winc = ar.Usacc.WinCenters;
ut = winc - 2600;

usr_least_mean = ar.Usacc.MeanRate(:, 1)*1000;      % least mean rate
usr_most_mean = ar.Usacc.MeanRate(:, 2)*1000;       % most mean rate
usr_least_sem = ar.Usacc.SemRate(:, 1)*1000;
usr_most_sem = ar.Usacc.SemRate(:, 2)*1000;

span = 0.04;
sl_mean = smooth(winc, usr_least_mean, span, 'rloess')';
sm_mean = smooth(winc, usr_most_mean, span, 'rloess')';
sl_sem  = smooth(winc, usr_least_sem, span, 'rloess')';
sm_sem  = smooth(winc, usr_most_sem, span, 'rloess')';

% spike rate data
% ---------------
st = ar.Spike.WinCenters - 2600;

spk_least_mean = ar.Spike.MeanRate(:, 1)';
spk_most_mean = ar.Spike.MeanRate(:, 2)';
spk_least_sem = ar.Spike.SemRate(:, 1)';
spk_most_sem = ar.Spike.SemRate(:, 2)';

% ========================
% plot
% ========================
opengl software
% plot usacc rate
% ------------------
% (1) not smoothed data
figure('name', sprintf('Microsaccade Rate of %s', snames{1}));
% error sem
X = [ut, fliplr(ut)];
Y_l = [usr_least_mean' + usr_least_sem', fliplr(usr_least_mean' - usr_least_sem')];
Y_m = [usr_most_mean' + usr_most_sem', fliplr(usr_most_mean' - usr_most_sem')];
fill(X, Y_l, [0 0 1], 'EdgeColor', 'none', 'FaceAlpha', 0.3)
hold on
fill(X, Y_m, [0 0.5 0], 'EdgeColor', 'none', 'FaceAlpha', 0.3)
% the means
plot(ut, usr_least_mean, 'color', [0 0 1], 'LineWidth', 2)
plot(ut, usr_most_mean, 'color', [0 0.5 0], 'LineWidth', 2)
set(gca, 'box', 'off')
% baseline usacc rate
plot(xlim, [2.08 2.08], 'color', [0.6 0.2 0], 'LineStyle', '--')
% the onset of contrast change
xlim([-350 1000])
ylim([1.059 3.001])
plot([0 0], ylim, 'r')
set(gca, 'FontSize', 14)
drawnow

% (2) smoothed data
figure('name', sprintf('Smoothed microsaccade Rate of %s', snames{1}));
% error sem
X = [ut, fliplr(ut)];
Y_l = [sl_mean + sl_sem, fliplr(sl_mean - sl_sem)];
Y_m = [sm_mean + sm_sem, fliplr(sm_mean - sm_sem)];
fill(X, Y_l, [0 0 1], 'EdgeColor', 'none', 'FaceAlpha', 0.3)
hold on
fill(X, Y_m, [0 0.5 0], 'EdgeColor', 'none', 'FaceAlpha', 0.3)
% the means
plot(ut, sl_mean, 'color', [0 0 1], 'LineWidth', 2)
plot(ut, sm_mean, 'color', [0 0.5 0], 'LineWidth', 2)
set(gca, 'box', 'off')
% baseline usacc rate
plot(xlim, [2.08 2.08], 'color', [0.6 0.2 0], 'LineStyle', '--')
% the onset of contrast change
xlim([-350 1000])
ylim([1.059 3.00])
plot([0 0], ylim, 'r')
set(gca, 'FontSize', 14)
drawnow

% plot spike rate
% ----------------
figure('name', sprintf('Spike Rate of %s', snames{1}));
% error sem
X = [st, fliplr(st)];
Y_l = [spk_least_mean + spk_least_sem, fliplr(spk_least_mean - spk_least_sem)];
Y_m = [spk_most_mean + spk_most_sem, fliplr(spk_most_mean - spk_most_sem)];
fill(X, Y_l, [0 0 1], 'EdgeColor', 'none', 'FaceAlpha', 0.3)
hold on
fill(X, Y_m, [0 0.5 0], 'EdgeColor', 'none', 'FaceAlpha', 0.3)
% the means
plot(st, spk_least_mean, 'color', [0 0 1], 'LineWidth', 2)
plot(st, spk_most_mean, 'color', [0 0.5 0], 'LineWidth', 2)
set(gca, 'box', 'off')
% baseline usacc rate
plot(xlim, [0 0], 'color', [0.6 0.2 0], 'LineStyle', '--')
% the onset of contrast change
xlim([-350 1000])
ylim([-1 11])
plot([0 0], ylim, 'r')
set(gca, 'FontSize', 14)
drawnow 

opengl hardware

end % function Spike_raster_and_rate

% [EOF]
