function varargout = movieTracePlayer(varargin)
% MOVIETRACEPLAYER M-file for movieTracePlayer.fig
%      MOVIETRACEPLAYER, by itself, creates a new MOVIETRACEPLAYER or raises the existing
%      singleton*.
%
%      H = MOVIETRACEPLAYER returns the handle to a new MOVIETRACEPLAYER or the handle to
%      the existing singleton*.
%
%      MOVIETRACEPLAYER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOVIETRACEPLAYER.M with the given input arguments.
%
%      MOVIETRACEPLAYER('Property','Value',...) creates a new MOVIETRACEPLAYER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before movieTracePlayer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to movieTracePlayer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help movieTracePlayer

% Last Modified by GUIDE v2.5 12-Feb-2010 18:07:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @movieTracePlayer_OpeningFcn, ...
                   'gui_OutputFcn',  @movieTracePlayer_OutputFcn, ...
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


% --- Executes just before movieTracePlayer is made visible.
function movieTracePlayer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to movieTracePlayer (see VARARGIN)

% Choose default command line output for movieTracePlayer
handles.output = hObject;





handles.imgfolder   = varargin{1};
handles.imgname     = varargin{2};
handles.nframes     = varargin{3};
handles.x           = varargin{4};
handles.y           = varargin{5};

set(handles.sldTime,'SliderStep',[1/handles.nframes 10/handles.nframes]);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes movieTracePlayer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = movieTracePlayer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in butPlay.
function butPlay_Callback(hObject, eventdata, handles)
% hObject    handle to butPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = 0;
j =1;
while ( value < .85 )
    value = get(handles.sldTime,'value');
    set(handles.sldTime,'value', value + 1/handles.nframes)
    updateimage(handles)
    drawnow
    a = getframe(handles.axes1);
    if (isequal(size(a.cdata),[324 584 3]) )
        M(j) = getframe(handles.axes1);
    j=j+1;
    end
end

movie(M,1) % Play the movie twenty times

% --- Executes on button press in butPause.
function butPause_Callback(hObject, eventdata, handles)
% hObject    handle to butPause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function sldTime_Callback(hObject, eventdata, handles)
% hObject    handle to sldTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


updateimage(handles)



% --- Executes during object creation, after setting all properties.
function sldTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function updateimage(handles)

set(handles.axes1,'nextplot','replacechildren')
currentframe = max(get(handles.sldTime,'value')*handles.nframes,1);
imgfile = sprintf('%s\\%s %0.3d.jpg',handles.imgfolder,handles.imgname, floor(currentframe));
I = imread(imgfile);
imshow(I,'parent',handles.axes1);
set(handles.axes1,'nextplot','add')
set(handles.axes1,'XLimMode','manual');
set(handles.axes1,'YLimMode','manual');

idx = round(currentframe/30*500+100);
if ( ~iscell(handles.x))
plot(handles.axes1,handles.x(idx),handles.y(idx),'.','markersize',30,'color','yellow');
else
    for i=1:length(handles.x)
        plot(handles.axes1,handles.x{i}(idx),handles.y{i}(idx),'.','markersize',30,'color','yellow');
    end
end
