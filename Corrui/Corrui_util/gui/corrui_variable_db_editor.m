function varargout = corrui_variable_db_editor(varargin)
% CORRUI_VARIABLE_DB_EDITOR M-file for corrui_variable_db_editor.fig
%      CORRUI_VARIABLE_DB_EDITOR, by itself, creates a new CORRUI_VARIABLE_DB_EDITOR or raises the existing
%      singleton*.
%
%      H = CORRUI_VARIABLE_DB_EDITOR returns the handle to a new CORRUI_VARIABLE_DB_EDITOR or the handle to
%      the existing singleton*.
%
%      CORRUI_VARIABLE_DB_EDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CORRUI_VARIABLE_DB_EDITOR.M with the given input arguments.
%
%      CORRUI_VARIABLE_DB_EDITOR('Property','Value',...) creates a new CORRUI_VARIABLE_DB_EDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before corrui_variable_db_editor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to corrui_variable_db_editor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help corrui_variable_db_editor

% Last Modified by RJC on Fri 04/10/2020  4:37:12.924 PM

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @corrui_variable_db_editor_OpeningFcn, ...
                   'gui_OutputFcn',  @corrui_variable_db_editor_OutputFcn, ...
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


% --- Executes just before corrui_variable_db_editor is made visible.
function corrui_variable_db_editor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to corrui_variable_db_editor (see VARARGIN)

% Choose default command line output for corrui_variable_db_editor

handles.output = hObject;

% GUI
% ----
% editor name
hObject.Name = 'jLab - Variable Editor';

% set scrolling in variable table
jscrollpane = findjobj(handles.uitablevar);
jtable = jscrollpane.getViewport.getView;
jtable.setSortable(true);		% or: set(jtable,'Sortable','on');
jtable.setAutoResort(true);
jtable.setMultiColumnSortable(true);
jtable.setPreserveSelectionsAfterSorting(true);

% fill the tables
currpath = mfilename('fullpath');
if ( exist([currpath '.mat'],'file') )
    load([currpath '.mat'], 'data', 'descriptions');
    set(handles.uitablevar,'Data',data);
    handles.descriptions = descriptions;
end

% description editor
if ismac == true
    handles.txtDescription.FontSize = 11;
elseif ispc == true
    handles.txtDescription.FontSize = 8;
end % if

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes corrui_variable_db_editor wait for user response (see UIRESUME)
% uiwait(handles.corr_var_db_edit_fig);


% --- Outputs from this function are returned to the command line.
function varargout = corrui_variable_db_editor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in butSave.
function butSave_Callback(hObject, eventdata, handles)
% hObject    handle to butSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global column
%global full_data
data = get(handles.uitablevar,'Data');
descriptions = handles.descriptions;
if ( size(data,1) ~= size(descriptions,1) )
    error( 'The database is corrupted')
end

currpath = mfilename('fullpath');
save([currpath '.mat'], 'data', 'descriptions');



function txtDescription_Callback(hObject, eventdata, handles)
% hObject    handle to txtDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtDescription as text
%        str2double(get(hObject,'String')) returns contents of txtDescription as a double
global column;

handles.descriptions{column}=get(handles.txtDescription,'string');
% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in butAdd.
function butAdd_Callback(hObject, eventdata, handles)
% hObject    handle to butAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = get(handles.uitablevar,'Data');
data = cat(1,data,{ 'New Variable', false, '', 'No'} );
handles.descriptions{end+1} = {};
set(handles.uitablevar,'Data',data)

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in butDelete.
function butDelete_Callback(hObject, eventdata, handles)
% hObject    handle to butDelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global column

data = get(handles.uitablevar,'Data');
if ( ~isempty( data ) )
    data(column,:)=[];
    handles.descriptions(column) = [];
    set(handles.uitablevar,'Data',data);
end

% Update handles structure
guidata(hObject, handles);

% --- Executes when selected cell(s) is changed in uitablevar.
function uitablevar_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitablevar (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

global column 

data = get(handles.uitablevar,'Data');
if ( ~isempty(eventdata.Indices) )
    % column = eventdata.Indices(1);
    column = eventdata.Indices(:, 1);
    
    % set(handles.lblVariable,'string',data{eventdata.Indices(1),1})
    handles.lblVariable.String = sprintf('Description of %s',data{eventdata.Indices(1),1});
    
    set(handles.txtDescription,'Enable','on')
    description = handles.descriptions{eventdata.Indices(1)};
    set(handles.txtDescription,'string',description);
else
    set(handles.txtDescription,'Enable','off')
end
% Update handles structure
guidata(hObject, handles);
    

% --- Executes when user attempts to close corr_var_db_edit_fig.
function corr_var_db_edit_fig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to corr_var_db_edit_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject)


% --- Executes on button press in pushbuttonclose.
function pushbuttonclose_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonclose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice = questdlg('Do you want to save before exiting?', ...
	'Closing form', 'Yes','No','Cancel', 'Cancel');
% Handle response
switch choice
    case 'Yes'
        butSave_Callback(hObject, eventdata, handles);   
    case 'No'
        disp('');
    case 'Cancel'
        return;  
end

% Hint: delete(hObject) closes the figure
delete(handles.corr_var_db_edit_fig)
