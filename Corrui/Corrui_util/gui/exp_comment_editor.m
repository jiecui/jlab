function varargout = exp_comment_editor(varargin)
% EXP_COMMENT_EDITOR MATLAB code for exp_comment_editor.fig
%      EXP_COMMENT_EDITOR, by itself, creates a new EXP_COMMENT_EDITOR or raises the existing
%      singleton*.
%
%      H = EXP_COMMENT_EDITOR returns the handle to a new EXP_COMMENT_EDITOR or the handle to
%      the existing singleton*.
%
%      EXP_COMMENT_EDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXP_COMMENT_EDITOR.M with the given input arguments.
%
%      EXP_COMMENT_EDITOR('Property','Value',...) creates a new EXP_COMMENT_EDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before exp_comment_editor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to exp_comment_editor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exp_comment_editor

% Last Modified by GUIDE v2.5 06-Aug-2016 16:07:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exp_comment_editor_OpeningFcn, ...
                   'gui_OutputFcn',  @exp_comment_editor_OutputFcn, ...
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


% --- Executes just before exp_comment_editor is made visible.
function exp_comment_editor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to exp_comment_editor (see VARARGIN)

% initialize the comment dialog window
% ------------------------------------
hObject.WindowStyle = 'normal';
dat = varargin{3};
ul_pos = dat.UpperLeftCorner;
user_sname = dat.UserSessName;
session = dat.SessName;
lastcomm = dat.LastComment;
corrgui_handles = dat.CorrguiHandles;

p = hObject.Position;
if ~isempty(ul_pos)
    win_p = [ul_pos, p(3:4)];
else
    win_p = p;
end % if
hObject.Position = win_p;

% initialize session label
% -------------------------
handles.textsessionname.String = user_sname;

% initialize editor box
% ---------------------
handles.editcomment.String = lastcomm;
handles.lastcomment = lastcomm;

% others
% -------
handles.session = session;
handles.corruigui_handles = corrgui_handles;

% Choose default command line output for exp_comment_editor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes exp_comment_editor wait for user response (see UIRESUME)
% uiwait(handles.exp_comm_edit_fig);


% --- Outputs from this function are returned to the command line.
function varargout = exp_comment_editor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editcomment_Callback(hObject, eventdata, handles)
% hObject    handle to editcomment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editcomment as text
%        str2double(get(hObject,'String')) returns contents of editcomment as a double


% --- Executes during object creation, after setting all properties.
function editcomment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editcomment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonclose.
function pushbuttonclose_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonclose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newcomm = handles.editcomment.String;
% S.Comment = {newcomm};
dat.comment = newcomm;
session = handles.session;
sessdb('add', session, dat);

% close the editor
delete(handles.exp_comm_edit_fig)

% refresh experiment description
corruigui_handles = handles.corruigui_handles;
corrui('changeselectedsession', corruigui_handles )


% --- Executes on button press in pushbuttoncancel.
function pushbuttoncancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttoncancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

last_comm = handles.lastcomment;
new_comm = handles.editcomment.String;
if strcmpi(last_comm, new_comm) == true     % no changes
    delete(handles.exp_comm_edit_fig)
else
    choice = questdlg('Save changes?',...
        'Cancel Comment',...
        'Yes', 'No', 'Cancel', 'Yes');
    switch choice
        case 'Yes'
            pushbuttonclose_Callback(hObject, eventdata, handles)
        case 'No'
            delete(handles.exp_comm_edit_fig)
        case 'Cancel'
            
    end % switch
end % if


% --- Executes when user attempts to close exp_comm_edit_fig.
function exp_comm_edit_fig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to exp_comm_edit_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in pushbuttonsave.
function pushbuttonsave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

comm = handles.editcomment.String;
handles.lastcomment = comm;

dat.comment = comm;
session = handles.session;
sessdb('add', session, dat);

% refresh change indicator
last_sess_label = handles.textsessionname.String;
% check if it is already marked
if strcmp(last_sess_label(end), '*') == true    % already marked, need to remove the marker
    new_sess_label = last_sess_label(1:end-1);
    handles.textsessionname.String = new_sess_label;
end % if

% refresh experiment description
corruigui_handles = handles.corruigui_handles;
corrui('changeselectedsession', corruigui_handles )

guidata(handles.exp_comm_edit_fig, handles)


% --- Executes on key press with focus on editcomment and none of its controls.
function editcomment_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editcomment (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

last_comm = handles.lastcomment;
new_comm = handles.editcomment.String;
if strcmpi(last_comm, new_comm) == false     % comments are changed
    % indicate the change in the session label
    last_sess_label = handles.textsessionname.String;
    % check if it is already marked
    if strcmp(last_sess_label(end), '*') == false    % not labeled
        new_sess_label = [last_sess_label, '*'];
        handles.textsessionname.String = new_sess_label;
    end % if
end % if
