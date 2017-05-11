classdef FxcmMirrorTrader < Experiment
    % Class FXCMMIRRORTRADER defines the functions used in processing FxcmMirrorTrader experiments
    
    % Copyright 2014-2016 Richard J. Cui. Created: Fri 11/07/2014 10:50:12.134 PM
    % $Revision: 0.2 $  $Date: Wed 08/10/2016 10:51:34.533 AM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com

    % =====================================================================
    % constructor
    % =====================================================================
    methods
        function this = FxcmMirrorTrader()
            
            % Prefix for the name of the sessions from this experiment
            this.prefix = 'FMT';
            
            % Name of the experiment (can contain spaces)
            this.name = [this.prefix, ' - ', 'FXCM MirrorTrader'];
            
            % which files can be imported for this type of experiment
            this.filetypes = {'XLSX'};
            
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
        % ====== Import ======
        [filenames, pathname, sessname, S] = import_files_dialog( prefix, tag, extension, extra_options )
        
        % ====== otheres ======

    end % static methods
    
    methods        
        % ====== Experiment ======
        [session_name, imported_data] = importExp(this, pathname, filename, session_name, values, imported_filetype)
                
        % ====== otheres ======
    end
    
end

