function square_wave_jerk_plot(sname,S, plotdat)
% trace
if ( 1)
	if( isfield( plotdat, 'left_eyedat') && ~isempty(plotdat.left_eyedat) )
		eyedat = plotdat.left_eyedat;
		square_wave_jerks = plotdat.left_square_wave_jerks;
		square_wave_jerks2 = plotdat.left_square_wave_jerks2;
		usacc_starts = plotdat.left_usacc_starts;
		usacc_ends = plotdat.left_usacc_ends;
	else
		eyedat = plotdat.right_eyedat;
		square_wave_jerks = plotdat.right_square_wave_jerks;
		square_wave_jerks2 = plotdat.right_square_wave_jerks2;
		usacc_starts = plotdat.right_usacc_starts;
		usacc_ends = plotdat.right_usacc_ends;
	end
	figure
    START = 625000;
    STOP = 750000;
    START = 1;
    STOP = length(eyedat);
    eyedat = eyedat(START:STOP,1:2);
    plotdat.blinkYesNo = plotdat.blinkYesNo(START:STOP,1);
    t = [1:length(eyedat(:,1))]/500;
    eyedat(:,1) = eyedat(:,1)-mean(eyedat(1:100,1));
	plot(t,eyedat(:,1),'k');
	hold on;
	x = nan(length(eyedat(:,1)),1);
	y = nan(length(eyedat(:,1)),1);
	for i=1:length(square_wave_jerks)
        if (  usacc_starts(square_wave_jerks2(i)) > STOP ||  usacc_starts(square_wave_jerks(i)) < START)
            continue
        end
		idx = (usacc_starts(square_wave_jerks(i)):usacc_ends(square_wave_jerks2(i)))-START;
		x( idx ) =  eyedat( idx, 1 );
		y( idx ) =  eyedat( idx, 2);
	end
	u = nan(length(eyedat(:,1)),1);
	b = nan(length(eyedat(:,1)),1);
    b(find(plotdat.blinkYesNo)) = eyedat(find(plotdat.blinkYesNo),1);
	for i=1:length(usacc_starts)
        if (  usacc_ends(i) > STOP ||  usacc_starts(i) < START)
            continue
        end
		idx = (usacc_starts(i):usacc_ends(i))-START;
		u( idx ) =  eyedat( idx,1 );
	end
	% 						xlong = nan(length(eyedat(:,1)),1);
	% 						for i=1:length(square_wave_jerks)
	% 							if (usacc_ends(square_wave_jerks2(i)) - usacc_starts(square_wave_jerks(i)) > 175)
	% 								idx = usacc_starts(square_wave_jerks(i)):usacc_ends(square_wave_jerks2(i));
	% 								xlong( idx ) =  eyedat( idx,1 );
	% 							end
	% 						end
	% 						xlong = nan(length(eyedat(:,1)),1);
	% 						for i=1:length(square_wave_jerks)
	% 							if (cos( plotdat.left_usacc_directions(square_wave_jerks2(i)) - plotdat.left_usacc_directions(square_wave_jerks(i))) <0 )
	% 								idx = usacc_starts(square_wave_jerks(i)):usacc_ends(square_wave_jerks2(i));
	% 								xlong( idx ) =  eyedat( idx,1 );
	% 							end
	% 						end
	xlong = nan(length(eyedat(:,1)),1);
	ylong = nan(length(eyedat(:,1)),1);
% 	for i=1:length(square_wave_jerks)
% 		if (usacc_ends(square_wave_jerks(i)) - usacc_starts(square_wave_jerks2(i)) > -20 )
% 			idx = usacc_starts(square_wave_jerks(i)):usacc_ends(square_wave_jerks2(i));
% 			xlong( idx ) =  eyedat( idx,1 );
% 		end
% 	end	

% 	for i=1:length(usacc_starts)
% 		if ( plotdat.left_usacc_pkvelocities(i) < 10 )
% 		%if ( plotdat.left_usacc_magnitudes(i) < 0.2 )
% 			idx = usacc_starts(i):usacc_ends(i);
% 			xlong( idx ) =  eyedat( idx,1 );
% 			ylong( idx ) =  eyedat( idx,2 );
% 		end
% 	end
% 	plot(t,u,'c','LineWidth',4);
% 	plot(t,b,'g','LineWidth',4);
% 	plot(t,x,'r','LineWidth',2);
%  	plot(t,eyedat(:,2)-median(eyedat(:,2))-2, 'color', [0 0.5 0]);
% 	plot(y,'r','LineWidth',2);
% 	plot(ylong,'g','LineWidth',2);
	title(sname)
end

set(gca,'xlim', [1 30],'ylim',[-4 4]);
set(gcf,'position', [100 100 1500 300]);
set(gca,'position',[.02 .1 .96 .8])
xlabel('Time(s)'), ylabel('DVA')
return
% differences in intern position histogram

usacc_starts		= [plotdat.left_usacc_starts; plotdat.right_usacc_starts + length(plotdat.left_eyedat)];
usacc_ends			= [plotdat.left_usacc_ends;plotdat.right_usacc_ends + length(plotdat.left_eyedat)];
usacc_directions	= [plotdat.left_usacc_directions;plotdat.right_usacc_directions ];
usacc_durations		= [plotdat.left_usacc_durations;plotdat.right_usacc_durations];
usacc_magnitudes	= [plotdat.left_usacc_magnitudes;plotdat.right_usacc_magnitudes];
usacc_pkvelocities	= [plotdat.left_usacc_pkvelocities;plotdat.right_usacc_pkvelocities];
square_wave_jerks	= [plotdat.left_square_wave_jerks plotdat.right_square_wave_jerks + length(plotdat.left_usacc_starts)];
square_wave_jerks2	= [plotdat.left_square_wave_jerks2 plotdat.right_square_wave_jerks2 + length(plotdat.left_usacc_starts)];
eyedat				= [plotdat.left_eyedat;plotdat.right_eyedat];

s1 = usacc_starts(square_wave_jerks);
e1 = usacc_ends(square_wave_jerks);
s2 = usacc_starts(square_wave_jerks2);
e2 = usacc_ends(square_wave_jerks2);
if ( square_wave_jerks2 < length(usacc_starts))
    s3 = usacc_starts(square_wave_jerks2+1);
    e3 = usacc_ends(square_wave_jerks2+1);
else
    s3 = NaN;
    e3 = NaN;
end

x1 = eyedat(s1,1);
x2 = eyedat(e1,1);
x3 = eyedat(s2,1);
x4 = eyedat(e2,1);

y1 = eyedat(s1,2);
y2 = eyedat(e1,2);
y3 = eyedat(s2,2);
y4 = eyedat(e2,2);

d1 = usacc_directions(square_wave_jerks);
d2 = usacc_directions(square_wave_jerks2);

m1 = usacc_magnitudes(square_wave_jerks);
m2 = usacc_magnitudes(square_wave_jerks2);

v1 = usacc_pkvelocities(square_wave_jerks);
v2 = usacc_pkvelocities(square_wave_jerks2);


%% -- X component -----------------------------------------------
if ( S.Square_Wave_Jerk_Options.Square_Wave_Jerk_X_Component == 1 )

	figure
	% X component
	degbins = 0:0.1:2;
	subplot(2,3,1);
	hist_X = histc([abs(x1-x2);abs(x3-x4)], degbins);
	bar(degbins, hist_X, 'histc');
	title( 'X component' );
	xlabel( 'X component(deg)' );
	ylabel( '# of swjs' );

	% y component hist
	degbins = 0:0.1:2;
	subplot(2,3,4);
	hist_Y = histc([abs(y1-y2);abs(y3-y4)], degbins);
	bar(degbins, hist_Y, 'histc');
	title( 'Y component' );
	xlabel( 'Y component(deg)' );
	ylabel( '# of swjs' );

	degbins = 0:0.02:1;
	% diferences in extern X position histogram
	subplot(2,3,2);
	hist_extern_diff = histc(abs(x2-x3),degbins);
	bar(degbins,hist_extern_diff, 'histc');
	title( 'extern X diff' );
	xlabel( 'Extern X diff(deg)' );
	ylabel( '# of swjs' );

	% diferences in intern X position histogram
	subplot(2,3,3);
	hist_intern_diff = histc(abs(x1-x4), degbins);
	bar(degbins, hist_intern_diff, 'histc');
	title( 'intern X diff' );
	xlabel( 'Intern X diff(deg)' );
	ylabel( '# of swjs' );

	% diferences in x histogram
	subplot(2,3,5);
	hist_x_diff = histc(abs(abs(x1-x2)-abs(x3-x4)), degbins);
	bar(degbins, hist_x_diff, 'histc');
	title( 'X component diff' );
	xlabel( 'X component diff(deg)' );
	ylabel( '# of swjs' );

	% diferences in x histogram
	subplot(2,3,6);
	hist_diff_diff = histc(abs(abs(x2-x3) -abs(x1-x4)),degbins);
	bar(degbins, hist_diff_diff , 'histc');
	title( 'diff of diffs' );
	xlabel( 'Diff between intern and extern diffs(deg)' );
	ylabel( '# of swjs' );
end

%% -- Magnitude -----------------------------------------------
if ( S.Square_Wave_Jerk_Options.Square_Wave_Jerk_Magnitude == 1 )
	figure
	% Magnitude
	degbins = 0:0.1:2;
	subplot(2,2,1);
	hist_mag = histc([m1;m2], degbins);
	bar(degbins, hist_mag, 'histc');
	title( 'usacc magnitude' );
	xlabel( 'usacc magnitude(deg)' );
	ylabel( '# of microsaccades' );


	% magnitude diff
	degbins = 0:0.02:1;
	subplot(2,2,2);
	hist_mag_diff = histc(abs(m1-m2), degbins);
	bar(degbins, hist_mag_diff, 'histc');
	title( 'magnitude diff' );
	xlabel( 'Magnitude diff(deg)' );
	ylabel( '# of microsaccades' );


	% main sequence
	subplot(2,2,3);
	h = plotmain( ...
		[m1;m2],...
		[usacc_pkvelocities(square_wave_jerks);usacc_pkvelocities(square_wave_jerks2)],...
		[d1;d2],...
		sum(plotdat.isInTrial)*2, 'Peak velocity main sequence', 'o', [0 0 1], 0, 1);
	xlabel( 'Magnitude (deg)' );
	ylabel( 'Peak velocity (deg/s)' );
end

%% -- direction -----------------------------------------------
if ( S.Square_Wave_Jerk_Options.Square_Wave_Jerk_Direction == 1 )
	figure
	% relative direction histogram
	subplot(2,2,1);
	a=polarplot(abs(d1-d2));

	% absolute direction of first usac histogram
	subplot(2,2,2);
	a=polarplot(d1);
	% absolute direction of second usac histogram
	subplot(2,2,3);
	a=polarplot(d2);
end

%% -- timing -----------------------------------------------
if ( S.Square_Wave_Jerk_Options.Square_Wave_Jerk_Timing == 1 )
	figure

	degbins = 0:10:400;
	subplot(2,2,1);
	hist_x = histc(e2-s1, degbins);
	bar(degbins*1000/plotdat.samplerate, hist_x, 'histc');
	title( 'swj duration' );

	subplot(2,2,2);
	hist_x = histc(s2-e1, degbins);
	bar(degbins*1000/plotdat.samplerate, hist_x, 'histc');
	title( 'swj intern interval' );

	subplot(2,2,3);
	hist_x = histc(s3-e2, degbins);
	bar(degbins*1000/plotdat.samplerate, hist_x, 'histc');
	title( 'inter swj  interval' );
end

%% -- velocity -----------------------------------------------
if ( S.Square_Wave_Jerk_Options.Square_Wave_Jerk_Timing == 1 )
	figure

	degbins = 0:1:40;
	subplot(2,2,1);
	hist_x = histc(v2-v1, degbins);
	bar(degbins*1000/plotdat.samplerate, hist_x, 'histc');
	title( 'swj velocity diff' );

	degbins = 0:1:40;
	subplot(2,2,2);
	hist_x = histc([v2;v1], degbins);
	bar(degbins*1000/plotdat.samplerate, hist_x, 'histc');
	title( 'swj velocity' );
end


sname
total_ms = sum(plotdat.isInTrial) / plotdat.samplerate;
% swj number
swj_stats.number = length(square_wave_jerks);
	% swj rate
	swj_stats.rate = length(square_wave_jerks) / total_ms;
	% percentage of usacc that are part of swjs
	swj_stats.percent = length(square_wave_jerks)*2 / length(usacc_starts) *100;
	% mean duration
	swj_stats.duration		= mean(e2-s1);
	swj_stats.duration_std	= std(e2-s1);
	% mean magnitude
	swj_stats.magnitude		= mean([m1;m2]);
	swj_stats.magnitude_std = std([m1;m2]);
	swj_stats;




