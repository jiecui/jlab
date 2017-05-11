function plot_raw( handles, action )
% CORRGUI.PLOT_RAW conbines different data type into one session
%
% Syntax:
%   plot_raw( handles, action)
%
% Input(s):
%   handles     - corrui handles variable
%   action      - options
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Wed 06/15/2016 10:23:27.155 PM
% $Revision: 0.2 $  $Date: Wed 07/06/2016  8:09:14.801 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% set up initial conditions
% -------------------------
[~, curr_exp] = CorrGui.get_current_tag(handles);

xMaximum = -Inf;
xMinimum = Inf;
yMaximum = -Inf;
yMinimum = Inf;

maxLength = 0;

plotHandles = [];
histoData   = [];

% get contents of variable strings
% ---------------------------------
if ~isfield(handles, 'tableVarSelection')
    cprintf('Text', 'Please select variables.\n')
    return
end % if
vars = handles.Variable_List( handles.tableVarSelection.Indices(:, 1) );
if isempty(vars)
    return
end

% get contents of session strings
% -------------------------------
contentssess    = get( handles.sessionlistbox, 'String' );
sess            = get( handles.sessionlistbox, 'Value' );
curplot         = 0;

% get data, check max and min for common y-scale
% ----------------------------------------------
num_sess = numel(sess);
num_vars = numel(vars);
plotData = cell(num_vars, num_sess);
for k = 1:num_sess
    usess_k = contentssess{sess(k)};
    sess_k = curr_exp.UserSessName2SessName(usess_k);
    for j=1:num_vars
        var_j = vars{j};
        plotdat = CorruiDB.Getsessvar(sess_k, var_j);
        if isrow(plotdat) == true
            plotdat = plotdat.';
        end % if
        maxLength = max( maxLength, length(plotdat) );
        if ~isempty(plotdat) && isnumeric(plotdat)
            plotData{j,k} = plotdat;
        end % if
    end
end
if isempty(plotData{1, 1}) == true
    cprintf('SystemCommands', 'The selected variables are either empty or non-numeric.\n')
    return
end % if

% now plot
% --------
plotType = GetCurrentValue( handles.popupPlotType );

switch action
    case 'buttonplotvariable'
        figure;
        set( gcf, 'color', 'white' );
        for j=1:length(vars)
            for k=1:length(sess)
                curplot = curplot + 1;
                subplot( length(vars), length(sess), curplot );
                var_j  = vars{j};
                plotdat = double(plotData{j,k});
                if ( isscalar( plotdat) )
                    plotdat = plotdat * ones( maxLength,1);
                end
                if ~isempty( plotdat ) && isnumeric( plotdat )
                    if strcmp(plotType, 'histogram')
                        if size(plotdat,2)>1
                            warndlg(['Histogram doesn''t support variables' ...
                                ' with multiple columns'],'Unsupported Plot');
                            continue;
                        end
                        [n,xtickpositions,xticklabels] = myhist( plotdat, handles);
                        bar(n);
                        xtck = get(gca,'xtick');
                        %                         set(gca,'xtick',xtickpositions);
                        if xtck(1) == 0
                            xtck(1) = 1;
                        end
                        xtck(xtck>length(xticklabels)) = [];
                        set(gca,'xtick',xtck);
                        set(gca,'xticklabel',xticklabels(xtck,:));
                    else
                        plot( getsmooth( handles, plotdat ) );
                    end
                    if j==1
                        title( contentssess{sess(k)} );
                    end
                    if k==1
                        if strcmp( plotType, 'histogram' )
                            ylabel( ['# of ' deunderscore( var_j )] );
                            xlabel( deunderscore( var_j ) );
                        else
                            ylabel( deunderscore( var_j ) );
                        end
                    end
                    if handles.rawPlotOptions.Common_X_Scale
                        plotHandles(j,k) = gca;
                        currentXLim = getxlim();
                        if currentXLim(1) < yMinimum
                            xMinimum = currentXLim(1);
                        end
                        if currentXLim(2) > xMaximum
                            xMaximum = currentXLim(2);
                        end
                    end
                    if handles.rawPlotOptions.Common_Y_Scale
                        plotHandles(j,k) = gca;
                        currentYLim = getylim();
                        if currentYLim(1) < yMinimum
                            yMinimum = currentYLim(1);
                        end
                        if currentYLim(2) > yMaximum
                            yMaximum = currentYLim(2);
                        end
                    end
                else
                    disp('Warning: some variables were not present or not numeric');
                end
            end
        end
    case 'buttonplotgroupsession'
        figure;
        set(gcf,'color','white');
        for j=1:length(sess)
            curplot = curplot + 1;
            subplot(1,length(sess),curplot);
            lgnd = {};
            emptyplot = 1;
            for k=1:length(vars)
                var_j = vars{k};
                plotdat = double(plotData{k,j});
                if ( isscalar( plotdat) )
                    plotdat = plotdat * ones( maxLength,1);
                end
                if ~isempty(plotdat) && isnumeric(plotdat)
                    emptyplot = 0;
                    lgnd{length(lgnd)+1} = deunderscore(var_j);
                    if strcmp(plotType, 'histogram')
                        if size(plotdat,2) == 1
                            if handles.rawPlotOptions.Concatenate_Histogram_Data
                                if ( isempty(histoData) )
                                    histoData =  myhist(plotdat,handles);
                                else
                                    histoData = histoData +  myhist(plotdat,handles);
                                end
                                %histoData = [histoData plotdat'];
                            else
                                histoData = [histoData myhist(plotdat,handles)];
                            end
                        elseif size(plotdat,2) > 1
                            warndlg(['Histogram doesn''t support variables' ...
                                ' with multiple columns'],'Unsupported Plot');
                            continue;
                        end
                    else
                        plota(getsmooth(handles, plotdat));
                        if handles.rawPlotOptions.Common_X_Scale
                            plotHandles(j,k) = gca;
                            currentXLim = getxlim();
                            if currentXLim(1) < yMinimum
                                xMinimum = currentXLim(1);
                            end
                            if currentXLim(2) > xMaximum
                                xMaximum = currentXLim(2);
                            end
                        end
                        if handles.rawPlotOptions.Common_Y_Scale
                            plotHandles(j,k) = gca;
                            currentYLim = getylim();
                            if currentYLim(1) < yMinimum
                                yMinimum = currentYLim(1);
                            end
                            if currentYLim(2) > yMaximum
                                yMaximum = currentYLim(2);
                            end
                        end
                    end
                else
                    disp('Warning: some variables were not present or not numeric');
                end
            end
            if strcmp(plotType, 'histogram') && ~emptyplot && ~isempty(histoData)
                % 				if handles.rawPlotOptions.Concatenate_Histogram_Data
                % 					%                     bar(myhist(histoData,handles));
                % 					[n,xtickpositions,xticklabels] = myhist(plotdat,handles);
                % 					bar(n);
                % 					set(gca,'xticklabel',xticklabels);
                % 				else
                [n,xtickpositions,xticklabels] = myhist(plotdat,handles);
                bar('v6',histoData);
                xtck = get(gca,'xtick');
                %                         set(gca,'xtick',xtickpositions);
                if xtck(1) == 0
                    xtck(1) = 1;
                end
                xtck(xtck>length(xticklabels)) = [];
                set(gca,'xtick',xtck);
                set(gca,'xticklabel',xticklabels(xtck,:));
                % 				end
                histoData = [];
            end
            if ~emptyplot
                title(contentssess{sess(j)});
                legend(lgnd);
            end
        end
    case 'buttonplotgroupvariables'
        [xMinimum, xMaximum, yMinimum, yMaximum] = plot_group_vars(handles, vars, sess, contentssess, plotType, plotData);
    case 'buttonplotgroupall'
        lgnd = {};
        emptyplot = 1;
        figure;
        set(gcf,'color','white');
        for j=1:length(vars)
            var_j = vars{j};
            for k=1:length(sess)
                plotdat = double(plotData{j,k});
                if ( isscalar( plotdat) )
                    plotdat = plotdat * ones( maxLength,1);
                end
                if ~isempty(plotdat) && isnumeric(plotdat)
                    lgnd{length(lgnd)+1} = [deunderscore(var_j) ', ' contentssess{sess(k)}];
                    emptyplot = 0;
                    if strcmp(plotType, 'histogram')
                        if size(plotdat,2) == 1
                            histoData = [histoData myhist(plotdat,handles)];
                        elseif size(plotdat,2) > 1
                            warndlg(['Histogram doesn''t support variables' ...
                                ' with multiple columns'],'Unsupported Plot');
                            continue;
                        end
                    else
                        plota(getsmooth(handles, plotdat));
                    end
                else
                    disp('Warning: some variables were not present or not numeric');
                end
            end
        end
        if strcmp(plotType, 'histogram') && ~emptyplot && ~isempty(histoData)
            [n,xtickpositions,xticklabels] = myhist(plotdat,handles);
            bar(histoData,'grouped');
            if length(vars) == 1
                set(gca,'xticklabel',xticklabels);
            end
            histoData = [];
        end
        if ~emptyplot
            legend(lgnd);
        end
end

% set x scale
if handles.rawPlotOptions.Common_X_Scale
    plotHandles(plotHandles==0) = [];
    for hndle=plotHandles
        set(hndle,'xlim',[xMinimum xMaximum]);
    end
end
% set y scale
if handles.rawPlotOptions.Common_Y_Scale
    plotHandles(plotHandles==0) = [];
    for hndle=plotHandles
        set(hndle,'ylim',[yMinimum yMaximum]);
    end
end

% =========================================================================
% subroutines
% =========================================================================
function [xMinimum, xMaximum, yMinimum, yMaximum] = plot_group_vars(handles, vars, sess, contentssess, plotType, plotData)

% paras initialization
% --------------------
xMaximum = -Inf;
xMinimum = Inf;
yMaximum = -Inf;
yMinimum = Inf;

lgnd = {};
histoData = [];
curplot = 0;
plotHandles = zeros(length(vars), length(sess));

% plot
% ----
hf = figure;
set(hf, 'color', 'white');

for j=1:length(vars)
    curplot = curplot + 1;
    var_j = vars{j};
    subplot(length(vars),1,curplot);
    emptyplot = 1;
    for k=1:length(sess)
        plotdat = double(plotData{j,k});
        if ( isscalar( plotdat) )
            plotdat = plotdat * ones( maxLength,1);
        end
        if ~isempty(plotdat) && isnumeric(plotdat)
            lgnd = cat(1, lgnd, contentssess{sess(k)});
            emptyplot = 0;
            if strcmp(plotType, 'histogram')
                if size(plotdat,2) == 1
                    if handles.rawPlotOptions.Concatenate_Histogram_Data
                        % histoData = [histoData plotdat'];
                        histoData = cat(2, histoData, plotdat');
                    else
                        % histoData = [histoData myhist(plotdat,handles)];
                        histoData = cat(2, histoData, myhist(plotdat,handles));
                    end
                elseif size(plotdat,2) > 1
                    warndlg(['Histogram doesn''t support variables' ...
                        ' with multiple columns'],'Unsupported Plot');
                    continue;
                end
            else
                plota(getsmooth(handles, plotdat));
                if handles.rawPlotOptions.Common_X_Scale
                    plotHandles(j,k) = gca;
                    currentXLim = getxlim();
                    if currentXLim(1) < xMinimum
                        xMinimum = currentXLim(1);
                    end
                    if currentXLim(2) > xMaximum
                        xMaximum = currentXLim(2);
                    end
                end
                if handles.rawPlotOptions.Common_Y_Scale
                    plotHandles(j,k) = gca;
                    currentYLim = getylim();
                    if currentYLim(1) < yMinimum
                        yMinimum = currentYLim(1);
                    end
                    if currentYLim(2) > yMaximum
                        yMaximum = currentYLim(2);
                    end
                end
            end
        else
            disp('Warning: some variables were not present or not numeric');
        end
    end
    
    if strcmp(plotType, 'histogram') && ~emptyplot && ~isempty(histoData)
        %                 if ~handles.rawPlotOptions.Interleave_Histograms
        %                     histoData = histoData';
        %                 end
        if handles.rawPlotOptions.Concatenate_Histogram_Data
            % [n,xtickpositions,xticklabels] = myhist(histoData',handles);
            [n,~,xticklabels] = myhist(histoData',handles);
            bar(n);
            set(gca,'xticklabel',xticklabels);
        else
            % [n,xtickpositions,xticklabels] = myhist(plotdat,handles);
            [~, ~, xticklabels] = myhist(plotdat,handles);
            bar(histoData,'grouped');
            xtck = get(gca,'xtick');
            %                         set(gca,'xtick',xtickpositions);
            if xtck(1) == 0
                xtck(1) = 1;
            end
            xtck(xtck>length(xticklabels)) = [];
            set(gca,'xtick',xtck);
            set(gca,'xticklabel',xticklabels(xtck,:));
        end
        histoData = [];
    end
    if ~emptyplot
        legend(lgnd);
        title(deunderscore(var_j));
    end
end % function

function smooth = getsmooth(handles,data)
smooth = data;
if ~strcmp(handles.rawPlotOptions.Smoothing_Window_Width, 'None')
    if ischar(handles.rawPlotOptions.Smoothing_Window_Width)
        handles.rawPlotOptions.Smoothing_Window_Width = ...
            str2double(handles.rawPlotOptions.Smoothing_Window_Width);
    end
    smooth = sgolayfilt(data,1,handles.rawPlotOptions.Smoothing_Window_Width);
end

function [n,xLabelPositions,xLabels] = myhist(data, handles)
nBins = 10;
minBin = 0;
maxBin = 10;
if ~isempty(handles.rawPlotOptions)
    nBins = handles.rawPlotOptions.Number_Histogram_Bins;
    if ischar(nBins)
        nBins = squeeze(str2double(handles.rawPlotOptions.Number_Histogram_Bins));
    else
        nBins = squeeze(nBins);
    end
    if handles.rawPlotOptions.Manual_Bin_Range
        minBin = squeeze(handles.rawPlotOptions.Minimum_Bin);
        maxBin = squeeze(handles.rawPlotOptions.Maximum_Bin);
    else
        minBin = min(data);
        maxBin = max(data);
    end
end
if minBin == maxBin
    edges = minBin;
else
    edges = minBin:(maxBin-minBin)/nBins:maxBin;
end
n=histc(data,edges);
if length(n) >1
    n(end-1) = n(end-1) + n(end);
    n = n(1:end-1);
    xLabelPositions = edges(1:end-1) + ((maxBin-minBin)/nBins/2);
    xLabels = num2str(xLabelPositions','%.3f');
else
    xLabelPositions = minBin;
    xLabels = minBin;
end

% [EOF]