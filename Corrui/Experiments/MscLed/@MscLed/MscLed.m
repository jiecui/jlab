classdef MscLed < EyeAndSpikeExp
    % Class MSCLED defines the functions used in processing
    %       MSC-LED experiments
    
    % Copyright 2013-2014 Richard J. Cui. Created: Tue 09/03/2013  9:48:39.721 AM
    % $Revision: 0.3 $  $Date: Mon 04/21/2014  2:15:32.056 PM $
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
        function this = MscLed()
            
            % Prefix for the name of the sessions from this experiment
            this.prefix = 'MLD';
            
            % Name of the experiment (can contain spaces)
            this.name = [this.prefix, ' - ', 'MSC LED'];
            
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
        % ====== Experiment ======
        values = getSessionInfo(sess_name, max_num_chunks, filetypes)

    end % static methods
    
    methods
        % ====== Experiment ======
        [session_name, imported_data] = importExp(this, pathname, filename, session_name, values, imported_filetype)
        
        % ====== spikes methods ======
        dat = detect_spike_events(this, sname, S, import_variables)
        
        % ====== eye methods ======
        exp_blink   = Blink(this, sname)
        exp_fix     = Fixation(this, sname)
        exp_drif    = Drift(this, sname)
        exp_sacc    = Sacc(this, sname)
        exp_usacc   = Usacc(this, sname)
        dat = analyze_eye_movements( this, sname, S,  import_variables)
        
        % ====== spikes & eye methods ======
        [imported_data, stage0_data] = stage0process(this, sess_name, options)
        stage1_data = stage1process(this, sess_name, options)
        
        % ====== otheres ======

    end
    
end

