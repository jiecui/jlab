function varargout = new_show_data(varargin)
% NEW_SHOW_DATA Application M-file for new_show_data.fig
%    FIG = NEW_SHOW_DATA launch new_show_data GUI.
%    NEW_SHOW_DATA('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 22-Sep-2003 16:45:21

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.

%| TDYAR 3-8-04 -- I want this gui to subsume the setting of ignored
%| trials GUI, the old showdata gui, and the phase_arm gui. To do this
%| in a coherent way, I need to decide which buttons and options are at
%| the top level and which will be hidden. To clearly set the ignored
%| trials for a session, I should have ...

% --------------------------------------------------------------------
function varargout = listbox1_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.listbox1.
disp('listbox1 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = pushbutton1_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.pushbutton1.
disp('pushbutton1 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = pushbutton2_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.pushbutton2.
disp('pushbutton2 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = listbox2_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.listbox2.
disp('listbox2 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = pushbutton3_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.pushbutton3.
disp('pushbutton3 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = popupmenu1_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.popupmenu1.
disp('popupmenu1 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = popupmenu2_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.popupmenu2.
disp('popupmenu2 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = edit1_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.edit1.
disp('edit1 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = togglebutton2_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.togglebutton2.
disp('togglebutton2 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = togglebutton3_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.togglebutton3.
disp('togglebutton3 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = togglebutton4_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.togglebutton4.
disp('togglebutton4 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = togglebutton5_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.togglebutton5.
disp('togglebutton5 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = edit2_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.edit2.
disp('edit2 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = edit3_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.edit3.
disp('edit3 Callback not implemented yet.')