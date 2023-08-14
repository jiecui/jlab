function newsessions = process( this, sessions, S)
% EXPERIMENT.PROCESS process for class Experiment
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013-2020 Richard J. Cui. Created: Sun 11/03/2013  1:58:06.373 PM
% $Revision: 0.8 $  $Date: Wed 04/08/2020 11:59:31.826 AM $
%
% Multimodel Neuroimaging Lab (Dr. Dora Hermes)
% Mayo Clinic St. Mary Campus
% Rochester, MN 55905, USA
%
% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)

% check database
if isempty(this.db)
    this.db = CorruiDB(getpref('corrui', 'db_name' , pwd));
end % if

% get options
newsessions = S.newsessions;
opt = S.Options;
do_waitbar = opt.do_waitbar;

% if the name of the session was changed in the dialog a new session is
% created copying the original
for i = 1:length(sessions)
    if ( ~isequal( sessions{i}, newsessions{i} ) )
        CorruiDB.Copysess( sessions{i}, newsessions{i});
    end
end

% optional parallel processing
p = gcp('nocreate');
if isempty(p)
    poolsize = 0;
else
    poolsize = p.NumWorkers;
end % if
if isfield(opt, 'Parallel_Process') && ~opt.Parallel_Process
    if do_waitbar
        hwait = waitbar(0,'Please wait while sessions are processed...');
    end
    
    for snum = 1:length(sessions)
        process_single( this, newsessions{snum} , opt );
        if do_waitbar
            waitbar( snum/length(sessions), hwait );
        end
    end
    if do_waitbar
        close(hwait);
    end
else
    try
        % open a new matlab pool
        if  opt.Parallel_Process_Options.Number_of_Workers ~= poolsize || poolsize > length(sessions)
            % if there is a matlabpool already open, close it
            if poolsize > 0
                delete(p)
            end
            if min(opt.Parallel_Process_Options.Number_of_Workers, length(sessions)) > 1
                parpool(min(opt.Parallel_Process_Options.Number_of_Workers, length(sessions)));
            end
        end
        
        % process the sessions
        parfor snum = 1:length(sessions)
            process_single( this, newsessions{snum} , opt );
        end
        
    catch ex
        % disp( 'PARALELL PROCESS ERROR ' );
        cprintf('Errors', 'PARALELL PROCESS ERROR\n')
        ex.getReport
    end
    
    % close the pool
    if gcp('nocreate') > 0
        delete(gcp('nocreate'))
    end
end

end % function process

% =========================================================================
% subroutines
% =========================================================================
function process_single( this, sname, S)
% one single operaiton of process

% check info structure
% ---------------------
% check info makeup
info = this.db.Getsessvar(sname, 'info');
if isfield(info, 'import')
    if ~isfield(info.import, 'variables') == true
        info.import.variables = {};
        this.db.updateStruct(sname, 'info', info)
    end % if
end % if

try
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- Stage 0: Pre-processing ---------------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % prepare data for events detection in the next stage
    if  S.Do_Stage_0
        cprintf('Blue', ['++ ' this.name ' ++ ' this.SessName2UserSessName(sname)...
            ' ++ Stage 0 >> Pre-processing...\n']);
        
        % -- process stage 0 --
        [imported_data, stage0_data] = this.stage0process( sname, S );
                
        % list of new variables created
        variables = setdiff( fieldnames( stage0_data ), imported_data.info.import.variables );
        
        % save info and enum
        stage0_data.info.process_stage_0.date = datestr(now);
        stage0_data.info.process_stage_0.variables = variables;
        this.db.updateStruct( sname, 'info', stage0_data.info );
        stage0_data = rmfield( stage0_data, 'info');
        
        if ( isfield( stage0_data, 'enum' ) )
            this.db.updateStruct( sname, 'enum', stage0_data.enum );
            stage0_data = rmfield( stage0_data, 'enum');
        end
        
        % save the process events data
        this.db.unlock( sname, variables );
        this.db.add( sname, stage0_data );
        this.db.lock( sname, variables );
        
        clear imported_data process_trial_data;
        cprintf('Blue', ['++ ' this.name ' ++ ' this.SessName2UserSessName(sname)...
            ' ++ Stage 0 >> Done!\n']);

    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- Stage 1: Event detection ---------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if S.Do_Stage_1
        tic
        cprintf('Blue', ['++ ' this.name ' ++ ' sname ' ++ Stage 1 >> Detecting events...\n']);
        
        stage1_data = this.stage1process( sname, S );
        
        % make sure info is loaded
        if ~isfield(stage1_data, 'info')
            info = this.db.Getsessvar(sname, 'info');
            stage1_data.info = info;
        end % if
        % list of new variables created
        if isfield(stage1_data.info, 'saved_variables')
            saved_vars = stage1_data.info.saved_variables;
        else
            saved_vars = {};
        end % if
        stage1_variables = fieldnames(stage1_data);
        stage1_variables = union(stage1_variables, saved_vars);
        variables = setdiff( stage1_variables, stage1_data.info.import.variables );
        variables = setdiff( variables, stage1_data.info.process_stage_0.variables );
        
        % save the stage 1  data
        stage1_data.info.process_stage_1.date = datestr(now);
        stage1_data.info.process_stage_1.variables  = variables;
        this.db.updateStruct( sname, 'info', stage1_data.info );
        if isfield(stage1_data, 'enum')
            this.db.updateStruct( sname, 'enum', stage1_data.enum );
        end % if
        
        % this.db.unlock( sname, variables );
        this.db.unlock(sname, stage1_variables);
        this.db.add( sname, stage1_data );
        this.db.lock( sname, variables );
        
        cprintf('Blue', ['++ ' this.name ' ++ ' this.SessName2UserSessName(sname)...
            ' ++ Stage 1 >> Done!\n']);
        stage1_time = toc;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- Stage 2: Event analysis ----------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if S.Do_Stage_2
        tic;
        cprintf('Blue', ['++ ' this.name ' ++ ' this.SessName2UserSessName(sname)...
            ' ++ Stage 2 >> Analyzing events...\n']);
        
        % preload the variables that will be necessary for all
        % the analysis checked
        
        analysis_name = this.getProcessAnalysisList();
        for  i =  1:length(analysis_name)
            % preload the variables that will be necessary for all
            % the analysis checked
            % and for continuous analysis
                        
            % find the analysis function and call it
            % if( S.Stage_2_Options.( analysis_name{i} ) )
            if isfield(S.Stage_2_Options, ( analysis_name{i} ) ) && S.Stage_2_Options.( analysis_name{i} ) 
                try
                    cprintf([0 .5 0], [' -- Running ' analysis_name{i} ' for ' this.SessName2UserSessName(sname) ' ...\n'])
                    
                    % -- Run the analysis
                    dat = this.preload_analysis_vars( sname, S, analysis_name(i));
                    result_dat = this.analysisClass.(analysis_name{i})( this, sname, S, dat );
                    
                    % the analysis function can add new fields to enum
                    if isfield(result_dat,'enum')
                        this.db.updateStruct( sname, 'enum', result_dat.enum)
                        result_dat = rmfield(result_dat,'enum');
                    end
                                        
                    % update date info
                    if isfield(result_dat, 'info')
                       result_dat.info.process_stage_2.date = datestr(now); 
                    else
                        infodat = CorruiDB.Getsessvars(sname, {'info'});
                        if isfield(infodat, 'info')
                            info = infodat.info;
                            info.process_stage_2.date = datestr(now);
                            result_dat.info = info;
                        end % if
                    end
                    
                    % save results
                    if ( ~isempty( result_dat ) )
                        this.db.unlock(sname, {'info'});
                        this.db.add(sname, result_dat);
                        this.db.lock(sname, {'info'})
                    end
                    
                    t=toc;
                    cprintf([0 .5 0], [' -- Done with ' analysis_name{i}...
                        ' for ' this.SessName2UserSessName(sname)...
                        '.' ' Time: ' num2str(t/60) ' minutes\n']);
                    
                catch ex
                    fprintf('\n\nCORRUI ERROR PROCESSING :: experiment -> %s, analysis -> %s\n\n', class(this) , analysis_name{i} );
                    ex.getReport
                end
            end
        end
        
        cprintf('Blue', ['++ ' this.name ' ++ ' this.SessName2UserSessName(sname)...
            ' ++ Stage 2 >> Done!\n']);
        stage2_time = toc;
        
    end
    
    cprintf('Magenta', ['Done with Session: ' this.SessName2UserSessName(sname) '\n']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- Save Info ------------------------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isfield(S, 'batch_process') || ~S.batch_process
        info = this.db.getsessvar( sname, 'info' );
        
        processinfo.options = S ;
        if ( exist('stage1_time','var') )
            processinfo.stage1_time = stage1_time;
        end
        if ( exist('stage2_time','var') )
            processinfo.stage2_time = stage2_time;
        end
        processinfo.date = datestr(now, 'mm/dd/yyyy HH:MM:SS');
        
        if ( isfield(info,'process') )
            if length(info.process) == 1 && ~iscell(info.process)
                info.process = {info.process};
            end
            info.process{end+1} = processinfo; %can we just store the last process (doing a batch 400 times makes this kind of big and time consuming)
            if length(info.process) >= 40;
                info.process = {processinfo};
            end
        else
            info.process = {processinfo};
        end
        this.db.updateStruct(sname, 'info', info );
    end
    
    
catch ex
    fprintf('\n\nCORRUI ERROR PROCESSING :: experiment -> %s, session-> %s\n\n', ...
        class(this), sname);
    ex.getReport()
end

end % function process

% =========================================================================
% subroutines
% =========================================================================

% [EOF]
