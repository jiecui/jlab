function out = Aggplot_usacc_triggered_mld_response(current_tag, sname, S)
% AGGPLOT_USACC_TRIGGERED_mld_RESPONSE plots the results for microsaccade triggered mscled response.
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
% See also do_FiringXContrastCondition, AggUsaccTriggeredSpikeRateAnalysis.

% Copyright 2013 Richard J. Cui. Created: Fri 06/08/2012  4:22:08.402 PM
% $Revision: 0.7 $  $Date: TTue 04/23/2013  5:26:02.631 PM $
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
        
        options.Data_type = { '{Not normalized}|Normalized', 'Choose data type' };
        options.norm_method = { {'{Firing rate difference}' 'Percentage change'}, 'Normalization method used' };
        options.Trig_edge = { '{Onset}|Offset', 'Choose MS trig edge'};
        options.Surrogage_data = { {'{0}', '1'} };
        
        options.Show_single_contrast = { {'0','{1}'} };
        options.Show_single_contrast_options.level = { 0, 'Chose contrast level (%)'};
        options.Show_single_contrast_options.flag_curve = { {'0','{1}'}, 'Show spike rate' };
        options.Show_single_contrast_options.flag_mod_area = { {'0','{1}'}, 'Show modulation area' };
        options.Show_single_contrast_options.mod_range = { [-75 355], 'Mod. range of interest' };
        options.Show_single_contrast_options.flag_raster = { {'{0}','1'}, 'Show spike raster' };
        options.Show_single_contrast_options.flag_individual = { {'{0}','1'}, 'Show individual cell' };
        
        options.Show_all = { {'{0}','1'} };
        options.Show_all_options.Y_axis_lim = [0 20];
        
        options.Show_overlap = { {'{0}','1'} };
        options.Show_overlap_options.Levels = 0;
        
        options.Show_difference = { {'{0}','1'} };
        options.Show_difference_options.Data_type = { '{Not normalized}|Normalized', 'Choose data type' };
        options.Show_difference_options.Y_axis_lim = [0 20];
        options.Show_difference_options.Single_difference_level = {10 '* %' [10 100]};
                
        options.Show_comparison = { {'{0}','1'} };
        options.Show_modulation = { {'{0}','1'} };
        
        out = options;
        return
    end
end

%% ========================================================================
% get options
% =========================================================================
% curr_exp = CorrGui.CheckTag(current_tag);
data_type = S.([mfilename,'_options']).Data_type;
norm_method = S.([mfilename,'_options']).norm_method;
trig_edge = S.([mfilename,'_options']).Trig_edge;
suro_data = S.([mfilename,'_options']).Surrogage_data;

flag_single = S.([mfilename,'_options']).Show_single_contrast;

% some bugs of StructDlg
level_number = S.([mfilename,'_options']).Show_single_contrast_options.level;
if ischar(level_number)
    single_level = str2double(level_number);
else
    single_level = level_number;
end % if

flag_raster = S.([mfilename,'_options']).Show_single_contrast_options.flag_raster;
flag_curve = S.([mfilename,'_options']).Show_single_contrast_options.flag_curve;
flag_individual = S.([mfilename,'_options']).Show_single_contrast_options.flag_individual;

flag_all = S.([mfilename,'_options']).Show_all;
y_lim = S.([mfilename,'_options']).Show_all_options.Y_axis_lim;

flag_overlap = S.([mfilename,'_options']).Show_overlap;
overlap_levels = S.([mfilename,'_options']).Show_overlap_options.Levels;
flag_comp = S.([mfilename,'_options']).Show_comparison;

% Difference options
% ------------------
flag_diff =  S.([mfilename,'_options']).Show_difference;
diff_data_type = S.([mfilename,'_options']).Show_difference_options.Data_type;
diff_y_lim = S.([mfilename,'_options']).Show_difference_options.Y_axis_lim;
diff_single_level = S.([mfilename,'_options']).Show_difference_options.Single_difference_level;

% Modulation options
% ------------------
flag_mod = S.([mfilename,'_options']).Show_modulation;
flag_mod_area = S.([mfilename,'_options']).Show_single_contrast_options.flag_mod_area;
mod_range =  S.([mfilename,'_options']).Show_single_contrast_options.mod_range;

%% ========================================================================
% plot
% =========================================================================
curr_exp = CorrGui.CheckTag(current_tag);
dat_var = {'PreMSIntv', 'PostMSIntv', 'SpikeRateWinCenter'};
dat = curr_exp.db.Getsessvars( sname, dat_var );
pre_ms      = dat.PreMSIntv;
pos_ms      = dat.PostMSIntv;
ztime       = pre_ms + 1;   % zero time index
wc          = dat.SpikeRateWinCenter;
time        = wc - ztime;
t_low       = -pre_ms;
t_upp       = pos_ms -1;

color_max   = [0.0 0.0 1.0
               0.0 1.0 0.0
               0.8 0.5 0.0
               0.0 0.0 0.5
               0.0 0.5 0.0
               0.5 0.0 0.0
               0.0 0.5 0.5
               0.5 0.0 0.5
               0.5 0.5 0.0
               0.0 0.5 1.0
               0.5 0.0 1.0];
               
% [~, color_max] = get_nice_colors();

switch data_type
    case {'Not normalized'}
        switch trig_edge
            case 'Onset'
                if ~suro_data
                    dat_var = {'SpikeRateMean', 'SpikeRateSEM'};
                    dat = curr_exp.db.Getsessvars(sname,dat_var);
                    sr_mean = dat.SpikeRateMean;
                    sr_sem  = dat.SpikeRateSEM;
                else
                    dat_var = {'SurrogateSpikeRateMean', 'SurrogateSpikeRateSEM'};
                    dat = curr_exp.db.Getsessvars(sname,dat_var);
                    sr_mean = dat.SurrogateSpikeRateMean;
                    sr_sem  = dat.SurrogateSpikeRateSEM;
                end
            case 'Offset'
                if ~suro_data
                    dat_var = {'SpikeRateMeanOff', 'SpikeRateSEMOff'};
                    dat = curr_exp.db.Getsessvars(sname,dat_var);
                    sr_mean = dat.SpikeRateMeanOff;
                    sr_sem  = dat.SpikeRateSEMOff;
                else
                    dat_var = {'SurrogateSpikeRateMeanOff', 'SurrogateSpikeRateSEMOff'};
                    dat = curr_exp.db.Getsessvars(sname,dat_var);
                    sr_mean = dat.SurrogateSpikeRateMeanOff;
                    sr_sem  = dat.SurrogateSpikeRateSEMOff;
                end 
        end % switch
        
        % show spike rate data
        % --------------------
        if flag_single
            level_idx = round(single_level / 25) + 1;   % level index
            % show spike raster data
            % ---------------------------
            if flag_raster
                dat_var = {'SpikeTimes', 'UsaccNumbers', 'TrialLength'};
                dat = curr_exp.db.Getsessvars(sname,dat_var);
                
                spktimes    = dat.SpikeTimes;
                trl_len     = dat.TrialLength;
                num_usa     = dat.UsaccNumbers;
                
                spkt_k = spktimes{level_idx};
                num_usa_k = num_usa(level_idx);
                
                % raster
                figure
                plot_single_contrast_raster(gca, spkt_k, num_usa_k, trl_len, ztime, [t_low, t_upp])
                xlabel('Time from MS onset (ms)')
                ylabel('Trials')
                title(sprintf('Condition index = %d', level_idx))
            end % if
            
            % show spike rate curve
            % ---------------------
            if flag_curve
                sr_mean_level = sr_mean(level_idx, :) * 1000;
                sr_sem_level  = sr_sem(level_idx, :) * 1000;
                
                color = [0 0 1];
                mean_width = 2;
                options.flag_fill = true;
                options.flag_showerr = false;
                figure
                plot_mean_error(gca, time, sr_mean_level, sr_sem_level, color, mean_width, options)
                set(gca, 'TickDir', 'out')
                xlim([t_low, t_upp])
                hold on
                plot([0 0], ylim, 'r')
                xlabel('Time from MS onset (ms)')
                ylabel('Spike rate (spikes/s)')
                title(sprintf('Condition index = %d', level_idx))
                
            end % if
        end %if
        
        if flag_all
            figure
            nlevel = size(sr_mean, 1);
            for k = 1:nlevel
                sr_mean_k = sr_mean(k, :) * 1000;
                sr_sem_k = sr_sem(k, :) * 1000;
                
                subplot(nlevel, 1, k)
                plot(time, sr_mean_k, 'k', 'LineWidth', 2);
                hold on
                plot(time, sr_mean_k + sr_sem_k, 'k:')
                plot(time, sr_mean_k - sr_sem_k, 'k:')
                xlim([t_low, t_upp])
                ylim(y_lim)
                plot([0 0], ylim, 'r')
                set(gca, 'box', 'off')
                if k ~= nlevel
                    set(gca, 'XTickLabel', [])
                end % if
                
            end % for
        end
        
        if flag_overlap
            overlap_idx = round(overlap_levels / 25) + 1;
            N = length(overlap_idx);
            mean_line_width = 2;
            
            % line 
            options.flag_fill = false;
            options.flag_showerr = false;
            figure
            for k = 1:N
                color_k = color_max(k, :);
                level_k = overlap_idx(k);
                sr_mean_k = sr_mean(level_k, :) * 1000;
                sr_sem_k  = sr_sem(level_k, :) * 1000;
                plot_mean_error(gca, time, sr_mean_k, sr_sem_k, color_k, mean_line_width, options);
               
            end %for
            set(gca, 'TickDir', 'out')
            xlim([t_low, t_upp])
            hold on
            plot([0 0], ylim, 'r')
            xlabel('Time from MS onset (ms)')
            ylabel('Spike rate (spikes/s)')
            
            % fill
            options.flag_fill = true;
            options.flag_showerr = false;
            figure
            for k = 1:N
                color_k = color_max(k, :);
                level_k = overlap_idx(k);
                sr_mean_k = sr_mean(level_k, :) * 1000;
                sr_sem_k  = sr_sem(level_k, :) * 1000;
                plot_mean_error(gca, time, sr_mean_k, sr_sem_k, color_k, mean_line_width, options);
               
            end %for
            set(gca, 'TickDir', 'out')
            xlim([t_low, t_upp])
            hold on
            plot([0 0], ylim, 'r')
            xlabel('Time from MS onset (ms)')
            ylabel('Spike rate (spikes/s)')
        end % if
        
        if flag_individual  % if show response of individual cells
            dat_var = { 'SpikeRate' 'sessions' };
            dat = curr_exp.db.Getsessvars(sname,dat_var); 
            sr = squeeze(dat.SpikeRate);
            se = dat.sessions;
            num_cell = length(se);
            
            % show response in individual window
            for k = 1:num_cell
                sr_k = sr(:, k) * 1000;
                se_k = se{k};
                
                figure
                plot(time, sr_k, 'b')
                hold on
                plot([0 0], ylim, 'r')
                plot([100 100], ylim, 'k:')
                plot([200 200], ylim, 'k:')
                xlabel('Time around MS onset (ms)')
                ylabel('Absolute spike rate (spike/s)')
                title(['cell ' se_k])
            end % for
            
            % show responses in one window
            figure
            plot(time, sr * 1000, 'b')
            hold on
            plot([0 0], ylim, 'r')
            plot([100 100], ylim, 'k:')
            plot([200 200], ylim, 'k:')
            xlabel('Time around MS onset (ms)')
            ylabel('Absolute spike rate (spike/s)')            
        end % if
        
    case { 'Normalized' }
        switch trig_edge
            case 'Onset'
                if ~suro_data
                    dat_var = {'SpikeRateMean_Norm', 'SpikeRateSEM_Norm'};
                    dat = curr_exp.db.Getsessvars(sname,dat_var);
                    sr_mean = dat.SpikeRateMean_Norm;
                    sr_sem  = dat.SpikeRateSEM_Norm;
                else
                    dat_var = {'SurrogateSpikeRateMean_Norm', 'SurrogateSpikeRateSEM_Norm'};
                    dat = curr_exp.db.Getsessvars(sname,dat_var);
                    sr_mean = dat.SurrogateSpikeRateMean_Norm;
                    sr_sem  = dat.SurrogateSpikeRateSEM_Norm;
                end
            case 'Offset'
                if ~suro_data
                    dat_var = {'SpikeRateMeanOff_Norm', 'SpikeRateSEMOff_Norm'};
                    dat = curr_exp.db.Getsessvars(sname,dat_var);
                    sr_mean = dat.SpikeRateMeanOff_Norm;
                    sr_sem  = dat.SpikeRateSEMOff_Norm;
                else
                    dat_var = {'SurrogateSpikeRateMeanOff_Norm', 'SurrogateSpikeRateSEMOff_Norm'};
                    dat = curr_exp.db.Getsessvars(sname,dat_var);
                    sr_mean = dat.SurrogateSpikeRateMeanOff_Norm;
                    sr_sem  = dat.SurrogateSpikeRateSEMOff_Norm;
                end
        end % switch
        
        % show spike rate data
        % --------------------
        if flag_single
            level_idx = round(single_level / 25) + 1;   % level index
            % show spike raster data
            % ---------------------------
            if flag_raster
                dat_var = {'SpikeTimes', 'UsaccNumbers', 'TrialLength'};
                dat = curr_exp.db.Getsessvars(sname,dat_var);
                
                spktimes    = dat.SpikeTimes;
                trl_len     = dat.TrialLength;
                num_usa     = dat.UsaccNumbers;
                
                spkt_k = spktimes{level_idx};
                num_usa_k = num_usa(level_idx);
                
                % raster
                figure
                plot_single_contrast_raster(gca, spkt_k, num_usa_k, trl_len, ztime, [t_low, t_upp])
                xlabel('Time from MS onset (ms)')
                ylabel('Trials')
                title(sprintf('Condition index = %d', level_idx))
            end % if
            
            % show spike rate curve
            % ---------------------
            if flag_curve
                switch norm_method
                    case 'Firing rate difference'
                        sr_mean_level = sr_mean(level_idx, :) * 1000;
                        sr_sem_level  = sr_sem(level_idx, :) * 1000;
                        y_label = 'Spike rate difference (spikes/s)';
                    case 'Percentage change'
                        sr_mean_level = sr_mean(level_idx, :) * 100;
                        sr_sem_level  = sr_sem(level_idx, :) * 100;
                        y_label = 'Spike rate change (%)';
                end % switch
                
                color = [0 0 1];
                mean_width = 2;
                options.flag_fill = true;
                options.flag_showerr = false;
                figure
                if flag_mod_area
                    supp_t_idx = time >= mod_range(1) & time <= mod_range(2) & sr_mean_level < 0;
                    stem(time(supp_t_idx), sr_mean_level(supp_t_idx), ...
                        'Marker', 'none', 'Color', [1 0.5 0.5], 'LineWidth', 1)
                    hold on
                    enha_t_idx = time >= mod_range(1) & time <= mod_range(2) & sr_mean_level >= 0;
                    stem(time(enha_t_idx), sr_mean_level(enha_t_idx), ...
                        'Marker', 'none', 'Color', [0.5 1 0.5], 'LineWidth', 1)
                end
                
                plot_mean_error(gca, time, sr_mean_level, sr_sem_level, color, mean_width, options)
                set(gca, 'TickDir', 'out')
                xlim([t_low, t_upp])
                hold on
                ax = axis;
                axis tight;
                ymax = max(ax(3:4));
                ylim([-ymax, ymax])
                % ylim([-12 12])
                plot([0 0], ylim, 'r', 'LineWidth', 1)
                plot(xlim, [0 0], 'color', [0.6 0.2 0])
                
                xlabel('Time from MS onset (ms)')
                ylabel(y_label)
                title(sprintf('Condition index = %d', level_idx))
                
            end % if
        end %if
        
        if flag_all
            
            figure
            nlevel = size(sr_mean, 1);
            for k = 1:nlevel
                switch norm_method
                    case 'Percentage change'
                        sr_mean_k = sr_mean(k, :) * 100;
                        sr_sem_k = sr_sem(k, :) * 100;
                    case 'Firing rate difference'
                        sr_mean_k = sr_mean(k, :) * 1000;
                        sr_sem_k = sr_sem(k, :) * 1000;                        
                end % switch
                
                subplot(nlevel, 1, k)
                plot(time, sr_mean_k, 'k', 'LineWidth', 2);
                hold on
                plot(time, sr_mean_k + sr_sem_k, 'k:')
                plot(time, sr_mean_k - sr_sem_k, 'k:')
                xlim([t_low, t_upp])
                ylim(y_lim)
                plot([0 0], ylim, 'r')
                plot(xlim, [0 0], 'b:')
                set(gca, 'box', 'off')
                if k ~= nlevel
                    set(gca, 'XTickLabel', [])
                end % if
                
            end % for
        end
        
        if flag_overlap
            overlap_idx = round(overlap_levels / 25) + 1;
            N = length(overlap_idx);
            mean_line_width = 2;
            
            % line 
            options.flag_fill = false;
            options.flag_showerr = true;
            figure
            for k = 1:N
                color_k = color_max(k, :);
                level_k = overlap_idx(k);
                switch norm_method
                    case 'Percentage change'
                        sr_mean_k = sr_mean(level_k, :) * 100;
                        sr_sem_k  = sr_sem(level_k, :) * 100;
                    case 'Firing rate difference'
                        sr_mean_k = sr_mean(level_k, :) * 1000;
                        sr_sem_k  = sr_sem(level_k, :) * 1000;                        
                end % switch
                plot_mean_error(gca, time, sr_mean_k, sr_sem_k, color_k, mean_line_width, options);
               
            end %for
            set(gca, 'TickDir', 'out')
            xlim([t_low, t_upp])
            hold on
            plot([0 0], ylim, 'r')
            xlabel('Time from MS onset (ms)')
            switch norm_method
                case 'Percentage change'
                    ylabel('Spike rate change (%)')
                case 'Firing rate difference'
                    ylabel('Firing rate difference (spikes/s)')
            end % switch
            
            % fill
            options.flag_fill = true;
            options.flag_showerr = false;
            figure
            for k = 1:N
                color_k = color_max(k, :);
                level_k = overlap_idx(k);
                switch norm_method
                    case 'Percentage change'
                        sr_mean_k = sr_mean(level_k, :) * 100;
                        sr_sem_k  = sr_sem(level_k, :) * 100;
                    case 'Firing rate difference'
                        sr_mean_k = sr_mean(level_k, :) * 1000;
                        sr_sem_k  = sr_sem(level_k, :) * 1000;                        
                end % switch
                plot_mean_error(gca, time, sr_mean_k, sr_sem_k, color_k, mean_line_width, options);
               
            end %for
                set(gca, 'TickDir', 'out')
                xlim([t_low, t_upp])
                hold on
                plot([0 0], ylim, 'r')
                xlabel('Time from MS onset (ms)')
            switch norm_method
                case 'Percentage change'
                    ylabel('Spike rate change (%)')
                case 'Firing rate difference'
                    ylabel('Firing rate difference (spikes/s)')
            end % switch
            
            
        end % if
        
        if flag_individual  % if show response of individual cells
            dat_var = { 'SpikeRate_Norm' 'sessions' };
            dat = curr_exp.db.Getsessvars(sname,dat_var); 
            sr = squeeze(dat.SpikeRate_Norm);
            se = dat.sessions;
            num_cell = length(se);
            
            % show response in individual window
            for k = 1:num_cell
                sr_k = sr(:, k) * 1000;
                se_k = se{k};
                
                figure
                plot(time, sr_k, 'b')
                hold on
                plot([0 0], ylim, 'r')
                plot(xlim, [0 0], 'color', [0.6 0.2 0])
                plot([100 100], ylim, 'k:')
                plot([200 200], ylim, 'k:')
                xlabel('Time around MS onset (ms)')
                ylabel('Spike rate difference (spike/s)')
                title(['cell ' se_k])
            end % for
            
            % show responses in one window
            figure
            plot(time, sr * 1000, 'b')
            hold on
            plot([0 0], ylim, 'r')
            plot(xlim, [0 0], 'g')
            plot([100 100], ylim, 'k:')
            plot([200 200], ylim, 'k:')
            xlabel('Time around MS onset (ms)')
            ylabel('Spike rate difference (spike/s)')            
        end % if        
end % switch
%

if flag_diff
    level_idx = round(diff_single_level / 10) + 1;
    switch diff_data_type
        case {'Not normalized'}
            dat_var = {'SpikeRateDiffMean', 'SpikeRateDiffSEM'};
            dat = curr_exp.db.Getsessvars(sname,dat_var);
            sr_mean = dat.SpikeRateDiffMean * 1000;
            sr_sem  = dat.SpikeRateDiffSEM * 1000;
    
            sr_mean_level = sr_mean(level_idx, :);
            sr_sem_level  = sr_sem(level_idx, :);
            
            y_label = 'Spike rate difference (spikes/s)';
        case {'Normalized'}
            dat_var = {'SpikeRateDiffMean_Norm', 'SpikeRateDiffSEM_Norm'};
            dat = curr_exp.db.Getsessvars(sname,dat_var);
            sr_mean = dat.SpikeRateDiffMean_Norm * 100;
            sr_sem  = dat.SpikeRateDiffSEM_Norm * 100;

            sr_mean_level = sr_mean(level_idx, :);
            sr_sem_level  = sr_sem(level_idx, :);
            
            y_label = 'Percentage change difference (%)';
    end % switch
    
    % single contrast difference
    color = [0 0 1];
    mean_width = 2;
    options.flag_fill = true;
    options.flag_showerr = false;
    figure
    plot_mean_error(gca, time, sr_mean_level, sr_sem_level, color, mean_width, options)
    set(gca, 'TickDir', 'out')
    xlim([t_low, t_upp])
    ylim(diff_y_lim)
    hold on
    plot([0 0], ylim, 'r')
    plot(xlim, [0 0], 'b:')
    xlabel('Time from MS onset (ms)')
    ylabel(y_label)
    title(sprintf('Condition index = %d', level_idx))
    
    % show all
    figure
    for k = 1:11
        sr_mean_k = sr_mean(k, :);
        sr_sem_k = sr_sem(k, :);
        
        subplot(11, 1, k)
        plot(time, sr_mean_k, 'k', 'LineWidth', 2);
        hold on
        plot(time, sr_mean_k + sr_sem_k, 'k:')
        plot(time, sr_mean_k - sr_sem_k, 'k:')
        xlim([t_low, t_upp])
        ylim(diff_y_lim)
        plot([0 0], ylim, 'r')
        plot(xlim, [0 0], 'b:')
        set(gca, 'box', 'off')
        if k ~= nlevel
            set(gca, 'XTickLabel', [])
        end % if
        
    end % for
    
    % fill all
    selected_idx = [2 3 4 5 6 7 8 9 10 11];
    N = length(selected_idx);
    mean_line_width = 2;
    options.flag_fill = true;
    options.flag_showerr = false;
    figure
    for k = 1:N
        color_k = color_max(k, :);
        level_k = selected_idx(k);
        sr_mean_k = sr_mean(level_k, :);
        sr_sem_k  = sr_sem(level_k, :);
        plot_mean_error(gca, time, sr_mean_k, sr_sem_k, color_k, mean_line_width, options);
        
    end %for
    set(gca, 'TickDir', 'out')
    xlim([t_low, t_upp])
    hold on
    plot([0 0], ylim, 'r')
    xlabel('Time from MS onset (ms)')
    ylabel(y_label)
   
end % if

if flag_comp
    switch data_type
        case {'Not normalized'}
            dat_var = {'SpikeRateMean', 'SpikeRateSEM', ...
                       'SurrogateSpikeRateMean', 'SurrogateSpikeRateSEM'};
            dat = curr_exp.db.Getsessvars(sname,dat_var);
            sr_mean = dat.SpikeRateMean *1000;
            sr_sem  = dat.SpikeRateSEM * 1000;
            sursr_mean = dat.SurrogateSpikeRateMean *1000;
            sursr_sem  = dat.SurrogateSpikeRateSEM * 1000;
            show_zero = false;
        case {'Normalized'}
            dat_var = {'SpikeRateMean_Norm', 'SpikeRateSEM_Norm', ...
                       'SurrogateSpikeRateMean_Norm', 'SurrogateSpikeRateSEM_Norm'};
            dat = curr_exp.db.Getsessvars(sname,dat_var);
            sr_mean = dat.SpikeRateMean_Norm * 100;
            sr_sem  = dat.SpikeRateSEM_Norm * 100;
            sursr_mean = dat.SurrogateSpikeRateMean_Norm * 100;
            sursr_sem  = dat.SurrogateSpikeRateSEM_Norm * 100;
            show_zero = true;
    end % switch

            figure
            sig_color = [0.6, 0.2, 0];
            for k = 1:11
                sr_mean_k = sr_mean(k, :);
                sr_sem_k = sr_sem(k, :);
                sursr_mean_k = sursr_mean(k, :);
                sursr_sem_k = sursr_sem(k, :);
                
                idx_k = (sr_mean_k + sr_sem_k < sursr_mean_k - sursr_sem_k) ...
                        | (sr_mean_k - sr_sem_k > sursr_mean_k + sursr_sem_k); 
                sig_k = sr_mean_k;
                sig_k(~idx_k) = NaN;
                
                subplot(11, 1, k)
                plot(time, sr_mean_k, 'k', 'LineWidth', 1);
                hold on
                plot(time, sig_k, 'color', sig_color, 'LineWidth', 2);
                plot(time, sr_mean_k + sr_sem_k, 'k:')
                plot(time, sr_mean_k - sr_sem_k, 'k:')
                if show_zero
                    plot(xlim, [0 0], 'g')
                end % if
                xlim([t_low, t_upp])
                ylim(y_lim)
                plot([0 0], ylim, 'r')
                set(gca, 'box', 'off')
                if k ~= nlevel
                    set(gca, 'XTickLabel', [])
                end % if
            end % for    
end % if


if flag_mod
    vars = { 'Modulation' };
    dat = curr_exp.db.Getsessvars(sname, vars);
    mod = dat.Modulation;
    
    % plot supp_enha_index
    supp_enha_index = mod.SuppEnhaIndex;
    mass_cent = mod.MassCenter;
    mc_dist = mod.MC2EqualDist;
    sig_cell = mod.SignificantCell;
    nlevel = size(supp_enha_index, 1);
    
    for k = 1:nlevel
        sig_k = logical(sig_cell(k, :));
        idx_k = squeeze(supp_enha_index(k, :, :));
        % show significant and all mass center
        mc_k = squeeze(mass_cent(k, [1, 3], :));
        plot_idx_pair(idx_k(1, :), idx_k(2, :), mc_k, sig_k)
        
    end % for
    
    % plot mass center distance as a function of contrast
    mass_dist = mc_dist(:, 3);    % just for 'all' now
    plot_mass_cent(mass_dist)

end

end % function Aggplot_usacc_triggered_contrast_response

% =========================================================================
% subroutines
% =========================================================================
function plot_mass_cent(m_dist)

figure
nlevel = 0:10:100;
plot(nlevel, m_dist, 'o')

[fitd, gof] = fit(nlevel', m_dist, 'poly1');
hold on
plot(fitd)

fprintf('R^2 = %0.3f\n', gof.rsquare)

end 

function plot_idx_pair(supp_idx, enha_idx, mass_center, sig_cell)

figure
% plot sig_cell
supp_sig = supp_idx(sig_cell);
enha_sig = enha_idx(sig_cell);
% plot(supp_sig, enha_sig, 'o', 'MarkerEdgeColor', [0 0 1], 'MarkerFaceColor', [0 0 1])
loglog(supp_sig, enha_sig, 'o', 'MarkerEdgeColor', [0 0 1], 'MarkerFaceColor', [0 0 1], 'MarkerSize', 12)
hold on
% plot not_sig_cell
supp_not_sig = supp_idx(~sig_cell);
enha_not_sig = enha_idx(~sig_cell);
% plot(supp_not_sig, enha_not_sig, 'o', 'MarkerEdgeColor', [0.7 0.7 1], 'MarkerFaceColor', [0.7 0.7 1])
% loglog(supp_not_sig, enha_not_sig, 'o', 'MarkerEdgeColor', [0.7 0.7 1], 'MarkerFaceColor', [0.7 0.7 1])
loglog(supp_not_sig, enha_not_sig, 'o', 'MarkerEdgeColor', [0 0 1], 'MarkerFaceColor', [0 0 1], 'MarkerSize', 12)

% add mass center
% plot(mass_center(1,1), mass_center(1, 2), 'r+', 'LineWidth', 4, 'MarkerSize', 24) % significant cell center
plot(mass_center(2,1), mass_center(2, 2), 'r+', 'LineWidth', 4, 'MarkerSize', 24) % all cell center

x_lim = xlim;
y_lim = ylim;
lim = [x_lim, y_lim];
% axis([min(lim), max(lim), min(lim), max(lim)])
axis([0.01 10 0.01 10])
axis square
plot(xlim, ylim, 'k')

xlabel('Suppression')
ylabel('Enhancement')

end

function plot_single_contrast_raster(axis_hanle, spktimes, num_trl, trl_len, ztime, x_lim)
t_low = x_lim(1);
t_upp = x_lim(2);

% raster
rasterplot(spktimes, num_trl, trl_len, axis_hanle, 1000, true, ztime)
set(gca, 'YTick', [])
xlim([t_low, t_upp])
hold on
plot([0 0], ylim, 'r')

end
% [EOF]
