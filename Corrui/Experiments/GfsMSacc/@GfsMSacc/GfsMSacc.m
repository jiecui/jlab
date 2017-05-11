classdef GfsMSacc < EyeMovementExp & MultiUnitActivity & LocalFieldPotential
    % GFSMSACC This function explores the neural correlates of microsaccade in GFS experiments
    % 
    % References:
    %   Wilke, M., Logothetis, N. K., & Leopold, D. A. (2006). Local field
    %   potential reflects perceptual suppression in monkey visual cortex.
    %   Proceedings of the National Academy of Sciences of the United
    %   States of America, 103(46), 17507-17512.
    %
    %   Cui, J., Wilke, M., Logothetis, N. K., Leopold, D. A., & Liang, H.
    %   L. (2009). Visibility states modulate microsaccade rate and
    %   direction. Vision Research, 49(2), 228-236. doi:DOI
    %   10.1016/j.visres.2008.10.015

    % Copyright 2014-2016 Richard J. Cui. Created: Sun 08/03/2014 10:02:09.478 AM
    % $Revision: 0.9 $  $Date: Wed 08/10/2016 10:37:00.157 AM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com

    % =====================================================================
    % constructor
    % =====================================================================
    methods
        function this = GfsMSacc()
            
            % Prefix for the name of the sessions from this experiment
            this.prefix = 'GMS';
            
            % Name of the experiment (can contain spaces)
            this.name = [this.prefix, ' - GFS Microsaccades'];
            
            % which files can be imported for this type of experiment
            this.filetypes = {'MAT'};
            
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
        sess_name = getGMSSessName(data_fname)  % construct session name for GMS experiment
        
        % ====== otheres ======
        
    end % static methods
    
    methods
        % ====== Experiment ======
        [session_name, imported_data] = importExp(this, pathname, filename, session_name, values, imported_filetype)
        values = getSessionInfo(varargin)   % get Session information
        exp_menu_obj = setCurrExpMenus(this, handles)   % set current menus
        mnuMergeData_Callback(this, hObject, eventdata, handles)    % callback of merging data
        [newsession, dtype] = guiMergeData( this , handles )     % GUI for merge two data types
        newsessions = mergeData(this, blocks, opt, do_waitbar)    % conbines different data type into one session
        opt = getProcessStage0Options( this )   % options of process stage 0
        [imported_data, stage0_data] = stage0process(this, sess_name, options)
        % exp_trial   = Trial(this, sname)
       
        % ====== spikes methods ======
        % exp_spike = Spike(this, sname)
        
        % ====== eye methods ======
        dat = analyze_eye_movements( this, sname, S,  import_variables)
        
        % ====== neural signal & eye methods ======
        stage1_data = stage1process(this, sess_name, options)
        % out = filter_conditions( this, conditions, filter, enum, sname)
    end
    
end

