classdef GfsMSaccPlots < EyeMovementExpPlots
    % Class GFSMSACCPLOTS Collection of plot functions for GFS-MS experiment
    
    % Copyright 2014-2016 Richard J. Cui. Created: Sun 08/03/2014 11:32:19.742 AM
    % $Revision: 0.5 $  $Date: Mon 11/28/2016 10:02:34.375 PM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com
    
    properties
        
    end % properties
    
    methods
        function this = GfsMSaccPlots()
            
        end
    end % methods
    
    methods ( Static = true )
        % ****************************************************************
        % ADD NEW FUNCTIONS BELOW FOR NEW PLOTS **************************
        % ****************************************************************
        
        % Session functions
        % -----------------
        result_dat = Plot_check_signals(current_tag, sname, S)
        result_dat = Scroll_Plot(current_tag, sname, S)
        result_dat = Main_Sequence(current_tag, sname, S)
        
        % aggreate functions
        % -------------------
        % options = AggStep_contrast_response(current_tag, snames, S)
        
    end
    
    methods
        % ====== Scroll Up ======
        plotdat = prep_scrollup_data(this, sname, dat_var, ncond, ntrial, filter)
        hplot = show_scrollup(this, curr_exp, sname, plotdat)
        data = update_scrollup_data(this, hObject, eventdata, handles, condition, trial)
    end % methods
end % classdef

% [EOF]
