function opt = plot_MSTriggeredContrastResponse(current_tag, sname, S)
% PLOT_MSTRIGGEREDCONTRASTRESPONSE plots results from MSTriggeredContrastResponse
%
% Syntax:
%   options = plot_MSTriggeredContrastResponse(current_tag, snames, S)
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 04/30/2013  2:23:03.572 PM
% $Revision: 0.1 $  $Date: 04/30/2013  2:23:03.572 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% options
% =========================================================================
if ( nargin == 1 )
    if ( strcmp( current_tag, 'get_options' ) )
        opt.data_type = { '{Not normalized}|Normalized', 'Choose data type' };
        opt.trig_signal = { '{MS onset}|MS end', 'Trigger signal' };
        opt.y_axis_lim = {[0 40], 'Y axis lim', [-1000 1000]};
        opt.norm_method = { {'{Firing rate difference}' 'Percentage change'}, 'Normalization method used' };

        opt.Show_single_luminance = { {'{0}','1'} };
        opt.Show_single_luminance_options.level = { {'0' '10' '20' '30' '40' '50' '60' '70' '80' '90' '100'}, 'Chose luminance level (%)'};
        opt.Show_single_luminance_options.flag_curve = { {'0','{1}'}, 'Show spike rate' };
        opt.Show_single_luminance_options.flag_mod_area = { {'0','{1}'}, 'Show modulation area' };
        opt.Show_single_luminance_options.mod_range = { [-75 355], 'Mod. range of interest' };
        % opt.Show_single_luminance_options.flag_raster = { {'{0}','1'}, 'Show spike raster' };

        return
    end
end

% =========================================================================
% get options
% =========================================================================
data_type = S.([mfilename,'_options']).data_type;
trig_signal = S.([mfilename,'_options']).trig_signal;
y_axis_lim = S.([mfilename,'_options']).y_axis_lim;
norm_method = S.([mfilename,'_options']).norm_method;

flag_single = S.([mfilename,'_options']).Show_single_luminance;
% some bugs of StructDlg
level_number = S.([mfilename,'_options']).Show_single_luminance_options.level;
if ischar(level_number)
    single_level = str2double(level_number);
else
    single_level = level_number;
end % if

% flag_raster = S.([mfilename,'_options']).Show_single_luminance_options.flag_raster;
flag_curve = S.([mfilename,'_options']).Show_single_luminance_options.flag_curve;
flag_mod_area = S.([mfilename,'_options']).Show_single_luminance_options.flag_mod_area;
mod_range =  S.([mfilename,'_options']).Show_single_luminance_options.mod_range;

% =========================================================================
% get data wanted
% =========================================================================
dat_var = {'MSTriggeredContrastResponse'};
dat = CorruiDB.Getsessvars(sname,dat_var);
ms_trig_resp = dat.MSTriggeredContrastResponse;

% =========================================================================
% plot
% =========================================================================
sd = ms_trig_resp.Baseline.SD;
baseline_mean = ms_trig_resp.Baseline.Mean;
thres = 2.5 * sd;
ms_dur = ms_trig_resp.MSDuration;
winc = ms_trig_resp.SpikeRateWinCenter;
pre_ms = ms_trig_resp.Paras.pre_ms;
win_width = ms_trig_resp.Paras.win_width;
time = winc - round(pre_ms + win_width / 2);

supp_seq = ms_trig_resp.Modulation.ModIndex.WholeSignal.Suppression.Sequence;
enha_seq = ms_trig_resp.Modulation.ModIndex.WholeSignal.Enhancement.Sequence;
switch data_type
    case 'Not normalized'
        sr = ms_trig_resp.SpikeRate;
        sig_base = baseline_mean;
    case 'Normalized'
        sr = ms_trig_resp.SpikeRateNormalized;
        sig_base = zeros(size(baseline_mean));
end % switch
plot_allLevels(sname, time, sr, sig_base, thres, supp_seq, enha_seq, ms_dur, trig_signal, y_axis_lim)

% show spike rate data
% --------------------
if flag_single
    level_idx = round(single_level / 25) + 1;   % level index
    % show spike raster data
    % ---------------------------
    %     if flag_raster
    %         dat_var = {'SpikeTimes', 'UsaccNumbers', 'TrialLength'};
    %         dat = CorruiDB.Getsessvars(sname,dat_var);
    %
    %         spktimes    = dat.SpikeTimes;
    %         trl_len     = dat.TrialLength;
    %         num_usa     = dat.UsaccNumbers;
    %
    %         spkt_k = spktimes{level_idx};
    %         num_usa_k = num_usa(level_idx);
    %
    %         % raster
    %         figure
    %         plot_single_contrast_raster(gca, spkt_k, num_usa_k, trl_len, ztime, [t_low, t_upp])
    %         xlabel('Time from MS onset (ms)')
    %         ylabel('Trials')
    %         title(sprintf('Condition index = %d', level_idx))
    %     end % if
    
    % show spike rate curve
    % ---------------------
    if flag_curve
        switch norm_method
            case 'Firing rate difference'
                sr_mean_level = sr(level_idx, :) * 1000;
                y_label = 'Spike rate difference (spikes/s)';
            case 'Percentage change'
                sr_mean_level = sr(level_idx, :) * 100;
                y_label = 'Spike rate change (%)';
        end % switch
        sr_sem_level = 0;
        
        color = [0 0 1];
        mean_width = 2;
        options.flag_fill = false;
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
        xlim([time(1), time(end)])
        hold on
        axis tight;
        set(gca, 'YLimMode', 'auto')
        % ax = axis;
        % ymax = max(abs(ax(3:4)));
        % ylim([-ymax, ymax])
        % ylim([-12 12])
        plot([0 0], ylim, 'r', 'LineWidth', 2)
        
        xlabel('Time from MS onset (ms)')
        ylabel(y_label)
        title(sprintf('Condition index = %d', level_idx))
        
    end % if
end %if

end % function plot_MSTriggeredContrastResponse

% =========================================================================
% subroutines
% =========================================================================
function plot_allLevels(sname, time, sr_mean, baseline, thres, supp_seq, enha_seq, ms_dur, trig_signal, y_lim)
% spikerate, baseline, s.d.
% ------------------------
nlevel = size(sr_mean, 1);
t_low = min(time);
t_upp = max(time);

figure('Name', sname)
for k = 1:nlevel
    sr_mean_k = sr_mean(k, :) * 1000;
    bs_k = baseline(k) * 1000;
    thres_k = thres(k) * 1000;
    
    ms_dur_mean_k = ms_dur(k, 1);
    ms_dur_sd_k = ms_dur(k, 2) ;
    
    if strcmp(trig_signal, 'MS end')
        ms_dur_mean_k = -ms_dur_mean_k;
    end % if
    ms_dur_sd_left_k = ms_dur_mean_k - ms_dur_sd_k;
    ms_dur_sd_right_k = ms_dur_mean_k + ms_dur_sd_k;
    
    subplot(nlevel, 1, k)
    % supp / enhancement
    supp_seq_k = supp_seq{k};
    h = stem(time(supp_seq_k), sr_mean_k(supp_seq_k), 'Color', [1 .5 .5],...
        'LineWidth', 4, 'Marker', 'None');
    hbase = get(h, 'Baseline');
    set(hbase, 'BaseValue', bs_k);
    hold on

    enha_seq_k = enha_seq{k};
    h = stem(time(enha_seq_k), sr_mean_k(enha_seq_k), 'Color', [.5 1 .5],...
        'LineWidth', 4, 'Marker', 'None');
    hbase = get(h, 'Baseline');
    set(hbase, 'BaseValue', bs_k);
    
    % spike rate
    plot(time, sr_mean_k, 'k', 'LineWidth', 2);
    xlim([t_low, t_upp])
    ylim(y_lim)
    
    % threshold
    upp_k = bs_k + thres_k;
    low_k = bs_k - thres_k;
    plot(xlim, [bs_k bs_k], 'b')
    plot(xlim, upp_k*[1 1], 'b:')
    plot(xlim, low_k*[1 1], 'b:')
    
    % MS trigger
    plot([0 0], ylim, 'r', 'LineWidth', 2)
    
    % MS duration
    plot(ms_dur_mean_k * [1 1], ylim, 'color', [0 .5 0], 'LineWidth', 2)
    plot(ms_dur_sd_left_k * [1 1], ylim, 'color', [0 .5 0], 'LineStyle', ':')
    plot(ms_dur_sd_right_k * [1 1], ylim, 'color', [0 .5 0], 'LineStyle', ':')

    set(gca, 'box', 'off')
    if k == 1
        title(sname)
    end 
    if k ~= 11
        set(gca, 'XTickLabel', [])
    else
        xlabel('Time around trigger (ms)')
        
    end % if
    
end % for

end %

% [EOF]
