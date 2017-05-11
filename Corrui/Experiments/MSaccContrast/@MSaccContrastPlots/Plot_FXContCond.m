function out = Plot_FXContCond(current_tag, sname, S)
% PLOT_FXCONTCOND plots the spike raster and spike rates for the results of
%       FiringXContCond analysis.
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
% See also do_FiringXContrastCondition.

% Copyright 2014 Richard J. Cui. Created: Fri 06/08/2012  4:22:08.402 PM
% $Revision: 0.4 $  $Date: Wed 02/19/2014  4:22:51.670 PM $
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
        options.Condition_number = {1 '' [1 121]};
        options.Show_normalized =  { {'{0}','1'} };
        options.Show_all_condition.select =  { {'{0}','1'}, 'Show all condition' };
        options.Show_all_condition.flag_fill = { {'{0}','1'} 'Fill error'};
        options.Show_all_condition.flag_showerr = { {'{0}','1'} 'Show error limits'};
        options.Show_all_condition.flag_raster = { {'{0}','1'} 'Show raster'};
        options.Y_axis_lim = [0 40];
        out = options;
        return
    end
end

%% ========================================================================
% get data wanted
% =========================================================================
% curr_exp = CorrGui.ExperimentConstructor(current_tag);
dat_var = {'FiringXCondLength', 'NumberCycle'};
dat = CorruiDB.Getsessvars(sname, dat_var);
trl_len = dat.FiringXCondLength;
numtrl = dat.NumberCycle;

choose_stage = S.Plot_FXContCond_options.Choose_stages;
condnum = S.Plot_FXContCond_options.Condition_number;
show_norm = S.Plot_FXContCond_options.Show_normalized;
show_all = S.Plot_FXContCond_options.Show_all_condition.select;
y_lim = S.Plot_FXContCond_options.Y_axis_lim;

options.flag_fill = S.Plot_FXContCond_options.Show_all_condition.flag_fill;
options.flag_showerr = S.Plot_FXContCond_options.Show_all_condition.flag_showerr;
options.flag_raster = S.Plot_FXContCond_options.Show_all_condition.flag_raster;

%% ========================================================================
% plot
% =========================================================================
% show one condition
% -------------------
switch choose_stage
    case '1 --> 2'
        dat_var = {'FiringXCond12', 'FXCond12RateCenter'};
        dat = CorruiDB.Getsessvars(sname,dat_var);
        pointtimes = dat.FiringXCond12;
        rt_cen = dat.FXCond12RateCenter;
        
        if show_norm
            y_label = 'Normalized firing rate';
            dat_var = {'FXCond12Rate_Norm', 'FXCond12RateMean_Norm', 'FXCond12RateSEM_Norm'};
            dat = CorruiDB.Getsessvars(sname,dat_var);
            
            rt      = dat.FXCond12Rate_Norm;
            rt_mean = dat.FXCond12RateMean_Norm;
            rt_sem  = dat.FXCond12RateSEM_Norm;
        else
            y_label = 'Firing rate (1/s)';
            dat_var = {'FXCond12Rate', 'FXCond12RateMean', 'FXCond12RateSEM'};
            dat = CorruiDB.Getsessvars(sname,dat_var);
            
            rt      = dat.FXCond12Rate * 1000;
            rt_mean = dat.FXCond12RateMean * 1000;
            rt_sem  = dat.FXCond12RateSEM * 1000;
        end % if

    case '2 --> 3'
        dat_var = {'FiringXCond23', 'FXCond23RateCenter'};
        dat = CorruiDB.Getsessvars(sname,dat_var);
        pointtimes = dat.FiringXCond23;
        rt_cen = dat.FXCond23RateCenter;
        
        if show_norm
            y_label = 'Normalized firing rate';
            dat_var = {'FXCond23Rate_Norm', 'FXCond23RateMean_Norm', 'FXCond23RateSEM_Norm'};
            dat = CorruiDB.Getsessvars(sname,dat_var);
            
            rt      = dat.FXCond23Rate_Norm;
            rt_mean = dat.FXCond23RateMean_Norm;
            rt_sem  = dat.FXCond23RateSEM_Norm;
        else
            y_label = 'Firing rate (1/s)';
            dat_var = {'FXCond23Rate', 'FXCond23RateMean', 'FXCond23RateSEM'};
            dat = CorruiDB.Getsessvars(sname,dat_var);
            
            rt      = dat.FXCond23Rate * 1000;
            rt_mean = dat.FXCond23RateMean * 1000;
            rt_sem  = dat.FXCond23RateSEM * 1000;
        end % if

end % switch
show_one_cond(pointtimes, rt_cen, rt, rt_mean, rt_sem, condnum, trl_len, numtrl, y_label)

% show all conditions
% -------------------
if show_all
    switch choose_stage
        case '1 --> 2'
            dat_var = {'FiringXCond12', 'FXCond12RateCenter'};
            dat = CorruiDB.Getsessvars(sname,dat_var);
            pointtimes = dat.FiringXCond12;
            rt_cen = dat.FXCond12RateCenter;
            
            if show_norm
                dat_var = {'FXCond12RateMean_Norm', 'FXCond12RateSEM_Norm'};
                dat = CorruiDB.Getsessvars(sname,dat_var);
                
                rt_mean = dat.FXCond12RateMean_Norm;
                rt_sem  = dat.FXCond12RateSEM_Norm;
            else
                dat_var = {'FXCond12RateMean', 'FXCond12RateSEM'};
                dat = CorruiDB.Getsessvars(sname,dat_var);
                
                rt_mean = dat.FXCond12RateMean * 1000;
                rt_sem  = dat.FXCond12RateSEM * 1000;
            end
            
        case '2 --> 3'
            dat_var = {'FiringXCond23', 'FXCond23RateCenter'};
            dat = CorruiDB.Getsessvars(sname,dat_var);
            pointtimes = dat.FiringXCond23;
            rt_cen = dat.FXCond23RateCenter;
            
            if show_norm
                dat_var = {'FXCond23RateMean_Norm', 'FXCond23RateSEM_Norm'};
                dat = CorruiDB.Getsessvars(sname,dat_var);
                
                rt_mean = dat.FXCond23RateMean_Norm;
                rt_sem  = dat.FXCond23RateSEM_Norm;
            else
                dat_var = {'FXCond23RateMean', 'FXCond23RateSEM'};
                dat = CorruiDB.Getsessvars(sname,dat_var);
                
                rt_mean = dat.FXCond23RateMean * 1000;
                rt_sem  = dat.FXCond23RateSEM * 1000;
            end
            
    end % switch
    show_all_cond(pointtimes, rt_cen, rt_mean, rt_sem, ...
        trl_len, numtrl, y_lim, options)
end % if

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

function show_one_cond(pointtimes, rt_cen, rt, rt_mean, rt_sem, cond, trl_len, numtrl, y_label )

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

if ispc
    opengl software
end % if

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
m_wid = 2;
options.flag_fill = true;
options.flag_showerr = true;
plot_mean_error(gca, t, sig_mean, sig_sem, color, m_wid, options)
plot([0 0], ylim, 'r')
xlabel('Time (ms)')
ylabel(y_label)


end

function  show_all_cond(pointtimes, rt_center, rt_mean, rt_sem, ...
             trl_length, numtrl, y_lim, options)

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
    plot_mean_error(gca, t, rtm_k, rts_k, color, m_wid, options)
    ylim(y_lim)
    plot([0 0], ylim, 'r')
    set(gca, 'XTickLabel', [], 'YTickLabel', [])
    set(gca, 'TickDir', 'out')
    set(gca, 'TickLength', [0.03, .1])
end % for

% raster
% ------
if options.flag_raster
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
end % if

end % funciton

% [EOF]
