%% == plot_correlation
function out = plot_correlation( ax, corr, err, baseline, window_backward, window_forward, samplerate, titl, xlab, ylab, leg, S )
% plot_correlation( current_tag, snames, S, var_names, baseline_names, tit, xlab, ylab, leg )
%   Uses the database to plot a correlation
% plot_correlation( [ax], correlations, baselines, window_backward, samplerate, Type_of_Data, tit, xlab, ylab, leg )
%   Plots the correlation given in correlations
% plot_correlation( [ax], correlations, baselines, window_backward, samplerate, Type_of_Data, tit, xlab, ylab, leg, Type_of_error, errorbars )
%   Plots the correlation given in correlations with the errorbars in
%   errorbars
%
% options = plot_correlation( 'get_options' )
%
%
% Parameters:
%   - current_tag       = current experiment tag
%   - snames            = session names
%   - S                 = structure with options from dialog
%   - var_names         = variables to plot
%   - baseline_names    = baseline or baselines corresponding to each variable
%   - tit               = title for the plot
%   - xlab              = x axis label
%   - ylab              = y axis label
%   - leg               = legend (optional)
%   - ax                = axis to plot in
%   - correlations      = single vector or cell of vectors with correlations to plot
%   - window_backward   = number of miliseconds that the correlation goes back from zero
%   - Type_of_error     = 'None' 'Lines' 'Shading'
%   - errorbars         =
%
% Examples:
%
% plot_correlation( current_tag, snames, S, var_names, baseline_names, tit, xlab, ylab )
% plot_correlation( current_tag, snames, S, var_names, baseline_names, tit, xlab, ylab, leg )
%
% plot_correlation( ax, correlations, baselines, window_backward, samplerate )
% plot_correlation( correlations, baselines, window_backward, samplerate )
% plot_correlation( correlations, baselines, window_backward, samplerate, Type_of_Data, Type_of_error)
% plot_correlation( correlations, baselines, window_backward, samplerate, Type_of_Data, Type_of_error, tit, xlab, ylab, leg )
%

% global colors_array;
[COLORS colors_array] = CorrGui.get_nice_colors();

color = colors_array;
color([1,2],:) = color([2,1],:);


titl = deunderscore(titl);

xvalues = -window_backward : 1000/samplerate : window_forward-1;

%this is to fix clipping masks for final plots
if exist('S','var') && isfield(S, 'Correlation_X_limit')
    set(ax,'YLimMode','auto');
    xlim(ax,S.Correlation_X_limit);
    
    plot_idx = xvalues >= S.Correlation_X_limit(1) & xvalues <= S.Correlation_X_limit(2);
else
    plot_idx = ones(size(xvalues));
end


N = length(corr);

% fix format of data
if ( ~iscell( corr ) )
    corr = {corr};
end
if (~ isempty( err ) )
    if ( ~iscell( err ) )
        err = {err};
    end
end
errplus = {err};
errminus = {err};
% deal with baselines
number_of_baselines = 1;
if ( iscell(baseline) )
    number_of_baselines = length(baseline);
else
    baselinetemp = baseline;
    baseline = {};
    for i=1:N
        baseline{i} = baselinetemp;
    end
end
for i=1:N
    if ( number_of_baselines == N )
        baseline{i} = baseline{i}*ones(size(corr{i}));
    else
        baseline{i} = baseline{1}(1,1)*ones(size(corr{i}));
    end
end

baselineplot = baseline;
%% preprocess data
for i=1:N
    % interpolate Infs
    corr{i}(isinf(corr{i})) = interp1(find(~isinf(corr{i})), corr{i}(~isinf(corr{i})), find(isinf(corr{i})));
    if ( ~isempty( err ) )
        err{i}(isinf(err{i})) = interp1(find(~isinf(err{i})), err{i}(~isinf(err{i})), find(isinf(err{i})));
    end
    
    % interpolate NaNs
    if sum(~isnan(corr{i}))
        corr{i}(isnan(corr{i})) = interp1(find(~isnan(corr{i})), corr{i}(~isnan(corr{i})), find(isnan(corr{i})));
        corr{i}(isnan(corr{i})) = 0;
        if ( ~isempty( err ) )
            err{i}(isnan(err{i})) = interp1(find(~isnan(err{i})), err{i}(~isnan(err{i})), find(isnan(err{i})));
            err{i}(isnan(err{i})) = 0;
        end
    end
    % -- smooth data
    if S.Correlation_Smoothing_Window_Width > 1 
        if ~(S.Correlation_Smoothing_Window_Width < length(corr{i}))
            S.Correlation_Smoothing_Window_Width = max(1:2:floor(length(corr{i})/5));
        end
        corr{i} = sgolayfilt(corr{i},1, S.Correlation_Smoothing_Window_Width);
        if ( ~isempty( err ) )
            err{i} = sgolayfilt(err{i},1, S.Correlation_Smoothing_Window_Width);
        end
    end
    
    if ( ~isempty( err ) )
        errplus{i} = corr{i} + err{i};
        errminus{i} = corr{i} - err{i};
    end
    
    % -- correct for percent increase or zscore
    switch(  S.Correlation_Type_of_Data )
        case '% increase'
            corr{i} = devmn(corr{i}, baseline{i});
            if ( ~isempty( err ) )
                errplus{i} = devmn(errplus{i}, baseline{i});
                errminus{i} = devmn(errminus{i}, baseline{i});
            end
            
            number_of_baselines = 1;
            for i=1:N
                baselineplot{i} = 0;
            end
        case 'Z-scores'
            corr{i} = zscore(corr{i});
            if ( ~isempty( err ) )
                errplus{i} = zscore(errplus{i});
                errminus{i} = zscore(errminus{i});
            end
            
            number_of_baselines = 1;
            for i=1:N
                baselineplot{i} = 0;
            end
    end
end


% -- plot
legh = zeros(1,N);
set(ax,'nextplot','add');
switch( S.Type_of_error )
    
    case 'None'
        for i=1:N
            legh(i) = plot(ax, xvalues(plot_idx), corr{i}(plot_idx), '-', 'LineWidth', 3, 'Color', color(i,:) );
        end
        out.hline = legh;
    case 'Lines'
        for i=1:N
            % plot lines
            legh(i) = plot(ax, xvalues(plot_idx), corr{i}(plot_idx), '-', 'LineWidth', 3,'Color', color(i,:) );
            
            % plot error lines
            if ( ~isempty( err ) )
                plot(ax, xvalues(plot_idx), errplus{i}, '-', 'LineWidth', 2, 'Color', color(i,:) );
                plot(ax, xvalues(plot_idx), errminus{i}, '-', 'LineWidth', 2, 'Color', color(i,:) );
            end
        end
        out.hline = legh;
        
    case 'Shadow'
        
        % plot lines
        for i=1:N
            legh(i) = plot(ax, xvalues(plot_idx), corr{i}(plot_idx), '-', 'LineWidth', 2, 'Color', color(i,: ));
        end
        % plot shadows
        if ( ~isempty( err ) )
            for i=1:N
                %             set(gcf,'Renderer','Zbuffer')
                xvalues_backward = xvalues(end:-1:1);
                plot_idx_backward = plot_idx(end:-1:1);
                xvalues_double = [xvalues(plot_idx)   xvalues_backward(plot_idx_backward)];
                
                errminus_backwards =  errminus{i}(end:-1:1);
                err =	[errplus{i}(plot_idx);   errminus_backwards(plot_idx_backward)];
                err = err';
                axes(ax);
                patch( xvalues_double, err, '-', 'FaceColor', color(i,:), 'LineStyle', 'none','FaceAlpha','flat','FaceVertexAlphaData',0.3,'AlphaDataMapping','none');
            end
        end
        out.hline = legh;
    otherwise
        disp('Unknown  Type_of_error');
        
end
mytight( ax, 15 );

% plot baseline
if ( number_of_baselines == 1 )
        plot(ax, xvalues(plot_idx), baselineplot{1}(plot_idx), 'k-.' );
else
    for i=1:N
            plot(ax, xvalues(plot_idx), baselineplot{i}(plot_idx), '-.', 'color',  color(i,:)  );
    end
end

if exist('S','var') && isfield(S, 'Correlation_X_limit')
    set(ax,'YLimMode','auto');
    xlim(ax,S.Correlation_X_limit);
end
% add line at zero
plot(ax, [0 0], get(ax,'YLim'), 'Color', 'k' )


% format plot
set(ax,'FontName', 'Arial', 'FontSize',14);
set(ax,'layer','top')
title(ax,titl);
xlabel(ax,xlab);
ylabel(ax,ylab);
box off;

% -- set legend
if ( ~isempty(leg) )
    legend(legh,leg)
end


if exist('S','var') && isfield(S, 'Correlation_Y_limit')
    ylim(ax,S.Correlation_Y_limit);
end



end









function p = check_parameters( varargin )


if ( nargin >=4)
    p = inputParser;   % Create an instance of the class.
    
    if ( isstr( varargin{1} ) )
        p.addRequired('current_tag', @isstr);
        p.addRequired('snames', @(x)(isstr(x)|iscell(x)));
        p.addRequired('S', @isstruct);
        p.addRequired('var_names', @(x)(isstr(x)|iscell(x)));
        p.addRequired('baseline_names', @(x)(isstr(x)|iscell(x)));
    else
        if ( ishandle( varargin{1} ) )
            p.addRequired('ax', @ishandle);
        end
        p.addRequired('correlations', @(x)(isnumeric(x)&& length(x)>1)||iscell(x));
        p.addRequired('baselines', @(x)(isnumeric(x))||iscell(x));
        p.addRequired('window_backward', @(x)(isnumeric(x))||iscell(x));
        p.addRequired('samplerate', @isnumeric);
        p.addOptional('Type_of_Data', '',  @isstr);
        p.addOptional('tit', 'Correlation', @isstr);
        p.addOptional('xlab', 'Time (ms)', @isstr);
        p.addOptional('ylab', '', @isstr);
        p.addOptional('leg', '',  @(x)(isstr(x)|iscell(x)));
        p.addOptional('Type_of_error', '',  @isstr);
        p.addOptional('errorbars', @(x)(isnumeric(x)&& length(x)>1)||iscell(x));
    end
    
    p.addOptional('tit', 'Correlation', @isstr);
    p.addOptional('xlab', 'Time (ms)', @isstr);
    p.addOptional('ylab', '', @isstr);
    p.addOptional('leg', '',  @(x)(isstr(x)|iscell(x)));
    
    
    p.StructExpand = true;
    p.parse(varargin{:});
    
    
    p = p.Results;
    if ( ~isfield( p, 'S') )
        p.S = S;
    end
else
    throw('at least four parameter are necessary');
end

end