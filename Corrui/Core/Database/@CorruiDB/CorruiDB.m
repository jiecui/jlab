classdef CorruiDB
    % CORRUIDB Summary of this class goes here
    %   Detailed explanation goes here
    
    % Copyright 2012-2016 Richard J. Cui. Created: 01/18/2012  5:48:23.507 PM
    % $Revision: 0.6 $  $Date: SWed 08/10/2016  5:58:47.797 PM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com
    
    properties
        dbname = '';
    end
    
    methods
        function this = CorruiDB( dbname )
            if ( exist( 'dbname', 'var') )
                this.dbname = dbname;
            else
                pn = uigetdir(pwd, 'Select the Session Database Directory');
                if pn
                    this.dbname = pn;
                else
                    return
                end
            end
        end
        
        %% new
        function dat = new( this, session_name, session_struct )
            dat = sessdb2( this.dbname, 'new', session_name, session_struct );
        end
        
        %% add
        function add( this, session_name, session_struct, selectedVars )
            
            if ( ~isempty( session_struct ) )
                % don't save locked variables
                dat.lock = this.getsessvar( session_name, 'lock' );
                variables = fieldnames( session_struct );
                for i=1:length( variables )
                    if ( any(strcmp( variables{i}, dat.lock )  ) )
                        session_struct = rmfield( session_struct, variables{i} );
                        cprintf([1 .5 0], 'The variable %s is locked\n', variables{i} );
                    end
                end
                if ( exist( 'selectedVars', 'var' ) )
                    variables = fieldnames( session_struct );
                    variablesToRemove = setdiff( variables, selectedVars);
                    session_struct = rmfield( session_struct, variablesToRemove);
                end
                sessdb2( this.dbname, 'add', session_name, session_struct);
            end
        end
        
        %% remove
        function dat = remove( this, session_name )
            dat = sessdb2( this.dbname, 'remove', session_name );
        end
        
        %% copysess
        function copysess( this, source_session, destine_session )
            sessdb2( this.dbname, 'copysess', source_session, destine_session );
        end
        
        %% copysessto
        function dat = copysessto( this, source_session, folder )
            dat = sessdb2( this.dbname, 'copysessto', source_session, folder );
        end
        
        %% movesessto
        function dat = movesessto( this, source_session, folder )
            dat = sessdb2( this.dbname, 'movesessto', source_session, folder );
        end
        
        %% listsess
        function dat = listsess( this )
            dat = sessdb2( this.dbname, 'listsess' );
        end
        
        %% listvar
        function dat = listvar( this, session_names )
            dat = sessdb2( this.dbname, 'listvar', session_names );
        end
        
        %% getsess
        function dat = getsess( this, session_name, exclude_vars )
            if exist('exclude_vars', 'var')
                dat = sessdb2( this.dbname, 'getsess', session_name, exclude_vars );
            else
                dat = sessdb2( this.dbname, 'getsess', session_name );
            end
        end
        
        %% getsessvar
        function dat = getsessvar( this, session_name, variable_name )
            dat = sessdb2( this.dbname, 'getsessvar', session_name, variable_name );
        end
        
        %% getsessnames
        function dat = getsessnames( this, text )
            dat = sessdb2( this.dbname, 'getsessnames', text );
        end
        
        %% getVarNamesForSession
        function dat = getVarNamesForSession( this, sname)
            dat = sessdb2( this.dbname, 'GetVarNamesForSession', sname);
        end
        
        %% getvar
        function dat = getvar( this, variable_name, sesslist)
            
            if nargin == 3
                num_empty = 0;
                for iexp = 1:length(sesslist)
                    dat.(sesslist{iexp}) = this.getsessvar( sesslist{iexp}, variable_name);
                    if isempty(dat.(sesslist{iexp}))
                        num_empty = num_empty + 1;
                    end
                end
                if num_empty == length(sesslist)
                    dat = [];
                end
            else
                dat = sessdb2( this.dbname, 'getvar', variable_name );
            end
        end
        
        %% remsessvars
        function dat = remsessvars( this, session_name, variable_name )
            dat = sessdb2( this.dbname, 'remsessvars', session_name, variable_name );
        end
        
        %% getsessvars
        function dat = getsessvars( this, session_name, variable_names )
            dat = sessdb2( this.dbname, 'getsessvars', session_name, variable_names );
        end
        
        %% getVarInfo
        function dat = getVarInfo( this, session_name, variable_name )
            whole_name = fullfile(this.dbname, [session_name '_' variable_name '.mat']);
            % dat = whos( '-file', fullfile(this.dbname, [session_name '_' variable_name '.mat']), 'dat' );
            dat = whos( '-file', whole_name, 'dat' );
            % matlab bug
            if isempty(dat.size)
                s = load(whole_name, 'dat');
                dat.size = size(s.dat);
            end % if
            dirData = dir(fullfile(this.dbname, [session_name '_' variable_name '.mat']));
            dat.date = dirData.date;
        end
        
        %% lock
        function lock( this, session_name, variable_names )
            % get the current list of locked variables
            dat.lock = this.getsessvar( session_name, 'lock' );
            
            % add the new variables
            dat.lock = union( dat.lock, variable_names );
            
            % save the list
            this.add(  session_name, dat );
        end
        
        %% unlock
        function unlock( this, session_name, variable_names )
            % get the current list of locked variables
            dat.lock = this.getsessvar( session_name, 'lock' );
            
            % remove the variables
            dat.lock = setdiff( dat.lock, variable_names );
            
            % save the list
            this.add(  session_name,  dat );
        end
        
        %% isLocked
        function islocked = isLocked( this, session_name, variable_name )
            % get the current list of locked variables
            dat.lock = this.getsessvar( session_name, 'lock' );
            
            % remove the variables
            islocked = ~isempty( intersect( dat.lock, variable_name ));
        end
        
        %% updateStruct
        function updateStruct( this, session_name, variable_name, newvariable )
            
            % get the current struct from the database
            variable = this.getsessvar(session_name, variable_name );
            
            % merge the structs
            dat.(variable_name) = mergestructs(variable, newvariable);
            
            % unlock variable if necessary
            locked = false;
            if this.isLocked( session_name, variable_name )
                locked = true;
                this.unlock( session_name, { variable_name});
            end
            % save merged struct
            this.add( session_name, dat );
            
            % lock again the variable if necessary
            if ( locked )
                this.Lock( session_name, { variable_name});
            end
            
        end
        
        %% makearray
        function [total_dat, wb, wf, sess_found] = makearray( this, sessionlist, varname, win_back, win_for, samplerate )
            total_dat = [];
            wb = [];
            wf = [];
            sess_found = [];
            
            % Get the var for all the sessions
            v = this.getvar( varname, sessionlist );
            
            if ~exist('win_back', 'var')
                win_back	= this.getvar('window_backward', sessionlist);
                win_for		= this.getvar('window_forward', sessionlist);
                samplerate =  this.getvar('samplerate', sessionlist);
            end
            samplerate  = cell2mat(struct2cell(samplerate));
            
            % if there are no variables to average in any session
            if isempty(v)
                return
            end
            
            
            % check if the variable is present in all the sessions
            sess_found = [];
            for i=1:length(sessionlist)
                if ( ~isfield( v, sessionlist{i} ) || isempty( v.(sessionlist{i}) ) )
                    fprintf( 'Variable %s not present in session %s\n', varname, sessionlist{i});
                else
                    sess_found = [sess_found i];
                end
            end
            
            % get the window backward for this variable in all the sessions
            varlength = nan(length(sess_found), 1);
            varNumDims = zeros(length(sess_found), 1);
            varSizeSameYesNo = zeros(length(sess_found), 1);
            varSizeFirst = size(v.(sessionlist{sess_found(1)}));
            for i=1:length(sess_found)
                varlength(i) = length(v.(sessionlist{sess_found(i)}));
                varNumDims(i) = length(size(v.(sessionlist{sess_found(i)})));
                if all(varSizeFirst == size(v.(sessionlist{sess_found(i)})))
                    varSizeSameYesNo(i) = 1;
                end
            end
            
            if all(varNumDims == varNumDims(1)) && all(varSizeSameYesNo == 1)
                allVarsSameDimAndSize = 1;
                sizeOfVar = varSizeFirst;
                varNumDims = varNumDims(1);
            else
                allVarsSameDimAndSize = 0;
                disp(['Not all variables have the same size: ' varname]);
            end
            
            % get the window backward for this variable in all the sessions
            win_back_temp = nan(length(sess_found), 1);
            for i=1:length(sess_found)
                if ( isfield( win_back, sessionlist{sess_found(i)}) && isfield( win_back.(sessionlist{sess_found(i)}), varname) )
                    win_back_temp(i) = win_back.(sessionlist{sess_found(i)}).(varname);
                end
            end
            win_back = win_back_temp(~isnan(win_back_temp));
            
            % get the window forward for this variable in all the sessions
            win_for_temp = nan(length(sess_found), 1);
            for i=1:length(sess_found)
                if ( isfield( win_for, sessionlist{sess_found(i)}) && isfield( win_for.(sessionlist{sess_found(i)}), varname) )
                    win_for_temp(i) = win_for.(sessionlist{sess_found(i)}).(varname);
                end
            end
            win_for = win_for_temp(~isnan(win_for_temp));
            
            
            % check if samplerate is there for all the sessions and is the
            % same
            if ( length( samplerate ) < length(sess_found))
                fprintf( 'Samplerate is not there for all the sessions\n');
                return
            end
            if ( length( unique( samplerate ) ) > 1 )
                fprintf( 'Samplerate is not the same for all the sessions\n');
                return
            end
            
            % window backward and window forward can be present or not. But
            % if it is it has to be there for all the sessions and be the
            % same
            if ( ~isempty(win_back) && length( win_back ) < length(sess_found) ) || ( ~isempty(win_for) && length( win_for ) < length(sess_found) )
                fprintf( 'Window backwards or forward is not there for some session for variable %s\n', varname);
                return
            end
            if ( ~isempty(win_back) && length( unique(win_back) ) > 1 || ( ~isempty(win_for) && length( unique(win_for) ) > 1 ) )
                fprintf( 'Window backwards or forward  is not the same for all the sessions for variable %s\n', varname);
                return
            end
            
            % check that the variable has the same length for all the
            % sessions
            if ( length(unique(varlength)) > 1 )
                fprintf( 'The length of %s is not the same for all the sessions\n', varname);
                return
            end
            
            
            wb	= unique(win_back);
            wf		= unique(win_for);
            samplerate  = unique(samplerate);
            varlength   = unique(varlength);
            
            % Initialize the vector for the concatenated data
            if allVarsSameDimAndSize
                
                switch varNumDims
                    case 2
                        if (sizeOfVar(1) == 1) && (sizeOfVar(2) == 1)
                            total_dat = zeros([1, length(sess_found)]);
                        elseif (sizeOfVar(1) == 1) && ~(sizeOfVar(2) == 1)
                            total_dat = zeros([sizeOfVar(2), length(sess_found)]);
                        elseif ~(sizeOfVar(1) == 1) && (sizeOfVar(2) == 1)
                            total_dat = zeros([sizeOfVar(1), length(sess_found)]);
                        else
                            total_dat = zeros([sizeOfVar, length(sess_found)]);
                        end
                        
                    otherwise
                        total_dat = zeros([sizeOfVar, length(sess_found)]);
                end
                
                
            elseif ( ~isempty(wb) && ~isempty(wf) )
                total_dat = zeros(wb/ 1000 * samplerate + wf/ 1000 * samplerate, length(sess_found));
            else
                total_dat = zeros(varlength, length(sess_found));
            end
            
            
            for isess = 1:length(sess_found)
                curr_dat = v.(sessionlist{sess_found(isess)});
                
                if allVarsSameDimAndSize
                    switch varNumDims
                        case 2
                            if (sizeOfVar(1) == 1) && (sizeOfVar(2) == 1)
                                total_dat(:, isess) = curr_dat;
                                
                            elseif (sizeOfVar(1) == 1) && ~(sizeOfVar(2) == 1)
                                total_dat(:, isess) = curr_dat(1, :);
                                
                            elseif ~(sizeOfVar(1) == 1) && (sizeOfVar(2) == 1)
                                total_dat(:, isess) = curr_dat(:, 1);
                                
                            else
                                total_dat(:, :, isess) = curr_dat;
                            end
                            
                        case 3
                            total_dat(:, :, :, isess) = curr_dat;
                            
                        case 4
                            total_dat(:, :, :, :, isess) = curr_dat;
                    end
                    
                else
                    
                    if size(curr_dat, 1) == 1
                        curr_dat = curr_dat';
                    end
                    curr_dat = curr_dat(:);
                    total_dat(:, isess) = curr_dat;
                    
                end
            end
        end
        
        %% get_plotdat
        function plotdat = get_plotdat( this, actual_plotdat, session_name, variable_names , which_eye, fields)
            % plotdat = get_plotdat( actual_plotdat, session_name, variable_names , lrb)
            %Fields is a cell with the fields of variable_names that you want. Each
            %element in variable_names must have the same field when using this
            %feature.
            % Get a structure with one field per variable needed for the plot.
            % If any field is present in actual_plot it will stay.
            % the variable_names should be a cell array with the variable names that
            % will be retreived from the DB.
            % lrb (optional) is used to indicate the eye. 0 left 1 right 2 both 3
            % concatenate 4 is data with no eye dependence
            
            if isempty( variable_names )
                return
            end
            
            if ( exist( 'which_eye', 'var' ) )
                switch( which_eye)
                    case 'Left'
                        lrb = 0;
                    case 'Right'
                        lrb = 1;
                    case 'Both'     % means average
                        lrb = 2;
                    case 'Concat'
                        lrb = 3;
                    case 'Unique'
                        lrb = 4;
                end
            end
            
            
            
            if ischar(variable_names)
                variable_names = { variable_names };
            end
            j=1;
            for variable_name = variable_names
                
                variable_name = char(variable_name);
                
                % if the variable has already been retrieved
                if ( isfield( actual_plotdat, variable_name) && ~isempty( actual_plotdat.(variable_name) ) )
                    continue
                end
                
                % Get the variable from the DB for left, right, of both eyes
                if exist('lrb', 'var') && ( lrb == 0 )&& ~exist('fields', 'var')
                    % left eye
                    actual_plotdat.(variable_name) = this.getsessvar( session_name, ['left_' variable_name]);
                elseif exist('lrb', 'var') && ( lrb == 1 )&& ~exist('fields', 'var')
                    % right eye
                    actual_plotdat.(variable_name) = this.getsessvar( session_name, ['right_' variable_name]);
                elseif exist('lrb', 'var') && ( lrb == 0 )&& exist('fields', 'var')&& ~isempty(fields)
                    % left eye
                    left	= this.getsessvar( session_name, ['left_' variable_name] );
                    fieldnames = fields{j};
                    for i=1:length(fieldnames)
                        if ~isempty(left.(fieldnames{i}))
                            actual_plotdat.(variable_name).(fieldnames{i}) = left.(fieldnames{i});
                        else
                            actual_plotdat.(variable_name).(fieldnames{i}) = [];
                        end
                    end
                    
                elseif exist('lrb', 'var') && ( lrb == 1 )&& exist('fields', 'var')&& ~isempty(fields)
                    % right eye
                    right	= this.getsessvar( session_name, ['right_' variable_name] );
                    fieldnames = fields{j};
                    for i=1:length(fieldnames)
                        if ~isempty(right.(fieldnames{i}))
                            actual_plotdat.(variable_name).(fieldnames{i}) = right.(fieldnames{i});
                        else
                            actual_plotdat.(variable_name).(fieldnames{i}) = [];
                        end
                    end
                    
                elseif exist('lrb', 'var') && ( lrb == 2 )&& ~exist('fields', 'var')
                    % both eyes averaged
                    left	= this.getsessvar( session_name, ['left_' variable_name] );
                    right	= this.getsessvar( session_name, ['right_' variable_name] );
                    if ( ~isstruct(left) )
                        D = ndims(left);
                        actual_plotdat.(variable_name) = mean(cat(D+1, left, right), D+1 );
                    else
                        actual_plotdat.(variable_name) = mean_struct( [left right] );
                    end
                elseif exist('lrb', 'var') && ( lrb == 2 )&& exist('fields', 'var') && ~isempty(fields)
                    % both eyes averaged
                    left	= this.getsessvar( session_name, ['left_' variable_name] );
                    right	= this.getsessvar( session_name, ['right_' variable_name] );
                    if isempty(left)||isempty(right)
                        continue;
                    end
                    fieldnames = fields{j};
                    for i=1:length(fieldnames)
                        if ~isempty(left.(fieldnames{i}))&&~isempty(right.(fieldnames{i}))
                            actual_plotdat.(variable_name).(fieldnames{i}) = ...
                                mean(cat(3, left.(fieldnames{i}), right.(fieldnames{i})), 3);
                        else
                            actual_plotdat.(variable_name).(fieldnames{i}) = [];
                        end
                    end
                    
                    
                elseif exist('lrb', 'var') && ( lrb == 3 )&& ~exist('fields', 'var')
                    % both eyes concatenated
                    left	= this.getsessvar( session_name, ['left_' variable_name] );
                    right	= this.getsessvar( session_name, ['right_' variable_name] );
                    if isempty(left)&& isempty(right)
                        continue;
                    end
                    if ( size(left, 2) == size(right, 2) )
                        actual_plotdat.(variable_name) = [left;right];
                    else
                        if ( isempty(left) )
                            actual_plotdat.(variable_name) = right;
                        elseif (isempty(right) )
                            actual_plotdat.(variable_name) = left;
                        else
                            actual_plotdat.(variable_name) = [left';right'];
                        end
                    end
                    
                elseif exist('lrb', 'var') && ( lrb == 3 )&& exist('fields', 'var')&& ~isempty(fields)
                    % both eyes concatenated
                    left  = this.getsessvar( session_name,  ['left_' variable_name]);
                    right = this.getsessvar( session_name,  ['right_' variable_name]);
                    if isempty(left)||isempty(right)
                        continue;
                    end
                    fieldnames = fields{j};
                    for i=1:length(fieldnames)
                        
                        if ( size(left.(fieldnames{i}), 2) == size(right.(fieldnames{i}), 2) )
                            actual_plotdat.(variable_name).(fieldnames{i}) = [left.(fieldnames{i});right.(fieldnames{i})];
                        elseif ~(isempty(right.(fieldnames{i})) )|| ~(isempty(left.(fieldnames{i})) )
                            if ( isempty(left.(fieldnames{i})) )
                                actual_plotdat.(variable_name) = [right.(fieldnames{i})];
                            elseif (isempty(right.(fieldnames{i})) )
                                actual_plotdat.(variable_name) = [left.(fieldnames{i})];
                            else
                                actual_plotdat.(variable_name).(fieldnames{i}) = [left.(fieldnames{i})';right.(fieldnames{i})];
                            end
                        else
                            actual_plotdat.(variable_name).(fieldnames{i}) = [];
                        end
                    end
                    
                elseif exist('lrb', 'var') && ( lrb == 4 )&& exist('fields', 'var')&& ~isempty(fields)
                    
                    data	= this.getsessvar( session_name,  variable_name );
                    if isempty(data)
                        continue;
                    end
                    fieldnames = fields{j};
                    for i=1:length(fieldnames)
                        actual_plotdat.(variable_name).(fieldnames{i}) = data.(fieldnames{i});
                    end
                    
                else
                    actual_plotdat.(variable_name) = this.getsessvar( session_name,  variable_name);
                end
                
                j=j+1;
                
            end
            plotdat = actual_plotdat;
        end
    end
    
    
    methods(Static)
        function dat = New( session_name, session_struct )
            dat = sessdb( 'new', session_name, session_struct );
        end
        
        function Open( dir )
            sessdb( 'open', dir );
            setpref('corrui', 'db_name' , dir);
        end
        
        function Close( )
            sessdb( 'close');
        end
        
        function Addsessvars(session_name, session_struct, flag_unlock)
            if ~exist('flag_unlock', 'var')
                flag_unlock = '';
            end % if
            
            var_names = fieldnames(session_struct);
            switch lower(flag_unlock)
                case 'unlock'
                    locked_idx = CorruiDB.IsLocked(session_name, var_names);
                    locked_var = var_names(locked_idx);
                    CorruiDB.Unlock(session_name, locked_var);
                    CorruiDB.Add(session_name, session_struct)
                    CorruiDB.Lock(session_name, locked_var);
                case 'lock'
                    CorruiDB.Add(session_name, session_struct)
                    CorruiDB.Lock(session_name, var_names);                    
                otherwise
                    CorruiDB.Add(session_name, session_struct)
            end % switch
            
        end
        
        function Add( session_name, session_struct, selectedVars )
            
            if ( ~isempty( session_struct ) )
                % don't save locked variables
                dat.lock = sessdb( 'getsessvar', session_name, 'lock' );
                variables = fieldnames( session_struct );
                for i=1:length( variables )
                    if ( ~isempty( intersect( variables{i}, dat.lock ) ) )
                        session_struct = rmfield( session_struct, variables{i} );
                        cprintf([1 0.5 0], 'The variable %s is locked\n', variables{i} );
                    end
                end
                
                if ( exist( 'selectedVars', 'var' ) )
                    variables = fieldnames( session_struct );
                    variablesToRemove = setdiff( variables, selectedVars);
                    session_struct = rmfield( session_struct, variablesToRemove);
                end
                sessdb( 'add', session_name, session_struct );
            end
        end
        
        function dat = Remove( session_name )
            dat = sessdb( 'remove', session_name );
        end
        
        function Copysess( source_session, destine_session )
            sessdb( 'copysess', source_session, destine_session );
        end
        
        function Copysessto( source_session, folder )
            sessdb( 'copysessto', source_session, folder );
        end
        
        function dat = Movesessto( source_session, folder )
            dat = sessdb( 'movesessto', source_session, folder );
        end
        
        function dat = Listsess(   )
            dat = sessdb( 'listsess' );
        end
        
        function dat = Listvar( session_names )
            dat = sessdb( 'listvar', session_names );
        end
        
        function dat = Getsess( session_name, exclude_vars )
            if exist('exclude_vars', 'var')
                dat = sessdb( 'getsess', session_name, exclude_vars );
            else
                dat = sessdb( 'getsess', session_name );
            end
        end
        
        function dat = Getsessvar( session_name, variable_name )
            dat = sessdb( 'getsessvar', session_name, variable_name );
        end
        
        function dat = Getsessnames( text )
            dat = sessdb( 'getsessnames', text );
        end 
        
        function dat = GetVarNamesForSession(sname)
            dat = sessdb('GetVarNamesForSession', sname);
        end
        
        function dat = Getvar( variable_name, sesslist)
            
            if nargin == 2
                num_empty = 0;
                for iexp = 1:length(sesslist)
                    dat.(sesslist{iexp}) =    sessdb( 'getsessvar', sesslist{iexp}, variable_name);
                    if isempty(dat.(sesslist{iexp}))
                        num_empty = num_empty + 1;
                    end
                end
                if num_empty == length(sesslist)
                    dat = [];
                end
            else
                dat = sessdb( 'getvar', variable_name );
            end
        end
        
        function dat = Remsessvars( session_name, variable_name )
            dat = sessdb( 'remsessvars', session_name, variable_name );
        end
        
        function dat = Getsessvars( session_name, variable_names )
            dat = sessdb( 'getsessvars', session_name, variable_names );
        end
        
        function dat = GetVarInfo( session_name, variable_name )
            dbname = sessdb( 'getdbname' );
            dat = whos( '-file', fullfile(dbname, [session_name '_' variable_name '.mat']), 'dat' );
            dirData = dir(fullfile(dbname, [session_name '_' variable_name '.mat']));
            dat.date = dirData.date;
        end
        
        function Lock( session_name, variable_names )
            % get the current list of locked variables
            dat.lock = sessdb( 'getsessvar', session_name, 'lock' );
            
            % add the new variables
            dat.lock = union( dat.lock, variable_names );
            
            % save the list
            CorruiDB.Add(  session_name, dat );
        end
        
        function Unlock( session_name, variable_names )
            % get the current list of locked variables
            dat.lock = sessdb( 'getsessvar', session_name, 'lock' );
            
            % remove the variables
            dat.lock = setdiff( dat.lock, variable_names );
            
            % save the list
            CorruiDB.Add(  session_name,  dat );
        end
        
        function islocked = IsLocked( session_name, variable_name )
            num_vars = numel(variable_name);
            islocked = false(1, num_vars);
            
            % get the current list of locked variables
            dat.lock = sessdb('getsessvar', session_name, 'lock' );
            for k = 1:num_vars
                var_k = variable_name(k);
                
                % remove the variables
                islocked(k) = ~isempty( intersect( dat.lock, var_k ));
            end % for
        end
        
        function UpdateStruct( session_name, variable_name, newvariable )
            
            % get the current struct from the database
            variable = CorruiDB.Getsessvar(session_name, variable_name );
            
            % merge the structs
            dat.(variable_name) = mergestructs(variable, newvariable);
            
            % unlock variable if necessary
            locked = false;
            if CorruiDB.IsLocked( session_name, variable_name )
                locked = true;
                CorruiDB.Unlock( session_name, { variable_name});
            end
            % save merged struct
            CorruiDB.Add( session_name, dat );
            
            % lock again the variable if necessary
            if ( locked )
                CorruiDB.Lock( session_name, { variable_name});
            end
            
        end
    end
    
end

