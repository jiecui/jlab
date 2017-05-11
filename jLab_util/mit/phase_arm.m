function varargout = phase_arm(varargin)
% PHASE_ARM Application M-file for phase_arm.fig
%    FIG = PHASE_ARM launch phase_arm GUI.
%    PHASE_ARM('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 23-Sep-2003 17:45:44

if nargin == 0 | ~ischar(varargin{1})  % LAUNCH GUI

	fig = openfig(mfilename,'new');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    if nargin == 1
        handles.session_info = varargin{1};
        arm_vars = {'Shoulder X Pos (cm)', 'Shoulder Y Pos (cm)', 'Shoulder Z Pos (cm)', 'Upper Arm Yaw (degr)', ...
                'Upper Arm Pitch (degr)', 'Upper Arm Roll (degr)', 'Elbow Flexion (degr)', 'Pronation/Supination (degr)', ...
                'Wrist Flexion/Extension (degr)', 'Wrist Ab/Adduction (degr)'};
        handles.arm_varnames = arm_vars;
        set(handles.xpopup, 'String', arm_vars);
        set(handles.ypopup, 'String', arm_vars);
        set(handles.popupmenu4, 'String', arm_vars);
        set(handles.popupmenu5, 'String', arm_vars);
        set(handles.popupmenu6, 'String', arm_vars);
        handles.plotmode = 0; % indicating phase plot
        switchplotmode(handles);
        set(handles.radiobutton1, 'Value', 1);
        set(handles.radiobutton2, 'Value', 0);
        try
            set(handles.project_summary, 'String', handles.session_info.summary);
        catch
            set(handles.project_summary, 'String', '');
        end
        try
            set(handles.edit1, 'String', handles.session_info.selectedtrials);
        catch 
            set(handles.edit1, 'String', '');
        end
    end
    
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

function switchplotmode(handles)
if handles.plotmode == 0
    set(handles.popupmenu4, 'Enable', 'Off');
    set(handles.popupmenu5, 'Enable', 'Off');
    set(handles.popupmenu6, 'Enable', 'Off');
    set(handles.xpopup, 'Enable', 'On');
    set(handles.ypopup, 'Enable', 'On');
else
    set(handles.popupmenu4, 'Enable', 'On');
    set(handles.popupmenu5, 'Enable', 'On');
    set(handles.popupmenu6, 'Enable', 'On');
    set(handles.xpopup, 'Enable', 'Off');
    set(handles.ypopup, 'Enable', 'Off');
end

function data = getplotarray(session_info, trial, variable)
% first map the variable
% arm_vars = {'Shoulder X Pos', 'Shoulder Y Pos', 'Shoulder Z Pos', 'Upper Arm Yaw', ...
%                'Upper Arm Pitch', 'Upper Arm Roll', 'Elbow Flexion', 'Pronation/Supination', ...
%                'Wrist Flexion/Extension', 'Wrist Ab/Adduction'};
switch variable
case 1
    data = session_info.arm_data(trial).pshoulder(:,1);
case 2
    data = session_info.arm_data(trial).pshoulder(:,2);
case 3
    data = session_info.arm_data(trial).pshoulder(:,3);
case 4
    data = session_info.arm_data(trial).eshoulder(:,1);
case 5
    data = session_info.arm_data(trial).eshoulder(:,2);
case 6
    data = session_info.arm_data(trial).eshoulder(:,3);
case 7
    data = session_info.arm_data(trial).eelbow(:,2);
case 8
    data = session_info.arm_data(trial).eelbow(:,3);
case 9
    data = session_info.arm_data(trial).ewrist(:,2);
case 10
    data = session_info.arm_data(trial).ewrist(:,1);
end
data = sav_golay(data, 1, 2, 0);

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



% --------------------------------------------------------------------
function varargout = pushbutton1_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.pushbutton1.
trstring = get(handles.edit1,'String');
if  ~isempty(trstring)
    eval(sprintf('trials = [%s];',trstring));
    trials = trials(find((trials<=size(handles.session_info.trial_in_block,1)) & (trials>=1)));
    dt = length(handles.session_info.sensor_string)/240;
    % check for making a new plot
    if get(handles.checkbox1, 'Value') == 0
        if isfield(handles,'lastfig')
            plotfig = handles.lastfig;
            % clear the previous line data??
            hold off;
            cla;
        else
            plotfig = figure;
        end
    else
        plotfig = figure;
    end
    handles.lastfig = plotfig;
    figure(plotfig);
    if handles.plotmode == 0
        % plot a phase plot
        for t=trials
            tind = [0:size(handles.session_info.arm_data(t).pshoulder,1)-1]*dt;
            xdat = getplotarray(handles.session_info, t, get(handles.xpopup, 'Value'));
            ydat = getplotarray(handles.session_info, t, get(handles.ypopup, 'Value'));
            cline2(xdat, ydat, tind);
            %plot(xdat, ydat);
            hold on;
        end
        xlabel(handles.arm_varnames{get(handles.xpopup, 'Value')});
        ylabel(handles.arm_varnames{get(handles.ypopup, 'Value')});
        title(sprintf('File: %s, Trial(s): %s',handles.session_info.filename,trstring));
        hold off;
    else
        % plot a 3-figure setup...
        % set up subplots
        orient tall;
        sub1 = subplot(3,1,1);
        sub2 = subplot(3,1,2);
        sub3 = subplot(3,1,3);
        for t=trials
            tind = [0:size(handles.session_info.arm_data(t).pshoulder,1)-1]*dt;
            subplot(sub1);
            plot(tind, getplotarray(handles.session_info, t, get(handles.popupmenu4, 'Value')));
            hold on;
            subplot(sub2);
            plot(tind, getplotarray(handles.session_info, t, get(handles.popupmenu5, 'Value')));
            hold on;
            subplot(sub3);
            plot(tind, getplotarray(handles.session_info, t, get(handles.popupmenu6, 'Value')));
            hold on;
        end
        
        subplot(sub1);
        title(sprintf('File: %s, Trial(s): %s',handles.session_info.filename,trstring));
        xlabel('Time (seconds)');
        ylabel(handles.arm_varnames{get(handles.popupmenu4, 'Value')});
        hold off;
        subplot(sub2);
        xlabel('Time (seconds)');
        ylabel(handles.arm_varnames{get(handles.popupmenu5, 'Value')});
        hold off;
        subplot(sub3);
        xlabel('Time (seconds)');
        ylabel(handles.arm_varnames{get(handles.popupmenu6, 'Value')});
        hold off;
    end
    guidata(h, handles);
end

% --------------------------------------------------------------------
function varargout = checkbox1_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.checkbox1.
%if get(handles.checkbox1, 'Value')


% --------------------------------------------------------------------
function varargout = radiobutton1_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.radiobutton1.
set(handles.radiobutton1, 'Value', 1);
set(handles.radiobutton2, 'Value', 0);
handles.plotmode = 0;
switchplotmode(handles);
guidata(h, handles);

% --------------------------------------------------------------------
function varargout = radiobutton2_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.radiobutton2.
set(handles.radiobutton2, 'Value', 1);
set(handles.radiobutton1, 'Value', 0);
handles.plotmode = 1;
switchplotmode(handles);
guidata(h, handles);

% --------------------------------------------------------------------
function varargout = xpopup_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.popupmenu1.
%disp('popupmenu1 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = ypopup_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.popupmenu2.
%disp('popupmenu2 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = popupmenu4_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.popupmenu4.
%disp('popupmenu4 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = popupmenu5_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.popupmenu5.
%disp('popupmenu5 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = popupmenu6_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.popupmenu6.
%disp('popupmenu6 Callback not implemented yet.')


% --------------------------------------------------------------------
function varargout = xpopup_CreateFcn(h, eventdata, handles, varargin)
% Stub for CreateFcn of the uicontrol handles.xpopup.
%disp('xpopup CreateFcn not implemented yet.')


% --------------------------------------------------------------------
function varargout = edit1_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.edit1.
%disp('edit1 Callback not implemented yet.')