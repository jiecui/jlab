classdef MSaccContrastPlots < TunePlots & EyeMovementExpPlots
    % Class MSACCCONTRASTPLOTS Collection of plot functions for the
    %       experiment of microsaccade-contrast project
    
    % Copyright 2011-2016 Richard J. Cui. Created: 11/20/2011  7:27:02.143 PM
    % $Revision: 0.9 $  $Date: Mon 11/14/2016  2:52:31.518 PM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com
    
    properties
        
    end % properties
    
    methods
        function this = MSaccContrastPlots()
            
        end
    end % methods
    
    methods
        sac_frm = format_sacc(this, sacc_props, var_name)
        fix_frm = format_fix(this, sacc_props)
        drift_frm = format_drift(this, drift_props)
        blink_frm = format_blink(this, blink_props)
    end % methods
    
    methods ( Static = true )
        % ****************************************************************
        % ADD NEW FUNCTIONS BELOW FOR NEW PLOTS **************************
        % ****************************************************************
        % Example
        % --------
        % options = Plot_ABS_Example( current_tag, snames, S )
        
        % Session functions
        % -----------------
        out = Plot_mSaccConSig(current_tag, snames, S)
        options = Contrast_response_function(current_tag, snames, S)
        options = Spike_raster_and_rate(current_tag, snames, S)
        options = Plot_FRChange_consistency(current_tag, snames, S)
        out = Plot_FXContCond(current_tag, snames, S)
        out = Plot_UXContCond(current_tag, snames, S)
        options = plot_MSTriggeredContrastResponse(current_tag, sname, S)
        opt = plot_MSTriggeredSpikeSpecgram(current_tag, sname, S)
        result_dat = Main_Sequence(current_tag, sname, S)
        result_dat = Scroll_Plot(current_tag, sname, S)
        
        % aggreate functions
        % -------------------
        options = AggStep_contrast_response(current_tag, snames, S)
        options = Plot_response_sorted_percentage_analysis(current_tag, snames, S)
        options = Aggplot_check_FR_change(current_tag, snames, S)
        out = Aggplot_usacc_triggered_contrast_response(current_tag, snames, S)
        options = Aggplot_compare_SCMT_index(current_tag, snames, S)
        options = Aggplot_MT_index(current_tag, snames, S)
    end
end % classdef

% [EOF]
