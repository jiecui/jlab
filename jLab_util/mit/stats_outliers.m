function project = stats_outliers(project)
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
% This problem is solved by saving the output as a FIG-file.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.
% 
% NOTE: certain newer features in MATLAB may not have been saved in this
% M-file due to limitations of this format, which has been superseded by
% FIG-files.  Figures which have been annotated using the plot editor tools
% are incompatible with the M-file/MAT-file format, and should be saved as
% FIG-files.


if project.valid < 1,
   return;
end;
load stats_outliers

h0 = figure('Units','points', ...
	'Color',[0.8 0.8 0.8], ...
	'Position',[246.75 332.25 513 253.5], ...
	'Tag','Fig1', ...
	'ToolBar','none');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[17.25 220.5 135 15], ...
	'String','Trials to Analyze', ...
	'Style','text', ...
	'Tag','StaticText1');
proj_trials_list = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[17.25 15.75 174.75 199.5], ...
	'String',project.trials_list, ...
	'Style','listbox', ...
	'Tag','Listbox1', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[237 219 135 15], ...
	'String','Trials to Ignore', ...
	'Style','text', ...
	'Tag','StaticText1');
proj_outliers_list = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[234 17.25 174.75 196.5], ...
	'String', project.outliers_list, ...
	'Style','listbox', ...
	'Tag','Listbox2', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
   'Position',[195.75 126 33 29.25], ...
   'Callback', 'proj_move_selected(current_proj.prjui.trials_list, current_proj.prjui.outliers_list)', ...
	'String','>>', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
   'Position',[195.75 81.75 33 29.25], ...
   'Callback', 'proj_move_selected(current_proj.prjui.outliers_list, current_proj.prjui.trials_list)', ...
	'String','<<', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'FontSize',10, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
   'Position',[426.75 132.75 57.75 27.75], ...
   'Callback', 'current_proj = outliers_close(current_proj, 0);', ...
	'String','Cancel', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'FontSize',10, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
   'Position',[426.75 168.75 57.75 27.75], ...
   'Callback', 'current_proj = outliers_close(current_proj, -1);', ...
	'String','Apply', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
   'Position',[426.75 204.75 57.75 27.75], ...
   'Callback', 'current_proj = outliers_close(current_proj, 1);', ...
	'String','OK', ...
   'Tag','Pushbutton1');

%set up global pointers
project.prjui.outliers_fig = h0;
project.prjui.trials_list = proj_trials_list;
project.prjui.outliers_list = proj_outliers_list;
if nargout > 0, fig = h0; end
