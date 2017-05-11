function bigbar(results,crunch,subject,measure)
% given a cached_results cell array and a subject number, plot bar plots of all the data

% matrix to tell which measures make sense for which movement conditions
condmeas = ones(23,5);
condmeas([1:6 8:9 14:15 17:23],[3 5]) = 0;
condmeas([10:23],4) = 0;
condmeas([10:15],1:2) = 0;
    

r=results;
%slicelabels = results{subject}{3};
%get dims
numslices = max(r.slicei);
numcond = max(r.condi);
ymin = 1000;
ymax = -1000;
plotnum=0;
for i=1:numcond,
    for j=1:numslices,
        plotnum = plotnum+1;
        subplot(numcond, numslices, plotnum);
        dat = r.data(find(r.subji==subject&r.slicei==j&r.condi==i),measure);
        if ~isempty(dat),
            % combo measure and condition
            if condmeas(measure,i),
                bar(dat);
                ylim = get(gca,'YLim');
                if ylim(1) < ymin,
                    ymin = ylim(1);
                end
                if ylim(2) > ymax,
                    ymax = ylim(2);
                end
            end
        end
        if j == 1,
            ylabel(crunch.conditions{i});
        end
        if i == 1,
            title(crunch.subjects(subject).slice_labels{j});
        end
    end
end

% fix axes limits
plotnum=0;
for i=1:numcond,
    for j=1:numslices,
        plotnum = plotnum+1;
        subplot(numcond, numslices, plotnum);
        if ymin < ymax,
            set(gca,'YLim',[ymin ymax]);
        end
    end
end

orient tall
set(gcf,'Name',char(strcat(crunch.measures(measure),', ', crunch.subjects(subject).id)));
