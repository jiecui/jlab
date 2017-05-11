function out = swj_plots( handles, sname, plotdat,S, ptype,  type_of_experiment, type_of_data, samplerate, which_eye)

global COLORS;
global colors_array;

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
    case 'Square_Wave_Jerk'
        plotdat = get_plotdat( plotdat, sname, { 'samplerate', 'left_eyedat','left_usacc_starts','left_usacc_ends', 'left_usacc_directions', 'left_usacc_durations', 'left_usacc_pkvelocities', 'left_usacc_magnitudes', 'left_square_wave_jerks','left_square_wave_jerks2', 'left_usacc_peakvelocities', ...
            'right_eyedat', 'right_usacc_starts', 'right_usacc_ends', 'right_usacc_directions' , 'right_usacc_durations', 'right_usacc_pkvelocities', 'right_usacc_magnitudes', 'right_square_wave_jerks','right_square_wave_jerks2', 'right_usacc_peakvelocities', 'isInTrial','blinkYesNo' } );
        % 						check_plotdat(plotdat,  { 'left_usacc_starts','left_usacc_ends',  'left_usacc_directions', 'left_usacc_durations', 'left_usacc_pkvelocities', 'left_usacc_magnitudes', 'left_square_wave_jerks', ...
        % 							'right_eyedat', 'right_usacc_starts', 'right_usacc_ends','right_usacc_directions', 'right_usacc_durations', 'right_usacc_pkvelocities', 'right_usacc_magnitudes', 'right_square_wave_jerks'} );


        square_wave_jerk_plot(sname, S, plotdat );
    case 'Square_Wave_Jerk_viewer'
        plotdat = get_plotdat( plotdat, sname, { 'samplerate' } );
        if ( strcmp( which_eye, 'Both' ) )
            which_eye = 'Left';
        end
        plotdat = get_plotdat( plotdat, sname, { 'eyedat', 'usacc_starts','usacc_ends', 'usacc_directions','usacc_magnitudes', 'square_wave_jerks' , 'square_wave_jerks2' },which_eye );

        swj_viewer( plotdat );

        %% SWJ ------------------------------------------------------
    case 'SWJ_Main_Sequence'
        %--------------------------------------------------
        plotdat = get_plotdat( plotdat, sname, { 'samplerate', 'left_eyedat','left_usacc_starts','left_usacc_ends', 'left_usacc_directions', 'left_usacc_durations', 'left_usacc_pkvelocities', 'left_usacc_magnitudes', 'left_square_wave_jerks', 'left_square_wave_jerks2', ...
            'right_eyedat', 'right_usacc_starts', 'right_usacc_ends', 'right_usacc_directions' , 'right_usacc_durations', 'right_usacc_pkvelocities', 'right_usacc_magnitudes', 'right_square_wave_jerks', 'right_square_wave_jerks2', 'isInTrial' } );
        %
        left_index_all = 1:length(plotdat.left_usacc_starts);
        left_index_swj = [plotdat.left_square_wave_jerks';plotdat.left_square_wave_jerks2'];
        left_index_noswj = setdiff(left_index_all, left_index_swj);

        right_index_all = 1:length(plotdat.right_usacc_starts);
        right_index_swj = [plotdat.right_square_wave_jerks';plotdat.right_square_wave_jerks2'];
        right_index_noswj = setdiff(right_index_all, right_index_swj);
        switch ( which_eye )
            case 'Left'
                swj_usacc_magnitudes = plotdat.left_usacc_magnitudes(left_index_swj);
                swj_usacc_pkvelocities = plotdat.left_usacc_pkvelocities(left_index_swj);
                swj_usacc_durations = plotdat.left_usacc_durations(left_index_swj);
                noswj_usacc_magnitudes = plotdat.left_usacc_magnitudes(left_index_noswj);
                noswj_usacc_pkvelocities = plotdat.left_usacc_pkvelocities(left_index_noswj);
                noswj_usacc_durations = plotdat.left_usacc_durations(left_index_noswj);
                totaltime = sum(plotdat.isInTrial)/samplerate*1000;
            case 'Right'
                swj_usacc_magnitudes = plotdat.right_usacc_magnitudes(right_index_swj);
                swj_usacc_pkvelocities = plotdat.left_usacc_pkvelocities(right_index_swj);
                swj_usacc_durations = plotdat.left_usacc_durations(right_index_swj);
                noswj_usacc_magnitudes = plotdat.right_usacc_magnitudes(right_index_noswj);
                noswj_usacc_pkvelocities = plotdat.left_usacc_pkvelocities(right_index_noswj);
                noswj_usacc_durations = plotdat.left_usacc_durations(right_index_noswj);
                totaltime = sum(plotdat.isInTrial)/samplerate*1000;
            case 'Both'
                swj_usacc_magnitudes = [plotdat.left_usacc_magnitudes(left_index_swj); plotdat.right_usacc_magnitudes(right_index_swj)];
                swj_usacc_pkvelocities = [plotdat.left_usacc_pkvelocities(left_index_swj); plotdat.right_usacc_pkvelocities(right_index_swj)];
                swj_usacc_durations = [plotdat.left_usacc_durations(left_index_swj); plotdat.right_usacc_durations(right_index_swj)];
                noswj_usacc_magnitudes = [plotdat.left_usacc_magnitudes(left_index_noswj); plotdat.right_usacc_magnitudes(right_index_noswj)];
                noswj_usacc_pkvelocities = [plotdat.left_usacc_pkvelocities(left_index_noswj); plotdat.right_usacc_pkvelocities(right_index_noswj)];
                noswj_usacc_durations = [plotdat.left_usacc_durations(left_index_noswj); plotdat.right_usacc_durations(right_index_noswj)];
                totaltime = 2*sum(plotdat.isInTrial)/samplerate*1000;
        end
        figure


        plot_mainsequence( sname, S,...
            {noswj_usacc_magnitudes swj_usacc_magnitudes},...
            {noswj_usacc_pkvelocities swj_usacc_pkvelocities},...
            {noswj_usacc_durations swj_usacc_durations},...
            [totaltime totaltime], 'Peak velocity main sequence',  [COLORS.MEDIUM_BLUE;COLORS.MEDIUM_RED], which_eye )


        %--------------------------------------------------
    case 'SWJ_Magnitude'
        %--------------------------------------------------
        if ( strcmp( which_eye, 'Both' ) )
            which_eye = 'Concat';
        end
        plotdat = get_plotdat( plotdat, sname, {'swj_mag1' 'swj_mag2' 'totaltime' } ,which_eye);
        check_plotdat(plotdat,  { 'swj_mag1' 'swj_mag2' } );
        bins = 0:.04:5;
        hist_magnitude(S, [plotdat.swj_mag1;plotdat.swj_mag2],get_plot_title(sname,'SWJ Microsaccade Magnitude Distribution'),bins  , plotdat.totaltime, '');
        %--------------------------------------------------
    case 'SWJ_Relative_Magnitude'
        %--------------------------------------------------
        if ( strcmp( which_eye, 'Both' ) )
            which_eye = 'Concat';
        end
        plotdat = get_plotdat( plotdat, sname, {'swj_mag1' 'swj_mag2' },which_eye );
        check_plotdat(plotdat,  {'swj_mag1' 'swj_mag2' } );

        degbins = -200:10:200;
        relmag = (plotdat.swj_mag2 - plotdat.swj_mag1) ./ (plotdat.swj_mag2 + plotdat.swj_mag1)*2*100;
        [mu, sigma] = normfit(relmag)
        plot_histogram(S, relmag, degbins, 'SWJ Microsaccade Relative Magnitude Distribution', 'Microsaccade Magnitude (deg)', 'Microsaccades', 0 )


        % 						hist_x = histc( relmag, degbins);
        % 						h=bar(degbins, hist_x, 'histc');
        % 						set(h, 'facecolor', COLORS.MEDIUM_BLUE);
        % 						title( 'swj magnitude' );
        % 						title( get_plot_title(sname,'SWJ Microsaccade Relative Magnitude Distribution',which_eye),'fontsize', 14);
        % 						set(gca, 'FontSize', 14);
        % 						xlabel('SWJ Microsaccade Relative Magnitude (%)','fontsize', 14);
        % 						ylabel('Number of Microsaccades','fontsize', 14);
        %--------------------------------------------------
    case 'SWJ_Duration'
        %--------------------------------------------------
        if ( strcmp( which_eye, 'Both' ) )
            which_eye = 'Concat';
        end
        plotdat = get_plotdat( plotdat, sname, { 'swj_dur' } ,which_eye);
        check_plotdat(plotdat,  { 'swj_dur' } );

        hist_duration(S, [plotdat.swj_dur],get_plot_title(sname,'SWJ Microsaccade Magnitude Distribution',which_eye),'Number of SWJs', 0:20:800);
        %--------------------------------------------------
    case 'SWJ_InterSaccadic_Interval'
        %--------------------------------------------------
        if ( strcmp( which_eye, 'Both' ) )
            which_eye = 'Concat';
        end
        plotdat = get_plotdat( plotdat, sname, { 'swj_isi' },which_eye);
        check_plotdat(plotdat,  {'swj_isi' } );
        hist_interval(S, [plotdat.swj_isi],get_plot_title(sname,'SWJ Internal Interval Distribution', which_eye), 'SWJs', 0:25:1000);
        %--------------------------------------------------
    case 'SWJ_Direction'
        %--------------------------------------------------
        if ( strcmp( which_eye, 'Both' ) )
            which_eye = 'Concat';
        end
        plotdat = get_plotdat( plotdat, sname, { 'samplerate' 'swj_dir1' 'swj_dir2' },which_eye );
        check_plotdat(plotdat,  { 'swj_dir1' 'swj_dir2' } );

%         						dirs = { abs(plotdat.swj_dir1 - plotdat.swj_dir2), [plotdat.swj_dir1;plotdat.swj_dir2] };
        						dirs = { abs(plotdat.swj_dir1 - plotdat.swj_dir2)};
%         dirs = { [plotdat.swj_dir1;plotdat.swj_dir2] };
% 
%         figure
%         a=polarplot(dirs);
% %         legend( { 'SWJ Direction difference', 'SWJ direction'} ,'fontsize', 14);
%         title(get_plot_title(sname,'SWJ Microsaccade Magnitude Distribution'))  
%         
        
        
        dirdif = mod(acos(cos((plotdat.swj_dir1 - plotdat.swj_dir2)*pi/180))*180/pi .* sign((plotdat.swj_dir1 - plotdat.swj_dir2))+90,360);
%         dirdif(dirdif<190 |dirdif>350) = [];
        plot_histogram(S, dirdif,0:5:360, 'SWJ Direction difference', 'Direction difference (deg)', 'SWJs', 0 )
        %--------------------------------------------------
    case 'SWJ_Score'
        %--------------------------------------------------
        if ( strcmp( which_eye, 'Both' ) )
            which_eye = 'Concat';
        end
        plotdat = get_plotdat( plotdat, sname, { 'samplerate'} );
        plotdat = get_plotdat( plotdat, sname, { 'swj_qx' 'swj_qy' },which_eye  );
        check_plotdat(plotdat,  { 'samplerate'  'swj_qx' 'swj_qy' } );

        bins = 0:0.2:6;
        mean_qx = mean(plotdat.swj_qx);
        mean_qy = mean(plotdat.swj_qy);
        mean_q = mean( max(plotdat.swj_qx, plotdat.swj_qy));
%         hist_qx = hist(plotdat.swj_qx,bins)/length(plotdat.swj_qx);
%         hist_qy = hist(plotdat.swj_qy,bins)/length(plotdat.swj_qy);
%         hist_q = hist( max(plotdat.swj_qx, plotdat.swj_qy), bins)/length(plotdat.swj_qx);
        hist_qx = hist(plotdat.swj_qx,bins);
        hist_qy = hist(plotdat.swj_qy,bins);
        hist_q = hist( max(plotdat.swj_qx, plotdat.swj_qy), bins);
        figure, plot(repmat(bins,2,1)',[hist_qx ;hist_qy; ]','linewidth',2)
%         line([ mean_qx mean_qx], [0 .2],'Color', [0 0 1],'linewidth',2)
%         line([ mean_qy mean_qy], [0 .2],'Color', [0 0.5 0], 'linewidth',2)
%         line([ mean_q mean_q], [0 .2],'Color', [0.8 0 0], 'linewidth',2)
        set(gca, 'FontSize', 14);
%         legend({'Horizontal score distribution' 'Vertical score
%         distribution' 'Maximum score'})
        legend({'Horizontal score distribution' 'Vertical score distribution' })
        xlabel('SWJ score','fontsize', 14);
        ylabel('Number of SWJs','fontsize', 14);
        mytight(gca,30)
%         set(gca, 'ylim', [0 .3])
        title(get_plot_title(sname,'SWJ Score', which_eye));
        %--------------------------------------------------
    case 'SWJ_D'
        %--------------------------------------------------
        if ( strcmp( which_eye, 'Both' ) )
            which_eye = 'Concat';
        end
        plotdat = get_plotdat( plotdat, sname, {'swj_d' },which_eye );
        check_plotdat(plotdat,  {'swj_d' } );

        figure
        % Magnitude
        degbins = -1:.05:1;


        hist_x = histc( plotdat.swj_d, degbins);
        h=bar(degbins, hist_x, 'histc');
        set(h, 'facecolor', COLORS.MEDIUM_BLUE);
        title( 'swj d' );
        title( get_plot_title(sname,'SWJ d',which_eye),'fontsize', 14);
        set(gca, 'FontSize', 14);
        xlabel('SWJ d (%)','fontsize', 14);
        ylabel('Number of Microsaccades','fontsize', 14);
end

function hist_magnitude(S, data, tit, degbins , totaltime, leg)
if ( ~exist( 'degbins' ) )
	degbins = 0:0.1:3;
end
if ( ~exist( 'totaltime' ) )
	plot_histogram(S, data, degbins, tit, 'Microsaccade Magnitude (deg)', 'Microsaccades' )
else
	plot_histogram(S, data, degbins, tit, 'Microsaccade Magnitude (deg)', 'Microsaccades', totaltime , leg)
end
set(gca,'xlim',[degbins(1) degbins(end)]);


function hist_duration(S, data, tit, degbins , totaltime, leg)
if ( ~exist( 'degbins' ) )
	degbins = 0:1:100;
end
if ( ~exist( 'totaltime' ) )
	plot_histogram(S, data, degbins, tit, 'Microsaccade Duration (s)', 'Microsaccades' )
else
	plot_histogram(S, data, degbins, tit, 'Microsaccade Duration (s)', 'Microsaccades', totaltime, leg)
end
set(gca,'xlim',[degbins(1) degbins(end)]);



function hist_interval(S, data, tit, ylabel, degbins )

if ( ~exist( 'degbins' ) )
	degbins = 0:20:1000;
end
plot_histogram(S, data, degbins, tit, 'Interval (ms)', ylabel);

function plotlist = get_plotlist()

plotlist.Square_Wave_Jerk =  { {'{0}','1'} };
plotlist.Square_Wave_Jerk_Options.Square_Wave_Jerk_X_Component =  { {'0','{1}'} };
plotlist.Square_Wave_Jerk_Options.Square_Wave_Jerk_Magnitude	=  { {'{0}','1'} };
plotlist.Square_Wave_Jerk_Options.Square_Wave_Jerk_Direction	=  { {'{0}','1'} };
plotlist.Square_Wave_Jerk_Options.Square_Wave_Jerk_Timing		=  { {'{0}','1'} };
plotlist.Square_Wave_Jerk_viewer =  { {'{0}','1'} };
plotlist.SWJ_Main_Sequence	= { {'{0}','1'} };
plotlist.SWJ_Magnitude					=  { {'{0}','1'} };
plotlist.SWJ_Relative_Magnitude		=  { {'{0}','1'} };
plotlist.SWJ_Duration					=  { {'{0}','1'} };
plotlist.SWJ_InterSaccadic_Interval	=  { {'{0}','1'} };
plotlist.SWJ_Direction					=  { {'{0}','1'} };
plotlist.SWJ_Score						=  { {'{0}','1'} };
plotlist.SWJ_D							=  { {'{0}','1'} };