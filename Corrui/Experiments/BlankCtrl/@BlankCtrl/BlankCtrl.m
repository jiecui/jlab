classdef BlankCtrl < EyeAndSpikeExp
    % Class BLANKCTRL defines the functions used in processing
    %       Blank-control experiments
    
    % Copyright 2012-2016 Richard J. Cui. Created: Tue 08/07/2012  5:42:19.522 PM
    % $Revision: 0.3 $  $Date: Wed 08/10/2016 10:51:34.533 AM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com

    % =====================================================================
    % constructor
    % =====================================================================
    methods
        function this = BlankCtrl()
            
            % Prefix for the name of the sessions from this experiment
            this.prefix = 'BCT';
            
            % Name of the experiment (can contain spaces)
            this.name = [this.prefix, ' - Blank Control'];
            
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
            % options.Wavelet_Filter = { {'{0}','1'} };
            % options.Wavelet_Filter_Options.Wavelet_Name = {{'db1','{db4}','dmey'}};
            % options.Wavelet_Filter_Options.Decomposition_Level = {3 '' [1 100]};
            
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
        % ====== spikes methods ======
        dat = detect_spike_events(this, sname, S, import_variables)
        
        % ====== eye methods ======
        dat = analyze_eye_movements( this, sname, S,  import_variables)
        
        % ====== spikes & eye methods ======
        
        % ====== otheres ======
        [imported_data, stage0_data] = stage0process(this, sname, options)
        stage1_data = stage1process(this, sname, options)

    end
    
end

