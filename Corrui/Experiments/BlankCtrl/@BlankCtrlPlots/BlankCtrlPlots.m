classdef BlankCtrlPlots < EyeMovementPlots
    % Class BLANKCTRLPLOTS (summary)
    
    % Copyright 2012 Richard J. Cui. Created: Mon 08/13/2012  6:11:12.643 PM
    % $Revision: 0.1 $  $Date: Mon 08/13/2012  6:11:12.643 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com
    
    properties
        
    end % properties
    
    methods
        function this = BlankCtrlPlots()
            
        end
    end % methods
    
    methods ( Static )
        % ****************************************************************
        % ADD NEW FUNCTIONS BELOW FOR NEW PLOTS **************************
        % ****************************************************************
        
        
        % Session functions
        % -----------------
        opt = plot_MSTriggeredContrastResponse(current_tag, sname, S)
        
        % aggreate functions
        % -------------------
        out = Aggplot_usacc_triggered_bct_response(current_tag, sname, S)
        
    end
end % classdef

% [EOF]
