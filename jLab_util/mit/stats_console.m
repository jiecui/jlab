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

%load stats_console
clear current_proj;
current_proj.valid = 0;
h0 = figure('Units','points', ...
   'Color',[0.8 0.8 0.8], ...
   'MenuBar', 'none', ...
   'Name', 'Statistics Console', ...
   'NumberTitle', 'off', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[432.75 436.5 347.25 138], ...
	'Tag','Statistics Console', ...
	'ToolBar','none');
h1 = uimenu('Parent',h0, ...
	'Label','&File', ...
	'Tag','             ');
h2 = uimenu('Parent',h1, ...
	'Callback','proj_new', ...
	'Label','&New Project...', ...
   'Tag','             ');
h3 = uimenu('Parent',h1, ...
	'Callback','proj_open', ...
	'Label','&Open Project...', ...
	'Tag','             ');
h4 = uimenu('Parent',h1, ...
	'Callback','proj_save', ...
	'Label','&Save Project', ...
	'Tag','             ');
h5 = uimenu('Parent',h1, ...
	'Callback','proj_save_as', ...
	'Label','Save Project &As...', ...
	'Tag','             ');
proj_info_box = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.85 0.85 0.85], ...
	'ListboxTop',0, ...
	'Position',[141 88.5 169.5 36.75], ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.75 0.75 0.75], ...
	'FontSize',9, ...
	'ListboxTop',0, ...
   'Position',[15 15 91.5 36.75], ...
   'Callback', 'current_proj = stats_outliers(current_proj);', ...
	'String','Trials to Ignore ...', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.75 0.75 0.75], ...
	'FontSize',9, ...
	'ListboxTop',0, ...
   'Position',[195 15 74.25 36.75], ...
   'Callback', 'current_proj = proj_stats(current_proj);', ...
	'String','Statistics ...', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.75 0.75 0.75], ...
	'FontSize',9, ...
	'ListboxTop',0, ...
	'Position',[279 15 43.5 36.75], ...
	'String','Calculate!', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.85 0.85 0.85], ...
	'ListboxTop',0, ...
	'Position',[15 93 112.5 29.25], ...
	'String','Current Project Info', ...
	'Style','text', ...
	'Tag','StaticText2');
proj_scenelist = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.75 0.75 0.75], ...
	'ListboxTop',0, ...
	'Position',[13.5 61.5 305.25 18.75], ...
	'String',' ', ...
	'Style','popupmenu', ...
	'Tag','PopupMenu1', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.75 0.75 0.75], ...
	'FontSize',9, ...
	'ListboxTop',0, ...
   'Position',[116.25 15 68.25 36.75], ...
   'Callback', 'current_proj = proj_conditions(current_proj);', ...
	'String','Conditions ...', ...
	'Tag','Pushbutton2');
