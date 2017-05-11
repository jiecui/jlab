classdef MSaccContrast < EyeAndSpikeExp
    % MSACCCONTRAST This function explores the neural correlates of the effect of microsaccade on contrast perception
    
    % Copyright 2011-2016 Richard J. Cui. Created: 01/18/2012  5:48:23.507 PM
    % $Revision: 0.5 $  $Date: Sun 08/07/2016 10:30:50.526 AM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com

    % =====================================================================
    % properties
    % =====================================================================
    properties
        enum        % column meaning; use table in the future
    end % properties
    
    % =====================================================================
    % constructor
    % =====================================================================
    methods
        function this = MSaccContrast()
            
            % Prefix for the name of the sessions from this experiment
            this.prefix = 'MSC';
            
            % Name of the experiment (can contain spaces)
            this.name = [this.prefix, ' - Microsaccade Contrast'];
            
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
        new_session_name = blocks2session(blocks, opt, do_waitbar)  % conbines different blocks in a session into one
    end % static methods

    % methods can be overwritten
    % --------------------------
    methods(Static = true)
        % ====== Experiment ======
        values = getSessionInfo(sess_name, max_num_chunks)
        
        % ====== spikes methods ======
        % spktimes = get_1stage_spktime(cycleidx, condidx, stageidx, enum, spiketimes)
        % spk_yn = get_1stage_spkyn(cycleidx, condidx, stageidx, enum, ...
        %     spiketimes, grattime, NumberCondition, CondInCycle, trailMatrix)
        [spktimes12, spktimes23, start12, end12, start23, end23] = get_1trial_spktime(cycleidx, condidx, ...
            trialMatrix, NumberCondition, CondInCycle, grattime, enum, spiketimes)
        
        [spk12_yn, spk23_yn] = get_1trial_spkyn(cycleidx, condidx, enum, ...
            spiketimes, grattime, NumberCondition, CondInCycle, trialMatrix)
        
        % ====== eye methods ======        
        [us_start_times12, us_end_times12, us_start_times23, us_end_times23, ...
            start12, end12, start23, end23] = get_1trial_ustime(cycleidx, condidx, trialMatrix, ...
            NumberCondition, CondInCycle, grattime, enum, usacc_props)
        
        [us_start12_yn, us_end12_yn, us_start23_yn, us_end23_yn] = get_1trial_usyn(cycleidx, condidx, enum, grattime, NumberCondition, ...
            CondInCycle, trialMatrix, usacc_props)
        % ====== spikes & eye methods ======
        
        % ====== otheres ======
        trialnum = cyc_cond_2_trialnum(cycleidx, condidx, NumberCondition, CondInCycle)
    end % static methods
    
    methods
         % ====== Experiment ======
        [session_name, imported_data] = importExp(this, pathname, filename, session_name, values, imported_filetype)
        exp_trial   = Trial(this, sname)
        mnuRunCombineBlocks_Callback(this, hObject, eventdata, handles)     % callback of combining blocks
        exp_menu_obj = setCurrExpMenus(this, handles)   % setup current menus
        newsession = guiBlock2session( this , handles )    % GUI for combining two data blocks
        totaltime   = get_totaltime( this, sname, filter )
        
        % ====== spikes methods ======
        dat = detect_spike_events(this, sname, S, import_varialbes)
        exp_spike = Spike(this, sname)
        
        % ====== eye methods ======
        exp_blink   = Blink(this, sname)
        exp_fix     = Fixation(this, sname)
        exp_drif    = Drift(this, sname)
        exp_sacc    = Sacc(this, sname)
        exp_usacc   = Usacc(this, sname)
        dat = analyze_eye_movements(this, sname, S, import_varialbes)
        
        % ====== spikes & eye methods ======
        [imported_data, stage0_data] = stage0process(this, sess_name, options)
        stage1_data = stage1process(this, sess_name, options)
        out = filter_conditions( this, conditions, filter, enum, sname)
        
    end
    
end

