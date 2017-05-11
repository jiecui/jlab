classdef Grating < Experiment & EyeMovement
    % Class GRATING explores the neural during grating testing
    
    % Copyright 2012-2016 Richard J. Cui. Created: Fri 08/03/2012  5:11:03.840 PM
    % $Revision: 0.2 $  $Date: Wed 08/10/2016 10:37:00.157 AM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com

    % =====================================================================
    % constructor
    % =====================================================================
    methods
        function this = Grating()
            
            % Prefix for the name of the sessions from this experiment
            this.prefix = 'GRA';
            
            % Name of the experiment (can contain spaces)
            this.name = [this.prefix, ' - ', 'Grating'];
            
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
            
            % Options for stationary wavelet filter 
            %---------------------------
            options = [];
        end
        
        % additional methods
        % ==================
        
    end % static methods

    % methods can be overwritten
    % --------------------------
    methods(Static = true)

    end % static methods
    
    methods
        % process( this, sname, S )
    end
    
end

