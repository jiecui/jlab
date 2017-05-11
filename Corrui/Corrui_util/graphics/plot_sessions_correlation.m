function out = plot_sessions_correlation( current_tag, snames, S, var_names, baseline_names, tit, xlab, ylab, leg )
% out = plot_sessions_correlation( current_tag, snames, S, var_names, baseline_names, tit, xlab, ylab, leg )
%   plots a typical press and release correlation
%
% options = plot_pr_re_correlation( 'get_options' )
%
%
% Parameters:
%   - current_tag       = current experiment tag
%   - snames            = session names
%   - S                 = structure with options from dialog
%   - var_names         = correlations to plot
%   - baseline_names    = baselines
%   - tit               = title for the plot
%   - xlab              = x axis label
%   - ylab              = y axis label
%   - leg               = legend (optional)
%

out = [];
if ( nargin == 1 && isstr(varargin{1}))
    command = varargin{1};
    switch (command)
        case 'get_options'
            % TODO: add more options for formatting
            Correlation_Options.Correlation_Smoothing_Window_Width = { 151 '* (ms)' [1 10000] };
            Correlation_Options.Correlation_Type_of_Data = { {'{Raw}','% increase', 'Z-scores', '%_increase_pre-smoothed' 'Raw_pre-smoothed'} };
            Correlation_Options.Type_of_error = { {'{None}','Lines','Shadow'} };
            out = Correlation_Options;
    end
    return
end

% build the necessary figures and axes
if isfield(S,'axes_handles')
    ax = S.axes_handles;
else
    ax = CorrGui.create_subj_filter_figures( snames, S );
end

if ( ~exist('leg','var') )
    leg = {};
end
if ( ~iscell(var_names) )
    var_names = {var_names};
end
if ( ~iscell(baseline_names) )
    baseline_names = {baseline_names};
end

% select the eyes to use in the plot
if ( ~isfield( S, 'Which_Eyes_To_Use' ) )
    % specially for aggregated sessions where there is no
    % left and right
    S.Which_Eyes_To_Use = 'Unique';
end

if ~isfield(S, 'Reaction_Times_After_Time_Zero')
    S.Reaction_Times_After_Time_Zero = 0;
end

if ischar(current_tag)
    curr_exp = CorrGui.ExperimentConstructor(current_tag);
else
    curr_exp = current_tag;
end
filters = fieldnames( S.Trial_Categories );
if ( length(filters) > 1 ) %% BAD, IS JUST FOR EXPERIMENTS THAT DON'T DO CORRELATIONS WITH FILTERS
    % for each subject one figure
    for isubj=1:length(snames)
        n=0;
        
        % for each filter one axes
        for ifilter=1:length(filters)
            filter = filters{ifilter};
            if ( S.Trial_Categories.(filter) )
                n=n+1;
                filter_var_names = var_names;
                for i=1:length(var_names)
                    filter_var_names{i} = [var_names{i} '_' filter];
                end
                filter_baseline_names = baseline_names;
                for i=1:length(baseline_names)
                    filter_baseline_names{i} = [baseline_names{i} '_' filter];
                end

                % make current the appropiate axis and plot on it
                titl = { tit [ snames{isubj}(3:end) ' -- ' filter] };
                
                
                [corrs baselines samplerate window_backward window_forward corrs_SE, signif] = get_correlation_dat( snames{isubj}, filter_var_names, filter_baseline_names, S.Which_Eyes_To_Use, S.Correlation_Type_of_Data,S );
                Splot = S;
                if ( ~isempty(corrs_SE) )
                    Splot.Correlation_Type_of_Data = 'Raw';
                    Splot.Correlation_Smoothing_Window_Width = 1;
                end
                
                out.(snames{isubj}).(filter).ax = ax(isubj,n);
                out.(snames{isubj}).(filter).corr = plot_correlation(ax(isubj,n), corrs, corrs_SE, baselines, window_backward, window_forward, samplerate, titl, xlab, ylab, leg, Splot );
                
                if S.Plot_Peak_Interval
                    interval = sessdb('getsessvar',snames{isubj},['peak_interval_' filter]);
                    
                    if ~isempty(interval)
                        interval = (interval)*1000/samplerate;
                        plot(ax(isubj,n),[interval(1) interval(1) ], [0 max(get(ax(isubj,n),'ylim')) ],'linestyle','-','color','k','linewidth',2);
                        plot(ax(isubj,n),[interval(2) interval(2) ], [0 max(get(ax(isubj,n),'ylim')) ],'linestyle','-','color','k','linewidth',2);
                    end
                end
                if S.Plot_Reaction_Time
                    reaction_time_before_or_after = 'before';
                    if ismethod(curr_exp, 'get_associated_real_or_illusory_filter')
                        opp_filter = curr_exp.get_associated_real_or_illusory_filter(curr_exp, filter, 'real');
                        reaction_times_re = CorruiDB.Getsessvar(snames{isubj},['reaction_times_re_' opp_filter]);
                        reaction_times_pr = CorruiDB.Getsessvar(snames{isubj},['reaction_times_pr_' opp_filter]);
                        if curr_exp.is_Avg
                            concat_vars = CorruiDB.Getsessvar(snames{isubj},  'concatenated_vars' );
                            groups_re = concat_vars.(['reaction_times_re_' opp_filter]).sessionflag;
                            groups_pr = concat_vars.(['reaction_times_pr_' opp_filter]).sessionflag;
                            groups = [groups_pr;groups_re];
                        else
                            groups = [];
                        end
                        
                    else
                        reaction_times_re = CorruiDB.Getsessvar(snames{isubj},['reaction_times_re']);
                        reaction_times_pr = CorruiDB.Getsessvar(snames{isubj},['reaction_times_pr']);
                        if curr_exp.is_Avg
                            concat_vars = CorruiDB.Getsessvar(snames{isubj},  'concatenated_vars' );
                            groups_re = concat_vars.(['reaction_times_re']).sessionflag;
                            groups_pr = concat_vars.(['reaction_times_pr']).sessionflag;
                            groups = [groups_pr;groups_re];
                        else
                            groups = [];
                        end
                    end
                    reaction_times = [reaction_times_pr; reaction_times_re];
                    
                    out.(snames{isubj}).(filter).reaction_time = plot_reaction_time_patch(ax(isubj,n), reaction_times, reaction_time_before_or_after, groups);
                end
                if (isfield(S,'Plot_Significance') && S.Plot_Significance && isfield( signif, 'ttest') && ~isempty(signif.ttest) )
                    tt = signif.ttest;
                    tt(tt==0) = nan;
                    tt = [nan(1,5) tt nan(1,5)];
                    xind = -window_backward : 1000/samplerate : window_forward-1;
                    yl = get(ax(isubj,n),'ylim');
                    plot(ax(isubj,n),xind,yl(2)*tt*0.99,'-','linewidth',1,'color',[.5 .5 .5])
                end
                set(gcf,'color','white');
            end
            
        end
    end
    
elseif exist( 'current_tag', 'var' )
    % for each subject one figure
    for isubj=1:length(snames)
        n=0;
        
        % for each filter one axes
        for ifilter=1:length(filters)
            filter = filters{ifilter};
            if ( S.Trial_Categories.(filter) )
                n=n+1;
                
                
                % make current the appropiate axis and plot on it
                axes(ax(isubj,n))
                
                titl = [ snames{isubj}(3:end) ' -- ' filter];
                
                [corrs baselines samplerate window_backward window_forward corrs_SE] = get_correlation_dat( snames{isubj}, var_names, baseline_names, S.Which_Eyes_To_Use, S.Correlation_Type_of_Data,S );
                
                plot_correlation(ax(isubj,n), corrs, corrs_SE, baselines, window_backward, window_forward, samplerate, titl, xlab, ylab, leg, S );
                
            end
            set(gcf,'color','white');
        end
        
    end
end
end

