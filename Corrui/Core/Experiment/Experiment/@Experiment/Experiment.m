classdef Experiment < DataIO & ExpProcedure
	% Class EXPERIMENT parent class of all experiment
    %       Basic properties of experiment system, data i/o, stimulus and trials

	% Copyright 2014-2020 Richard J. Cui. Created: 05/30/2013  7:33:59.043 PM
	% $Revision: 0.7 $  $Date: Tue 04/21/2020  4:17:15.868 PM $
    %
    % 1026 Rocky Creek Dr NE
    % Rochester, MN 55906, USA
    %
    % Email: richard.cui@utoronto.ca
    
    % =================================================================
    % Properties, new experiments should change their values
    % =================================================================
    properties (Access = public)
        % Prefix for the name of the sessions from this experiment
        prefix
        
        % Name of the experiment (can contain spaces)
        name
        
        % which files can be imported for this type of experiment
        filetypes
 
    end % properties
    
    % =================================================================
    % Other properties, new experiments should not change their values
    % =================================================================
    properties (Access = public)
        % Indicates if the session is an aggregated session or not
        is_Avg = 0;
        % condition filter names
        filters = {};
        % CorruiDB object
        db = [];
        
        % related classes
        analysisClass = [];
        aggregateClass = [];
        plotClass = [];
        
    end % properties
 
    properties

    end % properties
    
    % =================================================================
    % Contructor and important functions
    % =================================================================
    methods (Sealed = true)
        function this = Experiment()
            % Prefix for the name of the sessions from this experiment
            this.prefix = 'EXP';
            
            % Name of the experiment (can contain spaces)
            this.name = 'General Experiment';
            
            % which files can be imported for this type of experiment
            this.filetypes = { };
            
            % -----------------
            % others
            % -----------------
            this.filters = this.filter_conditions( 'get_condition_names' );
            
            % setup db 
            curr_db_dir = getpref('corrui', 'dbDirectory', pwd);
            this.db = CorruiDB(curr_db_dir);
            
            % setup other classes
            if exist( [class(this) 'Analysis'], 'class')
                this.analysisClass = eval([class(this) 'Analysis']);
            else
                this.analysisClass = EyeMovementAnalysis;
            end
            if exist( [class(this) 'Aggregate'], 'class')
                this.aggregateClass = eval([class(this) 'Aggregate']);
            else
                this.aggregateClass = EyeMovementAggregate;
            end
            if exist( [class(this) 'Plots'], 'class')
                this.plotClass = eval([class(this) 'Plots']);
            else
                this.plotClass = EyeMovementPlots;
            end
            
        end
    end % methods
    
    % =================================================================
    % Important functions
    % =================================================================
    methods (Sealed = true)
        opt = getProcessOptions( this )
        dat = preload_analysis_vars( this, sname, S, analysis_names )
        inf = registerSavedVars(this, sname, vars)
        sess_name = UserSessName2SessName(this, user_sn)
        user_sn = SessName2UserSessName(this, sess_name)
        
        % ====== aggregate =====
        new_session_name = aggregate( this , sessionlist, opt )
        opt = getAggregateGeneralOptions( this )
        opt = getAggregateOptions( this )
        opt = getAggregateExperimentOptions( this )
        aggregateLis = getAggregateList( this )
        
        % ====== plot ======
        plotList    = getPlotList( this )
        figures     = plot( this, sessions, opt )
        opt = getPlotOptions( this )
        opt = getPlotExperimentOptions( this )
                
    end % methods
    
    
    % =================================================================
    % methods that new experiments can overwrite
    % =================================================================    
    methods (Static)
        S = getStaticMethodNames( clsName )

    end
    
    methods
        % ====== others =======
        out = filter_conditions( this, conditions, filter, enum, sname)
        handles_out = updateCurrExpMenus(this, handles)     % update menu for current experiment
        exp_menu_obj = setCurrExpMenus(this, hfig)    % setup current menus
        
        % ====== process ======
        opt = getProcessStage0Options( this )
        opt = getProcessStage1Options( this )
        opt = getProcessStage2Options( this )
        analysisList = getProcessAnalysisList( this )
        newsessions = batch_operation( this, operation, varargin )

        [imprted_data, stage0_data] = stage0process(this, sname, options)
        stage1_data = stage1process(this, sess_name, options)
        newsessions = process( this, sessions, S)
        
        % ===== plot =====
        opt = getPlotGeneralOptions( this )
        
    end
    
end % classdef

% [EOF]
