function fig = testgui()
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

load testgui

h0 = figure('Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'FileName','C:\MATLABR11\bin\testgui.m', ...
	'HandleVisibility','callback', ...
	'MenuBar','none', ...
	'Name','Crunch Plot', ...
	'NumberTitle','off', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[364 252 775 420], ...
	'Tag','Fig1', ...
	'ToolBar','none', ...
	'UserData',mat1);
h1 = uimenu('Parent',h0, ...
	'Label','&File', ...
	'Tag','             ');
h2 = uimenu('Parent',h1, ...
	'Callback','crunchPlot(''loadDataFile'');', ...
	'Label','&Load Data File...', ...
	'Tag','             ');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','crunchPlot(''selectSubject'');', ...
	'ListboxTop',2, ...
	'Min',1, ...
	'Position',[18 168.75 150 112.5], ...
	'String',mat2, ...
	'Style','listbox', ...
	'Tag','Listbox1', ...
	'Value',11);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Max',3, ...
	'Min',1, ...
	'Position',[206.25 168.75 150 112.5], ...
	'String',mat3, ...
	'Style','listbox', ...
	'Tag','Listbox2', ...
	'Value',[3 4 5 6]);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Min',1, ...
	'Position',[393.75 168.75 150 112.5], ...
	'String',mat4, ...
	'Style','listbox', ...
	'Tag','Listbox3', ...
	'Value',22);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Max',3, ...
	'Min',1, ...
	'Position',[18.75 18.75 150 112.5], ...
	'String',mat5, ...
	'Style','listbox', ...
	'Tag','Listbox3', ...
	'Value',8);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[206.25 113.25 187.5 18.75], ...
	'String',mat6, ...
	'Style','popupmenu', ...
	'Tag','PopupMenu1', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','crunchPlot(''selectGroupSession'');', ...
	'ListboxTop',0, ...
	'Position',[206.25 89.25 112.5 18.75], ...
	'String','Group by Session', ...
	'Style','radiobutton', ...
	'Tag','Radiobutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','crunchPlot(''selectGroupCondition'');', ...
	'ListboxTop',0, ...
	'Position',[206.25 70.5 112.5 18.75], ...
	'String','Group by Condition', ...
	'Style','radiobutton', ...
	'Tag','Radiobutton1', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[209.25 21 112.5 18.75], ...
	'String','Make new figure', ...
	'Style','checkbox', ...
	'Tag','Radiobutton1', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','crunchPlot(''plotData'');', ...
	'ListboxTop',0, ...
	'Position',[468.75 37.5 75 37.5], ...
	'String','Plot Data', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[18.75 281.25 147 18.75], ...
	'String','Subject(s)', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[18.75 131.25 150 18.75], ...
	'String','Condition(s)', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[393.75 281.25 150 18.75], ...
	'String','Normal Subject(s)', ...
	'Style','text', ...
	'Tag','StaticText3');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[206.25 131.25 187.5 18.75], ...
	'String','Measure', ...
	'Style','text', ...
	'Tag','StaticText3');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[206.25 281.25 150 18.75], ...
	'String','Evaluation Session(s)', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'ListboxTop',0, ...
	'Position',[208.5 45 110.25 21.75], ...
	'String','Plot Normals', ...
	'Style','checkbox', ...
	'Tag','Checkbox1');
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'ColorOrder',mat7, ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);
if nargout > 0, fig = h0; end
