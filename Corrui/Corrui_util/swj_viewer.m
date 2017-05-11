function varargout = swj_viewer(varargin)
% SWJ_VIEWER M-file for swj_viewer.fig
%      SWJ_VIEWER, by itself, creates a new SWJ_VIEWER or raises the existing
%      singleton*.
%
%      H = SWJ_VIEWER returns the handle to a new SWJ_VIEWER or the handle to
%      the existing singleton*.
%
%      SWJ_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SWJ_VIEWER.M with the given input arguments.
%
%      SWJ_VIEWER('Property','Value',...) creates a new SWJ_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before swj_viewer_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to swj_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help swj_viewer

% Last Modified by GUIDE v2.5 26-Feb-2007 15:56:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @swj_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @swj_viewer_OutputFcn, ...
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


% --- Executes just before swj_viewer is made visible.
function swj_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to swj_viewer (see VARARGIN)


% Choose default command line output for swj_viewer
handles.output = hObject;



dat = varargin{1};

handles.eyedat				= dat.eyedat;
handles.square_wave_jerks	= dat.square_wave_jerks;
handles.square_wave_jerks2	= dat.square_wave_jerks2;
handles.usacc_starts		= dat.usacc_starts;
handles.usacc_ends			= dat.usacc_ends;
handles.usacc_directions	= dat.usacc_directions;
handles.usacc_magnitudes	= dat.usacc_magnitudes;
handles.samplerate			= dat.samplerate;

set( handles.slider1, 'Max', length(dat.square_wave_jerks) );
set( handles.slider1, 'SliderStep', [1/length(dat.square_wave_jerks) 10/length(dat.square_wave_jerks)]);



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes swj_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = swj_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

i = floor(get( handles.slider1, 'value' ));

s1 = handles.usacc_starts(handles.square_wave_jerks(i));
e1 = handles.usacc_ends(handles.square_wave_jerks(i));
s2 = handles.usacc_starts(handles.square_wave_jerks2(i));
e2 = handles.usacc_ends(handles.square_wave_jerks2(i));



avg = mean(  handles.eyedat(max(s1-5000,1):e2+5000, 1));
media = median(  handles.eyedat(max(s1-5000,1):e2+5000, 1));

avg1 = mean(  handles.eyedat( [max(s1-5000,1):s1 e2:e2+5000], 1));
media1 = median(  handles.eyedat( [max(s1-5000,1):s1 e2:e2+5000], 1));


plot( handles.axes1,  handles.eyedat(max(s1-1000,1):e2+1000, 1) , handles.eyedat(max(s1-1000,1):e2+1000, 2) ,'k-+');
hold( handles.axes1);
plot(  handles.axes1,handles.eyedat(s1:e2, 1), handles.eyedat(s1:e2, 2), 'r.');

plot(  handles.axes1, handles.eyedat(s1:e1, 1),handles.eyedat(s1:e1, 2), 'b-', 'Linewidth', 2);

plot(  handles.axes1, handles.eyedat(s2:e2, 1),handles.eyedat(s2:e2, 2),'b-', 'Linewidth', 2);

hold( handles.axes1);

plot( handles.axes2, ((max(s1-1000,1):e2+1000)- s1)/handles.samplerate*1000 , handles.eyedat(max(s1-1000,1):e2+1000, 1) );

hold( handles.axes2);
plot(  handles.axes2, ((s1:e2)- s1)/handles.samplerate*1000, handles.eyedat(s1:e2, 1), 'r.','markersize',1);

plot(  handles.axes2, ((s1:e1)- s1)/handles.samplerate*1000, handles.eyedat(s1:e1, 1), 'b-', 'Linewidth', 2);

plot(  handles.axes2, ((s2:e2)- s1)/handles.samplerate*1000, handles.eyedat(s2:e2, 1), 'b-', 'Linewidth', 2);
% 
% plot(  handles.axes2, ((max(s1-1000,1):e2+1000)- s1)/handles.samplerate*1000, ones(length(max(s1-1000,1):e2+1000),1)*avg);
% plot(  handles.axes2, ((max(s1-1000,1):e2+1000)- s1)/handles.samplerate*1000, ones(length(max(s1-1000,1):e2+1000),1)*media , 'r');
% plot(  handles.axes2, ((max(s1-1000,1):e2+1000)- s1)/handles.samplerate*1000, ones(length(max(s1-1000,1):e2+1000),1)*avg1, 'm');
plot(  handles.axes2, ((max(s1-1000,1):e2+1000)- s1)/handles.samplerate*1000, ones(length(max(s1-1000,1):e2+1000),1)*media1 , 'g');
hold( handles.axes2);

plot( handles.axes4, ((max(s1-1000,1):e2+1000)- s1)/handles.samplerate*1000, handles.eyedat(max(s1-1000,1):e2+1000,2) );

hold( handles.axes4);
plot(  handles.axes4, ((s1:e2)- s1)/handles.samplerate*1000, handles.eyedat(s1:e2, 2), 'r.');

plot(  handles.axes4, ((s1:e1)- s1)/handles.samplerate*1000, handles.eyedat(s1:e1, 2), 'b-', 'Linewidth', 2);

plot(  handles.axes4, ((s2:e2)- s1)/handles.samplerate*1000, handles.eyedat(s2:e2, 2), 'b-', 'Linewidth', 2);


hold( handles.axes4);



	mx = median(  handles.eyedat( [max(s1-5000,1):s1 e2:min(e2+5000,length(handles.eyedat))], 1));
	my = median(  handles.eyedat( [max(s1-5000,1):s1 e2:min(e2+5000,length(handles.eyedat))], 2));
	
	x1 = handles.eyedat(s1,1);
	x2 = handles.eyedat(e1,1);
	x3 = handles.eyedat(s2,1);
	x4 = handles.eyedat(e2,1);

	y1 = handles.eyedat(s1,2);
	y2 = handles.eyedat(e1,2);
	y3 = handles.eyedat(s2,2);
	y4 = handles.eyedat(e2,2);
 	
 	dist1 = sqrt( (x2-mx)^2+(y2-my)^2) - sqrt( (x1-mx)^2+(y1-my)^2) ;
 	dist2 = sqrt( (x3-mx)^2+(y3-my)^2) - sqrt( (x4-mx)^2+(y4-my)^2) ;
	
	%d(i) = (dist1+dist2) / ( usacc_magnitudes(swj(i)) + usacc_magnitudes(swj2(i)) ) ;
	d = (dist1+dist2) / ( sqrt( (x1-x2)^2 + (y1-y2)^2 ) + sqrt( (x3-x4)^2 + (y3-y4)^2 ) ) ;
	
	
set( handles.axes2, 'ylim', [x1-2 x1+2])
set( handles.axes4, 'ylim', [y1-2 y1+2])
	
index = 1;
max_x = max(handles.eyedat(e1(index):s2(index),1));
		min_x = min(handles.eyedat(e1(index):s2(index),1));
		max_y = max(handles.eyedat(e1(index):s2(index),2));
		min_y = min(handles.eyedat(e1(index):s2(index),2));
		
		if ( ( (abs(x2(index)-x3(index))) * (abs(y2(index)-y3(index))) ) ~= 0 )
			a = ((max_x-min_x)*(max_y-min_y) - ( (abs(x2(index)-x3(index))) * (abs(y2(index)-y3(index))) ))*1000
		else
			a = 1000;
		end


		area1 = abs(x1(index)-x2(index)) * ( e1(index) -s1(index) );
		area2 = (max_x - min_x) * (s2(index) - e1(index) );
		area3 = abs(x3(index)-x4(index)) * ( e2(index) -s2(index) );
		
		total_area = area1 + area2 + area3;
	
		%q = (mean( [abs(x1(index)-x2(index)),  abs(x3(index)-x4(index))]) * (e2(index) - s1(index) ) ) / total_area
		if ( (x1(index)-x2(index))*(x3(index)-x4(index)) <0 )
			q = (   (abs(x1(index)-x2(index)) +  abs(x3(index)-x4(index))) * (e2(index) - s1(index) ) /2 / total_area);
		else
			q = (   abs((abs(x1(index)-x2(index))-  abs(x3(index)-x4(index)))) * (e2(index) - s1(index) ) /2 / total_area);
		end
		
		title(handles.axes2, ['q = ' num2str(q) ', ' num2str(d)]);
		
		
		area1 = abs(y1(index)-y2(index)) * ( e1(index) -s1(index) );
		area2 = (max_y - min_y) * (s2(index) - e1(index) );
		area3 = abs(y3(index)-y4(index)) * ( e2(index) -s2(index) );
		
		total_area = area1 + area2 + area3;
		
		%qy =   (mean( [abs(y1(index)-y2(index)),  abs(y3(index)-y4(index))]) * (e2(index) - s1(index) ) )/ total_area
		if ( (y1(index)-y2(index))*(y3(index)-y4(index)) <0 )
			qy = (   (abs(y1(index)-y2(index)) +  abs(y3(index)-y4(index))) * (e2(index) - s1(index) ) /2 )/ total_area;
		else
			qy = (   abs((abs(y1(index)-y2(index)) -  abs(y3(index)-y4(index)))) * (e2(index) - s1(index) ) /2/ total_area );
		end
		
		title(handles.axes4, ['q = ' num2str(qy) ', ' num2str(dist1) ' ' num2str(dist2)]);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = figure

c = copyobj(handles.axes2, h)


