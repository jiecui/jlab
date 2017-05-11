classdef Tune < Experiment & EyeMovement
    % Tune This function explores the neural activity during orentational
    %       tuning estimation
    
    % Copyright 2012 Richard J. Cui. Created: Thu 08/02/2012  4:00:45.064 PM
    % $Revision: 0.1 $  $Date: Thu 08/02/2012  4:00:45.064 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    % =====================================================================
    % constructor
    % =====================================================================
    methods
        function this = Tune()
            
            % Prefix for the name of the sessions from this experiment
            this.prefix = 'TUN';
            
            % Name of the experiment (can contain spaces)
            this.name = [this.prefix, ' - ', 'Orientation Tuning'];
            
            % which files can be imported for this type of experiment
            this.filetypes = {'RF'};
            
        end
    end
    
    % =====================================================================
    % methods
    % =====================================================================
    methods ( Static )
        
        function options = getExpProcessOptions( )
            % options = get_options( )
            %
            % Global options to appear in the process dialog. They are
            % common for all the analysis
            %
            % Imput:
            % Output
            %   options: struct with the options
            %
            % Example:
            % options.Window_Backward             = 4000;
            % options.Window_Forward              = 2000;
            % options.Use_Only_Previous_Period    = { {'0','{1}'} };
            
            options = [];

        end
        
        % additional methods
        % ==================
        
    end % static methods
    
    % methods can be overwritten
    % --------------------------
    methods(Static = true)

    end % static methods
    
end

