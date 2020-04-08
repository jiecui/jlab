function varargout = corrui(varargin)
% CORRUI M-file for corrui.fig
%      CORRUI, by itself, creates a new CORRUI or raises the existing
%      singleton*.
%
%      H = CORRUI returns the handle to a new CORRUI or the handle to
%      the existing singleton*.
%
%      CORRUI('CALLBACK',hObject,eventData,handles,...) caggrealls the
%      local
%      function named CALLBACK in CORRUI.M with the given input arguments.
%
%      CORRUI('Property','Value',...) creates a new CORRUI or raises the
%      existing singleton*.  Starting from the left, property value pairs
%      are
%      applied to the GUI before corrui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to corrui_OpeningFcn via varargin.
%
%      CORRUI(jlab_exp)
% 
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help corrui

% Last Modified by GUIDE v2.5 10-Aug-2016 10:02:54
% Last modified by Richard J. Cui on Tue 03/31/2020  9:54:35.086 AM
% e-mail: richard.jie.cui@gmail.com

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @corrui_OpeningFcn, ...
    'gui_OutputFcn',  @corrui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Outputs from this function are returned to the command line.
function varargout = corrui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes just before corrui is made visible.
function corrui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to corrui (see VARARGIN)


% ---------------------
% -- Initializations --
% ---------------------
if nargin && iscell(varargin{1})
    handles.jlab_exp = varargin{1};
end % if

if ispc == true
    handles = corrui_init_pc(hObject, eventdata, handles);
elseif ismac == true
    handles = corrui_init_mac(hObject, eventdata, handles);
else
    cprintf('SystemCommands', 'Not supported operating system!\n')
    handles = corrui_init_mac(hObject, eventdata, handles);
end % if

% Update handles structure
% ------------------------
guidata(hObject, handles);

function handles = setup_corrui_db(handles)
% Setup Corrui Database
% get/set default database folder
% --------------------------------
handles.Current_Directory = getpref( 'corrui', 'dbDirectory', pwd );
LastdbDirectories = getpref( 'corrui', 'LastdbDirectories', {pwd} );
set( handles.currentdir_popup, 'String', LastdbDirectories);
try
    CorruiDB.Open( handles.Current_Directory );
catch ex
    ex.getreport()
    fprintf('ERROR openning database folder\n\n');
    close(hObject)
    return
end

function handles = setup_vars_db(handles)
% Setup variables database

data = load('corrui_variable_db_editor.mat');
handles.variable_db = data;
% populate descriptions
[handles.variable_descriptions, handles.variable_aggregate] = CorrGui.get_variable_descriptions( handles.variable_db );
% list of main variables that go in the first box
handles.MainVariables = CorrGui.get_main_variables( handles.variable_db );

function hObject = setup_corr_fig(hObject, handles)
% set name of the GUI of Corrui
if strcmpi(hObject.Tag, 'CorruiGUI') == true
    hObject.Name = 'jLab - Integrated Environment of Signal Processing';
end % if

% set scrolling in variable table
jscrollpane = findjobj(handles.tableVar);
jtable = jscrollpane.getViewport.getView;
jtable.setSortable(true);		% or: set(jtable,'Sortable','on');
jtable.setAutoResort(true);
jtable.setMultiColumnSortable(true);
jtable.setPreserveSelectionsAfterSorting(true);

function handles = setup_quick_tools(handles)
set( handles.popupPlotType, 'String', {'Line','histogram'} );
set( handles.popupPlotType, 'value', 1 );
handles.rawPlotOptions	= getrawplotstruct( false );
handles.processOptions	= [];

function handles = setup_exp_menu(handles)
% setup experiment dependent menus
% Menu objects
if ~isfield(handles, 'ExpDependMenuObj')
    handles.ExpDependMenuObj = {};
end % if

handles = updateCurrentMenus(handles);

function handles = corrui_init_mac(hObject, eventdata, handles)
% CORRUI GUI Mac Intialization

% corrui database
% ---------------
handles = setup_corrui_db(handles);

% Variable DB data
% ----------------
handles = setup_vars_db(handles);

% tag system setup
% -----------------
handles = setuptags( handles );

% Corrui GUI fig
% --------------
hObject = setup_corr_fig(hObject, handles);

% setup session search filter
% ----------------------------
handles.sessFilter.FontSize = 11;

% setup session list
% --------------------------------------
handles = update_session_lists( handles );
set( handles.internaltag_popup, 'String', handles.Enums.Internal_Text_List );
set( handles.internaltag_popup, 'value', getpref('corrui','current_tag_value', 1) );
internaltag_popup_Callback(hObject, eventdata, handles);

% setup session drecription editor
% ---------------------------------
% Session description
sess_edit_width = 39; % characters, for Consolas fondsize 11
handles.SessionDescriptionTextWidth = sess_edit_width;
handles.textsessdes.FontSize = 11;

% setup variable list
% --------------------

% setup variable description editor
% ----------------------------------
handles.textvardes.FontSize = 11;

% quick-tool, Raw plot types, options
% ------------------------------------
handles = setup_quick_tools(handles);

% initialized experiment-dependent graphic objects
% ------------------------------------------------
handles = setup_exp_menu(handles);

function handles = corrui_init_pc(hObject, eventdata, handles)
% CORRUI GUI Windows/pc Intialization

% corrui database
% ---------------
handles = setup_corrui_db(handles);

% Variable DB data
% ----------------
handles = setup_vars_db(handles);

% tag system setup
% -----------------
handles = setuptags( handles );

% Corrui GUI fig
% --------------
hObject = setup_corr_fig(hObject, handles);

% setup session search filter
% ----------------------------
handles.sessFilter.FontSize = 11;

% setup session list
% --------------------------------------
handles = update_session_lists( handles );
set( handles.internaltag_popup, 'String', handles.Enums.Internal_Text_List );
set( handles.internaltag_popup, 'value', getpref('corrui','current_tag_value', 1) );
internaltag_popup_Callback(hObject, eventdata, handles);

% setup session drecription editor
% ---------------------------------
% Session description
sess_edit_width = 39; % characters, for Consolas fondsize 11
handles.SessionDescriptionTextWidth = sess_edit_width;
handles.textsessdes.FontSize = 8;

% setup variable list
% --------------------

% setup variable description editor
% ----------------------------------
handles.textvardes.FontSize = 8;

% quick-tool, Raw plot types, options
% ------------------------------------
handles = setup_quick_tools(handles);

% initialized experiment-dependent graphic objects
% ------------------------------------------------
handles = setup_exp_menu(handles);

% ------------------
% function setuptags
% ------------------
function handles = setuptags(handles)

% enums is a struct holding the string values of the system-defined tags
% TAGS
handles.Enums = [];
handles.Enums.Internal_Text_List        = {};
handles.Enums.Internal_Text_List_Avg    = {};
handles.Enums.Internal_Tag_List         = {};
handles.Enums.Internal_Tag_List_Avg     = {};
handles.Enums.Experiment_List           = {};
handles.Enums.Experiment_List_Avg       = {};
handles.Enums.experiment_tags           = {};

% -- Experiment tags -- 
% searchs inside the default folder (jLab/Corrui/Experiments) and
% additional folders for class names (tag).  The folder name is the tag
% name.

% default directory
dir_df = [fileparts(mfilename('fullpath')) [filesep 'Experiments']];
d_df = dir(dir_df);
% additional directories
dir_add = handles.jlab_exp;
if ~isempty(dir_add)
    d_add = struct([]);
    for k = 1:numel(dir_add)
        dir_k = dir_add{k};
        d_k = dir(dir_k);
        d_add = cat(1, d_add, d_k);
    end % for
    d = cat(1, d_df, d_add);
else
    d = d_df;
end % if
for i = 1:length(d)
    if isempty(strfind( d(i).name, '.')) && d(i).isdir == true
        handles.Enums.experiment_tags{end+1} = d(i).name;
    end
end

for i=1:length(handles.Enums.experiment_tags)
    tag     = char(handles.Enums.experiment_tags{i});
    
    % test if there is any problem with the experiment
    try
        % setup dependents of the experiments
        fprintf('Setting up dependents of experiment: %s ...\n', tag)
        dep_tag = [tag, 'Dependents']; % must be ExpDependents class
        dependent = CorrGui.ExperimentConstructor(dep_tag);
        dependent.setup;
        
        % setup the experiments
        fprintf(['Setting up experiment: ' tag ' ...\n']);
        experiment = CorrGui.ExperimentConstructor( tag );
        name = experiment.name;
        experiment_avg = CorrGui.ExperimentConstructor( tag );
        experiment_avg.is_Avg = 1;
        
    catch ex
        ex.getReport()
        handles.Enums.experiment_tags{i} = {};
        warning('off', 'backtrace')
        warning('Probably you need to run jlab_setup to update the matlab path');
        warning('on', 'backtrace')
        continue;
    end
    % fprintf('\n');
    
    handles.Enums.Internal_Text_List{end+1} = name;
    handles.Enums.Internal_Text_List_Avg{end+1} = [name ' Avg'];
    
    handles.Enums.Internal_Tag_List{end+1} = tag;
    handles.Enums.Internal_Tag_List_Avg{end+1} = [tag '_Avg'];
    
    handles.Enums.Experiment_List{end+1} = experiment;
    handles.Enums.Experiment_List_Avg{end+1} = experiment_avg;
    
    % one list for each experiment containing all the sessions of the type
    handles.([tag '_List']) = {}; 
    handles.([tag '_Avg_List']) = {};
end

% add an uncategorized type of session just in case
% handles.Enums.Experiment_List{end+1}        = {};
% handles.Enums.experiment_tags{end+1}        = 'Uncategorized';  % Tue 02/15/2011 12:37:45 PM by RJC
% handles.Enums.Internal_Text_List{ end+1}    = 'Uncategorized';
% handles.Enums.Internal_Tag_List{end+1}      = 'Uncategorized';
% handles.Uncategorized_List = {};


%% function update_session_lists
function handles = update_session_lists(handles, selectedsessions)
% Update the internal list of sessions, checking in the database folder for
% sessions of all types

if ( ~exist( 'selectedsessions', 'var' ) || isempty( selectedsessions ) )
    selectedsessions = {};
end
if ~iscell(selectedsessions)
    selectedsessions = {selectedsessions};
end


hwait = waitbar(0,'Please wait while sessions list is loading ...');

% get the sessions and fill the list int he gui
try
    % get the sessions
    struct_lists = CorrGui.get_session_lists( union(handles.Enums.Internal_Tag_List, handles.Enums.Internal_Tag_List_Avg) );
    handles = mergestructs(handles, struct_lists);
    
    curr_tag = CorrGui.get_current_tag( handles );
    
    % update session listbox    
    set( handles.sessionlistbox, 'Value', [] );
    % set( handles.sessionlistbox, 'String', handles.([curr_tag '_List']) );
    sess_list_str = CorrGui.setSessListString( handles );
    
    % filter the session list according to the session filter
    sess_filter = handles.sessFilter.String;
    sess_filtered_list = {};
    for k = 1:numel(sess_list_str)
        sess_name = sess_list_str{k};
        if isempty(sess_filter) || ~isempty(strfind(sess_name, sess_filter))
            sess_filtered_list = cat(1, sess_filtered_list, sess_name);
        end % if
    end % for
    sess_list_str = sess_filtered_list;
    
    set( handles.sessionlistbox, 'String', sess_list_str );
    
catch ex
    ex.getReport
    disp('corrui: Error loading sessions. Probably some session was saved with a bad name (spaces or underscores)');
end

% mark as the selected sessions
SelectionIndex = zeros(length(selectedsessions),1);
for isess = 1:length(selectedsessions)
    index = find( strcmp( handles.([curr_tag '_List']), selectedsessions{isess} ) );
    if ~isempty(index)
        SelectionIndex(isess) = index;
    end
end

empty_idx = SelectionIndex == 0;
SelectionIndex(empty_idx) = [];
if ~isempty(SelectionIndex)
    set(handles.sessionlistbox, 'value', SelectionIndex );
end % if
close(hwait)

% update variables
handles = update_variable_list(handles);
% toogle_buttons( handles )
guidata( handles.internaltag_popup, handles);

% ------------------------
% update current menus
% ------------------------
function handles = updateCurrentMenus(handles)
% update menus for the current experiment

% clear menu obj in other experiments
other_menu_obj = handles.ExpDependMenuObj;
if ~isempty(other_menu_obj)
    nobj = numel(other_menu_obj);
    for k = 1:nobj
        obj_k = other_menu_obj{k};
        delete(obj_k)
    end % for
    handles.ExpDependMenuObj = {};
end % if

% get obj of current exp
[~, curr_exp] = CorrGui.get_current_tag(handles);

% update menus for current exp
handles = curr_exp.updateCurrExpMenus(handles);


%% function update_variable_list
function handles = update_variable_list(handles)
% Update the internal list of variables

[~, curr_exp] = CorrGui.get_current_tag( handles );

% get current selected session(s)
curval = CorrGui.getSessListString( handles );

if ( isempty(curval) )
    handles.Variable_List = {};
    set( handles.tableVar, 'data', {}) ;
    return
end

% get vars in current sessions
all_variables = curr_exp.db.listvar( curval );

% separate the main variables and the rest
handles.Variable_List = all_variables;

% filter the variables depending on the filter box
varFilter = get(handles.txtFilter, 'string');
handles.Variable_List_temp = {};
for iVariable = 1:length(handles.Variable_List)
    varName = handles.Variable_List{iVariable};
    % varFilter = get(handles.txtFilter, 'string');
    % if ( length(varFilter) == 0 || ( ~isempty( strfind( varName, varFilter )) ) )
    if ( isempty(varFilter) || ( ~isempty( strfind( varName, varFilter )) ) )
        handles.Variable_List_temp{end+1} = varName;   
    end
end
handles.Variable_List = handles.Variable_List_temp;

data = cell(size(handles.Variable_List,2),4);

% get the variable info
for iVariable = 1:length(handles.Variable_List)
    varName = handles.Variable_List{iVariable};
    data{iVariable,1} = varName;
    if ( (~isempty( intersect(handles.MainVariables', varName) ) || ...
           ~isempty( intersect(handles.MainVariables', strrep(varName,'left_','')) ) || ...
           ~isempty( intersect(handles.MainVariables', strrep(varName,'right_','')) ) ) ...
           && (ischar(curval)||length(curval)==1))
        dat = curr_exp.db.getVarInfo( curval, varName );
        variableSizes = ['[' num2str(dat.size(1))];
        for iDim = 1:length( dat.size ) - 1
            % variableSizes = [variableSizes ' x ' num2str(dat.size(iDim+1)) ];
            variableSizes = cat(2, variableSizes, ' x ', num2str(dat.size(iDim+1)));
        end
        % variableSizes = [variableSizes ']'];
        variableSizes = cat(2, variableSizes, ']');
        data{iVariable,2} = variableSizes;
        data{iVariable,3} = dat.class;
        data{iVariable,4} = dat.date;
    end
end

set( handles.tableVar, 'Data',data);

%% function changedir
function handles = changedirdb( handles )
d  = uigetdir(handles.Current_Directory,'Select the database directory');

if (d  ~= 0)
    handles.Current_Directory = d;
    
    CorruiDB.Open( handles.Current_Directory  );
    
    setpref( 'corrui', 'dbDirectory', handles.Current_Directory );

    LastdbDirectories = getpref( 'corrui', 'LastdbDirectories', {pwd} );
    % [LastdbDir, order] = setdiff( LastdbDirectories, handles.Current_Directory);
    [~, order] = setdiff( LastdbDirectories, handles.Current_Directory);
    LastdbDirectories = LastdbDirectories(sort(order));
    LastdbDirectories = {handles.Current_Directory LastdbDirectories{1:min(length(LastdbDirectories),9)}};
    setpref( 'corrui', 'LastdbDirectories', LastdbDirectories);

    set( handles.currentdir_popup, 'String', LastdbDirectories );
    set( handles.currentdir_popup, 'Value', 1 );
    
    for i=1:length(handles.Enums.Experiment_List)
        handles.Enums.Experiment_List{i}.db = CorruiDB(handles.Current_Directory);
    end
    for i=1:length(handles.Enums.Experiment_List_Avg)
        handles.Enums.Experiment_List_Avg{i}.db = CorruiDB(handles.Current_Directory);
    end
    
    handles = update_session_lists( handles );
end

%% function changedir
function handles = changedirdbpopup( handles )
    
currentdirval = get(handles.currentdir_popup,'value');
dirs = get(handles.currentdir_popup,'string');

handles.Current_Directory = dirs{currentdirval};
setpref( 'corrui', 'dbDirectory', handles.Current_Directory );

    LastdbDirectories = getpref( 'corrui', 'LastdbDirectories', {pwd} );
    % [LastdbDir, order] = setdiff( LastdbDirectories, handles.Current_Directory);
    [~, order] = setdiff( LastdbDirectories, handles.Current_Directory);
    LastdbDirectories = LastdbDirectories(sort(order));
LastdbDirectories = {handles.Current_Directory LastdbDirectories{:}};
setpref( 'corrui', 'LastdbDirectories', LastdbDirectories);

CorruiDB.Open( handles.Current_Directory  );

set( handles.currentdir_popup, 'String', LastdbDirectories );
set( handles.currentdir_popup, 'Value', 1 );
for i=1:length(handles.Enums.Experiment_List)
    handles.Enums.Experiment_List{i}.db = CorruiDB(handles.Current_Directory);
end
for i=1:length(handles.Enums.Experiment_List_Avg)
    handles.Enums.Experiment_List_Avg{i}.db = CorruiDB(handles.Current_Directory);
end

handles = update_session_lists( handles );

% refresh descriptions
handles.textsessdes.String = 'Please select a session...';
handles.textvardes.String = 'Please select a variable...';


%% function  changecurrenttag
function handles = changecurrenttag(handles)

% save the last tag used to reopen properly the GUI
current_tag_value	= get(handles.internaltag_popup,'Value');
setpref('corrui','current_tag_value', current_tag_value);

% refresh session list
handles = update_session_lists(handles);

% refresh descriptions
handles.textsessdes.String = 'Please select a session...';
handles.textvardes.String = 'Please select a variable...';


%% function changeselectedsession
function handles = changeselectedsession( handles )

[current_tag, curr_exp] = CorrGui.get_current_tag( handles );

%  update the variable list
handles = update_variable_list(handles);

% write session description
sessionlist = CorrGui.getSessListString( handles );

if ( ischar( sessionlist) == 1 )
    % try
        
        if ( isempty( strfind(current_tag, 'Avg' )))
            dat = sessdb( 'getsessvars', sessionlist, { 'samplerate',  'isInTrial', 'comment', 'info',...
                'filenames', 'folder', 'date'} );
            if ( ~isfield(dat, 'comment') )
                dat.comment = '';
            end
            date_stage0 = '---';
            date_stage1 = '---';
            date_stage2 = '---';
            if isfield(dat, 'info')
                if ( ~isfield( dat.info, 'import' ) ||  ~isfield( dat.info.import, 'date' ) )
                    dat.info.import.date = 'N/A';
                end
                if isfield(dat.info, 'process_stage_0')
                    if isfield(dat.info.process_stage_0, 'date')
                        date_stage0 = dat.info.process_stage_0.date;
                    end % if
                end % if
                if ( isfield(dat.info, 'process_stage_1') )
                    if ( isfield(dat.info.process_stage_1, 'date') )
                        date_stage1 = dat.info.process_stage_1.date;
                    end
                end
                if ( isfield(dat.info, 'process_stage_2') )
                    if ( isfield(dat.info.process_stage_2, 'date') )
                        date_stage2 = dat.info.process_stage_2.date;
                    end
                end
              
%                 text = sprintf( [...
%                     'Session: %s\n'...
%                     'Imported on: %s\n' ...
%                     'Run Stage 0 on:  %s\n' ...
%                     'Run Stage 1 on:  %s\n' ...
%                     'Run Stage 2 on:  %s\n' ...
%                     'Comment: %s' ...
%                              ] ,...
%                              curr_exp.SessName2UserSessName(sessionlist),...
%                              dat.info.import.date,...
%                              date_stage0, date_stage1, date_stage2,...
%                              dat.comment);
                user_sname = sprintf('Session: %s', curr_exp.SessName2UserSessName(sessionlist));
                imp_date   = sprintf('Imported on: %s', dat.info.import.date);
                stg0_date  = sprintf('Run Stage 0 on:  %s', date_stage0);
                stg1_date  = sprintf('Run Stage 1 on:  %s', date_stage1);
                stg2_date  = sprintf('Run Stage 2 on:  %s', date_stage2);
                comm       = sprintf('Comment: %s', dat.comment);
                text = {user_sname; imp_date;...
                   stg0_date; stg1_date; stg2_date};

            else
                text = sprintf(['No ''info'' information available.\n'...
                     'Comment: %s' ...
                             ], dat.comment);
            end % if
        else
            
            dat = sessdb( 'getsessvars', sessionlist, { 'samplerate', 'sessions' 'comment' 'info'} );
            
            % -- Session description
            % if ( ischar(dat.sessions) )
            %     sessions = dat.sessions;
            % else
            %     sessions = dat.sessions{1};
            %     for i=2:length(dat.sessions)
            %         sessions = [sessions ', ' dat.sessions{i}];
            %     end
            % end
            if ( ~isfield(dat, 'comment') )
                dat.comment = '';
            end
            comm = '';
            %             text = sprintf( 'Session: %s \nFs = %d Hz \nSessions: %s \nComment: %s' ,...
            %                 sessionlist, dat.samplerate, sessions , dat.comment);
            text = sprintf( 'Session: %s \nComment: %s' ,...
                curr_exp.SessName2UserSessName(sessionlist), dat.comment);
        end
        
        % refresh session description
        opt.Width = handles.SessionDescriptionTextWidth;
        % fm_text = formatDescription(text, opt);
        fm_comm = textwrap(handles.textsessdes, {comm}, opt.Width);
        % fm_comm = formatDescription(comm, opt);
        fm_text = cat(1, text, fm_comm);
        set(handles.textsessdes, 'string', fm_text );
        % refresh variable description
        handles = changeselectedvar(handles);
    % catch
    %     set(handles.textsessdes, 'string', 'No description available (TOFIX: changeselectedsession() in corrui.m)' );
    % end
else
    set(handles.textsessdes, 'string', sprintf('%d sessions selected.', numel(sessionlist)));
end

%% function changeselectedvar
function handles = changeselectedvar( handles )

[~, curr_exp] = CorrGui.get_current_tag( handles );
    
tableVarData = get(handles.tableVar,'Data');

if isfield(handles, 'tableVarSelection')
    selectedrow = unique(handles.tableVarSelection.Indices(:,1));
    if selectedrow > size(tableVarData, 1)
        selectedrow = [];
    end % if
else
    selectedrow = [];
end % if

% Show variable description
num_vars = numel(selectedrow);
if num_vars == 0
    handles.textvardes.String = 'Please select a variable...';
elseif num_vars == 1 
    
    varname = tableVarData{selectedrow,1};
    
    val1 = strrep(strrep(varname,'left_',''),'right_','');
    val1 = trim_filter_name(val1,curr_exp);
    
    if isfield(handles.variable_descriptions, val1)
        %         d = '';
        %         for i=1:size(handles.variable_descriptions.(val1) ,1)
        %             d = cat(2, d, '\n', handles.variable_descriptions.(val1)(i,:));
        %         end
        %         % set(handles.textsessdes,'string',sprintf([' %s : \n' d '\n\nAggregate: %s'], val1,handles.variable_aggregate.(val1)));
        %         in_text = sprintf(['Variable - %s \n' d '\n\nAggregate: %s'], val1,handles.variable_aggregate.(val1));
        %         opt.Width = getpref('corrui', 'VariableDescriptionTextWidth');
        %         % fm_text = textwrap(handles.textvardes, {in_text});
        %         fm_text = formatDescription(in_text, opt);
        
        var_name = sprintf('Variable - %s', val1);
        d = handles.variable_descriptions.(val1);
        agg_stat = sprintf('Aggregate: %s', handles.variable_aggregate.(val1));
        fm_text = cat(1, var_name, {''}, d, {''}, agg_stat);
        handles.textvardes.String = fm_text;
    else
        % set(handles.textsessdes,'string','');
        set(handles.textvardes,'string',...
            sprintf('Variable - %s\n\nNo description available', val1));
    end
elseif num_vars > 1
    handles.textvardes.String = sprintf('%d variables selected.', num_vars);
end


%% function import
function handles = import(handles)
% just for one data block, for batch import, see CorrGui.batch_operation

curr_tag = CorrGui.get_current_tag( handles );

newsession = CorrGui.Import( curr_tag );
if ( ~isempty( newsession ) )
    %-- update lists and select the new sessions
    handles = update_session_lists(handles, newsession);
end

%% function plot
function handles = process( handles )
%-- get current tag
[~, curr_exp] = CorrGui.get_current_tag( handles );

%-- get the selected sessions
sessions = CorrGui.getSessListString( handles );

if ischar(sessions), sessions = {sessions}; end

if ( isempty(sessions) )
    msgbox('Select one or more sessions to process','Error');
    return
end
[newsessions, opt] = CorrGui.ShowProcessDlg( curr_exp, sessions, handles.processOptions );
if ( isempty( newsessions ) )
    return
end

%-- commit to handles so we keep the options in the case there is an error
% preocessing
handles.processOptions = opt;

%-- process the sessions
CorrGui.Process( curr_exp, sessions, newsessions, opt);

%-- update lists and select the sessions
handles	= update_session_lists(handles, newsessions);
% refresh session description
handles = changeselectedsession(handles);


%% function plot
function handles = plot( handles )

[~, curr_exp] = CorrGui.get_current_tag( handles );
sessions = CorrGui.getSessListString( handles );

if isempty(sessions)
    cprintf('SystemCommands', 'Please select one or more sessions...\n')
    return
end % if

if ( ischar(sessions) )
    sessions = {sessions};
end

opt = CorrGui.ShowPlotDlg( curr_exp );
if ( isempty( opt ) )
    return;
end

if (opt.Save_Plot)
    CorrGui.SavePlot( opt );
end

CorrGui.Plot( curr_exp, sessions, opt );


% -------------------------------------------------------------------------
% function plotsavedplot
% -------------------------------------------------------------------------
function handles = plotsavedplot( handles )

[~, curr_exp] = CorrGui.get_current_tag( handles );
sessions = CorrGui.getSessListString( handles );

if ( ischar(sessions) )
    sessions = {sessions};
end

saved_plots = getpref('corrui', 'saved_plots' , []);
if isempty(saved_plots) == true
    cprintf('Keywords', 'No saved plots are found.\n')
    return
end % if

saved_plots_names = fieldnames(saved_plots);

if ( isempty( saved_plots_names ) )
    cprintf('Keywords', 'No saved plots are found.\n')
    return
end

for i=1:length(saved_plots_names)
    S.(saved_plots_names{i}) = {{'{0}' '1'}};
end


% show struct dialog to the user
S = StructDlg( S, 'Select Plots to Make', [], CorrGui.get_default_dlg_pos() );
if isempty(S)
    return
end
for i=1:length(saved_plots_names)
    if ( S.(saved_plots_names{i}) )
        CorrGui.Plot( curr_exp, sessions, saved_plots.(saved_plots_names{i}) );
    end
end

% -------------------------------------------------------------------------
% function editsavedplots
% -------------------------------------------------------------------------
function handles = editsavedplots( handles )

saved_plots = getpref('corrui', 'saved_plots' , []);
if isempty(saved_plots) == true
    cprintf('Keywords', 'No saved plots are found.\n')
    return
end % if

saved_plots_names = fieldnames(saved_plots);

if ( isempty( saved_plots_names ) )
    cprintf('Keywords', 'No saved plots are found.\n')
    return
end

for i=1:length(saved_plots_names)
    S.(saved_plots_names{i}) = {{'0' '{1}'}};
end


% show struct dialog to the user
S = StructDlg( S, 'Mark plots you want to delete', [], CorrGui.get_default_dlg_pos() );
if isempty(S)
    return
end
for i=1:length(saved_plots_names)
    if ( S.(saved_plots_names{i}) )
        saved_plots = rmfield(saved_plots, saved_plots_names{i});
    end
end
setpref('corrui',  'saved_plots'  , saved_plots);


% -------------------------------------------------------------------------
% function aggregate
% -------------------------------------------------------------------------
function handles = aggregate( handles )

[~, curr_exp] = CorrGui.get_current_tag( handles );
sessionlist = CorrGui.getSessListString( handles );

if ( isempty(sessionlist) || ~iscell(sessionlist) )
    msgbox('Select more than one sessions to aggregate','Error');
    return
end

opt = CorrGui.ShowAggregateDlg( curr_exp );
if ( isempty( opt ) )
    return
end
newsession = CorrGui.Aggregate( curr_exp, sessionlist , opt );

if ( ~isempty( newsession ) )
    set(handles.chkShowAggregated,'value',1);
    handles = update_session_lists(handles, {newsession});
end

% function plotoptions
function handles = plotoptions( handles )
S = getrawplotstruct( true );
S = StructDlg( S, 'Plot Options', handles.rawPlotOptions,  CorrGui.get_default_dlg_pos()  );
if isempty(S)
    return
end
handles.rawPlotOptions = S;

%% function getrawplotstruct
function S = getrawplotstruct(dialogOrDefaults)
if dialogOrDefaults
    % common yscale, concat, smoothing window
    S.Common_X_Scale = { {'{0}','1'} };
    S.Common_Y_Scale = { {'{0}','1'} };
    S.Smoothing_Window_Width = { {'{None}' '15' '31' '75' '91' '151'} };
    S.Number_Histogram_Bins = { {'{10}' '25' '50' '100' '500' '1000'} };
    S.Manual_Bin_Range = { {'{0}','1'} };
    S.Minimum_Bin = { 0 };
    S.Maximum_Bin = { 10 };
    S.Concatenate_Histogram_Data = { {'{0}','1'} };
else
    S.Common_X_Scale = 0;
    S.Common_Y_Scale = 0;
    S.Smoothing_Window_Width = 'None';
    S.Number_Histogram_Bins = 10;
    S.Manual_Bin_Range = 0;
    S.Minimum_Bin = 0;
    S.Maximum_Bin = 10;
    S.Concatenate_Histogram_Data = 0;
end


%% function deletesession
function handles = deletesession( handles )
res = questdlg(' All the data in the selected sessions will be removed, do you whant to continue?', ...
    'Warning', ...
    'Yes', 'No', 'No');
if ( strcmp(res, 'No') )
    return
end

sessions = CorrGui.getSessListString( handles );

if ( ~iscell( sessions ) )
    sessions = {sessions};
end

for snum = 1:length(sessions)
    se_session = sessdb( 'getsessvar',  sessions{snum}, 'associatedSESession' );
    if ( ~isempty( se_session ) )
        sessdb('remove', se_session );
    end
    sname	= sessions{snum};
    sessdb('remove', sname );
end

handles = update_session_lists(handles);

% refersh GUI
handles = changecurrenttag(handles);


%% function renamesession
function handles = renamesession( handles )

session = CorrGui.getSessListString( handles );

if ( ischar( session ) )
    session = {session};
    %msgbox( 'Only one session could be renamed.' );
end

for i = 1:length(session)
    sname = char(session{i});
    S.(sname) = sname;
end
S = StructDlg( S, 'New session name', [],  CorrGui.get_default_dlg_pos() );
if ( isempty( S ) )
    return;
end

hwait = waitbar(0,'Please wait while sessions are renamed...');
newsessions = {};
for i = 1:length(session)
    old_sname = char(session{i});
    newname = S.(old_sname);
    % newsessions{i} = newname;
    newsessions = cat(2, newsessions, newname);
    
    % get the associated error session
    se_session = sessdb( 'getsessvar', old_sname, 'associatedSESession' );
    
    % rename the session
    if ( ~strcmp(old_sname, newname) )
        sessdb( 'copysess', old_sname, newname );
        sessdb( 'remove', old_sname);
    end
    % rename the associated error session
    if ( ~isempty( se_session ) )
        new_se_session = strrep(se_session, old_sname(5:end), newname(5:end));
        sessdb( 'copysess', se_session, new_se_session );
        sessdb( 'remove', se_session);
        
        dat.Associated_AVG_String = new_se_session;
        sessdb( 'add', newname, dat);
    end
        
    waitbar(i/length(session),hwait);
    drawnow
end
close(hwait);


handles = update_session_lists(handles, newsessions);


%% function copysession
function handles = copysession( handles )

session = CorrGui.getSessListString( handles );

if ( ~ischar( session ) )
    msgbox( 'Only one session could be renamed.' );
end

S.New_Session_Name = session;
S = StructDlg( S, 'Copy sessionNew session name', [],  CorrGui.get_default_dlg_pos() );
if ( isempty( S ) )
    return;
end

newname = S.New_Session_Name;

% get the associated error session
se_session = sessdb( 'getsessvar', session, 'associatedSESession' );

% rename the session
if ( ~strcmp(session, newname) )
    sessdb( 'copysess', session, newname );
end
% rename the associated error session
if ( ~isempty( se_session ) )
    new_se_session = strrep(se_session, session(5:end), newname(5:end));
    sessdb( 'copysess', se_session, new_se_session );
    
    dat.Associated_AVG_String = new_se_session;
    sessdb( 'add', newname, dat);
end

handles = update_session_lists(handles, newname);


%% function copysessionto 
function handles = copysessionto( handles )

old_path = pwd;
start_folder = getpref('corrui', 'copysessionto_directory', old_path);
% if not exist, use current directory
if(~exist(start_folder,'dir'))
    start_folder = old_path;
end % if

folder = uigetdir(start_folder, 'Destination folder');
if ( folder == 0 )
    return
end
% save folder in prefs
setpref('corrui', 'copysessionto_directory', folder);

sessions = CorrGui.getSessListString( handles );

if ( ~iscell( sessions ) )
    sessions = {sessions};
end

nsess = length(sessions);
h = waitbar(0, 'Copying sessions to...');
for snum = 1:nsess
    waitbar(snum / nsess);
    sname	= sessions{snum};
    se_session = sessdb( 'getsessvar', sname, 'associatedSESession' );
    if ( ~isempty( se_session ) )
        sessdb('copysessto', se_session, folder );
    end
    sessdb('copysessto', sname, folder );
end
close(h)

handles = update_session_lists(handles, sessions);


%% function movesession
function handles = movesession( handles )

old_path = pwd;
start_folder = getpref('corrui', 'movesessionto_directory', old_path);
% if not exist, use current directory
if(~exist(start_folder,'dir'))
    start_folder = old_path;
end % if

folder = uigetdir(start_folder, 'Destination folder');
if ( folder == 0 )
    return
end
% save folder in prefs
setpref('corrui', 'movesessionto_directory', folder);

sessions = CorrGui.getSessListString( handles );

nsess = length(sessions);
h = waitbar(0, 'Moving sessions to ...');
if ( ~iscell( sessions ) )
    waitbar(1 / nsess)
    sessdb('movesessto', sessions, folder );
else
    for snum = 1:nsess
        waitbar(snum / nsess)
        sname	= sessions{snum};
        se_session = sessdb( 'getsessvar', sname, 'associatedSESession' );
        if ( ~isempty( se_session ) )
            sessdb('movesessto', se_session, folder );
        end
        sessdb('movesessto', sname, folder );
    end
end
close(h)

handles = update_session_lists(handles, sessions);

%% function addvar
function handles = addvar( handles )

varlist = { handles.Variable_List{handles.tableVarSelection.Indices(:,1)} };

session = CorrGui.getSessListString( handles );

if ( ~ischar(session) )
    for j=1:length(session)
        sess = char(session{j});
        for i=1:length(varlist)
            if ( ischar(varlist) )
                var = varlist;
            else
                var = varlist{i};
            end
            dat = sessdb( 'getsessvar', sess, var );
            assignin('base', [sess '_' var], dat);
        end
    end
    % 	msgbox('Only one session could be selected');
    % 	return
else
    for i=1:length(varlist)
        if ( ischar(varlist) )
            var = varlist;
        else
            var = varlist{i};
        end
        dat = sessdb( 'getsessvar', session, var );
        assignin('base', var, dat);
    end
end
handles = update_variable_list(handles);


%% function remvars
function handles = remvars( handles )
res = questdlg(' The selected variables will be removed, do you whant to continue?', ...
    'Warning', ...
    'Yes', 'No', 'No');
if ( strcmp(res, 'No') )
    return
end

session = CorrGui.getSessListString( handles );

% if ( ~ischar(session) )
%     msgbox('Only one session could be selected');
%     return
% end

if ischar(session)
    session = {session};
end % if

varlist = { handles.Variable_List{handles.tableVarSelection.Indices(:,1)} };

for k = 1:numel(session)
    sess_k = session{k};
    sessdb( 'remsessvars', sess_k, varlist );
end % for

%  update the variable list
handles = update_variable_list(handles);


%% function importvar
function handles = importvar( handles )

% S.Variable_name = {''};
% S = StructDlg(S,'Import variable', [], CorrGui.get_default_dlg_pos() );

vars = evalin('base', 'whos');
N = length(vars);
if N == 1
    var_names = vars.name;
else
var_names = {};
for k = 1:N
    var_names_k = vars(k).name;
    if k == 1
        var_names_k = strcat('{', var_names_k, '}');
    end % if
    var_names = cat(2, var_names, var_names_k);
end % for
end % if
V.Variable_name = {var_names, 'Select variable'};
S = StructDlg(V,'Import variable', [], CorrGui.get_default_dlg_pos() );


if ( ~isempty(S) )
    dat.(S.Variable_name) = evalin('base', S.Variable_name);
    
    sessions = CorrGui.getSessListString( handles );

    if ( ~iscell( sessions ) )
        sessions = {sessions};
    end
    for snum = 1:length(sessions)
        sname	= sessions{snum};
        sessdb( 'add', sname, dat );
    end
%     % set the GUI?
%     internaltag_popup_Callback(hObject, eventdata, handles);
%  update the variable list
handles = update_variable_list(handles);

end


%% function addcomment
function handles = addcomment( handles )

[~, curr_exp] = CorrGui.get_current_tag(handles);
session = CorrGui.getSessListString( handles );

if ( ~ischar( session ) )
    msgbox( 'Please select one session only.', 'Add Comment', 'Warn' )
    return
end

comment = sessdb('getsessvar', session, 'comment');

dlg_name = [curr_exp.prefix, ' Comments'];
user_sname = curr_exp.SessName2UserSessName(session);

% initialze the editor
% ---------------------
default_dlg_pos = CorrGui.get_default_dlg_pos();
if ~isempty(default_dlg_pos)
    ul_pos = default_dlg_pos(1:2);
else
    ul_pos = [];
end % if
dat.UpperLeftCorner = ul_pos;
dat.UserSessName    = user_sname;
dat.SessName        = session;
dat.LastComment     = comment;
dat.CorrguiHandles  = handles;
exp_comment_editor('Name', dlg_name, dat);


%% function cleardata
function handles = cleardata( handles, stage )

warnstr = sprintf('Data produced in Stage %g analysis will be deleted, do you whant to continue?', stage);
res = questdlg(warnstr , 'Warning', 'Yes', 'No', 'No');
if ( strcmp(res, 'No') )
    return
end

sessions = CorrGui.getSessListString( handles );

if ( ~iscell( sessions ) )
    sessions = {sessions};
end

for snum = 1:length(sessions)
    sname = sessions{snum};
    
    info = CorruiDB.Getsessvar( sname, 'info' );
    if ( isempty( info) || ~isfield( info, 'import') || ~isfield( info.import, 'variables') )
        continue
    end
    all_vars = CorruiDB.GetVarNamesForSession(sname);
    switch( stage )
        case 0 % Stage 0, process events
            if ( ~isfield( info, 'process_stage_0') || ~isfield( info.process_stage_0, 'variables' ) )
                continue
            end
            stage_0_vars = info.process_stage_0.variables;
            CorruiDB.Remsessvars( sname, stage_0_vars);
            % remove name in the lock list
            lock = CorruiDB.Getsessvar(sname, 'lock');
            s = intersect(lock, stage_0_vars);
            dat.lock = setdiff(lock, s);
            CorruiDB.Addsessvars(sname, dat, 'unlock');
        case 1 % Stage 1
            if ( ~isfield( info, 'process_stage_1') || ~isfield( info.process_stage_1, 'variables' ) )
                continue
            end
            stage_1_vars = info.process_stage_1.variables;
            CorruiDB.Remsessvars( sname, stage_1_vars );
            % remove name in the lock list
            lock = CorruiDB.Getsessvar(sname, 'lock');
            s = intersect(lock, stage_1_vars);
            dat.lock = setdiff(lock, s);
            CorruiDB.Addsessvars(sname, dat, 'unlock');
        case 2 % stage 2
            if ( ~isfield( info, 'process_stage_0') || ~isfield( info.process_stage_0, 'variables' ) )
                continue
            end
            if ( ~isfield( info, 'process_stage_1') || ~isfield( info.process_stage_1, 'variables' ) )
                continue
            end
            import_vars = info.import.variables;
            process_stage_0_vars = info.process_stage_0.variables;
            process_stage_1_vars = info.process_stage_1.variables;
            
            % stage 2 variables are all the variables minus the variables
            % of import, process_stage_0 and process_stage_1
            stage2_vars = setdiff(all_vars, union(process_stage_1_vars, union(import_vars, process_stage_0_vars)));
            stage2_vars = setdiff( stage2_vars, 'internalTag' );
            CorruiDB.Remsessvars( sname, stage2_vars );
    end
    % eliminate the date of last processing
    info.(sprintf('process_stage_%d', stage)).date = '---';
    info.(sprintf('process_stage_%d', stage)).variables = {};
    dat.info = info;
    CorruiDB.Addsessvars( sname, dat, 'unlock')
end

% refresh session description
handles = update_variable_list(handles);
handles = changeselectedsession( handles );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -- Calbacks ------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function seldir_Callback(hObject, eventdata, handles)
handles = changedirdb(handles);
guidata( hObject, handles );

function currentdir_popup_Callback(hObject, eventdata, handles)
handles = changedirdbpopup(handles);
guidata( hObject, handles );

function internaltag_popup_Callback(hObject, eventdata, handles)
handles = changecurrenttag(handles);

% update exp-dependent menus
if strcmpi(hObject.Tag, 'internaltag_popup') == true
    handles = updateCurrentMenus(handles);
end % if

guidata( handles.internaltag_popup, handles);

function chkShowAggregated_Callback(hObject, eventdata, handles)

handles = update_session_lists(handles);

guidata( handles.internaltag_popup, handles);

function sessionlistbox_Callback(hObject, eventdata, handles)
handles = changeselectedsession( handles );
guidata(hObject,handles);

function tableVar_CellSelectionCallback(hObject, eventdata, handles)
handles.tableVarSelection = eventdata;
handles = changeselectedvar( handles );
guidata( handles.internaltag_popup, handles);

function txtFilter_Callback(hObject, eventdata, handles)
% get(hObject,'string');
handles = update_variable_list(handles);
guidata(hObject, handles);

function txtFilter_KeyPressFcn(hObject, eventdata, handles)

function butImport_Callback(hObject, eventdata, handles)
handles = import(handles);
guidata(hObject, handles);

function process_button_Callback(hObject, eventdata, handles)
handles = process( handles );
guidata(hObject, handles);

function plot_button_Callback(hObject, eventdata, handles)
handles = plot( handles );
guidata(hObject, handles);

function aggregate_button_Callback(hObject, eventdata, handles)
handles = aggregate( handles );guidata(hObject, handles);
guidata(hObject, handles);

function combine_button_Callback(hObject, eventdata, handles)
handles = combine( handles );
guidata(hObject, handles);

function buttonplotvariable_Callback(hObject, eventdata, handles)
CorrGui.plot_raw( handles, get(hObject, 'tag') );

function buttonplotgroupsession_Callback(hObject, eventdata, handles)
CorrGui.plot_raw( handles, get(hObject, 'tag') );

function buttonplotgroupvariables_Callback(hObject, eventdata, handles)
CorrGui.plot_raw( handles, get(hObject, 'tag') );

function buttonplotgroupall_Callback(hObject, eventdata, handles)
CorrGui.plot_raw( handles, get(hObject, 'tag') );

function pushbuttonPlotOptions_Callback(hObject, eventdata, handles)
handles = plotoptions( handles );
guidata(hObject,handles);

% -------------------------------------------------------------------------
%% == Session list context menu callbacks
% -------------------------------------------------------------------------
function ctxmenuSessionDelete_Callback(hObject, eventdata, handles)
handles = deletesession( handles );
guidata(hObject, handles);

function ctxmnuRenameSession_Callback(hObject, eventdata, handles)
handles = renamesession( handles );
guidata(hObject, handles);

function ctxmnuCopySession_Callback(hObject, eventdata, handles)
handles = copysession( handles );
guidata(hObject, handles);

function ctxmnuCopySessionTo_Callback(hObject, eventdata, handles)
handles = copysessionto( handles );
guidata(hObject, handles);

function ctxmnuMoveSessionTo_Callback(hObject, eventdata, handles)
handles = movesession( handles );
guidata(hObject, handles);

function ctxmnuAddComment_Callback(hObject, eventdata, handles)
handles = addcomment( handles );
guidata(hObject, handles);

function ctxmnuClearStage0Data_Callback(hObject, eventdata, handles)
handles = cleardata( handles, 0 );
guidata(hObject, handles);

function ctxmnuClearStage1Data_Callback(hObject, eventdata, handles)
handles = cleardata( handles, 1 );
guidata(hObject, handles);

function ctxmnuClearStage2Data_Callback(hObject, eventdata, handles)
handles = cleardata( handles, 2 );
guidata(hObject, handles);

% -------------------------------------------------------------------------
%% == Variable list context menu callbacks
% -------------------------------------------------------------------------
function ctxmnuAddVariables_Callback(hObject, eventdata, handles)
handles = addvar( handles );
guidata(hObject, handles);

function ctxmnuRemoveVariables_Callback(hObject, eventdata, handles)
handles = remvars( handles );
guidata(hObject, handles);

function ctxmnuVarlistImportVariable_Callback(hObject, eventdata, handles)
handles = importvar( handles );
guidata(hObject, handles);


% -------------------------------------------------------------------------
%% == Main menu callbacks
% -------------------------------------------------------------------------
function mnuSPLImport_Callback(hObject, eventdata, handles)
handles = import( handles );
guidata(hObject, handles);

function mnuRunProcess_Callback(hObject, eventdata, handles)
handles = process(handles);
guidata( handles.internaltag_popup, handles);

function mnuSPLExit_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSPLExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection = questdlg(['Close ' get(handles.CorruiGUI,'Name') '?'],...
                     'Exit SPL...',...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return
end

delete(handles.CorruiGUI)


% -------------------------------------------------------------------------
%% == Toolbar callbacks
% -------------------------------------------------------------------------

function toolbarOpenDB_ClickedCallback(hObject, eventdata, handles)
handles = changedirdb(handles);
guidata( hObject, handles );

function toolbarImport_ClickedCallback(hObject, eventdata, handles)
handles = import(handles);
guidata( hObject, handles );
    
function toolbarRun_ClickedCallback(hObject, eventdata, handles)
handles = process(handles);
guidata( handles.internaltag_popup, handles);

function toolbarPlot_ClickedCallback(hObject, eventdata, handles)
handles = plot(handles);
guidata( handles.internaltag_popup, handles);

function toolbarAggregate_ClickedCallback(hObject, eventdata, handles)
handles = aggregate(handles);
guidata( handles.internaltag_popup, handles);

% --------------------------------------------------------------------
function mnuToolsConfig_Callback(hObject, eventdata, handles)
% hObject    handle to mnuToolsConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnuVar_Callback(hObject, eventdata, handles)
% hObject    handle to mnuVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function main_variable_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to main_variable_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function mnuVarPlot_Callback(hObject, eventdata, handles)
% hObject    handle to mnuVarPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plot(handles);
guidata( handles.internaltag_popup, handles);


% --------------------------------------------------------------------
function mnuRunAggregate_Callback(hObject, eventdata, handles)
% hObject    handle to mnuRunAggregate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = aggregate(handles);
guidata( handles.internaltag_popup, handles);


% --------------------------------------------------------------------
function mnuVarDesEditor_Callback(hObject, eventdata, handles)
% hObject    handle to mnuVarDesEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
corrui_variable_db_editor


% --------------------------------------------------------------------
function mnuRunBatchOperation_Callback(hObject, eventdata, handles)
% hObject    handle to mnuRunBatchOperation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% RJC, Fri 04/19/2013  4:58:02.770 PM
%-- get current tag
current_tag = CorrGui.get_current_tag( handles );

newsessions = CorrGui.batch_operation( current_tag );

%-- update lists
if ~isempty(newsessions)
    handles = update_session_lists(handles, newsessions);
else
    handles = update_session_lists(handles);
end % if
guidata(hObject, handles);


% --- Executes on button press in pushbuttonOpenDB.
function pushbuttonOpenDB_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOpenDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = changedirdb(handles);
guidata( hObject, handles );


% --------------------------------------------------------------------
function mnuVarPlotSavedPlot_Callback(hObject, eventdata, handles)
% hObject    handle to mnuVarPlotSavedPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = plotsavedplot( handles );
guidata( hObject, handles );


% --------------------------------------------------------------------
function mnuVarEditSavedPlot_Callback(hObject, eventdata, handles)
% hObject    handle to mnuVarEditSavedPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = editsavedplots( handles );
guidata(hObject, handles);



function textsessdes_Callback(hObject, eventdata, handles)
% hObject    handle to textsessdes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textsessdes as text
%        str2double(get(hObject,'String')) returns contents of textsessdes as a double


% --- Executes during object creation, after setting all properties.
function textsessdes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textsessdes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close CorruiGUI.
function CorruiGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to CorruiGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --------------------------------------------------------------------
function mnuAbout_Callback(hObject, eventdata, handles)
% hObject    handle to mnuAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msgbox({'jLab (0.2.090816)',...
        '',...
        sprintf('(c) Richard Jie Cui 2009 - %s', datestr(now, 'yyyy')),...
        'Contact: richard.jie.cui@gmail.com'}, 'About jLab', 'help')



function sessFilter_Callback(hObject, eventdata, handles)
% hObject    handle to sessFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sessFilter as text
%        str2double(get(hObject,'String')) returns contents of sessFilter as a double

handles = update_session_lists(handles);
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function sessFilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
