function multiscroll(varargin)
% FUNCTION MULTISCROLL(varargin)
% 
% Automates the linking of multiple listboxes for simultaneous scrolling
% and selection.
%
% Enter a comma-delimited list of handles to scrolling listboxes.
% Multiscroll will link them so that they scroll and are highlighted
% together. (All lists must have equal-lengthed strings.)
% Multiple groupings are supported.
%
% Note that this function uses timer objects and so requires ML R14.
%
% Example:
%
% 	tmp = dir;
% 	a = uicontrol('style','listbox',...
%      'string',strvcat(tmp(:).name),...
%      'pos',[10 100 150 100]);
% 	b = uicontrol('style','listbox',...
%      'string',strvcat(tmp(:).date),...
%      'pos',[140 100 150 100]);
% 	c = uicontrol('style','listbox',...
%      'string',num2str([tmp(:).bytes]'),...
%      'pos',[270 100 150 100]);
% 	d = uicontrol('style','listbox',...
%      'string',num2str([tmp(:).isdir]'),...
%      'pos',[400 100 150 100]);
% 	multiscroll(a,b,c,d)
%
% Example using multiple timers
%
% 	a=uicontrol('style','listbox',...
%      'string',{1:100},'pos',[10 100 150 100]);
% 	b=uicontrol('style','listbox',...
%      'string',{1:100},'pos',[140 100 150 100]);
% 	c=uicontrol('style','listbox',...
%      'string',{1:100},'pos',[270 100 150 100]);
% 	d=uicontrol('style','listbox',...
%      'string',{1:100},'pos',[400 100 150 100]);
% 	multiscroll(a,c,d);
% %(NOTE THE EXCLUSION OF b!!!)
% 	a2=uicontrol('style','listbox',...
%      'string',{1:50},'pos',[10 250 150 100]);
% 	b2=uicontrol('style','listbox',...
%      'string',{1:50},'pos',[140 250 150 100]);
% 	c2=uicontrol('style','listbox',...
%      'string',{1:50},'pos',[270 250 150 100]);
% 	d2=uicontrol('style','listbox',...
%      'string',{1:50},'pos',[400 250 150 100]);
% 	multiscroll(a2,b2,c2,d2);
%
% (Note in the FEX image, all listboxes in the top cluster are linked, while only
%  listboxes 1,3 and 4 in the bottom cluster are linked.)
%
% Written by Brett Shoelson, PhD
% shoelson@helix.nih.gov
% 4/26/05

%Ensure that all input arguments are handles to equal-length listboxes
try
	tmp = cellfun('length',get([varargin{:}],'string'));
	tmp = cellfun('size',2,get([varargin{:}],'string'))
end
if any(~ishandle([varargin{:}])) ||...
		~all(strcmp(get([varargin{:}],'style'),'listbox')) ||...
		~all(tmp==tmp(1))
	error('All input arguments to multiscroll must be handles to existing, equal-length LISTBOX uicontrols.');
end
if ~all(cellfun('isempty',get([varargin{:}],'tag')))
	tmp = questdlg('Function multiscroll uses the tag property of the listboxes. At least one one of your listboxes has a non-empty tag, which will be overwritten if you choose to continue!','Warning: Non-empty callback or tag!','CANCEL','Continue','CANCEL');
	if strcmp(tmp,'CANCEL')
		return
	end
end

% Determine how many timers are currently in use; no need to delete existing timer objects
tmrnum = timerfindall;
tmrnum = length(tmrnum)+1;

set([varargin{:}],'tag',sprintf('multiscroll%d',tmrnum));

% Create a new 10-Hz timer; store the current listboxtop and current value in its userdata property
th=timer('executionmode','fixedrate','timerfcn',@multiscrollfcn,...
	'startdelay',0,'period',0.1,'tag',sprintf('multiscrolltimer%d',tmrnum),'userdata',[1 1]);
start(th);

set(get(varargin{1},'parent'),'deletefcn',@timerdelete);
return

function multiscrollfcn(varargin)
ntimers = length(timerfindall);
for ii = 1:ntimers
	%Scroll boxes together, and highlight boxes together
	lbt = get(findobj('tag',sprintf('multiscroll%d',ii)),'listboxtop');
	if isempty(lbt) %timer ii is not a multiscroll timer
		break
	end
	lbv = get(findobj('tag',sprintf('multiscroll%d',ii)),'value');

	%Determine if selection or listboxtop has changed
	if ~(all(cell2mat(lbv) == lbv{1}) && all(cell2mat(lbt) == lbt{1}))
		%Get current values stored in userdata of timer object
		tmp = get(timerfind('tag',sprintf('multiscrolltimer%d',ii)),'userdata');
		if ~all(cell2mat(lbt) == lbt{1})
			%Update lbt
			currtop = setdiff(cell2mat(lbt),tmp(1));
			currtop = currtop(1); %Ensure uniqueness; this will align tops for initialization.
			set(findobj('tag',sprintf('multiscroll%d',ii)),'listboxtop',currtop);
		else
			currtop = tmp(1);
		end
		if ~all(cell2mat(lbv) == lbv{1})
			%Update selections
			currval = setdiff(cell2mat(lbv),tmp(2));
			currval = currval(1); %Ensure uniqueness: this will sychronize selections for initialization.
			set(findobj('tag',sprintf('multiscroll%d',ii)),'value',currval);
		else
			currval = tmp(2);
		end
		set(timerfind('tag',sprintf('multiscrolltimer%d',ii)),'userdata',[currtop currval]);
	end %if ~(all(cell2mat(lbv) == lbv{1}) && all(cell2mat(lbt) == lbt{1}))
end %for ii = 1:ntimers
return

function timerdelete(varargin)
%Delete only timer objects created by multiscroll
th = timerfindall;
tmp = strmatch('multiscrolltimer',get(th,'tag'));
stop(th(tmp));
delete(th(tmp));

