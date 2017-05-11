function [corrs baselines samplerate window_backward window_forward corrs_SE signif] = get_correlation_dat( session_name, corr_names, baseline_names, which_eye, Correlation_Type_of_Data,S )
% plotdat = get_avgcorr_plotdat( Correlation_Type_of_Data, actual_plotdat, session_name, int_name, fad_name, avg_name)
% get from the database all the data necessary for an average session plot
% of correlation


if ( ~iscell(corr_names) )
    corr_names = {corr_names};
end

% if the session is aggregated we don't need left and right data
current_tag = CorruiDB.Getsessvar(session_name, 'internalTag');
isavg = ~isempty( strfind( current_tag, 'Avg')  );
if ( isavg )
    which_eye = 'Unique';
end
if ( ~isavg )
    Correlation_Type_of_Data = 'Raw';
end

samplerate      = CorruiDB.Getsessvar( session_name, 'samplerate');

%% window backward and forward
window_backward = CorruiDB.Getsessvar( session_name, 'window_backward');
window_forward  = CorruiDB.Getsessvar( session_name, 'window_forward');
if ( ~isavg) && isfield( window_backward, ['left_' corr_names{1}])
    window_backward = window_backward.(['left_' corr_names{1}]);
    window_forward  = window_forward.(['left_' corr_names{1}]);
else
    window_backward = window_backward.(corr_names{1});
    window_forward  = window_forward.(corr_names{1});
end

%% baselines
if ~iscell(baseline_names)
    baseline_names = {baseline_names};
end
if (~isavg)
    baselines = zeros(1, length(baseline_names));
else
    baselines = cell(1, length(baseline_names));
end
for i=1:length(baseline_names)
    % first check in filter_averages
    plotdat = get_plotdat( [], session_name, { 'indiv_filter_averages' 'filter_averages'}, which_eye );
    
    if ( ~isavg )
        if ( isfield( plotdat.filter_averages,  baseline_names{i} ) )
            baselines(i) = plotdat.filter_averages.(baseline_names{i});
            continue;
        end
    else
        if ( isfield( plotdat.indiv_filter_averages,  baseline_names{i} ) )
            baselines{i} = plotdat.indiv_filter_averages.(baseline_names{i})(1,1,:);
            continue;
        end
    end
    % if is not in filter averages
    
    % check if is a left/right variable or not
    plotdat = get_plotdat( plotdat, session_name, baseline_names{i}, which_eye );
    if ( isfield(plotdat,baseline_names{i}) && ~isempty( plotdat.(baseline_names{i})) )
        baselines(i) = plotdat.(baseline_names{i});
        continue;
    end
    
    % in the case is not a left/right variable no need for wich_eye
    plotdat = get_plotdat( plotdat, session_name, baseline_names{i} );
    if ( isfield(plotdat,baseline_names{i}) && ~isempty( plotdat.(baseline_names{i})) )
        baselines(i) = plotdat.(baseline_names{i});
        continue;
    end
    
    % it tries to remove the filter and look again
    nofilter_baseline = trim_filter_name(baseline_names{i}, current_tag);
    
    % check if is a left/right variable or not
    plotdat = get_plotdat( plotdat, session_name, nofilter_baseline, which_eye );
    if ( isfield(plotdat,nofilter_baseline) && ~isempty( plotdat.(nofilter_baseline) ))
        baselines(i) = plotdat.(nofilter_baseline);
        continue;
    end
    
    % in the case is not a left/right variable no need for wich_eye
    plotdat = get_plotdat( plotdat, session_name, nofilter_baseline );
    if ( isfield(plotdat,nofilter_baseline) && ~isempty( plotdat.(nofilter_baseline)) )
        baselines(i) = plotdat.(nofilter_baseline);
        continue;
    end
    
    warning(['baseline' baseline_names{i} 'not found']);
end


%% correlations and correlations Standard Errors
corrs = cell(size(corr_names));
corrsind = cell(size(corr_names));
if ( isavg )
    corrs_SE = cell(size(corr_names));
else
    corrs_SE = {};
end

for i=1:length(corr_names)
    if ( ~isavg )
        plotdat = get_plotdat( [], session_name, corr_names{i}, which_eye );
        corrs{i} = plotdat.(corr_names{i});
    else
        indivdata = CorruiDB.Getsessvar(  session_name,  'raw' );
        corr = indivdata.raw.(corr_names{i});
        switch( Correlation_Type_of_Data )
            case 'Raw'
                for j=1:size(corr,2)
                    corr(:,j) = cleanandsmooth( corr(:,j), S);
                end
            case '% increase'
                for j=1:size(corr,2)
                    corr(:,j) = cleanandsmooth( corr(:,j), S);
                    if( length( baselines ) == length(corr_names) )
                        corr(:,j) = devmn(corr(:,j), baselines{i}(j));
                    else
                        corr(:,j) = devmn(corr(:,j), baselines{1}(j));
                    end
                end
                
            case 'Z-scores'
        end
        corrs{i} = nanmean(corr,2);
        corrs_SE{i} = nanstd(corr,[],2)./sqrt(size(corr,2));
        corrsind{i} = corr;
    end
end
if ( length(corr_names)==2 && isavg  )
    [signif.ttest] = testsignif( corrsind, S );
else
    signif = [];
end
if ( isavg )
    if( length( baselines ) == length(corr_names) )
        baselines_tot = baselines;
        for i=1:length(corr_names)
            baselines{i} = nanmean(baselines_tot{i}(:));
        end
    else
        baselines{1} = nanmean(baselines{1}(:));
    end
end
%
%             %These should be avg sessions no matter what
%             if ~exist('plotdat_dev','var')
%                 plotdat_dev = get_plotdat( [], session_name, { 'raw_dev' } );
%             end
%             if ~isempty(plotdat_dev) && isfield(plotdat_dev.raw_dev,corr_names{i})
%
%                 all_pre_smooth_subj_dat = plotdat_dev.raw_dev.(corr_names{i});
%
%                 pre_smoothed_avg = nanmean(sgolayfilt(all_pre_smooth_subj_dat,1, S.Correlation_Smoothing_Window_Width),2);
%                 corrs{i}   = pre_smoothed_avg;
%
%                 pre_smoothed_std = nanstd(sgolayfilt(all_pre_smooth_subj_dat,1, S.Correlation_Smoothing_Window_Width),[],2)./sqrt(sum(~isnan(all_pre_smooth_subj_dat),2));
%                 corrs_SE{i}   = pre_smoothed_std;
%
%             end
%         case  'Raw_pre-smoothed'
%             %These should be avg sessions no matter what
%             if ~exist('plotdat_raw','var')
%                 plotdat_raw = get_plotdat( [], session_name, { 'raw' } );
%             end
%             if ~isempty(plotdat_raw)&& isfield(plotdat_raw.raw,corr_names{i})
%
%                 all_pre_smooth_subj_dat = plotdat_raw.raw.(corr_names{i});
%
%
%                 pre_smoothed_avg = nanmean(sgolayfilt(all_pre_smooth_subj_dat,1, S.Correlation_Smoothing_Window_Width),2);
%                 corrs{i}   = pre_smoothed_avg;
%
%                 pre_smoothed_std = nanstd(sgolayfilt(all_pre_smooth_subj_dat,1, S.Correlation_Smoothing_Window_Width),[],2)./sqrt(sum(~isnan(all_pre_smooth_subj_dat),2));
%                 corrs_SE{i}   = pre_smoothed_std;
%
%             end
%     end
end

function corr = cleanandsmooth( corr, S )
% interpolate Infs
corr(isinf(corr)) = interp1(find(~isinf(corr)), corr(~isinf(corr)), find(isinf(corr)));
                        
% interpolate NaNs
if sum(~isnan(corr))
    corr(isnan(corr)) = interp1(find(~isnan(corr)), corr(~isnan(corr)), find(isnan(corr)));
    corr(isnan(corr)) = 0;
end
% -- smooth data
if S.Correlation_Smoothing_Window_Width > 1
    if ~(S.Correlation_Smoothing_Window_Width < length(corr))
        S.Correlation_Smoothing_Window_Width = max(1:2:floor(length(corr)/5));
    end
    corr = sgolayfilt(corr,1, S.Correlation_Smoothing_Window_Width);
end
end

function signif = testsignif( corrs, S )
    signif = ones(size(corrs,1),1);
    corr1 = corrs{1};
    corr2 = corrs{2};
    w = 10;
    for i=1:length(corr1)-w
        a = corr1(i:i+w,:);
        b = corr2(i:i+w,:);
%         [h(i),p(i)] = signrank(a(:),b(:) ,'alpha', 0.05);
        [h(i),p(i)] = ttest(a(:),b(:) , 0.01/length(corr1),'right');
    end
    signif = h;
end

