function out = Plot_UXContCond(current_tag, snames, S)
% PLOT_UXCONTCOND plots the usacc raster and usacc rates for the results of
%       UsaccXContCond analysis.
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
% See also do_UsaccXContrastCondition.

% Copyright 2012 Richard J. Cui. Created: Fri 06/08/2012  4:22:08.402 PM
% $Revision: 0.2 $  $Date: Wed 07/11/2012  9:49:14.679 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

%% ========================================================================
% options
% =========================================================================
if ( nargin == 1 )
    if ( strcmp( current_tag, 'get_options' ) )
        
        options.Choose_stages = {'1 --> 2|{2 --> 3}'};
        options.Conditions_shown =  { 'Single|All|{Both}' };
        options.Single_condition_number = {1 '' [1 121]};
        options.Onset_or_Offset = { '{Onset}|Offset' };
        options.Y_axis_lim = [0 10];
        out = options;
        return
    end
end

%% ========================================================================
% get data wanted
% =========================================================================
% data
dat_var = {'UsaccXCondLength', 'NumberCycle'};
dat = CorruiDB.Getsessvars(snames{1},dat_var);
trl_len = dat.UsaccXCondLength;
numtrl = dat.NumberCycle;

% options
choose_stage = S.Plot_UXContCond_options.Choose_stages;
condshown = S.Plot_UXContCond_options.Conditions_shown;
condnum = S.Plot_UXContCond_options.Single_condition_number;
usaedge = S.Plot_UXContCond_options.Onset_or_Offset;
y_lim = S.Plot_UXContCond_options.Y_axis_lim;

%% ========================================================================
% plot
% =========================================================================
% show one condition
% -------------------
switch condshown
    case {'Single' 'Both'}
        switch choose_stage
            case '1 --> 2'
                dat_var = {'Left_UXCond12RateCenter'};
                dat = CorruiDB.Getsessvars(snames{1},dat_var);
                rt_cen     = dat.Left_UXCond12RateCenter;
                switch usaedge
                    case 'Onset'
                        dat_var = {'Left_UsaccXCond12_Start', 'Left_UXCond12OnsetRate', 'Left_UXCond12OnsetRateMean', 'Left_UXCond12OnsetRateSEM'};
                        dat = CorruiDB.Getsessvars(snames{1},dat_var);
                        
                        pointtimes = dat.Left_UsaccXCond12_Start;
                        rt         = dat.Left_UXCond12OnsetRate;
                        rt_mean    = dat.Left_UXCond12OnsetRateMean;
                        rt_sem     = dat.Left_UXCond12OnsetRateSEM;
                    case 'Offset'
                        dat_var = {'Left_UsaccXCond12_end', 'Left_UXCond12OffsetRate', 'Left_UXCond12OffsetRateMean', 'Left_UXCond12OffsetRateSEM'};
                        dat = CorruiDB.Getsessvars(snames{1},dat_var);
                        
                        pointtimes = dat.Left_UsaccXCond12_end;
                        rt         = dat.Left_UXCond12OffsetRate;
                        rt_mean    = dat.Left_UXCond12OffsetRateMean;
                        rt_sem     = dat.Left_UXCond12OffsetRateSEM;
                        
                end % switch
            
            case '2 --> 3'
                dat_var = {'Left_UXCond23RateCenter'};
                dat = CorruiDB.Getsessvars(snames{1},dat_var);
                rt_cen     = dat.Left_UXCond23RateCenter;
                switch usaedge
                    case 'Onset'
                        dat_var = {'Left_UsaccXCond23_Start', 'Left_UXCond23OnsetRate', 'Left_UXCond23OnsetRateMean', 'Left_UXCond23OnsetRateSEM'};
                        dat = CorruiDB.Getsessvars(snames{1},dat_var);
                        
                        pointtimes = dat.Left_UsaccXCond23_Start;
                        rt         = dat.Left_UXCond23OnsetRate;
                        rt_mean    = dat.Left_UXCond23OnsetRateMean;
                        rt_sem     = dat.Left_UXCond23OnsetRateSEM;
                    case 'Offset'
                        dat_var = {'Left_UsaccXCond23_end', 'Left_UXCond23OffsetRate', 'Left_UXCond23OffsetRateMean', 'Left_UXCond23OffsetRateSEM'};
                        dat = CorruiDB.Getsessvars(snames{1},dat_var);
                        
                        pointtimes = dat.Left_UsaccXCond23_end;
                        rt         = dat.Left_UXCond23OffsetRate;
                        rt_mean    = dat.Left_UXCond23OffsetRateMean;
                        rt_sem     = dat.Left_UXCond23OffsetRateSEM;
                        
                end % switch

        end % switch
        
        show_one_cond(pointtimes, rt_cen, rt * 1000, rt_mean * 1000, rt_sem * 1000, condnum, trl_len, numtrl)
    case 'All'

    otherwise
        error('Unknown conditions shown')
end % switch

% show all conditions
% -------------------
switch condshown
    case {'All' 'Both'}
        switch choose_stage
            case '1 --> 2'
                dat_var = {'Left_UXCond12RateCenter'};
                dat = CorruiDB.Getsessvars(snames{1},dat_var);
                rt_center     = dat.Left_UXCond12RateCenter;
                switch usaedge
                    case 'Onset'
                        dat_var = {'Left_UsaccXCond12_Start', 'Left_UXCond12OnsetRateMean', 'Left_UXCond12OnsetRateSEM'};
                        dat = CorruiDB.Getsessvars(snames{1},dat_var);
                        
                        pointtimes = dat.Left_UsaccXCond12_Start;
                        rt_mean    = dat.Left_UXCond12OnsetRateMean;
                        rt_sem     = dat.Left_UXCond12OnsetRateSEM;
                    case 'Offset'
                        dat_var = {'Left_UsaccXCond12_end', 'Left_UXCond12OffsetRateMean', 'Left_UXCond12OffsetRateSEM'};
                        dat = CorruiDB.Getsessvars(snames{1},dat_var);
                        
                        pointtimes = dat.Left_UsaccXCond12_end;
                        rt_mean    = dat.Left_UXCond12OffsetRateMean;
                        rt_sem     = dat.Left_UXCond12OffsetRateSEM;
                        
                end
            case '2 --> 3'
                dat_var = {'Left_UXCond23RateCenter'};
                dat = CorruiDB.Getsessvars(snames{1},dat_var);
                rt_center     = dat.Left_UXCond23RateCenter;
                switch usaedge
                    case 'Onset'
                        dat_var = {'Left_UsaccXCond23_Start', 'Left_UXCond23OnsetRateMean', 'Left_UXCond23OnsetRateSEM'};
                        dat = CorruiDB.Getsessvars(snames{1},dat_var);
                        
                        pointtimes = dat.Left_UsaccXCond23_Start;
                        rt_mean    = dat.Left_UXCond23OnsetRateMean;
                        rt_sem     = dat.Left_UXCond23OnsetRateSEM;
                    case 'Offset'
                        dat_var = {'Left_UsaccXCond23_end', 'Left_UXCond23OffsetRateMean', 'Left_UXCond23OffsetRateSEM'};
                        dat = CorruiDB.Getsessvars(snames{1},dat_var);
                        
                        pointtimes = dat.Left_UsaccXCond23_end;
                        rt_mean    = dat.Left_UXCond23OffsetRateMean;
                        rt_sem     = dat.Left_UXCond23OffsetRateSEM;
                end
        end
        show_all_cond(pointtimes, rt_center, rt_mean * 1000, rt_sem * 1000, ...
            trl_len, numtrl, y_lim)
        
end % switch

end % function Spike_raster_and_rate

% =========================================================================
% subroutines
% =========================================================================
% function plot_mean_error(axis_handle, time, sig_mean, sig_err, color, mean_line_width)
% 
% if ~exist('mean_line_width', 'var')
%     mean_line_width = 2;
% end % if
% t = time(:)';
% X = [t, fliplr(t)];
% Y = [sig_mean + sig_err, fliplr(sig_mean - sig_err)];
% 
% opengl software
% 
% axes(axis_handle)
% hold on
% fill(X, Y, color, 'EdgeColor', 'none', 'FaceAlpha', 0.3)
% plot(t, sig_mean, 'color', color, 'LineWidth', mean_line_width)
% set(gca, 'Box', 'off')
% axis tight
% set(gca, 'YTickMode', 'auto')
% set(gca, 'Box', 'off')
% drawnow
% 
% opengl hardware
% 
% end % function

function show_one_cond(pointtimes, rt_cen, rt, rt_mean, rt_sem, cond, trl_len, numtrl )

ztime = trl_len / 2 + 1;
t = rt_cen(:)' - ztime;

% show raster
ptm_cond = pointtimes{cond};
figure
rasterplot(ptm_cond,numtrl, trl_len, gca, 1000, true, ztime); 
hold on
plot([0 0], ylim, 'r')
title(sprintf('Condition Number = %g', cond))

% show point rate
rt_cond = rt(:, :, cond);
figure
N = size(rt, 1);
for k = 1:N
    rt_k = rt_cond(k, :);
    subplot(N, 1, N - k + 1)
    plot(t, rt_k)
    if k ~= 1
        set(gca, 'XTickLabel', [])
    else
        xlabel('Time (ms)')
    end % if
    axis tight
    set(gca, 'YTickMode', 'auto')
    set(gca, 'Box', 'off')
    hold on
    plot([0 0], ylim, 'r')
end % for
title(sprintf('Condition Number = %g', cond))

% show mean rate
color = [0 .5 0];
sig_mean = squeeze(rt_mean(:, :, cond));
sig_sem  = squeeze(rt_sem(:, :, cond));

opengl software

figure
% X = [t, fliplr(t)];
% Y = [sig_mean + sig_sem, fliplr(sig_mean - sig_sem)];
% fill(X, Y, color, 'EdgeColor', 'none', 'FaceAlpha', 0.3)
% hold on
% plot(t, sig_mean, 'color', color, 'LineWidth', 2)
% set(gca, 'Box', 'off')
% axis tight
% set(gca, 'YTickMode', 'auto')
% set(gca, 'Box', 'off')
% hold on
% plot([0 0], ylim, 'r')
% xlabel('Time (ms)')
% ylabel('Spike rate (1/s)')
% 
% drawnow
% opengl hardware
plot_mean_error(gca, t, sig_mean, sig_sem, color)
plot([0 0], ylim, 'r')
xlabel('Time (ms)')
ylabel('Microsaccade rate (1/s)')


end

function  show_all_cond(pointtimes, rt_center, rt_mean, rt_sem, ...
             trl_length, numtrl, y_lim)

ztime = trl_length / 2 + 1;
t = rt_center(:)' - ztime;

N = length(pointtimes);     % number of conditions
color = [0 0 1];
m_wid = 1;

% rate mean
% ---------
figure
for k = 1:N
    rtm_k = squeeze(rt_mean(:, :,k));
    rts_k = squeeze(rt_sem(:, :, k));
    
    subplot(11, 11, k)
    plot_mean_error(gca, t, rtm_k, rts_k, color, m_wid, false)
    ylim(y_lim)
    plot([0 0], ylim, 'r')
    set(gca, 'XTickLabel', [], 'YTickLabel', [])
    set(gca, 'TickDir', 'out')
    set(gca, 'TickLength', [0.03, .1])
end % for

% raster
% ------
figure
for k = 1:N
    pt_k = pointtimes{k};
    
    subplot(11, 11, k)
    rasterplot(pt_k, numtrl, trl_length, gca, 1000, true, ztime)
    hold on
    plot([0 0], ylim, 'r')
    set(gca, 'YTick', [])
    set(gca, 'XTickLabel', [], 'YTickLabel', [])
    set(gca, 'TickLength', [0.03, .1])
    xlabel(''), ylabel('')

end % for

end % funciton

% [EOF]
