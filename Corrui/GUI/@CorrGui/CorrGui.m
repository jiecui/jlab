classdef CorrGui
    % CORRGUI Class of GUI process
    %   Data and functions for GUI
    
    % Copyright 2013-2020 Richard J. Cui. Created: 04/28/2013  5:40:44.231 PM
    % $Revision: 1.3 $  $Date: Wed 05/06/2020 12:49:02.367 PM $
    %
    % Multimodal Neuroimaging Lab (Dr. Dora Hermes)
    % Mayo Clinic St. Mary Campus
    % Rochester, MN 55905, USA
    %
    % Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)
    
    methods (Static)
                
        % ===== IMPORT methods =====
        function newsession = Import( curr_tag )
            % newsessions = Import( current_tag, batch )
            %
            % imports one new single session (batch import by using
            % CorrGui.batch_operation
            %
            % Imput:
            %   curr_exp: current experiment object [batch]: struct
            %   containing the configuration for the batch import, folder,
            %   files and sessions ...
            %       batch.FileType batch.Sessions{i}.FileName
            %       batch.Sessions{i}.NewSessionName
            %       batch.Sessions{i}.Options (c.f. 'values' in
            %       import_rf.m)
            % Output
            %   newsessions: name of new sessions created
            
            curr_exp = CorrGui.CheckTag( curr_tag ); % in case curr_exp is a tag
            
            % GUI option input for single import
            % ----------------------------------
            % select the file type to be imported
            if ( length( curr_exp.filetypes ) > 1 )
                filetype = optionsdlg( ...
                    'What kind of data source do you want to use?', ...
                    'Select ', ...
                    curr_exp.filetypes, curr_exp.filetypes{1} , [] );
                if  iscell(filetype)
                    filetype = filetype{1};     % convert to string
                end
                if isempty(filetype)
                    newsession = [];
                    return
                end
            else
                filetype = curr_exp.filetypes{1};
            end
            
            % select the pathname and filename
            prefix = curr_exp.prefix;
            S = struct([]);
            [filenames, pathname, sessnames] = curr_exp.import_files_dialog( prefix, curr_tag, filetype, S );
            if ( isempty( filenames ) )
                newsession = [];
                return
            end
            % if length(sessnames) == 1
            %     newsession = sessnames{1};
            % end % if
            
            num_sess = length(sessnames);
            % get session info of experiments to be imported
            datablock = {};
            for k = 1:num_sess
                newsess_k = sessnames{k};   % should be string
                dbfname_k = filenames(k);   % should be cell
                switch filetype     % backward compatibility
                    case 'RF'
                        maxNumChunks = 5000;
                        Excluded_chunk_range = [];
                        switch curr_tag  % tag of different experiments
                            % ----- Microsaccade Contrast Blankctrl Experiments ------ %
                            case 'BlankCtrl'
                                Chunk_range = cell_blankctrl_exp_info( dbfname_k , maxNumChunks );
                                % get options
                                % range of chunks
                                opt.Chunk_range = {Chunk_range '' [1 maxNumChunks]};
                                opt.Excluded_chunk_range = {Excluded_chunk_range '' []};
                                opt.Which_reading_method = {'{Jie}|Other'};
                                values = StructDlg(opt,'Options for reading MSC RF file...');
                                
                                % ----- Orientation Tuning Experiments ----- %
                            case 'Tune'
                                Chunk_range = cell_tune_exp_info( dbfname_k , maxNumChunks );
                                % get options
                                % range of chunks
                                opt.Chunk_range = {Chunk_range '' [1 maxNumChunks]};
                                opt.Excluded_chunk_range = {Excluded_chunk_range '' []};
                                opt.Which_reading_method = {'{Jie}|Other'};
                                values = StructDlg(opt,'Options for reading MSC RF file...');
                                
                                % ----- Grating Experiments ----- %
                            case 'Grating'
                                Chunk_range = cell_grating_exp_info( dbfname_k , maxNumChunks );
                                % get options
                                % range of chunks
                                opt.Chunk_range = {Chunk_range '' [1 maxNumChunks]};
                                opt.Excluded_chunk_range = {Excluded_chunk_range '' []};
                                opt.Which_reading_method = {'{Jie}|Other'};
                                values = StructDlg(opt,'Options for reading MSC RF file...');
                                
                                % ----- Psychophysical Experiments ----- %
                            case 'Heliscene'
                                opt.tag = curr_tag;
                                opt_dlg_str = 'Options for reading HLS AVI file...';
                                values = StructDlg(opt, opt_dlg_str);
                                
                                % -- get other options for reading RF files
                            otherwise
                                values = curr_exp.getSessionInfo( dbfname_k, maxNumChunks, filetype );
                                
                        end % switch
                    otherwise
                        values = curr_exp.getSessionInfo( dbfname_k, filetype );
                end % swith\filetype
                
                % now construct the options
                datablock           = cat(1, datablock, dbfname_k);
                S(k).FileType       = filetype;
                S(k).PathName       = pathname;
                S(k).SessionName    = newsess_k;     % the session name where the imported data will be added
                S(k).Values         = values;
            end % for
            
            % import single data block one by one
            newsession = {};
            for k = 1:num_sess
                dbfname_k = datablock(k);
                S_k = S(k);
                values_k = S_k.Values;
                if ~isempty(values_k)
                    newsess_k = curr_exp.import(dbfname_k, S_k);
                    newsession = cat(1, newsession, newsess_k);
                end % if
            end % for
        end
        
        % ===== PROCESS methods =====
        function newsessions = Process( curr_exp, sessions, newsessions, opt, do_waitbar)
            % newsessions = Process( curr_exp, sessions, newsessions, opt )
            %
            % process sessions
            %
            % Imput:
            %   curr_exp: current experiment object
            %   sessions: names of the sessions to process
            %   newsessions: new names to give to the processed sessions
            %   opt: options from the dialog
            % Output
            %   newsessions: name of new sessions created or processed
            
            if ~exist('do_waitbar', 'var')
                do_waitbar = 1;
            end % if
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            S.newsessions = newsessions;
            S.Options = opt;
            S.Options.do_waitbar = do_waitbar;
            
            newsessions = curr_exp.process( sessions, S);
            
        end
        
        function opt = GetProcessOptions( curr_exp )
            % opt = GetProcessOptions( curr_exp )
            %
            % Gets the structure with the processing options for an
            % especific experiment.
            %
            % Imput:
            %   curr_exp: current experiment object or tag
            % Output
            %   opt: structure with all the options for StructDlg
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            opt = curr_exp.getProcessOptions( );
            exp_opt = curr_exp.getExpProcessOptions;
            opt = mergestructs(exp_opt, opt);
        end
        
        function defaults = GetProcessDefaults( curr_exp )
            % defaults = GetProcessDefaults( curr_exp )
            %
            % Gets the default structure with the processing options for an
            % especific experiment. It is very useful when running batch
            % analysis to build modify the defaults and pass it to
            % CorrGui.process(...)
            %
            % Imput:
            %   curr_exp: current experiment object or tag
            % Output
            %   defaults: structure with all the default options for
            %   process
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            opt = curr_exp.getProcessOptions( );
            defaults = StructDlg(opt,'',[],[],'off');
        end
        
        function [newsessions, opt] = ShowProcessDlg( curr_exp, sessions, lastoptions)
            % [newsessions, opt] = ShowProcessDlg( curr_exp, sessions, lastoptions)
            %
            % Shows the dialog with all the processing options
            %
            % Imput:
            %   curr_exp: current experiment object or tag
            %   sessions: list of sessions selected in the GUI
            %   lastoptions: last options entered by the user
            % Output
            %   newsessions: new session names entered by the user
            %   S: structure with all the options
            %
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            % Add the session names to the options so they can be changed
            num_sess = numel(sessions);
            user_sname = cell(num_sess, 1);
            dlg_sname = cell(num_sess, 1);
            for i = 1:num_sess
                sess_i = sessions{i};
                user_sname{i} = curr_exp.SessName2UserSessName(sess_i);
                % optSessNames.(sessions{i}) = sessions{i};
                % lastoptions.(sessions{i}) = sessions{i};
                dlg_sname{i} = sprintf('New_Name_of_%s', user_sname{i});
                optSessNames.(dlg_sname{i}) = user_sname{i};
                lastoptions.(dlg_sname{i}) = user_sname{i};
            end
            
            opt = CorrGui.GetProcessOptions( curr_exp );
            
            % select the most used analysis and leave the others in OTHER_ANALYSIS
            [stage2OptSelected, stage2OptOthers] = CorrGui.SelectFrequentAnalysis( curr_exp, opt.Stage_2_Options );
            opt.Stage_2_Options = stage2OptSelected;
            if ~isempty(stage2OptOthers)
                opt.Stage_2_Options.OTHER_ANALYSIS = stage2OptOthers;
            end
            opt = mergestructs(optSessNames, opt);
            
            %-- show DLG for parameter selection
            DlgWinName = sprintf('Process parameters of %s Exp', curr_exp.name);
            values = lastoptions;
            correct = 0;
            while( ~correct )
                values = StructDlg( opt, DlgWinName, values,  CorrGui.get_default_dlg_pos()  );
                if isempty(values)
                    newsessions = {};
                    return
                end
                % check session names, only letters and numbers allowed
                correct = 1;
                for snum = 1:num_sess
                    % newsname	= values.(sessions{snum});
                    new_user_sname = values.(dlg_sname{snum});
                    if ( ~CorrGui.IsValidSessionName( new_user_sname ) )
                        correct = 0;
                        values.(dlg_sname{snum}) = [user_sname{snum} 'ERROR'];
                    else
                        values.(dlg_sname{snum}) = curr_exp.UserSessName2SessName(user_sname{snum});
                    end
                end
            end
            opt = values;
            
            % deal with OTHER_ANALYSIS
            if ( isfield( opt.Stage_2_Options, 'OTHER_ANALYSIS' ) )
                opt.Stage_2_Options = mergestructs(opt.Stage_2_Options.OTHER_ANALYSIS, opt.Stage_2_Options);
                opt.Stage_2_Options = rmfield(opt.Stage_2_Options, 'OTHER_ANALYSIS');
            end
            CorrGui.UpdateFrequentAnalysis( class(curr_exp), opt.Stage_2_Options );
            
            % output the name of the new sessions
            newsessions = cell(size(sessions));
            for k = 1:num_sess
                % user_sname_k = curr_exp.SessName2UserSessName(sessions{k});
                newsessions{k} = opt.(dlg_sname{k});
            end            
        end
        
        function UpdateFrequentAnalysis( curr_exp,  opt )
            % UpdateFrequentAnalysis( curr_exp,  opt )
            %
            % updates the variable that counts how many times each analysis has been
            % run in order to show only the most common ones keeping the other ones in
            % OTHER_ANALYSIS
            %
            % Imput:
            %   current_tag: current experiment tag
            %   opt: list of analysis checked or not checked in
            %   the GUI
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            analysisList = curr_exp.getProcessAnalysisList();
            analysis_counts = getpref('corrui', ['analysis_counts_' class(curr_exp)] , []);
            
            % initialize fields that don't have a counter
            for i=1:length(analysisList)
                if ( ~isfield( analysis_counts, analysisList{i} ) )
                    analysis_counts.(analysisList{i}) = 0;
                end
            end
            
            % Update the counts
            for i=1:length(analysisList)
                if ( isfield(opt, analysisList{i} )&&  opt.(analysisList{i} ))
                    analysis_counts.(analysisList{i}) = analysis_counts.(analysisList{i}) +1;
                else
                    analysis_counts.(analysisList{i}) = max(analysis_counts.(analysisList{i}) - 0.5,0);
                end
            end
            setpref('corrui', ['analysis_counts_' class(curr_exp)] , analysis_counts);
        end
        
        [stage2Opt1, stage2Opt2] = SelectFrequentAnalysis(curr_exp, stage2Opt)
        
        % ===== AGGREGATE methods =====        
        function newsession = Aggregate( curr_exp , sessionlist, opt, do_waitbar )
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            if ( ~exist( 'do_waitbar','var') )
                do_waitbar = 1;
            end
            
            opt.Filters_To_Use   =  CorrGui.filter_conditions( 'get_filters_to_use_from_dlg', curr_exp, opt.Filters_To_Use );
            
            if do_waitbar
                hwait = waitbar(0, 'Please wait while sessions are aggregated...'); %nwait= 6;
            end
            % perform average, using list of variables defined previously
            newsession = curr_exp.aggregate( sessionlist, opt);
            if do_waitbar
                close(hwait)
            end
        end
        
        function opt = GetAggregateOptions( curr_exp )
            % opt = GetAggregateOptions( curr_exp )
            %
            % Gets the structure with the aggregating options for an
            % especific experiment.
            %
            % Imput:
            %   curr_exp: current experiment object or tag
            % Output
            %   opt: structure with all the options for StructDlg
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            opt = curr_exp.getAggregateOptions( );
        end
        
        function defaults = GetAggregateDefaults( curr_exp )
            % defaults = GetAggregateDefaults( curr_exp )
            %
            % Gets the default structure with the aggregating options for an
            % especific experiment. It is very useful when running batch
            % analysis to build modify the defaults and pass it to
            % CorrGui.aggregate(...)
            %
            % Imput:
            %   curr_exp: current experiment object or tag
            % Output
            %   defaults: structure with all the default options for StructDlg
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            opt = curr_exp.getAggregateOptions( );
            defaults = StructDlg(opt,'',[],[],'off');
        end
        
        function opt = ShowAggregateDlg( curr_exp )
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            opt = CorrGui.GetAggregateOptions( curr_exp );
            values = [];
            while(1)
                res = StructDlg(opt,'Choose New Session Name', values, CorrGui.get_default_dlg_pos() );
                if isempty(res) || isempty( res.Name_of_New_Aggregated_Session )
                    opt = res;  % rjc
                    return
                else
                    % check names, only letters and numbers allowed
                    if ( ~CorrGui.IsValidSessionName( res.Name_of_New_Aggregated_Session ) )
                        res.Name_of_New_Aggregated_Session = 'ERROR';
                        values = res;
                    else
                        opt = res;
                        break
                    end
                end
            end
        end
        
        [mn, se] = aggregate_structs( sessions, filters_to_use, curr_exp, structs_LRavg, fields_for_structs_LRavg, structs_avg, fields_for_structs_avg,...
            structs_LRadd, fields_for_structs_LRadd, structs_LRconcat, fields_for_structs_LRconcat, structs_concat, fields_for_structs_concat, new_session_name)
        
        [mn, se] = aggregate_structs_no_filter( sessions, curr_exp, structs_LRavg, fields_for_structs_LRavg, structs_avg, fields_for_structs_avg,...
            structs_LRadd, fields_for_structs_LRadd, structs_LRconcat, fields_for_structs_LRconcat, structs_concat, fields_for_structs_concat, new_session_name)
        
        % ===== PLOT methods =====
        function figures = Plot( curr_exp, sessions, opt )
            % Plot( curr_exp, sessions, opt )
            %
            % plots the figures indicated in the GUI dialog
            %
            % Imput:
            %   current_tag: current type of experiment selected.
            %   sessions: names of the selected sessions
            %   opt: structure with the plot options for StructDlg
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            for k = 1:length(sessions)
                session_k = sessions{k};
                figures = curr_exp.plot( session_k, opt );
            end % for
            
        end
        
        function opt = GetPlotOptions( curr_exp )
            % opt = GetPlotOptions( curr_exp )
            %
            % Gets the structure with the plotting options for an
            % especific experiment.
            %
            % Imput:
            %   curr_exp: current experiment object or tag
            % Output
            %   opt: structure with all the options for StructDlg
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            opt = curr_exp.getPlotOptions();
        end
        
        function defaults = GetPlotDefaults( curr_exp )
            % defaults = GetPlotDefaults( curr_exp )
            %
            % Gets the default structure with the plotting options for an
            % especific experiment. It is very useful when running batch
            % analysis to build modify the defaults and pass it to
            % CorrGui.aggregate(...)
            %
            % Imput:
            %   curr_exp: current experiment object or tag
            % Output
            %   defaults: structure with all the default options for
            %   StructDlg
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            opt = CorrGui.GetPlotOptions( curr_exp );
            defaults = StructDlg(opt,'',[],[],'off');
            
            if ( curr_exp.is_Avg )
                defaults.Which_Eyes_To_Use = 'Unique';
            end
        end
        
%         function [opt] = ShowPlotDlg( curr_exp )
%             
%             curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
%             
%             % get the plot options for the dialog
%             opt = CorrGui.GetPlotOptions( curr_exp );
%             
%             % select the most used plots and leave the others in other_plots
%             [opt1, opt2] = CorrGui.SelectFrequentPlots( curr_exp, opt);
%             opt = opt1;
%             if ~isempty( opt2 )
%                 opt.OTHER_PLOTS = opt2;
%             end
%             
%             % get the options used the last time
%             lastOptions = getpref('corrui', 'plot_options' , []);
%             lastOptions.Save_Plot = 0;
%             lastOptions.Saved_Plot_Name = '';
%             
%             
%             % show struct dialog to the user
%             opt = StructDlg( opt, 'Select Plots to Make', lastOptions, CorrGui.get_default_dlg_pos() );
%             if isempty(opt)
%                 return
%             end
%             
%             % save the options used now for the next time
%             setpref( 'corrui', 'plot_options', opt );
%             
%             % add the OTHER PLOTS to the normal plots structure
%             if ( isfield( opt, 'OTHER_PLOTS' ) )
%                 opt = mergestructs(opt, opt.OTHER_PLOTS);
%                 opt = rmfield(opt, 'OTHER_PLOTS');
%             end
%             
%             % update the counts of most used plots
%             CorrGui.UpdateFrequentPlots( curr_exp, opt );
%             
%             if ( ~isfield(opt,'Which_Eyes_To_Use'))
%                 opt.Which_Eyes_To_Use = 'Unique';
%             end
%         end
        
        function [opt1, opt2] = SelectFrequentPlots(curr_exp, opt)
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            % get the counts
            plot_counts = getpref('corrui', ['plot_counts_' class(curr_exp)] , []);
            
            plotList = curr_exp.getPlotList();
            
            % initialize
            for i=1:length(plotList)
                if ( ~isfield(plot_counts, plotList{i} ) )
                    plot_counts.(plotList{i}) = 0;
                end
            end
            
            
            % get the plot_counts into an array
            fields = fieldnames(plot_counts);
            counts = zeros(1,length(fields));
            for i=1:length(fields)
                counts(i) = plot_counts.(fields{i});
            end
            
            % select a threshold
            counts = -sort(-counts(counts>0));
            if ( ~isempty(counts) )
                if ( length(counts) > 10 )
                    th = counts(5);
                else
                    th = min(counts);
                end
            else
                th = 0;
            end
            
            % for each plot
            plots = fieldnames(opt);
            i=0;
            while( i < length(plots) )
                i=i+1;
                if ( isempty(intersect(plotList, plots{i})) || plot_counts.(plots{i}) >= th )
                    opt1.(plots{i}) = opt.(plots{i});
                    if ( i<length(plots) &&  strcmp(plots{i+1}, [plots{i} '_options'] )  )
                        opt1.(plots{i+1}) = opt.(plots{i+1});
                        i=i+1;
                    end
                else
                    opt2.(plots{i}) = opt.(plots{i});
                    if ( i<length(plots) &&  strcmp(plots{i+1}, [plots{i} '_options'] )  )
                        opt2.(plots{i+1}) = opt.(plots{i+1});
                        i=i+1;
                    end
                end
                
            end
            
            if ~exist('opt2', 'var')
                opt2 = [];
            end
            
            
        end
        
        function UpdateFrequentPlots( curr_exp, opt )
            
            curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag
            
            % get the counts
            plot_counts = getpref('corrui', ['plot_counts_' class(curr_exp)] , []);
            
            plotList = curr_exp.getPlotList();
            
            % initialize
            for i=1:length(plotList)
                if ( ~isfield(plot_counts, plotList{i} ) )
                    plot_counts.(plotList{i}) = 0;
                end
            end
            
            % for each plot
            plots = fieldnames(plot_counts);
            for i=1:length(plots)
                if ~isfield(opt,plots{i})
                    continue
                end
                if ( opt.(plots{i}) )
                    plot_counts.(plots{i}) = plot_counts.(plots{i}) +1;
                else
                    plot_counts.(plots{i}) = max(plot_counts.(plots{i}) - 0.2,0);
                end
            end
            
            % save to disk
            setpref('corrui', ['plot_counts_' class(curr_exp)] , plot_counts);
        end
        
        function SavePlot( opt )
            
            saved_plots = getpref('corrui', 'saved_plots' , []);
            saved_plots.(opt.Saved_Plot_Name) = opt;
            
            setpref('corrui',  'saved_plots'  , saved_plots);
        end
        
        plot_raw( handles, action)
        opt = ShowPlotDlg( curr_exp )        
        
        % ===== OTHER =====       
        function experiment = ExperimentConstructor( experiment_tag, dbpath )
            % experiment = ExperimentConstructor( experiment_tag )
            %
            % Constructs an experiment object fromt the tag.
            %
            % Imput:
            %   experiment_tag: tag of the experiment.
            % Output
            %   experiment: new experiment object
            % Example:
            %   curr_exp = CorrGui.ExperimentConstructor( experiment_tag );
            
            if (~contains(experiment_tag,'_Avg'))
                experiment = eval(experiment_tag);
            else
                experiment = eval(strrep(experiment_tag,'_Avg',''));
                experiment.is_Avg = 1;
            end
            
            % if  (~exist('dbpath', 'var') )
            %     experiment.db = CorruiDB(getpref('corrui', 'db_name' , pwd));
            % else
            %     experiment.db = CorruiDB(dbpath);
            % end
            
            if exist('dbpath', 'var')
                experiment.db = CorruiDB(dbpath);
            end % if
        end
        
        function curr_exp = CheckTag( curr_exp )
            
            if ( ischar( curr_exp ) )
                % if the input is a tag and not an object we create the
                % object
                current_tag = curr_exp;
                curr_exp = CorrGui.ExperimentConstructor(current_tag);
            end
        end
        
        out = filter_conditions( varargin )
        
        function newsessions = batch_operation( curr_tag )
            % batch_operation( curr_tag, curr_exp )
            %
            % process sessions and aggregated them in a batch
            %
            % Imput:
            %   curr_tag    : tag of current experiment
            %   curr_exp    : object of current experiment
            %
            % Output:
            %   none
            
            % modified by RJC on Tue 04/23/2013 10:36:47.045 AM
            
            % ******************************
            % obtain analysis structures GUI
            % ******************************
            newsessions = [];
            curr_exp = CorrGui.CheckTag(curr_tag);
            
            % first, get the file
            old_path = pwd;
            pathname = getpref('corrui', 'batch_analysis_directory' , old_path);
            % if not exist, use current directory
            if(~exist(pathname,'dir'))
                pathname = old_path;
            end % if
            cd(pathname);
            % request the file
            S.tag_choise = {'{Current Exp}|Specified in Batch', 'Tag choise'};
            S.batch_func = { {'uigetfile(''*.m'', ''Chose the file to import'')'} , 'Batch function'};
            % S.batch_func = {{sprintf('uigetfile(''%s'',''%s'')','*.m','Choose the file to import')},'Batch function'};
            P = StructDlg(S, 'Select batch function');
            % [filename, pathname] = uigetfile('*.m', 'Chose the file to import');
            if isempty(P)
                return;
            else
                [pathname, funcname] = fileparts(P.batch_func);
                if isempty(pathname)
                    return
                end
            end % if
            % save cortex path in prefs
            setpref('corrui',  'batch_analysis_directory', pathname);
            
            % scond, get 'operation' var
            cd(pathname);
            batchfunc = str2func(funcname);
            operation = batchfunc();
            cd(old_path);
            
            % *****************
            % do the operations
            % *****************
            if ( exist( 'operation','var' ) )
                newsessions = curr_exp.batch_operation( operation, P.tag_choise );
            end
        end
        
        function config = config( command, config )
            
            if ( nargin == 0 )
                load('config.mat', 'config')
                return
            end
            
            switch(command)
                case 'save'
                    save 'config.mat' config
                case 'get_default'
                    config.plots.use_box = 0;
            end
        end
        
        function valid = IsValidSessionName( name )
            valid = ~isempty(regexp(name,'^[a-zA-Z0-9]+$','ONCE') );
        end
        
        function struct_lists = get_session_lists( tags )
            % gets the lists of sessions from the database for each
            % experiment type
            
            % get all the sessions and their tags
            % all_sessions	= sessdb( 'listsess' );
            tagged_sessions = sessdb( 'getvar', 'internalTag' );
            
            % reset the lists of sessions
            for i=1:length(tags)
                tag     = char(tags{i});
                struct_lists.([tag '_List']) = {};
            end
            
            %fill the list of sessions
            if ~isempty( tagged_sessions )
                snames = fieldnames( tagged_sessions );
                for sname = snames'
                    tag		= char( tagged_sessions.(char(sname)) );
                    % add the session to the corresponding list
                    if ( isfield( struct_lists, [tag '_List'] ) )
                        struct_lists.([tag '_List']){end+1} = char(sname);
                    end
                end
                
                % get rid of dups
                for i=1:length(tags)
                    tag     = char(tags{i});
                    struct_lists.([tag '_List']) = unique(struct_lists.([tag '_List']));
                end
                
                % tagged_sessions = fieldnames(tagged_sessions)';
            % else
                % tagged_sessions = {};
                % struct_lists = {};
            end
            % struct_lists.Uncategorized_List = setdiff( all_sessions, tagged_sessions' );
        end
        
        function [variable_descriptions, variable_aggregate] = get_variable_descriptions(variables_db)
            variable_descriptions = [];
            for i=1:size(variables_db.descriptions,1)
                variable_descriptions.(variables_db.data{i,1}) = variables_db.descriptions{i};
                variable_aggregate.(variables_db.data{i,1}) = variables_db.data{i,4};
            end
        end
        
        function mainvars = get_main_variables( variables_db )
            mainvars = {};
            for i=1:size(variables_db.data,1)
                if ( variables_db.data{i,2} )
                    % mainvars{end+1} = variables_db.data{i,1};
                    mainvars = cat(2, mainvars, variables_db.data{i,1});
                end
            end
        end
                                
        % [alldrift_props, alltotaltimes, alllegends] = get_drift_properties(current_tag, snames, S , filters_to_use );
        
        function default_dlg_pos = get_default_dlg_pos()
            screen_size  = get_screen_size('char');
            default_dlg_pos		= [10 screen_size(4)-15 120 10];
        end
        
        function default_plot_pos = get_default_plot_pos()
            default_plot_pos	= [100 100 400 300];
        end
        
        function [n] = get_subplot_dims(num_plots)
            nplot1 = [1 2 1 2 3 3 2 2 3 2 4 4 4 4 4 5 5 5 5 5 5 5 5 5];
            nplot2 = [1 1 3 2 2 2 4 4 3 5 3 3 4 4 4 4 4 4 4 5 5 5 5 5];
            
            n = [nplot1(num_plots);nplot2(num_plots)];
        end
        
        function ax = create_subj_filter_figures(varargin)
            % ax = create_subj_filter_figures(sessions)
            % ax = create_subj_filter_figures(S)
            % ax = create_subj_filter_figures(sessions,S)
            % ax = create_subj_filter_figures(sessions,S,factor)
            % Will initialize figures/axes based on the input.
            % Figures will be created according to sessions\filters, and
            % axes for that figure created according to the other (filters\sessions).
            % Will group according to the option S.Plot_Grouping,
            % subjects will be grouped in one figure if subj occurs before
            % trial in S.Plot_Grouping and vice versa for filters (S.Trial_Categories).
            % S must contain Plot_Grouping (decides order) and Trial_Categories (decides which filters).
            % If only one input, will create figure/axes for that input only.
            
            if nargin == 1
                if isstruct(varargin{1})  %if passing the filters
                    S = varargin;
                    sessions = {''};
                elseif iscell(varargin{1}) %if passing just the subjects
                    sessions = varargin{1};
                    S.Trial_Categories.All=1;
                    S.Plot_Grouping = 'subj-trial-data';
                elseif isnumeric(varargin{1}) %if passing just the number of plots desired
                    sessions = cell(1:varargin{1});
                    for i = 1:length(sessions)
                        sessions{i} = '';
                    end
                    S.Trial_Categories.All=1;
                    S.Plot_Grouping = 'subj-trial-data';
                end
            elseif nargin == 2
                S = varargin{2};
                sessions = varargin{1};
            end
            
            % Note: ax will always be in the form of ax(isubj,nfilter)
            % where nfilter is the ordinal of the checked filters only
            filters = fieldnames(S.Trial_Categories);
            
            % count how many filters are checked
            nfiltersON = 0;
            for ifilter=1:length(filters)
                filter = filters{ifilter};
                if ( S.Trial_Categories.(filter) )
                    nfiltersON = nfiltersON +1;
                end
            end
            
            % build the necessary figures and axes
            ax = [];
            if strfind(S.Plot_Grouping,'subj') < strfind(S.Plot_Grouping,'trial')%one figure of all filters for each subject
                %get subplot dimensions
                [m] = CorrGui.get_subplot_dims(nfiltersON);
                for isubj=1:length(sessions)
                    
                    sname = sessions{isubj};
                    pos = CorrGui.get_default_plot_pos();
                    pos(3) = pos(3)*m(2);
                    pos(4) = pos(4)*m(1);
                    figure('Position',pos,'name',sname, 'color','white')
                    nfilter=0;
                    % for each filter one axes
                    for ifilter=1:length(filters)
                        filter = filters{ifilter};
                        if ( S.Trial_Categories.(filter) )
                            nfilter=nfilter+1;
                            ax(isubj,nfilter) = subplot(m(1),m(2),nfilter);
                        end
                    end
                end
            else %one figure of all subjects for each filter
                [m] = CorrGui.get_subplot_dims(length(sessions));
                nfilter = 0;
                for ifilter = 1:length(filters)
                    filter = filters{ifilter};
                    if ( S.Trial_Categories.(filter) )
                        nfilter = nfilter+1;
                        pos = CorrGui.get_default_plot_pos();
                        pos(3) = pos(3)*m(2);
                        pos(4) = pos(4)*m(1);
                        figure('Position',pos,'name','', 'color','white')
                        
                        for isubj=1:length(sessions)
                            ax(isubj,nfilter) = subplot(m(1),m(2),isubj);
                        end
                    end
                end
            end
        end
        
        function neworder = get_plot_grouping( plotgrouping )
            subj = 1;
            trial = 2;
            data = 3;
            
            switch( plotgrouping )
                case 'subj-trial-data'
                    neworder = [subj trial  data];
                case 'trial-subj-data'
                    neworder = [trial subj data];
                case 'data-trial-subj'
                    neworder = [data trial subj];
                case 'data-subj-trial'
                    neworder = [data subj trial];
                case 'trial-data-subj'
                    neworder = [trial data subj ];
                otherwise
                    neworder = [subj trial  data];
            end
        end
        
        sess_str = setSessListString( handles )     % set string for the display in session list box
        sess_list = getSessListString( handles )    % get true strings of sessions from the display
        [current_tag, curr_exp] = get_current_tag( handles ) 
    end
end

