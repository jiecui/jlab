function fig = project_main()
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

load project_main

h0 = figure('Units','points', ...
	'Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'FileName','C:\MATLABR11\work\project_main.m', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[411.75 198.75 420 426], ...
	'Tag','Fig1', ...
	'ToolBar','none');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[7.5 123.75 205.5 259.5], ...
	'Style','frame', ...
	'Tag','Frame1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[5.25 387.75 135 22.5], ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[12.75 176.25 190.5 199.5], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox1', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[235.5 129.75 174.75 252], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox2', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[6.75 15.75 312 89.25], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox3', ...
	'Value',1);
if nargout > 0, fig = h0; end
