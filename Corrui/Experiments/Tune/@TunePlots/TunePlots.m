classdef TunePlots < EyeMovementPlots
    % Class TUNEPLOTS plots data from orientation tuning test
    
    % Copyright 2012 Richard J. Cui. Created: Thu 08/02/2012  5:30:24.296 PM
    % $Revision: 0.1 $  $Date: Thu 08/02/2012  5:30:24.296 PM $
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
        function this = TunePlots()
            
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
        options = Tuning_check(current_tag, snames, S)
        
        % aggreate functions
        % -------------------
        
    end
end % classdef

% [EOF]
