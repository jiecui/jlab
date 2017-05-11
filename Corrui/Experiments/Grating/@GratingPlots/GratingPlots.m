classdef GratingPlots < EyeMovementPlots
    % Class GRATINGPLOTS (summary)
    
    % Copyright 2012 Richard J. Cui. Created: Sun 08/05/2012 10:57:36.851 AM
    % $Revision: 0.1 $  $Date: Sun 08/05/2012 10:57:36.851 AM $
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
        function this = GratingPlots()
            
        end
    end % methods
    
    methods ( Static )
        % ****************************************************************
        % ADD NEW FUNCTIONS BELOW FOR NEW PLOTS **************************
        % ****************************************************************
        
        
        % Example
        % --------
        % options = Plot_ABS_Example( current_tag, snames, S )
        
        % Session functions
        % -----------------
        options = Grating_response(current_tag, snames, S)
        
        % aggreate functions
        % -------------------
        
    end
end % classdef

% [EOF]
