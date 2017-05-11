function out = incrthres_plots( handles, sname, plotdat,S, ptype,  type_of_experiment, type_of_data, samplerate, which_eye)


if ( nargin == 1 )
	command = handles;
	switch (command)
		case 'get_plotlist'
			out = get_plotlist();
	end
	return
end


ylab = '';
switch char(ptype)

	%--------------------------------------------------
	case 'Percentage_correct_per_bin'
		%-------------------------------------------------
		titl	= [sname ' -- percent correct for each bin and contrast increment'];

		% Get and check the data
		plotdat = get_plotdat( plotdat, sname, { 'percentcorr', 'corrincorr', 'asynchrony_edges' }  );
		check_plotdat( plotdat, { 'percentcorr', 'corrincorr', 'asynchrony_edges' } );

		figure;
		set(gcf,'name',[sname ' -- percent correct']);
		bar3(plotdat.percentcorr);
		xlabel 'Time bins'
		ylabel 'Contrast increments'
		zlabel '% Correct'

		%--------------------------------------------------
	case 'Microsaccades_per_bin'
		%--------------------------------------------------
		% Get and check the data
		plotdat = get_plotdat( plotdat, sname, { 'percentcorr', 'corrincorr', 'asynchrony_edges','asynchrony_edges', 'contrast_increments' }  );
		check_plotdat( plotdat, { 'percentcorr', 'corrincorr', 'asynchrony_edges' } );
		for i=1:size(plotdat.percentcorr,1),
			for j=1:size(plotdat.percentcorr,2),
				numusaccs(i,j)=length(plotdat.corrincorr{i,j});
			end
		end
		figure;
		set(gcf,'name',[sname ' -- number usaccs']);
		bar3(numusaccs);
        xticks = get(gca,'XTick');
        yticks = get(gca,'YTick');
        set(gca,'XTickLabel',plotdat.asynchrony_edges(xticks))
        set(gca,'YTickLabel',plotdat.contrast_increments(yticks))
		xlabel 'Time bins'
		ylabel 'Contrast increments'
		zlabel 'Number microsaccades'
		titl	= [sname ' -- Number microsaccades for each bin and contrast increment'];

		%--------------------------------------------------
	case 'Sigmoids'
		%--------------------------------------------------
		% Get and check the data
		plotdat = get_plotdat( plotdat, sname, { 'asynchrony_edges', 'contrast_increments', 'percentcorr', 'fitted_sigmo', 'contrast_threshold' }  );
		check_plotdat( plotdat, { 'asynchrony_edges', 'contrast_increments', 'percentcorr', 'fitted_sigmo', 'contrast_threshold' }  );

		edg = plotdat.asynchrony_edges;
		ctr = diff(edg)/2 + edg(1:end-1);
		
		a0 = [100,1];
		x = [0:0.1:66];
		c0 = [1,100];

		% with dots
		figure;
		titl	= [sname ];
		set(gcf,'name',sname);
		colrs = autocolor(length( plotdat.asynchrony_edges)-1 );
		for i = 1:length(plotdat.asynchrony_edges)-1
			h = plot(plotdat.contrast_increments,plotdat.percentcorr(:,i)', 'Color', colrs(i,:) );
			set(h,'Marker', '.', 'MarkerSize', 24, 'LineStyle', 'none')
			hold on
		end

		for i = 1:length(plotdat.asynchrony_edges)-1
			g = plot(x,plotdat.fitted_sigmo{i},'Color',colrs(i,:));
			set(g,'LineWidth',2);
		end
		l = line([0.1 24],[plotdat.contrast_threshold plotdat.contrast_threshold]);
		% set(gca,'YLim',[0.35 1.05],'XScale','log','XLim',[1.9 10.1]);
        set(gca,'YLim',[0.35 1.05],'XScale','log','XLim',[2 24]);
		set(l,'Color','k','LineStyle',':');
        legend(cellstr(num2str(ctr')));
        set(gca,'FontSize',14)
		xlabel('Contrast increase (%)')
		ylabel('% Correct');
		


		% without dots
		figure;
		titl	= [sname ];
		set(gcf,'name',sname);
		colrs = autocolor(length(plotdat.asynchrony_edges)-1);
		for i = 1:length(plotdat.asynchrony_edges)-1
			g = plot(x,plotdat.fitted_sigmo{i},'Color',colrs(i,:));
			hold on
			set(g,'LineWidth',2);
		end
		l = line([0.1 24],[plotdat.contrast_threshold plotdat.contrast_threshold]);
% 		set(gca,'YLim',[0.35 1.05],'XScale','log','XLim',[1.9 10.1]);
        set(gca,'YLim',[0.35 1.05],'XScale','log','XLim',[2 24]);
		set(l,'Color','k','LineStyle',':');
		xlabel('Contrast increase (%)')
		ylabel('% Correct');
		legend(cellstr(num2str(ctr')));
        
        % individual subplots
        figure;
        titl	= [sname ];
		set(gcf,'name',sname);
        subplot_col = floor(sqrt(length(plotdat.asynchrony_edges)-1));
        subplot_row = subplot_col + 1;
		colrs = autocolor(length(plotdat.asynchrony_edges)-1);
        for i = 1:length(plotdat.asynchrony_edges)-1
            subplot(subplot_row,subplot_col,i)
            h = plot(plotdat.contrast_increments,plotdat.percentcorr(:,i)', 'Color', colrs(i,:) );
            set(h,'Marker', '.', 'MarkerSize', 15, 'LineStyle', 'none')
            hold on
            g = plot(x,plotdat.fitted_sigmo{i},'Color',colrs(i,:));
            set(g,'LineWidth',2);
            set(gca,'YLim',[0.35 1.05],'XScale','log','XLim',[2 24]);
            l = line([0.1 24],[plotdat.contrast_threshold plotdat.contrast_threshold]);
            set(l,'Color','k','LineStyle',':');
            title(round(ctr(i)));
        end

		
		%--------------------------------------------------
	case 'Contrast_Increment_Threshold'
		%--------------------------------------------------
		% Get and check the data
		plotdat = get_plotdat( plotdat, sname, { 'asynchrony_edges', 'percent_contrast_increment_threshold', 'percent_contrast_increment_threshold_behav' }  );
		check_plotdat( plotdat, { 'asynchrony_edges', 'percent_contrast_increment_threshold', 'percent_contrast_increment_threshold_behav' }  );
		
		edg = plotdat.asynchrony_edges;
		ctr = diff(edg)/2 + edg(1:end-1);

		figure;
		set(gcf,'name',sname);
		plot(ctr, plotdat.percent_contrast_increment_threshold', 'k.-','linewidth',2,'markersize',30);
		hold on
		if length(plotdat.asynchrony_edges)-1 < 20
			wdw = 3;
		else
			wdw = 5;
		end

		colrs = autocolor(length(plotdat.asynchrony_edges)-1);
		for i = 1:length(plotdat.asynchrony_edges)-1
			g = plot(ctr(i),plotdat.percent_contrast_increment_threshold(i),'Color',colrs(i,:),'Marker','.','MarkerSize',24,'LineStyle','none');
			hold on
			set(g,'LineWidth',2);
		end

		plot(ctr,sgolayfilt(plotdat.percent_contrast_increment_threshold',1,wdw),'k-','linewidth',5,'markersize',30);

		if length(plotdat.asynchrony_edges)-1 == 6
			set(gca,'xtick',[1 2 3 4 5 6])
			set(gca,'xticklabel',{'way before' 'before' 'just before' 'just after' 'after' 'way after' })
		else
			step = 1;
			if length(edg)-1 > 20
				step = 2;
			elseif length(edg)-1 > 30
				step = 3;
			end
			set(gca,'xlim',ctr([1 length(edg)-1]));
			%         set(gca,'xtick',[1:step:length(edg)-1]);
			%         set(gca,'xticklabel',cellstr(num2str(ctr(1:step:end)')));
        end
        set(gca,'FontSize',14)
		xlabel 'usacc-flash onset asynchrony'
		ylabel '% contrast increment threshold'
		ylim = get(gca,'ylim');
		xlim = get(gca,'xlim');
		line([0,0],ylim, 'color', [0 0 0])
		line(xlim, [plotdat.percent_contrast_increment_threshold_behav plotdat.percent_contrast_increment_threshold_behav], 'color', [0 0 0])
		if( xlim(1) < -250 )
			line([-250,-250],ylim, 'color', [1 0 0])
		end
		if ( xlim(2) > 500 )
			line([500,500],ylim, 'color', [1 0 0])
		end
end


function plotlist = get_plotlist()
plotlist.Microsaccades_per_bin =  { {'{0}','1'} };
plotlist.Percentage_correct_per_bin =  { {'{0}','1'} };
plotlist.Sigmoids=  { {'{0}','1'} };
plotlist.Contrast_Increment_Threshold =  { {'{0}','1'} };