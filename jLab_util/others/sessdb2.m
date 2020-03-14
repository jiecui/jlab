function varargout = sessdb2(db_name, cmd,varargin)
% function varargout = sessdb(cmd,varargin)
% commands are:
% 'new', session_name,
%        session_struct:  prompts for db location, then stores given
%                            struct
%
% 'open', no input args:     prompts for database directory to be used for
%                            subsequent sessdb commands
%
% 'close', no input args:    clears the internal file name variable
%
% 'add', session_name,
%        session_struct:	adds/updates session
%
% 'remove', session_name:	deletes session from open db
%
% 'copysess', source_session,
%			destine_session: copies one session in the
%							database with a different name
%
% 'copysessto', source_session,
%				folder:		copies one session to
%							a different folder
%
% 'movesessto', source_session,
%				folder:		copies one session to
%							a different folder anr removes it from the
%							original location
%
% 'listsess', no input args:  list sessions in open db
%
% 'listvar', session_names:  list all unique variables in open db (not all
%                            sessions need have all variables), optional
%                            session_names input cell array of strings
%                            limits output to variables of those sessions
%
% 'getsess', session_name,
%            exclude_vars: returns struct with variables of named
%                            session, optionally excluding variables in
%                            'exclude_vars' list
%
%
% 'getsessvar', session_name,
%              variable_name: return specific variable from specific session
%
% 'getsessnames', text:       returns list of session names with text
%                            matching input
%
% 'getvar', variable_name:   returns struct with variables from each of
%                            sessions that contain that variable
%
% 'getvarvert', session_list,
%              variable_name:   returns array with variables from input
%                               sessions that contain that variable,
%                               vertically concatenated (not implemented)
% 'remsessvars', session_name,
%              variable_name: deletes specific variable from specific
%              session
%
% 'GetVarNamesForSession', session_name
%                 return list of all variables for a given session
%
% 'isopen', no input args:   returns 1 if open, 0 if not
%
% '*_with_location', full_path (location to put struct), OTHER VARS FOR
% ORIGINAL COMMAND:  This command is the same as the other commands but
% with a specific location given in the second slot. * can be any of the original commands except
% 'open','close', 'isopen', and 'new'.
%
% First, open a database, with "sessdb('open')". Then you can list the
% available sessions, the variables, or get a struct with the data
% from a particular run, or the data from one of the variables for all the
% sessions.
% This database system is designed initially for the fading sessions
% performed late 2004 - early 2005 in the laboratories of Susana
% Martinez-Conde. Each variable is stored in a separate file, to make
% additions and deletions very fast. Additionally, there is no penalty
% for grouping the data by variable or by session.
%

% Last modified by Ricard J. Cui on Thu 01/15/2015  2:16:48.104 PM


try
    if (~strcmpi('new',cmd) & ~strcmpi('open',cmd) & ~strcmpi('isopen',cmd)) & isempty(db_name)
        error('Database must be opened or created first.');
    end
    switch cmd
        case 'new'
            if nargin >= 4
                pn =uigetdir(pwd, 'Choose location for new Session Database');
                if pn
                    db_name = pn;
                    % following stmt will clear a db...
                    %save(db_name,'db_name','-MAT');
                    sessname = varargin{1};
                    sess = varargin{2};
                    varnames = fieldnames(sess);
                    str = varargin{1};
                    for i=1:length(varnames)
                        fullname = [sessname '_' varnames{i} '.mat'];
                        dat =getfield(sess,varnames{i});
                        save(fullfile(db_name,fullname), 'dat', '-MAT');
                    end
                else
                    return
                end
            else
                error('NEW command requires a Session name and data structure as input arguments.');
                return
            end
       
        case 'add'
            % add/update an session, requires nargin >=4
            if nargin >= 4
                sessname = varargin{1};
                sess = varargin{2};
                if ( isempty(sess) )
                    return
                end
                varnames = fieldnames(sess);
                for i=1:length(varnames)
                    fullname = [sessname '_' varnames{i} '.mat'];
                    % dat = getfield(sess,varnames{i});
                    dat = sess.(varnames{i});
                    ver = version;
                    if ver(1) >= '7'
                        save(fullfile(db_name,fullname), 'dat', '-v7.3');
                    else
                        save(fullfile(db_name,fullname), 'dat');
                    end
                end
            else
                error('ADD command needs both the session name and session struct as input arguments');
            end
            
            %         case 'add_with_location'
            %              if nargin >= 4
            %                 full_path = varargin{1};
            %                 name = varargin{2};
            %                 dat_struct = varargin{3};
            %                 if ( isempty(dat_struct) )
            %                     return
            %                 end
            %                 varnames = fieldnames(dat_struct);
            %                 for i=1:length(varnames)
            %                     fullname = [ full_path '\' name '_' varnames{i} '.mat'];
            %                     dat = getfield(dat_struct,varnames{i});
            %                     ver = version;
            %                     if ver(1)=='7'
            %                         save(fullname, 'dat', '-V6');
            %                     else
            %                         save(fullname, 'dat');
            %                     end
            %                 end
            %             else
            %                 error('add_with_location command needs both the session name and session struct as input arguments');
            %             end
            
        case 'remove'
            % remove variables from db from given session name, which is
            % removing the variables of that session from each file in
            % the directory
            if nargin >= 3
                d = dir([db_name filesep varargin{1} '_*.mat']);
                for i=1:length(d)
                    filename=d(i).name;
                    delete(fullfile(db_name,filename));
                end
            else
                error('REMOVE command needs the session name as input argument');
            end
        case 'copysess'
            if nargin >= 4
                tic
                d = dir([db_name filesep varargin{1} '_*.mat']);
                for i=1:length(d)
                    filename=d(i).name;
                    varname = filename(findstr( filename, '_' ) + 1:findstr( filename, '.mat' ) - 1);
                    fullname = [varargin{2} '_' varname '.mat'];
                    dos ( ['copy ' db_name '\' filename ' ' db_name '\' fullname]);
                end
                toc
            else
                error('ERROR');
            end
        case 'copysessto'
            if nargin >= 4
                dos ( ['copy ' db_name '\' varargin{1} '_*.mat ' varargin{2}]);
            else
                error('ERROR');
            end
        case 'movesessto'
            if nargin >= 4
                dos ( ['copy ' db_name '\' varargin{1} '_*.mat ' varargin{2}]);
                dos ( ['del ' db_name '\' varargin{1} '_*.mat ']);
            else
                error('ERROR');
            end
        case 'listsess'
            % return list of sessions in the db
            d = dir(db_name);
            sesss = {};
            j = 1;
            for i=1:length(d)
                sess = d(i).name;
                sess = sess(1:findstr(sess,'_')-1);
                if ~isempty(sess) && ~any(strcmp(sesss,sess))
                    sesss{j} = sess;
                    j = j+1;
                end
            end
            sessnames = unique(sesss);
            varargout{1} = sessnames;
        case 'listvar'
            % return list of unique variable names in this db
            vars		= {};
            varSizes	= {};
            varClasses	= {};
            varDates	= {};
            fileNames	= {};
            sn = {};
            if nargin >=3
                sn = varargin{1};
            end
            d = [];
            if ~isempty(sn)
                if ( ~iscell(sn) )
                    sn = {sn};
                end
                for i=1:length(sn)
                    sess=sn{i};
                    d = [d;dir(fullfile(db_name,[char(sess) '_*.mat']))];
                end
            else
                d = dir(db_name);
            end
            j = 1;
            for i=1:length(d)
                var = d(i).name;
                var = var(findstr( var, '_' ) + 1:findstr( var, '.mat' ) - 1);
                if ~isempty(var)
                    vars{j} = var;
                    fileNames{j} = d(i).name;
                    j = j+1;
                end
            end
            [varargout{1}, iUnique, jUnique] = unique(vars);
            
            fileNames   = fileNames(iUnique);
            varSizes    = cell(1,length(fileNames));
            varClasses  = cell(1,length(fileNames));
            varDates    = cell(1,length(fileNames));
            %             if ( 1 )
            for iFile = 1:length(fileNames)
                varSizes{iFile} = '';
                varClasses{iFile} = '';
                varDates{iFile} = '';
            end
            %             too slow
            %                 % now do whos on the unique ones
            %                 for iFile = 1:length(fileNames)
            %                     sDescription = whos( '-file', fullfile(db_name,fileNames{iFile}), 'dat' );
            %                     if ( ~isempty( sDescription ) )
            %                         varSizes{iFile} = ['[' num2str(sDescription.size(1))];
            %                         for iDim = 1:length( sDescription.size ) - 1
            %                             varSizes{iFile} = [varSizes{iFile} ' x ' num2str(sDescription.size(iDim+1)) ];
            %                         end
            %                         varSizes{iFile}		= [varSizes{iFile} ']'];
            %                         varClasses{iFile}	= sDescription.class;
            %                         dirData = dir(fullfile(db_name,fileNames{iFile}));
            %                         varDates{iFile}		= dirData.date;
            %                     end
            %
            %
            %                 end
            %             end
            if nargout > 1
                varargout{2} = varSizes;
            end
            if nargout > 2
                varargout{3} = varClasses;
            end
            if nargout > 3
                varargout{4} = varDates;
            end
        case 'getvar'
            % return struct of variables in db
            % matching the given variable name
            
            %             d = dir(fullfile(db_name,[sessname '_' varname '.mat']));
            %                 if length(d)
            %                     dat=load(fullfile(db_name,d(1).name),'dat','-MAT');
            %                     vout = dat.dat;
            %                 end
            
            if nargin == 3
                vout = [];
                varname = varargin{1};
                d = dir([db_name filesep '*_' varname '.mat']);
                for i=1:length(d)
                    filename=d(i).name;
                    match = findstr(varname,filename);
                    if ~isempty(match) && length(filename)<=match+length(varname)+4 && isempty(findstr(filename(1:match-2),'_'))
                        dat=load(fullfile(db_name,filename),'dat','-MAT');
                        sessname = filename(1:match-2);
                        eval(['vout.' sessname ' = dat.dat;']);
                    end
                end
                varargout{1} = vout;
            elseif nargin == 4
                vout = [];
                varname = varargin{1};
                sessions = varargin{2};
                for isubj = 1:length(sessions)
                    sessname = sessions{isubj};
                    d = dir([db_name filesep sessname '_' varname '.mat']);
                    for i=1:length(d)
                        filename=d(i).name;
                        match_var = findstr(varname,filename);
                        match_sess = findstr(sessname,filename);
                        if ~isempty(match_var) && ~isempty(match_sess)&& length(filename)<=match_var+length(varname)+4 && isempty(findstr(filename(1:match_var-2),'_'))
                            dat=load(fullfile(db_name,filename),'dat','-MAT');
                            eval(['vout.' sessname ' = dat.dat;']);
                        end
                    end
                end
                varargout{1} = vout;
                
                
            else
                error('GETVAR command needs the variable name as input argument');
            end
        case 'getsess'
            % return struct of variables in db
            % matching the given session name
            if nargin >= 3
                vout = [];
                sessname = varargin{1};
                d = dir([db_name filesep sessname '_*.mat']);
                if nargin > 3
                    exclude_vars = varargin{2};
                end
                for i=1:length(d)
                    filename = d(i).name;
                    match = findstr(sessname,filename);
                    if ~isempty(match)
                        varname = filename(findstr(filename,'_')+1:findstr(filename,'.')-1);
                        if exist('exclude_vars')
                            exclude = 0;
                            for exc=exclude_vars
                                if strcmp(char(exc),varname)
                                    exclude = 1;
                                end
                            end
                            if exclude
                                continue
                            end
                        end
                        dat=load(fullfile(db_name,filename),'dat','-MAT');
                        eval(['vout.' varname ' = dat.dat;']);
                    end
                end
                varargout{1} = vout;
            else
                error('GETSESS command needs the session name as input argument');
            end
            
        case  'GetVarNamesForSession'
            
            sessname = varargin{1};
            d = dir([db_name filesep sessname '_*.mat']);
            j = 0;
            vout = cell(length(d),1);
            for i=1:length(d)
                filename = d(i).name;
                match = findstr(sessname,filename);
                if ~isempty(match)
                    j = j + 1;
                    varname = filename(findstr(filename,'_')+1:findstr(filename,'.')-1);
                    
                    vout{j} = varname;
                end
                
            end
            if j <length(d)
                vout{j+1:end} = [];
            end
            varargout{1} = vout;
            
        case 'getsessnames'
            % return list of matching text names
            if nargin >= 3
                txt = varargin{1};
                sesslist = sessdb2('listsess');
                include = [];
                for i=1:length(sesslist)
                    if ~isempty(findstr(txt,sesslist{i}))
                        include = [include;i];
                    end
                end
                varargout{1} = sesslist(include);
            else
                error('GETSESSNAMES command needs the match text as input argument');
            end
        case 'getsessvar'
            % return specific variable from specific session
            if nargin >= 4
                sessname = varargin{1};
                varname = varargin{2};
                vout = [];
                d = dir(fullfile(db_name,[sessname '_' varname '.mat']));
                if length(d)
                    dat=load(fullfile(db_name,d(1).name),'dat','-MAT');
                    vout = dat.dat;
                end
                varargout{1} = vout;
            else
                error('GETSESSVAR command needs the session and variable names as input arguments');
            end
        case 'getsessvars'
            % return specific variable from specific session
            if nargin >= 4
                sessname = varargin{1};
                varnames = varargin{2};
                vout = [];
                for i=1:length(varnames)
                    v = varnames{i};
                    d = dir(fullfile(db_name,[sessname '_' v '.mat']));
                    if length(d)
                        dat=load(fullfile(db_name,d(1).name),'dat','-MAT');
                        vout.(v) = dat.dat;
                    end
                end
                varargout{1} = vout;
            else
                error('GETSESSVARS command needs the session and cell array of variable names as input arguments');
            end
        case 'remsessvars'
            % add/update an session, requires nargin >=4
            if nargin >= 4
                sessname = varargin{1};
                varnames = varargin{2};
                for i=1:length(varnames)
                    fullname = fullfile(db_name,[sessname '_' varnames{i} '.mat']);
                    delete(fullname);
                end
            else
                error('ADD command needs both the session name and session struct as input arguments');
            end
            
            varargout{1} = [];
            
        case 'plot'
        case 'isopen'
            try
                if ~isempty(db_name)
                    varargout{1} = 1;
                else
                    varargout{1} = 0;
                end
            catch
                varargout{1} = 0;
            end
        case 'getdbname'
            varargout{1} = db_name;
        otherwise
            error(['Unidentified Session Database Command: ' cmd]);
    end
    
    
    %     db_name = getpref('corrui', 'db_name' , pwd);
    
    
catch
    error(lasterr);
end