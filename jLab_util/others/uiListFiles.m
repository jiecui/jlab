function Files = uiListFiles(arg)
% Files = uiListFiles
% displays a dialog box to select a list of files from different folders.
% The selected files can be ordered inside the listbox using 'Shift /\' and 'Shift \/' buttons.
% The output a cell array of full names of selected files or [] if Cancel pushbutton clicked.
%
% Note 1: clicking OK button with no selected file returns {''}
% Note 2: uses browsefolder.dll (MEX-file, compiled with R12.1)

% Feel free to modify this file according to your needs !
% Fabrice.Pabois@ncl.ac.uk - University of Newcastle - 2000

if nargin==0
   arg='Start';
end

switch arg
case 'Start'
   h=LocalInit;
   waitfor(h,'Selected','on');
   Files=get(h,'UserData');
   delete(h);
   
case 'ChangeDir'
   NewPath = browsefolder('Please select a folder');
   if ~isempty(NewPath)
      cd(NewPath);
      set(findobj(gcbf,'Tag','CurrDir'),'String', NewPath);
      set(findobj(gcbf,'Tag','FileListLb'),'String', GetFiles, 'Value',[]);
   end
   
case 'AddFile'
    FileListLb = findobj(gcbf,'Tag','FileListLb');
    NewSelection = get(FileListLb,'Value');
    
    if ~isempty(NewSelection)
        FileList = get(FileListLb,'String');
        FullFiles = [repmat([cd filesep],length(NewSelection),1) char(FileList(NewSelection))];
        
        SelectionLb = findobj(gcbf,'Tag','SelectionLb');
        set(SelectionLb, 'String', union(get(SelectionLb,'String'), FullFiles, 'rows'), 'Value', []);
    end
   
case 'RemFile'
   SelectionLb = findobj(gcbf,'Tag','SelectionLb');
   ToRemove = get(SelectionLb,'Value');
   if any(ToRemove)
      FileList = cellstr(get(SelectionLb,'String'));
      FileList(ToRemove)=[];
      set(SelectionLb, 'String', char(FileList), 'Value',[]);
   end
   
case 'ShiftUp'
   SelectionLb = findobj(gcbf,'Tag','SelectionLb');
   ToShift = get(SelectionLb,'Value');
   if ~isempty(ToShift)
      if ToShift(1)>1		% Can shift up then
         % Keep first contiguous block
         NonContiguous = find(diff(ToShift)~=1);
         StartPos = ToShift(1);
         if isempty(NonContiguous)	% Just 1 contiguous block
            EndPos = ToShift(end);
         else
            EndPos = NonContiguous(1)+1;
         end
         % Shift Up
         FileList = cellstr(get(SelectionLb,'String'));
         set(SelectionLb,'String',char(FileList([1:StartPos-2 StartPos:EndPos StartPos-1 EndPos+1:end],:)), 'Value',[StartPos:EndPos]-1);
      end
   end
   
case 'ShiftDown'
   SelectionLb = findobj(gcbf,'Tag','SelectionLb');
   ToShift = get(SelectionLb,'Value');
   if ~isempty(ToShift)
      FileList = cellstr(get(SelectionLb,'String'));
      FileLength = size(FileList,1);
      if ToShift(end)<FileLength		% Can shift down then
         % Keep first contiguous block
         NonContiguous = find(diff(ToShift)~=1);
         StartPos = ToShift(1);
         if isempty(NonContiguous)	% Just 1 contiguous block
            EndPos = ToShift(end);
         else
            EndPos = NonContiguous(1)+1;
         end
         % Shift down
         set(SelectionLb,'String',char(FileList([1:StartPos-1 EndPos+1 StartPos:EndPos EndPos+2:end],:)), 'Value',[StartPos:EndPos]+1);
      end
   end
   
case 'OK'
   set(gcbf,'Selected','On', 'UserData', cellstr(get(findobj(gcf,'Tag','SelectionLb'),'String')));
   
case 'Cancel'
   set(gcbf,'Selected','On','UserData',[]);
   
end

% -------------------------------------------------------------------------------------------------------------------
function ListNames = GetFiles
% Here you could add your filters if you want to return certain types of files
DirRes = dir('*.*');

% Get the files + directories names
[ListNames{1:length(DirRes),1}] = deal(DirRes.name);

% Get directories only
[DirOnly{1:length(DirRes),1}] = deal(DirRes.isdir);

% Turn into logical vector and take complement to get indexes of files
FilesOnly = ~cat(1, DirOnly{:});
ListNames = ListNames(FilesOnly);

% -------------------------------------------------------------------------------------------------------------------
function Fig=LocalInit
% Dialog box
OldUnits=get(0,'Units');
set(0,'Units','pixels');
Pos=get(0,'ScreenSize');		% Get screen dimensions to centre dialog box
set(0,'Units',OldUnits);
Fig=figure('name','Select Files','NumberTitle','off','Resize','off','CloseRequestFcn','uiListFiles(''Cancel'');', ...
   'WindowStyle','modal','MenuBar','none','units','pixels','Position',[Pos(3)/2-250 Pos(4)/2-150 500 300], ...
   'Color',get(0,'DefaultUIControlBackgroundColor'),'Tag','uiListFiles');

uicontrol('Parent',Fig,'Style','frame','units','pixels','Position',[5 50 490 240]);

% Current folder
uicontrol('Parent',Fig,'Style','text','units','pixels','HorizontalAlignment','left','String','Current Folder:', ...
   'Position',[20 260 150 20]);
uicontrol('Parent',Fig,'Style','edit','units','pixels','BackgroundColor',[1 1 1],'HorizontalAlignment','left', ...
   'Enable','off','String',cd,'Position',[20 240 350 24],'Tag','CurrDir');
uicontrol('Parent',Fig,'Style','pushbutton','units','pixels','String','...','Position',[420 240 50 24], ...
   'Tag','ChangeDir','Callback','uiListFiles(''ChangeDir'')');

% Contents of the current folder
uicontrol('Parent',Fig,'Style','text','units','pixels','HorizontalAlignment','left','String','Files:','Position',[20 200 50 20]);
uicontrol('Parent',Fig,'Style','Listbox','units','pixels','BackgroundColor',[1 1 1],'Max',2, ...
   'String',GetFiles, 'Position',[20 60 100 140],'Tag','FileListLb','Value',[]);

% Current selection
uicontrol('Parent',Fig,'Style','text','units','pixels','HorizontalAlignment','left','String','Selection:','Position',[210 200 70 20]);
uicontrol('Parent',Fig,'Style','Listbox','units','pixels','BackgroundColor',[1 1 1],'Max',2, ...
   'String','','Position',[210 60 210 140],'Tag','SelectionLb');

% Select-Remove pushbuttons
uicontrol('Parent',Fig,'Style','pushbutton','units','pixels','String','Add --->','Position',[130 140 70 30],'CallBack','uiListFiles(''AddFile'')');
uicontrol('Parent',Fig,'Style','pushbutton','units','pixels','String','Remove <---','Position',[130 100 70 30],'CallBack','uiListFiles(''RemFile'')');

% Shift up/down pushbuttons
uicontrol('Parent',Fig,'Style','pushbutton','units','pixels','String','Shift /\','Position',[430 140 50 30],'CallBack','uiListFiles(''ShiftUp'')');
uicontrol('Parent',Fig,'Style','pushbutton','units','pixels','String','Shift \/','Position',[430 100 50 30],'CallBack','uiListFiles(''ShiftDown'')');

% OK/Cancel Pushbuttons
uicontrol('Parent',Fig,'Style','pushbutton','units','pixels','String','OK','Position',[160 4 100 32],'CallBack','uiListFiles(''OK'')');
uicontrol('Parent',Fig,'Style','pushbutton','units','pixels','String','Cancel','Position',[270 4 100 32],'CallBack','uiListFiles(''Cancel'')');
