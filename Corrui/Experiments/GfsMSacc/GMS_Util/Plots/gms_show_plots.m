function varargout = gms_show_plots(varargin)
% GMS_SHOW_PLOTS MATLAB code for gms_show_plots.fig
%      GMS_SHOW_PLOTS, by itself, creates a new GMS_SHOW_PLOTS or raises the existing
%      singleton*.
%
%      H = GMS_SHOW_PLOTS returns the handle to a new GMS_SHOW_PLOTS or the handle to
%      the existing singleton*.
%
%      GMS_SHOW_PLOTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GMS_SHOW_PLOTS.M with the given input arguments.
%
%      GMS_SHOW_PLOTS('Property','Value',...) creates a new GMS_SHOW_PLOTS or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gms_show_plots_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gms_show_plots_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gms_show_plots

% Last Modified by GUIDE v2.5 17-Aug-2016 10:43:30

% Copyright 2016 Richard J. Cui. Created: Sun 08/03/2016 10:02:09.478 AM
% $Revision: 0.5 $  $Date: Thu 12/08/2016 10:02:43.246 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gms_show_plots_OpeningFcn, ...
                   'gui_OutputFcn',  @gms_show_plots_OutputFcn, ...
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

% --- Executes just before gms_show_plots is made visible.
function gms_show_plots_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gms_show_plots (see VARARGIN)

% Choose default command line output for gms_show_plots
handles.output = hObject;

handles = initialize_gui(hObject, handles, varargin{:});
if isempty(handles.hplot)
    hObject.Visible = 'off';
end % if

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes gms_show_plots wait for user response (see UIRESUME)
% uiwait(handles.showplots);

% --- Outputs from this function are returned to the command line.
function varargout = gms_show_plots_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.hplot;

% --- Executes when selected object changed in condgroup.
function condgroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in condgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if hObject == handles.radsubjdisp
    handles.condition = 'SubjDisp';
    max_ntrl = handles.max_ntrl_subjdisp;
elseif hObject == handles.radsubjnodisp
    handles.condition = 'SubjNoDisp';
    max_ntrl = handles.max_ntrl_subjnodisp;    
else
    msgbox('This condition does''t apply.', 'Warn Condition', 'warn')
    return
end
% update trial number popupmenau
trl_str = textscan(num2str(1:max_ntrl), '%s');
value = 1;
handles.poptrlnum.String = [trl_str{1}; 'All'];
handles.poptrlnum.Value = value;
handles.trial = trl_str{1}{value};

% update handles
guidata(hObject, handles)

% --------------------------------------------------------------------
function handles = initialize_gui(fig_handle, handles, varargin)

% parse inputs
% ------------
curr_plot = varargin{1}; % object of GfsMSaccPlots
curr_exp  = varargin{2}; % object of GfsMSacc (GMS) experiment
sname     = varargin{3}; % session name
dat_var   = varargin{4}; % 
filter    = varargin{5};
prep_plot_data   = varargin{6};
show_plot = varargin{7};
update_plot_data = varargin{8};

% update figure title
% -------------------
name_str = sprintf('Show Plot - %s - %s', curr_exp.prefix,...
    curr_exp.SessName2UserSessName(sname));
fig_handle.Name = name_str;

% initialize condition
% --------------------
condition = 'SubjDisp';
set(handles.condgroup, 'SelectedObject', handles.radsubjdisp);

% initialize trial
% ----------------
exp_trl = GMSTrial(curr_exp, sname);
max_ntrl_subjdisp   = exp_trl.SubjDispTrialNumber;
max_ntrl_subjnodisp = exp_trl.SubjNoDispTrialNumber;
max_ntrl_physdisp   = exp_trl.PhysDispTrialNumber;

value = 1;
trl_str = textscan(num2str(1:max_ntrl_subjdisp), '%s');
handles.poptrlnum.String = [trl_str{1}; 'All'];
handles.poptrlnum.Value = value;
trial = trl_str{1}{value};

% update plot
% -----------
plotdat = prep_plot_data(sname, dat_var, condition, trial, filter);
hplot = show_plot(curr_exp, sname, plotdat);

if ~isempty(hplot)
    h_explorer = hplot.Explorer;
    expl_handles = guidata(h_explorer);
    expl_handles.text.info.Visible = 'on';
    info = sprintf('Condition: %s, Trial: %s', condition, trial);
    microsaccade_explorer('update_textinfo', expl_handles, info)
end % if

% Update handles structure
% ------------------------
handles.curr_plot = curr_plot;
handles.curr_exp  = curr_exp;
handles.sname     = sname;
handles.dat_var   = dat_var;
handles.condition = condition;
handles.trial     = trial;
handles.filter    = filter;
handles.prep_plot_data = prep_plot_data;
handles.show_plot = show_plot;
handles.update_plot_data = update_plot_data;
handles.hplot     = hplot;
handles.max_ntrl_subjdisp   = max_ntrl_subjdisp;
handles.max_ntrl_subjnodisp = max_ntrl_subjnodisp;
handles.max_ntrl_physdisp   = max_ntrl_physdisp;

guidata(fig_handle, handles);

% --- Executes on button press in pushapply.
function pushapply_Callback(hObject, eventdata, handles)
% hObject    handle to pushapply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get the condition and trial
condition = handles.condition;
trial = handles.trial;
% update plot data
update_plot_data = handles.update_plot_data;
update_plot_data(hObject, eventdata, handles, condition, trial);
% update scroll up plot
h_explorer = handles.hplot.Explorer;
expl_handles = guidata(h_explorer);
microsaccade_explorer('mainplot_Callback', h_explorer, eventdata, expl_handles)

% --- Executes on selection change in poptrlnum.
function poptrlnum_Callback(hObject, eventdata, handles)
% hObject    handle to poptrlnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns poptrlnum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from poptrlnum
trl_str = handles.poptrlnum.String;
handles.trial = trl_str{handles.poptrlnum.Value};

% update handles
guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function poptrlnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to poptrlnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushcloseall.
function pushcloseall_Callback(hObject, eventdata, handles)
% hObject    handle to pushcloseall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.hplot)
    % close scroll up window
    delete(handles.hplot.Scrollup)
    
    % close eye movement explorer
    delete(handles.hplot.Explorer)
end % if

% close GMS show plot
delete(handles.showplots)
