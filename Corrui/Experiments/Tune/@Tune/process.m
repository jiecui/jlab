function newsessions = process( this, sessions, S)
% TUNE.PROCESS process for Class Tune
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

% Copyright 2013-2014 Richard J. Cui. Created: Sun 05/26/2013 10:50:29.440 AM
% $Revision: 0.3 $  $Date: Sat 04/19/2014  3:12:37.888 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

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
        if  opt.Parallel_Process_Options.Number_of_Processors ~= matlabpool('size') || matlabpool('size') > length(sessions)
            % if there is a matlabpool already open close it
            if matlabpool('size')
                matlabpool close
            end
            if min(opt.Parallel_Process_Options.Number_of_Processors, length(sessions)) > 1
                matlabpool(min(opt.Parallel_Process_Options.Number_of_Processors, length(sessions)))
            end
        end
        
        % process the sessions
        parfor snum = 1:length(sessions)
            process_single( this, newsessions{snum} , opt );
        end
        
    catch ex
        disp( 'PARALELL PROCESS ERROR ' );
        ex.getReport
    end
    
    % close the pool
    % if ~opt.batch_process && matlabpool('size')
    if matlabpool('size')
        matlabpool close
    end
end

end % function process

% =========================================================================
% subroutines
% =========================================================================
function process_single( this, sname, S )
% one single operaiton of process

try
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- Stage 0: Pre-processing ---------------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % prepare data for events detection in the next stage
    if  S.Do_Stage_0
        disp(['++ ' this.name ' ++ ' sname ' ++ Stage 0 >> Pre-processing...']);
        
        fprintf('---- %s has no Stage 0 process for session %s ----\n', this.name, sname)
        
        % save info
        process_trial_data.info.process_stage_0.date = datestr(now);
        this.db.updateStruct( sname, 'info', process_trial_data.info );
        
        disp(['++ ' this.name ' ++ ' sname ' ++ Stage 0 >> Done!']);

    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- Stage 1: Event detection ---------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if S.Do_Stage_1
        disp(['++ ' this.name ' ++ ' sname ' ++ Stage 1 >> Detecting events...']);
        
        fprintf('---- %s has no Stage 1 process for session %s ----\n', this.name, sname)
        
        % save the stage 1 info
        stage1_data.info.process_stage_1.date = datestr(now);
        this.db.updateStruct( sname, 'info', stage1_data.info );
        
        disp(['++ ' this.name ' ++ ' sname ' ++ Stage 1 >> Done!']);
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- Stage 2: Event analysis ----------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if S.Do_Stage_2
        tic
        disp(['++ ' this.name ' ++ ' sname ' ++ Stage 2 >> Analyzing events...']);
        
        % preload the variables that will be necessary for all
        % the analysis checked
        
        analysis_name = this.getProcessAnalysisList();
        for  i =  1:length(analysis_name)
            % preload the variables that will be necessary for all
            % the analysis checked
            % and for continuous analysis
            
            % find the analysis function and call it
            if( isfield(S.Stage_2_Options, ( analysis_name{i} ) ) && S.Stage_2_Options.( analysis_name{i} ) )
                try
                    disp( [' -- Running ' analysis_name{i} ' for ' sname ' ...'])
                    
                    % -- Run the analysis
                    dat = this.preload_analysis_vars(sname, S, analysis_name(i));    % RJC, Wed 04/06/2011 11:12:50 AM
                    result_dat = this.analysisClass.(analysis_name{i})( this, sname, S, dat );
                    
                    % the analysis function can add new fields to enum
                    if isfield(result_dat,'enum')
                        this.db.updateStruct( sname, 'enum', result_dat.enum)
                        result_dat = rmfield(result_dat,'enum');
                    end
                    
                    % update date info
                    if isfield(result_dat, 'info')
                       result_dat.info.process_stage_2.date = date(now); 
                    else
                        infodat = CorruiDB.Getsessvars(sname, {'info'});
                        info = infodat.info;
                        info.process_stage_2.date = datestr(now);
                        result_dat.info = info;
                    end
                                        
                    % save results
                    if ( ~isempty( result_dat ) )
                        this.db.unlock(sname, fieldnames(result_dat));
                        this.db.add(sname, result_dat);
                    end
                    
                    t=toc;
                    disp( [' -- Done with ' analysis_name{i} ' for ' sname '.' ' Time: ' num2str(t/60) ' minutes']);
                    
                catch ex
                    fprintf('\n\nCORRUI ERROR PROCESSING :: experiment -> %s, analysis -> %s\n\n', class(this) , analysis_name{i} );
                    ex.getReport
                end
            end
        end
        
        disp(['++ ' this.name ' ++ ' sname ' ++ Stage 2 >> Done!']);
        stage2_time = toc;
        
    end
    
    disp(['Done with Session: ' sname]);
    
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
        processinfo.date = datestr(now);
        
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

% [EOF]
