function out = fixsim_correlation_plots( handles, sname, plotdat,S, ptype,  type_of_experiment, type_of_data, samplerate, which_eye)

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
    %--------------------------------------------------
    case 'Correlation_Microsaccade_Rate_around_Spike'
    %--------------------------------------------------
        switch( S.Correlation_Type_of_Data )
            case  { 'Raw' 'Raw - % increase' }
                ylab = 'Microsaccade rate (N/sec)';
            case '% increase'
                ylab = 'Microsaccade rate increase';
            case 'Z-scores'
                ylab = 'Microsaccade rate z-scores';
        end
        titl = [sname ' -- Microsaccade rate around spike'];
        xlab	= 'Time around spike (ms)';

        switch type_of_experiment
            case handles.Enums.Internal_Text_List{handles.Enums.Internal_FixSim}
                % Get and check the data
                plotdat = get_plotdat( plotdat, sname, { 'corr_usac_on_spk' 'pus'} , which_eye );
                check_plotdat( plotdat, { 'corr_usac_on_spk' 'pus' } );

                % Plot the data
                fading_correlation_plot( handles, sname, 'corr_usac_on_spk', titl, xlab, ylab, ...
                    plotdat.corr_usac_on_spk, [], plotdat.pus, ...
                    S.Correlation_Smoothing_Window_Width, type_of_data, samplerate );
                legend off
                
                
            case handles.Enums.Internal_Text_List{handles.Enums.Internal_FixSim_Avg}

                % Get the data
                plotdat = get_avgcorr_plotdat(handles, S.Correlation_Type_of_Data, plotdat, sname, 'corr_usac_on_spk','corr_usac_on_spk','pus');

                % Plot the data
                fading_avgcorr_plotdat( handles, sname, 'corr_usac_on_spk', S.Type_of_error, titl, xlab, ylab, ...
                    plotdat.corr_usac_on_spk, [], plotdat.pus, plotdat.SE_corr_usac_on_spk, [], ...
                    S.Correlation_Smoothing_Window_Width, samplerate );
                legend off
        end
            %--------------------------------------------------
    case 'Correlation_Spike_Rate_around_Microsaccade'
    %--------------------------------------------------
        switch( S.Correlation_Type_of_Data )
            case  { 'Raw' 'Raw - % increase' }
                ylab = 'Spike rate (N/sec)';
            case '% increase'
                ylab = 'Spike rate increase';
            case 'Z-scores'
                ylab = 'Spike rate z-scores';
        end
        titl = [sname ' -- Spike rate around microsaccade'];
        xlab	= 'Time around microsaccade (ms)';

        switch type_of_experiment
            case handles.Enums.Internal_Text_List{handles.Enums.Internal_FixSim}
                % Get and check the data
                plotdat = get_plotdat( plotdat, sname, { 'corr_spk_usacc' 'avg_spike_rate'} , which_eye );
                plotdat = get_plotdat( plotdat, sname, { 'avg_spike_rate'} );
                check_plotdat( plotdat, { 'corr_spk_usacc' } );

                % Plot the data
                fading_correlation_plot( handles, sname, 'corr_spk_usacc', titl, xlab, ylab, ...
                    plotdat.corr_spk_usacc, [], plotdat.avg_spike_rate, ...
                    S.Correlation_Smoothing_Window_Width, type_of_data, samplerate );
                legend off
                
                
            case handles.Enums.Internal_Text_List{handles.Enums.Internal_FixSim_Avg}

                % Get the data
                plotdat = get_avgcorr_plotdat(handles, S.Correlation_Type_of_Data, plotdat, sname, 'corr_spk_usacc','corr_spk_usacc','avg_spike_rate');

                % Plot the data
                fading_avgcorr_plotdat( handles, sname, 'corr_spk_usacc', S.Type_of_error, titl, xlab, ylab, ...
                    plotdat.corr_spk_usacc, [], plotdat.avg_spike_rate, plotdat.SE_corr_spk_usacc, [], ...
                    S.Correlation_Smoothing_Window_Width, samplerate );
                legend off
        end
        
        
    %--------------------------------------------------
    case 'Correlation_Sim_Microsaccade_Rate_around_Spike'
    %--------------------------------------------------
        switch( S.Correlation_Type_of_Data )
            case  { 'Raw' 'Raw - % increase' }
                ylab = 'Sim Microsaccade rate (N/sec)';
            case '% increase'
                ylab = 'Sim Microsaccade rate increase';
            case 'Z-scores'
                ylab = 'Sim Microsaccade rate z-scores';
        end
        titl = [sname ' -- Sim Microsaccade rate around spike'];
        xlab	= 'Time around spike (ms)';

        switch type_of_experiment
            case handles.Enums.Internal_Text_List{handles.Enums.Internal_FixSim}
                % Get and check the data
                plotdat = get_plotdat( plotdat, sname, { 'corr_simusac_on_spk' 'pus'} , which_eye );
                check_plotdat( plotdat, { 'corr_simusac_on_spk' 'pus' } );

                % Plot the data
                fading_correlation_plot( handles, sname, 'corr_simusac_on_spk', titl, xlab, ylab, ...
                    plotdat.corr_simusac_on_spk, [], plotdat.pus, ...
                    S.Correlation_Smoothing_Window_Width, type_of_data, samplerate );
                legend off
                
                
            case handles.Enums.Internal_Text_List{handles.Enums.Internal_FixSim_Avg}

                % Get the data
                plotdat = get_avgcorr_plotdat(handles, S.Correlation_Type_of_Data, plotdat, sname, 'corr_simusac_on_spk','corr_simusac_on_spk','pus');

                % Plot the data
                fading_avgcorr_plotdat( handles, sname, 'corr_simusac_on_spk', S.Type_of_error, titl, xlab, ylab, ...
                    plotdat.corr_simusac_on_spk, [], plotdat.pus, plotdat.SE_corr_simusac_on_spk, [], ...
                    S.Correlation_Smoothing_Window_Width, samplerate );
                legend off
        end
    %--------------------------------------------------
    case 'Correlation_Spike_Rate_around_Sim_Microsaccade'
    %--------------------------------------------------
        switch( S.Correlation_Type_of_Data )
            case  { 'Raw' 'Raw - % increase' }
                ylab = 'Spike rate (N/sec)';
            case '% increase'
                ylab = 'Spike rate increase';
            case 'Z-scores'
                ylab = 'Spike rate z-scores';
        end
        titl = [sname ' -- Spike rate around sim. microsaccade'];
        xlab	= 'Time around sim. microsaccade (ms)';

        switch type_of_experiment
            case handles.Enums.Internal_Text_List{handles.Enums.Internal_FixSim}
                % Get and check the data
                plotdat = get_plotdat( plotdat, sname, { 'corr_spk_simusacc' 'avg_spike_rate'} , which_eye );
                plotdat = get_plotdat( plotdat, sname, { 'avg_spike_rate'} );
                check_plotdat( plotdat, { 'corr_spk_simusacc' } );

                % Plot the data
                fading_correlation_plot( handles, sname, 'corr_spk_simusacc', titl, xlab, ylab, ...
                    plotdat.corr_spk_simusacc, [], plotdat.avg_spike_rate, ...
                    S.Correlation_Smoothing_Window_Width, type_of_data, samplerate );
                legend off
                
                
            case handles.Enums.Internal_Text_List{handles.Enums.Internal_FixSim_Avg}

                % Get the data
                plotdat = get_avgcorr_plotdat(handles, S.Correlation_Type_of_Data, plotdat, sname, 'corr_spk_simusacc','corr_spk_simusacc','avg_spike_rate');

                % Plot the data
                fading_avgcorr_plotdat( handles, sname, 'corr_spk_simusacc', S.Type_of_error, titl, xlab, ylab, ...
                    plotdat.corr_spk_simusacc, [], plotdat.avg_spike_rate, plotdat.SE_corr_spk_simusacc, [], ...
                    S.Correlation_Smoothing_Window_Width, samplerate );
                legend off
        end
    %--------------------------------------------------
    case 'Correlation_Combined_Microsaccade_Rate_around_Spike'
    %--------------------------------------------------
        switch( S.Correlation_Type_of_Data )
            case  { 'Raw' 'Raw - % increase' }
                ylab = 'Spike rate (N/sec)';
            case '% increase'
                ylab = 'Spike rate increase';
            case 'Z-scores'
                ylab = 'Spike rate z-scores';
        end
        titl = [sname ' -- Microsaccade rate around spike'];
        xlab	= 'Time around spike (ms)';

        switch type_of_experiment
            case handles.Enums.Internal_Text_List{handles.Enums.Internal_FixSim}
                % Get and check the data
                plotdat = get_plotdat( plotdat, sname, { 'corr_usac_on_spk' 'corr_simusac_on_spk' 'pus'} , which_eye );
                check_plotdat( plotdat, {'corr_usac_on_spk' 'corr_simusac_on_spk' } );

                % Plot the data
                fading_correlation_plot( handles, sname, 'corr_simusac_on_spk', titl, xlab, ylab, ...
                    plotdat.corr_simusac_on_spk, plotdat.corr_usac_on_spk, plotdat.pus, ...
                    S.Correlation_Smoothing_Window_Width, type_of_data, samplerate );
                
                
            case handles.Enums.Internal_Text_List{handles.Enums.Internal_FixSim_Avg}

                % Get the data
                plotdat = get_avgcorr_plotdat(handles, S.Correlation_Type_of_Data, plotdat, sname, 'corr_usac_on_spk','corr_simusac_on_spk','pus');

                % Plot the data
                fading_avgcorr_plotdat( handles, sname, 'corr_simusac_on_spk', S.Type_of_error, titl, xlab, ylab, ...
                    plotdat.corr_simusac_on_spk, plotdat.corr_usac_on_spk, plotdat.pus, plotdat.SE_corr_simusac_on_spk, plotdat.SE_corr_usac_on_spk, ...
                    S.Correlation_Smoothing_Window_Width, samplerate );
        end
    %--------------------------------------------------
    case 'Correlation_Spike_Rate_around_Combined_Microsaccade'
    %--------------------------------------------------
        switch( S.Correlation_Type_of_Data )
            case  { 'Raw' 'Raw - % increase' }
                ylab = 'Spike rate (N/sec)';
            case '% increase'
                ylab = 'Spike rate increase';
            case 'Z-scores'
                ylab = 'Spike rate z-scores';
        end
        titl = [sname ' -- Spike rate around microsaccade'];
        xlab	= 'Time around microsaccade (ms)';

        switch type_of_experiment
            case handles.Enums.Internal_Text_List{handles.Enums.Internal_FixSim}
                % Get and check the data
                plotdat = get_plotdat( plotdat, sname, { 'corr_spk_usacc' 'corr_spk_simusacc' 'avg_spike_rate'} , which_eye );
                plotdat = get_plotdat( plotdat, sname, { 'avg_spike_rate'} );
                check_plotdat( plotdat, { 'corr_spk_simusacc' 'corr_spk_usacc' } );

                % Plot the data
                fading_correlation_plot( handles, sname, 'corr_spk_simusacc', titl, xlab, ylab, ...
                    plotdat.corr_spk_simusacc, plotdat.corr_spk_usacc, plotdat.avg_spike_rate, ...
                    S.Correlation_Smoothing_Window_Width, type_of_data, samplerate );
                
                
            case handles.Enums.Internal_Text_List{handles.Enums.Internal_FixSim_Avg}

                % Get the data
                plotdat = get_avgcorr_plotdat(handles, S.Correlation_Type_of_Data, plotdat, sname, 'corr_spk_usacc','corr_spk_simusacc','avg_spike_rate');

                % Plot the data
                fading_avgcorr_plotdat( handles, sname, 'corr_spk_simusacc', S.Type_of_error, titl, xlab, ylab, ...
                    plotdat.corr_spk_simusacc, plotdat.corr_spk_usacc, plotdat.avg_spike_rate, plotdat.SE_corr_spk_simusacc, plotdat.SE_corr_spk_usacc, ...
                    S.Correlation_Smoothing_Window_Width, samplerate );
        end
        
        %--------------------------------------------------
    case 'Raster_Spike_around_Microsaccade'
    %--------------------------------------------------
    
        plotdat = get_plotdat( plotdat, sname, { 'left_raster_corr_spk_usacc' 'window_backward'} );
        
        plot_raster(plotdat.left_raster_corr_spk_usacc, plotdat.window_backward.left_corr_spk_usacc)

    
        
        
end




%% == fading_correlation_plot
function fading_correlation_plot( handles, session_name, varname,  titl, xlab, ylab, int_corr, fad_corr, avg, Correlation_Smoothing_Window_Width, dm, samplerate )

figure;
set(gcf,'position', CorrGui.get_default_plot_pos());
set(gcf,'name',titl);


window_backward = sessdb( 'getsessvar', session_name, 'window_backward');
window_backward = window_backward.(['left_' varname]);
window_forward	= sessdb( 'getsessvar', session_name, 'window_forward');
window_forward	= window_forward.(['left_' varname]);

fading_plotdat( int_corr, 'r-', 3, fad_corr, 'b-', 3, ...
    avg*ones(length(int_corr),1),  [-window_backward:1000/samplerate:window_forward-1], min(fad_corr), max(int_corr), ...
    titl, xlab, ylab, 'Simulated', 'Real', window_backward, window_forward, samplerate, ...
    floor(Correlation_Smoothing_Window_Width/1000*samplerate), dm);





%% == fading_avgcorr_plotdat
function fading_avgcorr_plotdat( handles, session_name, varname, Type_of_error, titl, xlab, ylab, int_corr, fad_corr, avg, int_err, fad_err, Correlation_Smoothing_Window_Width, samplerate)

figure;
set(gcf,'position', CorrGui.get_default_plot_pos());
set(gcf,'name',titl);

window_backward = sessdb( 'getsessvar', session_name, 'window_backward');
window_backward = window_backward.(varname);
window_forward	= sessdb( 'getsessvar', session_name, 'window_forward');
window_forward	= window_forward.(varname);

switch ( Type_of_error )
    case 'None'
        fading_plotdat( int_corr, 'r-', 3, fad_corr, 'b-', 3, ...
            avg*ones(length(int_corr),1), [-window_backward:1000/samplerate:window_forward-1], min(fad_corr), max(int_corr), ...
            titl, xlab, ylab, 'Simulated', 'Real',window_backward, window_forward, samplerate, ...
            floor(Correlation_Smoothing_Window_Width/1000*samplerate), 0 );
    case 'Lines'
        fading_plotdaterr(int_corr,'r-',fad_corr,'b-',...
            avg*ones(length(int_corr),1),int_err,'r-',fad_err,'b-',...
            [-window_backward:1000/samplerate:window_forward-1], min(fad_corr), max(int_corr), ...
            titl,xlab, ylab,...
            floor(Correlation_Smoothing_Window_Width/1000*samplerate), 0 , 'Simulated', 'Real', window_backward, window_forward, samplerate, ...
            3,3,2);
    case 'Shadow'
        fading_plotdaterr_shading( int_corr, 'r-', fad_corr, 'b-', ...
            avg*ones(length(int_corr),1),int_err, 'r-', fad_err, 'b-',...
            [-window_backward:1000/samplerate:window_forward-1], min(fad_corr), max(int_corr), ...
            titl, xlab, ylab,...
            floor(Correlation_Smoothing_Window_Width/1000*samplerate), 0, 'Simulated', 'Real',window_backward, window_forward, samplerate, ...
            2,2,2);
end


function plotlist = get_plotlist()

plotlist.Correlation_Microsaccade_Rate_around_Spike = { {'{0}','1'}};
plotlist.Correlation_Spike_Rate_around_Microsaccade = { {'{0}','1'} };
plotlist.Correlation_Sim_Microsaccade_Rate_around_Spike = { {'{0}','1'}};
plotlist.Correlation_Spike_Rate_around_Sim_Microsaccade = { {'{0}','1'} };
plotlist.Correlation_Combined_Microsaccade_Rate_around_Spike = { {'{0}','1'}};
plotlist.Correlation_Spike_Rate_around_Combined_Microsaccade = { {'{0}','1'} };


plotlist.Raster_Spike_around_Microsaccade = { {'{0}','1'} };

plotlist.Correlation_Smoothing_Window_Width = { 151 '* (ms)' [1 10000] };
plotlist.Correlation_Type_of_Data = { {'{Raw}','% increase', 'Z-scores', '%_increase_pre-smoothed' 'Raw_pre-smoothed'} };
plotlist.Type_of_error = { {'{None}','Lines','Shadow'} };
