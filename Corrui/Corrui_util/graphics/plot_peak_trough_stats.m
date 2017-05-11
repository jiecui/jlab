function [out, out2, signif] = plot_peak_trough_stats(current_tag, sessions, S,ax)
% This will plot the peak vs combinations of (trough,before peak, after peak) stats. Where teh peak
% is found from the contribution and efficacy analysis and the trough is found in an analogous way to
% the peak interval.
out = [];
out2 = [];
signif = [];
COLORS = CorrGui.get_nice_colors;

S.Histogram_options.Use_Lines = 1;
S.Histogram_options.Y_Axis =  'Percentage';

peak_trough_colors = cat(1,COLORS.ROYAL_PURPLE, COLORS.MEDIUM_BLUE,  COLORS.MEDIUM_GOLD,...
    COLORS.MAGENTA, COLORS.MEDIUM_PINK,COLORS.GREY  );
%peak = first color, trough = 2nd color, before = third color, after =
%fourth color, outside = fifth color, all = sixth color

% which_eye = S.Which_Eyes_To_Use;

which_eye =  'Unique';

%Get the type of eyemovement we are considering
movement_type = S.Peak_Trough_Stats_options.Movement_Type;

switch movement_type
    case 'drift'
        prop = get_enumprop_varname(S.Peak_Trough_Stats_options.Drift_Property);
    case {'sacc' 'usacc'}
        prop = get_enumprop_varname(S.Peak_Trough_Stats_options.Usacc_Sacc_Property);
end
%get the units
units = get_units(movement_type,prop);

%get the type of mean ( could be mean max, or mean)
mean_type = S.Peak_Trough_Stats_options.Mean_Type;
%get the error type, (could be std dev or std err)
error_type = S.Peak_Trough_Stats_options.Error_Type;

switch error_type
    case 'std_dev'
        error_type = 'std';
end

switch mean_type
    case 'mean'
        ylab = ['Mean ' prop ' (' units ')'];
        distr_type = [];
        xlab_distr = [distr_type ' ' prop ' (' units ')'];
    case 'mean_max'
        ylab = ['Mean max ' prop ' (' units ')'];
        distr_type = 'max_';
        xlab_distr = [distr_type ' ' prop ' (' units ')'];
    case 'mean_mean'
        ylab = ['Mean_mean ' prop ' (' units ')'];
        distr_type = 'mean_mean_';
        xlab_distr = [distr_type ' ' prop ' (' units ')'];
    case 'mean_median'
        ylab = ['Mean_median ' prop ' (' units ')'];
        distr_type = 'mean_median_';
        xlab_distr = [distr_type ' ' prop ' (' units ')'];
    case 'mean_std'
        ylab = ['Mean_std ' prop ' (' units ')'];
        distr_type = 'mean_std_';
        xlab_distr = [distr_type ' ' prop ' (' units ')'];
end
ylab_distr = movement_type;


if S.Peak_Trough_Stats_options.Drift_No_Other_Events_In_The_Intervals && strcmp(movement_type, 'drift')
    prop = ['no_event_' prop];
end

%get all the regions we will be plotting
regions = fields(S.Peak_Trough_Stats_options.Regions);

m=1;
idx=[];
for i = 1:length(regions)
    if S.Peak_Trough_Stats_options.Regions.(regions{i})
        idx(m) = i;
        m=m+1;
    end
end

regions = regions(idx);

for i=1:length(regions)
    %get the axes for each region, all filters for one subj will be in one
    %figure
    if S.Peak_Trough_Stats_options.Means
        if (~exist('ax','var'))||length(regions) ~= length(ax)
            ax{i} = CorrGui.create_subj_filter_figures(sessions,S);
        end
    end
    if S.Peak_Trough_Stats_options.Distributions && ~S.Peak_Trough_Stats_options.Means
        if exist('ax','var')
            ax2{i} = ax;
        end
        if (~exist('ax2','var'))||length(regions) ~= length(ax2)
            ax2{i} = CorrGui.create_subj_filter_figures(sessions,S);
        end
    elseif S.Peak_Trough_Stats_options.Distributions && S.Peak_Trough_Stats_options.Means
        ax2{i} = CorrGui.create_subj_filter_figures(sessions,S);
    end
    
    
    filters = fieldnames(S.Trial_Categories);
    for isubj = 1:length(sessions)
        nfilter = 0;
        for ifilter=1:length(filters)
            sname = sessions{isubj};
            clear bars errors
            if ~( S.Trial_Categories.(filters{ifilter}) )
                continue
            end
            nfilter = nfilter + 1;
            if ( isempty( strfind(current_tag, 'Avg') ) )
                
                trial_type = filters{ifilter};
                
                switch( regions{i} )
                    case   'Peak_vs_Trough'
                        
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_peak_stats_' prop '_' trial_type] ...
                            [movement_type '_trough_stats_' prop '_' trial_type]}, which_eye,{{[mean_type '_during'], [error_type '_during']}...
                            {[mean_type '_during'], [error_type '_during']}});
                        
                        bars(1) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(1) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([error_type '_during']);
                        bars(2) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(2) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([error_type '_during']);
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_peak_distribs_' prop '_' trial_type] ...
                                [movement_type '_trough_distribs_' prop '_' trial_type]}, 'Unique',{{[distr_type 'during']}...
                                {[distr_type 'during']}});
                            distr_data{1} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{2} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'during']);
                        end
                        
                        leg = {'Peak','Trough'};
                        color_index = [1,2];
                        
                    case 'Peak_vs_Rest'
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_peak_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [error_type '_during'],[mean_type '_outside'], [error_type '_outside']}});
                        
                        bars(1) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(1) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([error_type '_during']);
                        bars(2) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_outside']);
                        errors(2) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([error_type '_outside']);
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_peak_distribs_' prop '_' trial_type]}, 'Unique',...
                                {{[distr_type 'during'],[distr_type 'outside']}});
                            distr_data{1} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{2} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'outside']);
                        end
                        
                        leg = {'Peak','Rest'};
                        color_index = [1,5];
                    case 'Before_Peak_After'
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_peak_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [error_type '_during'],[mean_type '_before'], [error_type '_before'],...
                            [mean_type '_after'], [error_type '_after']}});
                        
                        bars(1) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_before']);
                        errors(1) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([error_type '_before']);
                        bars(2) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(2) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([error_type '_during']);
                        bars(3) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_after']);
                        errors(3) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([error_type '_after']);
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_peak_distribs_' prop '_' trial_type]}, 'Unique',...
                                {{[distr_type 'during'],[distr_type 'before'],[distr_type 'after']}});
                            distr_data{1} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'before']);
                            distr_data{2} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{3} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'after']);
                        end
                        
                        
                        
                        leg = {'Before peak','During peak','After peak'};
                        color_index = [3,1,4];
                        
                        
                    case 'Trough_vs_Rest'
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_trough_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [error_type '_during'],[mean_type '_outside'], [error_type '_outside']}});
                        
                        bars(1) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(1) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([error_type '_during']);
                        bars(2) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_outside']);
                        errors(2) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([error_type '_outside']);
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_trough_distribs_' prop '_' trial_type]}, 'Unique',...
                                {{[distr_type 'during'],[distr_type 'outside']}});
                            distr_data{1} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{2} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'outside']);
                        end
                        
                        leg = {'Trough','Rest'};
                        color_index = [2,5];
                    case 'Before_Trough_After'
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_trough_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [error_type '_during'],[mean_type '_before'], [error_type '_before'],...
                            [mean_type '_after'], [error_type '_after']}});
                        
                        bars(1) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_before']);
                        errors(1) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([error_type '_before']);
                        bars(2) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(2) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([error_type '_during']);
                        bars(3) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_after']);
                        errors(3) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([error_type '_after']);
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_trough_distribs_' prop '_' trial_type]}, 'Unique',...
                                {{[distr_type 'during'],[distr_type 'before'],[distr_type 'after']}});
                            distr_data{1} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'before']);
                            distr_data{2} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{3} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'after']);
                        end
                        
                        leg = {'Before Trough','During Trough','After Trough'};
                        color_index = [3,2,4];
                    case 'Peak_vs_All'
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_peak_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [error_type '_during'],[mean_type '_all'], [error_type '_all']}});
                        
                        bars(1) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(1) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([error_type '_during']);
                        bars(2) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_all']);
                        errors(2) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([error_type '_all']);
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_peak_distribs_' prop '_' trial_type]}, 'Unique',...
                                {{[distr_type 'during'],[distr_type 'all']}});
                            distr_data{1} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{2} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'all']);
                        end
                        
                        leg = {'Peak','All'};
                        color_index = [1,6];
                    case 'Trough_vs_All'
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_trough_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [error_type '_during'],[mean_type '_all'], [error_type '_all']}});
                        
                        bars(1) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(1) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([error_type '_during']);
                        bars(2) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_all']);
                        errors(2) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([error_type '_all']);
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_trough_distribs_' prop '_' trial_type]}, 'Unique',...
                                {{[distr_type 'during'],[distr_type 'all']}});
                            distr_data{1} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{2} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'all']);
                        end
                        
                        leg = {'Trough','All'};
                        color_index = [2,6];
                end
                
                groups = [];
                
            else
                
                
                trial_type = filters{ifilter};
                
                switch( regions{i} )
                    case   'Peak_vs_Trough'
                        
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_peak_stats_' prop '_' trial_type] ...
                            [movement_type '_trough_stats_' prop '_' trial_type]}, which_eye,{{[mean_type '_during']},{[mean_type '_during']}});
                        
                        se_plot_dat = get_plotdat( [], sessdb('getsessvar',...
                            sname,'associatedSESession'), {[movement_type '_peak_stats_' prop '_' trial_type]...
                            [movement_type '_trough_stats_' prop '_' trial_type]},which_eye,{{[mean_type '_during']},{[mean_type '_during']}});
                        
                        bars(1) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(1) = se_plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_during']);
                        bars(2) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(2) = se_plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_during']);
                        
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_peak_distribs_' prop '_' trial_type] ...
                                [movement_type '_trough_distribs_' prop '_' trial_type]}, 'Unique',{{[distr_type 'during']}...
                                {[distr_type 'during']}});
                            distr_data{1} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{2} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            
                            concat_vars = CorruiDB.Getsessvar(sname,'concatenated_vars');
                            groups{1} = concat_vars.([movement_type '_peak_distribs_' prop]).([distr_type 'during']).(trial_type).sessionflag;
                            groups{2} = concat_vars.([movement_type '_trough_distribs_' prop]).([distr_type 'during']).(trial_type).sessionflag;
                            
                            
                        end
                        
                        leg = {'Peak','Trough'};
                        color_index = [1,2];
                    case 'Peak_vs_Rest'
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_peak_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [mean_type '_outside']}});
                        
                        se_plot_dat = get_plotdat( [], sessdb('getsessvar',...
                            sname,'associatedSESession'),{[movement_type '_peak_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [mean_type '_outside']}});
                        
                        bars(1) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(1) = se_plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_during']);
                        bars(2) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_outside']);
                        errors(2) = se_plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_outside']);
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_peak_distribs_' prop '_' trial_type]}, 'Unique',...
                                {{[distr_type 'during'],[distr_type 'outside']}});
                            distr_data{1} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{2} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'outside']);
                            
                            concat_vars = CorruiDB.Getsessvar(sname,'concatenated_vars');
                            groups{1} = concat_vars.([movement_type '_peak_distribs_' prop]).([distr_type 'during']).(trial_type).sessionflag;
                            groups{2} = concat_vars.([movement_type '_peak_distribs_' prop]).([distr_type 'outside']).(trial_type).sessionflag;
                        end
                        
                        leg = {'Peak','Rest'};
                        color_index = [1,5];
                    case 'Before_Peak_After'
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_peak_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [mean_type '_before'], [mean_type '_after']}});
                        
                        se_plot_dat = get_plotdat( [], sessdb('getsessvar',...
                            sname,'associatedSESession'),{[movement_type '_peak_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [mean_type '_before'], [mean_type '_after']}});
                        
                        
                        bars(1) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_before']);
                        errors(1) = se_plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_before']);
                        bars(2) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(2) = se_plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_during']);
                        bars(3) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_after']);
                        errors(3) = se_plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_after']);
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_peak_distribs_' prop '_' trial_type]}, 'Unique',...
                                {{[distr_type 'during'],[distr_type 'before'],[distr_type 'after']}});
                            distr_data{1} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'before']);
                            distr_data{2} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{3} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'after']);
                            
                            concat_vars = CorruiDB.Getsessvar(sname,'concatenated_vars');
                            groups{1} = concat_vars.([movement_type '_peak_distribs_' prop]).([distr_type 'before']).(trial_type).sessionflag;
                            groups{2} = concat_vars.([movement_type '_peak_distribs_' prop]).([distr_type 'during']).(trial_type).sessionflag;
                            groups{3} = concat_vars.([movement_type '_peak_distribs_' prop]).([distr_type 'after']).(trial_type).sessionflag;
                            
                            
                            
                            % % %                             [minNumData, minIdx] =  min([length(distr_data{1}); length(distr_data{2});length(distr_data{3})]);
                            % % %                             distr_data2= distr_data;
                            % % %                             for inum = 1:3
                            % % %                                 if ~(minIdx == inum)
                            % % %                                     aa = randperm(length(distr_data2{inum}));
                            % % %                                     distr_data2{inum} =  distr_data2{inum}(aa(1:minNumData));
                            % % %                                 end
                            % % %                             end
                            
                            % % %                             [maxNumData, maxIdx] =  max([length(distr_data{1}); length(distr_data{2});length(distr_data{3})]);
                            % % %                             distr_data2= distr_data;
                            % % %                             for inum = 1:3
                            % % %                                 if ~(maxIdx == inum)
                            % % %                                     aa = randperm(length(distr_data2{inum}));
                            % % %                                     distr_data2{inum}(end:length(distr_data{maxIdx})) =  nan;
                            % % %                                 end
                            % % %                             end
                            % % %
                            % % %                             [signif.h.peak, signif.p.peak, signif.ci.peak] = ttest2(distr_data2{1}(:), distr_data2{2}(:) ,  0.00001, 'left', 'unequal');
                            % % %
                            % % %                             [signif.h.after_peak, signif.p.after_peak, signif.ci.after_peak] = ttest2(distr_data2{1}(:), distr_data2{3}(:) , 0.00001, 'left', 'unequal');
                            
                        end
                        
                        
                        leg = {'Before peak','During peak','After peak'};
                        color_index =  [3,1,4];
                        
                    case 'Trough_vs_Rest'
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_trough_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'],[mean_type '_outside']}});
                        
                        se_plot_dat = get_plotdat( [], sessdb('getsessvar',...
                            sname,'associatedSESession'),{[movement_type '_trough_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'],[mean_type '_outside']}});
                        
                        bars(1) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(1) = se_plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_during']);
                        bars(2) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_outside']);
                        errors(2) = se_plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_outside']);
                        
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_trough_distribs_' prop '_' trial_type]}, 'Unique',...
                                {{[distr_type 'during'],[distr_type 'outside']}});
                            distr_data{1} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{2} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'outside']);
                            
                            concat_vars = CorruiDB.Getsessvar(sname,'concatenated_vars');
                            groups{1} = concat_vars.([movement_type '_trough_distribs_' prop]).([distr_type 'during']).(trial_type).sessionflag;
                            groups{2} = concat_vars.([movement_type '_trough_distribs_' prop]).([distr_type 'outside']).(trial_type).sessionflag;
                        end
                        
                        leg = {'Trough','Rest'};
                        color_index = [2,5];
                    case 'Before_Trough_After'
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_trough_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [mean_type '_before'], [mean_type '_after']}});
                        
                        se_plot_dat = get_plotdat( [], sessdb('getsessvar',...
                            sname,'associatedSESession'),{[movement_type '_trough_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [mean_type '_before'], [mean_type '_after']}});
                        
                        bars(1) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_before']);
                        errors(1) = se_plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_before']);
                        bars(2) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(2) = se_plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_during']);
                        bars(3) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_after']);
                        errors(3) = se_plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_after']);
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_trough_distribs_' prop '_' trial_type]}, 'Unique',...
                                {{[distr_type 'during'],[distr_type 'before'],[distr_type 'after']}});
                            distr_data{1} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'before']);
                            distr_data{2} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{3} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'after']);
                            
                            concat_vars = CorruiDB.Getsessvar(sname,'concatenated_vars');
                            groups{1} = concat_vars.([movement_type '_trough_distribs_' prop]).([distr_type 'before']).(trial_type).sessionflag;
                            groups{2} = concat_vars.([movement_type '_trough_distribs_' prop]).([distr_type 'during']).(trial_type).sessionflag;
                            groups{3} = concat_vars.([movement_type '_trough_distribs_' prop]).([distr_type 'after']).(trial_type).sessionflag;
                        end
                        
                        leg = {'Before Trough','During Trough','After Trough'};
                        color_index = [3,2,4];
                    case 'Peak_vs_All'
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_peak_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [mean_type '_all']}});
                        
                        se_plot_dat = get_plotdat( [], sessdb('getsessvar',...
                            sname,'associatedSESession'),{[movement_type '_peak_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [mean_type '_all']}});
                        
                        bars(1) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(1) = se_plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_during']);
                        bars(2) = plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_all']);
                        errors(2) = se_plot_dat.([movement_type '_peak_stats_' prop '_' trial_type]).([mean_type '_all']);
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_peak_distribs_' prop '_' trial_type]}, 'Unique',{{[distr_type 'during'],[distr_type 'all']}});
                            distr_data{1} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{2} = plot_dat.([movement_type '_peak_distribs_' prop '_' trial_type]).([distr_type 'all']);
                            
                            concat_vars = CorruiDB.Getsessvar(sname,'concatenated_vars');
                            groups{1} = concat_vars.([movement_type '_peak_distribs_' prop]).([distr_type 'during']).(trial_type).sessionflag;
                            groups{2} = concat_vars.([movement_type '_peak_distribs_' prop]).([distr_type 'all']).(trial_type).sessionflag;
                        end
                        
                        leg = {'Peak','All'};
                        color_index = [1,6];
                    case 'Trough_vs_All'
                        
                        plot_dat = get_plotdat([], sname, {[movement_type '_trough_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [mean_type '_all']}});
                        
                        se_plot_dat = get_plotdat( [], sessdb('getsessvar',...
                            sname,'associatedSESession'),{[movement_type '_trough_stats_' prop '_' trial_type]},...
                            which_eye,{{[mean_type '_during'], [mean_type '_all']}});
                        
                        bars(1) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_during']);
                        errors(1) = se_plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_during']);
                        bars(2) = plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_all']);
                        errors(2) = se_plot_dat.([movement_type '_trough_stats_' prop '_' trial_type]).([mean_type '_all']);
                        
                        if S.Peak_Trough_Stats_options.Distributions
                            plot_dat = get_plotdat([], sname, {[movement_type '_trough_distribs_' prop '_' trial_type]}, 'Unique',...
                                {{[distr_type 'during'],[distr_type 'all']}});
                            distr_data{1} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'during']);
                            distr_data{2} = plot_dat.([movement_type '_trough_distribs_' prop '_' trial_type]).([distr_type 'all']);
                            
                            concat_vars = CorruiDB.Getsessvar(sname,'concatenated_vars');
                            groups{1} = concat_vars.([movement_type '_trough_distribs_' prop]).([distr_type 'during']).(trial_type).sessionflag;
                            groups{2} = concat_vars.([movement_type '_trough_distribs_' prop]).([distr_type 'all']).(trial_type).sessionflag;
                        end
                        leg = {'Trough','All'};
                        color_index = [2,6];
                end
                
            end
            
            titl = [sname(3:end) '-' movement_type '-' deunderscore(prop)  '-' trial_type];
            if S.Peak_Trough_Stats_options.Means
                barweb(bars,errors,.75,[],titl,[],ylab,peak_trough_colors(color_index,:),[],[],ax{i}(isubj,nfilter));
                set(ax{i}(isubj,nfilter),'box','on');
                legend(ax{i}(isubj,nfilter),leg,'location','Northeast');
                out = ax;
            end
            
            if S.Peak_Trough_Stats_options.Distributions
                if S.Peak_Trough_Stats_options.Distributions
                    
                    for j = 1:length(distr_data)
                        mindata(j) = min(distr_data{j});
                        maxdata(j) = max(distr_data{j});
                    end
                    mindata = min(mindata);
                    maxdata = max(maxdata);
                    
                    degbins = [mindata:(maxdata-mindata)/10:maxdata];
                    
                    plot_histogram( ax2{i}(isubj,nfilter), S.Histogram_options, distr_data, degbins, titl, xlab_distr, ylab_distr, [], groups , leg, peak_trough_colors(color_index,:) );
                    out2 = ax2;
                    set(ax2{i}(isubj,nfilter), 'xlim', [mindata, maxdata]);
                end
            end
            
            % plot_histogram( [ax], [S], data, [thebins], [tit], [xlab],
            % [ylab], [totaltime],[groups], [legend] )
        end
    end
end



