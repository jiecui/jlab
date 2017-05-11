function ax = fading_plotdat(  dat1, dat1_LineSpec, dat1_LineWidth,  dat2, dat2_LineSpec, dat2_LineWidth, ...
	dat3, xind, dmin, dmax,  titl, xlab, ylab, leg1, leg2, window_backward, window_forward, samplerate, sg, dm )


global COLORS;

% dm
%	0 = raw data
%	1 = % increase
%	2 = plotYY with raw data and % increase
%	3 = Z-scores

%dm = 2; % xoana to force double axes plots

%% -- Smoothing the data
if exist('sg')
    if sg > 1
        if ~mod(sg,2),sg = sg+1;end
        % 		disp(sprintf('Infs d1 :%d\n', length(find(isinf(dat1)))));
        % 		disp(sprintf('Infs d2 :%d\n', length(find(isinf(dat1)))));
        % 		disp(sprintf('NaNs d1 :%d\n', length(find(isnan(dat1)))));
        %         disp(sprintf('NaNs d2 :%d\n', length(find(isnan(dat1)))));

        if ( ~isempty( dat1 ))
            % interpolate Infs
            dat1(find(isinf(dat1))) = interp1(find(~isinf(dat1)), dat1(~isinf(dat1)), find(isinf(dat1)));
            % interpolate NaNs
            dat1(find(isnan(dat1))) = interp1(find(~isnan(dat1)), dat1(~isnan(dat1)), find(isnan(dat1)));
            % filter data
            dat1 = sgolayfilt(dat1,1,sg);
%             [a,dat1] = spaps(1:length(dat1),dat1, length(dat1)*mean((dat1-sgolayfilt(dat1,1,51)).^2));
        end
        if ( ~isempty( dat2 ))
            dat2(find(isinf(dat2))) = interp1(find(~isinf(dat2)), dat2(~isinf(dat2)), find(isinf(dat2)));
            dat2(find(isnan(dat2))) = interp1(find(~isnan(dat2)), dat2(~isnan(dat2)), find(isnan(dat2)));
            dat2 = sgolayfilt(dat2,1,sg);
%             [a,dat2] = spaps(1:length(dat2),dat2, length(dat2)*mean((dat2-sgolayfilt(dat2,1,51)).^2));
        end


		
	end
end


%% -- Calculating different options
if exist('dm') && dm == 1
    dat1 = devmn( dat1, dat3 );
    if ( ~isempty( dat2 ))
        dat2 = devmn( dat2, dat3 );
    end

    dat3 = zeros( size(dat1) );
elseif exist('dm') && dm == 3
    dat1 = zscore(dat1);
    if ( ~isempty( dat2 ))
        dat2 = zscore(dat2);
    end

    dat3 = zeros(size(dat1));
end


if exist('dm') && dm==2
    xind = repmat(xind,2,1)';
    dat = [dat1 dat2];
    [ax,h1,h2] = plotyy(xind,dat,xind(:,1),zeros(size(dat,1),1));
    set(h1(1),'color',dat1_LineSpec(1),...
        'LineWidth',dat1_LineWidth,...
        'LineStyle',dat1_LineSpec(2:end));
    set(h1(2),'color',dat2_LineSpec(1),...
        'LineWidth',dat2_LineWidth,...
        'LineStyle',dat2_LineSpec(2:end));
    set(h2(1),'color','k','LineStyle',':','LineWidth',1.1);
   	
	title(titl);
	xlabel(xlab);
	ylabel(ylab);
	
    buff=0.15*(dmax-dmin);
    mytight(ax(1),15);
    setylimpercent( ax(1), ax(2), dat3(1) );
    set(ax(2),'ytickmode', 'auto','xticklabel',{}, 'XTick',[],'ycolor','k');
    set(ax(1),'ytickmode', 'auto');
	set(get(ax(2),'Ylabel'),'String', '% increase from chance' );
%     fading_format_plot( leg1,leg2,length(xind),ax );

	box off;
else
 	ax(1) = plot(xind,dat1,dat1_LineSpec,'LineWidth',dat1_LineWidth,'Color', [1 0 0]);
	hold on;
    if ( ~isempty( dat2) )
        ax(2) = plot(xind,dat2,dat2_LineSpec,'LineWidth',dat2_LineWidth,'Color', [0 0 1]);
    end
	plot( xind, dat3, 'k-.' );
% 	fading_format_plot( leg1, leg2, length(xind) );
	mytight(gca,15);
	title(titl);
	xlabel(xlab);
	ylabel(ylab);
	box off;
end


% xTicks_ms =  mod(window_backward,2000):2000:(window_backward + window_forward);
% xTicks = xTicks_ms / 1000 * samplerate;

% set( gca, 'XTick', xTicks, 'XTickLabel', xTicks_ms-window_backward)
set( gcf, 'position', [20   180 515   356])
line( [0 0], get(gca,'YLim'), 'Color', 'k' )

