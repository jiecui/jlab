function [nsbh,nfh,Fields] = stsbar(h,varargin)
%STSBAR Creates a status-bar at the bottom of a figure
%[nsbh,nfh,Fields] = stsbar(h,varargin)
%   stsbar creates or updates a status bar that is created. It can either
%   be created on an existing figure or raised along with a newly created figure.
%
%   Syntax:
%       stsbar
%       stsbar(h)
%       stsbar(h,'Close')
%       stsbar([],'Field1',Field1,'Field2',Field2,...)
%       stsbar(h,'Field1',Field1,'Field2',Field2,...)
%       stsbar([],'Parent',fh,'Field1',Field1,'Field2',Field2,...)
%       stsbar(h,'Parent',fh,'Field1',Field1,'Field2',Field2,...)
%       stsbar([],'Title,'Test','Modal',1,fh,'Field1',Field1,'Field2',Field2,...)
%       stsbar(...,'Size',3,'Visible','on')
%       [nsb,nfh,Fields] = stsbar(...)
%
%   Description:
%       stsbar runs a demo
%       stsbar(h) only redraws status bar h
%       stsbar(h,'Close') closes (removes) status h
%       stsbar([],'Field1',Field1,'Field2',Field2,...) cretes a status-bar with several fields (see description of a field's contents below)
%
%   Field:
%       Field is a data structure that defines the type, shape, and contents of each field;
%       it has the following fields:
%           .type:      'text' (default) or 'progress'
%           .size:      a size in percent - the sum of all fields sizes
%                       must be equal to 100
%           .string:    a string to be shown in case of 'text'-typed field
%                       (defaults to '')
%           .shape:     'lowered' (default), 'normal', or 'raised'
%           .value:     an integer from -100..100 representing a progress
%                       percentage for 'progress'-typed field; if a negative value is
%                       given, the percentage number will be hidden - only the bar will
%                       be shown; defaults to 0
%           .color:     valid color specification for text or progress bar
%                       (defaults to 'k' for text and 'b' for progress)
%           .alignment: 'left' (default) or 'center' for 'text'-typed fields only
%
%   Overall properties for the status-bar:
%       'Parent':   a figure handle on which the status is to be created
%                   (if empty or not given a new figure will also be raised)
%       'Visible':  shows/hides the status bar if a figure is also created then this affect the figure too
%       'Title':    a string title that is displayed in the figure when the
%                   status bar is created in a new figure; defaults to an empty string
%       'Size':     height of the status bar; 1..12 (defaults to 1)
%       'FontSize': font size (6..18)     
%       'Modal':    1 for newly created figure to be modal and 0 to be
%                   non-modal (default)
%
%
%   EXAMPLES:   
%       stsbar
%           Runs a demo
%
%       Field1 = struct('type','text','string','Progress:','size',10,'color','k','shape','lowered');      
%       Field2 = struct('type','progress','value',10,'size',90,'color','b','shape','lowered');      
%       fh = figure;
%       [nsbh,nfh,Fields] = stsbar([],'Parent',fh,'Size',1,'Field1',Field1,'Field2',Field2,'Title','Progress');
%       set(fh,'UserData',nsbh,'ResizeFcn','stsbar(get(gcf,''UserData''))');
%           Creates a status bar with 2 fields - the "Progress:" text and
%           the progress bar. Also, the status-bar's handle is saved into
%           userdata section of the figure and an inline function is
%           assigned to figure's ResizeFcn for status-bar to resize along
%           with the figure.
%
%   See also: SBPROGRESS
%
%   Primoz Cermelj, 28.05.2004
%   (c) Primoz Cermelj, primoz.cermelj@email.si
%
%   Version: 1.0.0b
%   Last revision: 30.05.2004
%--------------------------------------------------------------------------

%----------------
% STSBAR history
%----------------
%
% [v.1.0.0] 28.05.2004
% - NEW: First release

global W
W = 400;

if nargin == 0
    % Run a demo
    Field1 = struct('type','text','size',30,'string','Demo status bar','alignment','center','color','k','shape','lowered');
    Field2 = struct('type','text','size',10,'string','Progres:','color','k','shape','lowered');
    Field3 = struct('type','progress','value',10,'size',60,'string','Second status:','color','b','shape','lowered');
    fh = figure;
    [nsbh,nfh,Fields] = stsbar([],'Parent',fh,'Size',1,'Field1',Field1,'Field2',Field2,'Field3',Field3,'Title','Status-bar demo');
    set(fh,'UserData',nsbh,'ResizeFcn','stsbar(get(gcf,''UserData''))');
    return
end

if nargin == 1
    Data = get(h,'UserData');
    [h,fh,FieldsOut] = updatesb(h,1,Data,[],Data.Fields);
    if nargout > 0
        nsbh = h;
        if nargout > 1
            nfh = fh;
            if nargout > 2
                Fields = FieldsOut;
            end
        end
    end
    return
end

%------------
% Task-bar's app data - default one or the existing one - read from an
% existing tb
%------------
if ~isempty(h) & ishandle(h)
    Data = get(h,'UserData');
    hExists = 1;
else
    hExists = 0;
    % Default values for status-bar
    Data.fhCreated = 0; % if a new figure is also created
    Data.nFields = 0;   % # of fields
    Data.hFieldObj = [];  % handle matrix; fields in rows; 3 columns (handles for text, patch, and perc. text)
    Data.hFieldFrame = [];% handle matrix for each field frame; 4 columns as there are 4 lines for each frame
    Data.fh = [];       % figure handle that status-bar is to be created on (the parent)
    Data.Fields = [];   % all the fields; Fields{i}.Type....; set later (see below)
    Data.title = '';    % title of a newly created figure
    Data.modal = 0;     % how newly created figure shows
    Data.visible = 'on';% if tb is visible
    Data.size = 1;      % size of the tb; 1..12    
    Data.fontSize = 8;  % size of the font
end

if nargin > 1
    % ---------------------
    % 'Close' might be given in the second parameter
    % ---------------------
    if strcmpi(varargin{1},'close')
        Data = get(h,'UserData');
        if ~isempty(Data) & ~isempty(Data.fh)
            if Data.fhCreated
                delete(Data.fh);
            else
                delete(h);
            end
        else
            error('Wrong h handle given');
        end        
        return
    end
end

if nargin > 2
    % ---------------------
    % Property property-value pairs and/or Fields are given - parses them
    % ---------------------
    if ischar(varargin{2}) && strcmpi(varargin{2},'remove')
        error('Remove option is not implemented yet!');
        [h,fh,FieldsOut] = removefield(h,hExists,varargin{3});
        if nargout > 0
            nsbh = h;
            if nargout > 1
                nfh = fh;
                if nargout > 2
                    Fields = FieldsOut;
                end
            end
        end
        return
    end 
    fieldNums = [];     % field-numbers given as parameters to be added and/or updated
    FieldsIn = [];      % field-contents given as parameters to be added and/or updated
    kk = 1;
    nProps = nargin - 1;
    if ~logical( 2*floor(nProps/2)==nProps ), error('Properties and/or fields must be given in pairs'), end;
    for ii=1:2:nProps
        if findstr(lower(varargin{ii}),'field')            
            fieldNums = [fieldNums parsefieldname(varargin{ii})];
            FieldsIn{kk} = varargin{ii+1};
            kk = kk + 1;
        elseif strcmpi(varargin{ii},'visible')
            Data.visible = varargin{ii+1};
        elseif strcmpi(varargin{ii},'parent')
            Data.fh = varargin{ii+1};            
        elseif strcmpi(varargin{ii},'size')
            Data.size = round(abs(varargin{ii+1}));
        elseif strcmpi(varargin{ii},'fontsize')
            Data.fontSize = round(abs(varargin{ii+1}));
        elseif strcmpi(varargin{ii},'visible')
            Data.visible = varargin{ii+1};            
        elseif strcmpi(varargin{ii},'modal')
            Data.modal = varargin{ii+1};            
        elseif strcmpi(varargin{ii},'title')
            Data.title = varargin{ii+1};            
        end
    end
end

% ---------------------
% Finally, updates/creates the status-bar
% ---------------------
[h,fh,FieldsOut] = updatesb(h,hExists,Data,fieldNums,FieldsIn);
if nargout > 0
    nsbh = h;
    if nargout > 1
        nfh = fh;
        if nargout > 2
            Fields = FieldsOut;
        end
    end
end








%**************************************************************************
%                   SUBFUNCTIONS
%**************************************************************************

%-----------------------------------------------------
function [nsbh,nfh,Fields] = updatesb(h,hExists,Data,fieldNums,FieldsIn);
% Creates/updates a status bar
border = 4;

if (Data.size < 1) | (Data.size > 12); H = 20; else;  H = round(Data.size) + 19; end;
if (Data.fontSize < 6) | (Data.size > 18); Data.fontSize = 8; end;
fhExists = 0;
if ~isempty(Data.fh) & ishandle(Data.fh)
    fhExists = 1;    
end
if ~fhExists
    Data.fh = createnewfig(H,Data.title,Data.modal,Data.visible);
    Data.fhCreated = 1;
end
%
[fPos,sbPos,fieldPos,fieldExists,Data] = preparedata(Data,H,fhExists,fieldNums,FieldsIn);
w = sbPos(3);   % overall width
%
if ~hExists     % new sb is to be created
    h = axes('Parent',Data.fh);    
    set(Data.fh,'DoubleBuffer','on');
    set(h,'Tag','sbAxes','Units','Pixels','Position',sbPos,'Box','off','Visible','off');    
    Data.hFieldFrame = zeros(Data.nFields,4);
    Data.hFieldObj = zeros(Data.nFields,3);
else            % sb is to be updated only
    set(h,'Position',sbPos);   
end
set(h,'XLim',[0 w],'YLim',[0 H-1]);
nsbh = h;
nfh = Data.fh;
%
% Set/re-set all the fields; each field has 3 handles for all of the
% possible objects: text, patch, percentage text
% and also 4 handles for its frame
for ii=1:Data.nFields
    if Data.Fields{ii}.value < -100;
        Data.Fields{ii}.value = -100;
    elseif Data.Fields{ii}.value > 100
        Data.Fields{ii}.value = 100;
    end
    al = 'left';
    doCenter = 0;
    if strcmpi(Data.Fields{ii}.alignment,'center')
        al = 'center';
        doCenter = 1;
    end        
    if ~fieldExists(ii) % create new field
        Data.hFieldFrame(ii,:) = createframe(h,Data.fh,fieldPos(ii,:),ii,H,Data.Fields{ii}.shape,'new');
        Data.hFieldObj(ii,1) = text(fieldPos(ii,1)+doCenter*(fieldPos(ii,2)-fieldPos(ii,1))/2+~doCenter*border,0.55*H,Data.Fields{ii}.string,'Color',Data.Fields{ii}.color,'Units','Pixels','FontSize',Data.fontSize,'HorizontalAlignment',al,'Visible','Off');
        len = round(fieldPos(ii,1) + abs(Data.Fields{ii}.value)*(fieldPos(ii,2)-2-fieldPos(ii,1))/100);
        Data.hFieldObj(ii,2) = patch([fieldPos(ii,1)+1; len+1; len+1; fieldPos(ii,1)+1],[1; 1; H-3; H-3],Data.Fields{ii}.color,'EdgeColor','none','Visible','off');
        Data.hFieldObj(ii,3) = text( (fieldPos(ii,1)+fieldPos(ii,2))/2,0.55*H,[num2str(abs(Data.Fields{ii}.value)) '%'],'Color',Data.Fields{ii}.color,'Units','Pixels','FontSize',Data.fontSize,'FontWeight','bold','Visible','Off','EraseMode','xor','HorizontalAlignment','Center');
    else                % update field
        Data.hFieldFrame(ii,:) = createframe(h,Data.fh,fieldPos(ii,:),ii,H,Data.Fields{ii}.shape,'update');
        set(Data.hFieldObj(ii,1),'Position',[fieldPos(ii,1)+doCenter*(fieldPos(ii,2)-fieldPos(ii,1))/2+~doCenter*border 0.55*H],'String',Data.Fields{ii}.string,'Color',Data.Fields{ii}.color,'HorizontalAlignment',al);
        len = round(fieldPos(ii,1) + abs(Data.Fields{ii}.value)*(fieldPos(ii,2)-2-fieldPos(ii,1))/100);
        set(Data.hFieldObj(ii,2),'XData',[fieldPos(ii,1)+1; len+1; len+1; fieldPos(ii,1)+1],'YData',[1; 1; H-3; H-3],'FaceColor',Data.Fields{ii}.color);
        set(Data.hFieldObj(ii,3), 'Position',[(fieldPos(ii,1)+fieldPos(ii,2))/2 0.55*H],'String',[num2str(abs(Data.Fields{ii}.value)) '%'],'Color',Data.Fields{ii}.color);     
    end
    if strcmpi(Data.Fields{ii}.type,'text') & strcmpi(Data.visible,'on')
        set(Data.hFieldObj(ii,1),'Visible','on');   
    else
        set(Data.hFieldObj(ii,1),'Visible','off');
    end
    if strcmpi(Data.Fields{ii}.type,'progress') & strcmpi(Data.visible,'on')
        set(Data.hFieldObj(ii,2),'Visible','on');
        if Data.Fields{ii}.value > 0
            set(Data.hFieldObj(ii,3),'Visible','on');
        else
            set(Data.hFieldObj(ii,3),'Visible','off');
        end
    else
        set(Data.hFieldObj(ii,2),'Visible','off');
        set(Data.hFieldObj(ii,3),'Visible','off');        
    end    
end
%-----
if Data.fhCreated
    fPos = get(Data.fh,'Position');
    fPos(4) = H;
    set(Data.fh,'Name',Data.title,'Position',fPos);
    if Data.modal
        set(Data.fh,'WindowStyle','modal');
    else
        set(Data.fh,'WindowStyle','normal');
    end
    if strcmpi(Data.visible,'on')
        set(Data.fh,'Visible','on');
    else
        set(Data.fh,'Visible','off');
    end
end
if strcmpi(Data.visible,'on')
%     set(Data.hFieldObj,'Visible','On');
    set(Data.hFieldFrame,'Visible','On');
else
%     set(Data.hFieldObj,'Visible','Off');
    set(Data.hFieldFrame,'Visible','Off');
end
%-----
% Save data to h's userdata
set(h,'UserData',Data);
Fields = Data.Fields;
drawnow;
set(h,'HandleVisibility','off');
%-----------------------------------------------------


%-----------------------------------------------------
function hFrame = createframe(h,fh,fieldPos,fieldN,H,shape,state);
% Creates a virtual panel surrounding the field starting at fieldPos(1) and
% ending end fieldPos(2) pixels. fh is the figure's handle, h is the sb's handle (axes).
% It returns a handle array designating the frame.
% See also the self-contained function BEVEL.
% pos = get(h,'Position');
% w = pos(3);
% h = pos(4);
from = fieldPos(1);
to = fieldPos(2);
col = rgb2hsv(get(fh,'Color'));
lightColor = col;   lightColor(2) = 0.5*lightColor(2);  lightColor(3) = 0.9; lightColor = hsv2rgb(lightColor);
darkColor = col;    darkColor(3) = 0.4;  darkColor = hsv2rgb(darkColor);  
if strcmpi(shape,'raised')
    tmpColor = lightColor;
    lightColor = darkColor;
    darkColor = tmpColor;
elseif strcmpi(shape,'normal')
    lightColor = 'k';
    darkColor = 'k';    
end
if strcmpi(state,'new')
    frame = zeros(4,1);    
    hFrame(1) = line([from to],[H-2 H-2],'Color',darkColor,'Visible','off');
    hFrame(2) = line([from from],[1 H-2],'Color',darkColor,'Visible','off');
    hFrame(3) = line([from+1 to-1],[1 1],'Color',lightColor,'Visible','off');
    hFrame(4) = line([to-1 to-1],[1 H-2],'Color',lightColor,'Visible','off');
else
    Data = get(h,'UserData');
    hFrame = Data.hFieldFrame(fieldN,:);
    set(hFrame(1),'XData',[from to],'YData',[H-2 H-2]);
    set(hFrame(2),'XData',[from from],'YData',[1 H-2]);
    set(hFrame(3),'XData',[from+1 to-1],'YData',[1 1]);
    set(hFrame(4),'XData',[to-1 to-1],'YData',[1 H-2]);
end
%-----------------------------------------------------



%-----------------------------------------------------
function [fPos,sbPos,fieldPos,fieldExists,DataOut] = preparedata(Data,H,fhExists,fieldNums,FieldsIn)
% Returns coordinates of an existing figure fh and for 
% existing or non-existing axis to be created/updated - axis is a basis for our status-bar.
% Also, all the fields given in input are re-set according to any existing
% fields in data and coordinates for all the fields are also returned.

DataOut = Data;
if ~(isempty(fieldNums) | isempty(FieldsIn))    % if any of the fields has been changed, added,...
    % First check
    if ~unique(fieldNums)
        error('Given fields are not unique');
    end
    % Parse all the fields, sort them and set/re-set their size
    existingNFields = DataOut.nFields;
    [dum,ind] = sort(fieldNums);
    FieldsIn = FieldsIn(ind);
    fieldNums = fieldNums(ind);
    maxFieldNum = max(existingNFields,max(fieldNums));
    fieldExists = zeros(maxFieldNum,1);
    fieldExists(1:existingNFields) = 1;
    len = length(find(fieldNums > existingNFields));
    if (existingNFields + len)~=maxFieldNum
        error('Given fields must be given in a successive way (fields can not be skipped)');
    end
    for ii=1:length(fieldNums)
        if fieldNums(ii) > existingNFields
            DataOut.Fields{ii} = struct('type','text','size',20,'string','','shape','lowered','value',0,'color','k','alignment','left');
        end
        if isfield(FieldsIn{ii},'type');        DataOut.Fields{fieldNums(ii)}.type = FieldsIn{ii}.type; end;
        if isfield(FieldsIn{ii},'size');        DataOut.Fields{fieldNums(ii)}.size = FieldsIn{ii}.size;  end;
        if isfield(FieldsIn{ii},'string');      DataOut.Fields{fieldNums(ii)}.string = FieldsIn{ii}.string;  end;
        if isfield(FieldsIn{ii},'shape');       DataOut.Fields{fieldNums(ii)}.shape = FieldsIn{ii}.shape;  end;
        if isfield(FieldsIn{ii},'value');       DataOut.Fields{fieldNums(ii)}.value = round(FieldsIn{ii}.value);  end;
        if isfield(FieldsIn{ii},'color');       DataOut.Fields{fieldNums(ii)}.color = FieldsIn{ii}.color;  end;    
        if isfield(FieldsIn{ii},'alignment');   DataOut.Fields{fieldNums(ii)}.alignment = FieldsIn{ii}.alignment;  end;    
    end
    DataOut.nFields = maxFieldNum;
    % The size of each field
    fSizes = zeros(maxFieldNum,1);
    for ii=1:maxFieldNum
        DataOut.Fields{ii}.size = round(DataOut.Fields{ii}.size);
        fSizes(ii) = DataOut.Fields{ii}.size;
    end
    s = sum(fSizes);
    if s ~= 100
        warning('The sum of all fields'' sizes is not equal to 100! Fields'' sizes were adjusted!');
        wi = fSizes/s;
        fSizes = round(100*wi);
        fSizes(end) = 100-sum(fSizes(1:end-1));
        for ii=1:maxFieldNum
            DataOut.Fields{ii}.size = fSizes(ii);
        end
    end
else
    fieldExists = ones(DataOut.nFields,1);
end
% Set sb's position
figure(Data.fh);
fUnits = get(Data.fh,'Units');
set(Data.fh,'Units','Pixels');
fPos = get(Data.fh,'Position');
set(Data.fh,'Units',fUnits);
sbPos = fPos;
sbPos(1) = 1;
sbPos(2) = 2;
sbPos(3) = fPos(3)-2;
sbPos(4) = H-1;
% Calculate each field's position (start and end x position) in pixels
fieldPos = zeros(DataOut.nFields,2);
if DataOut.nFields > 0
    w = sbPos(3);    
    fieldPos(1,1) = 1;
    fieldPos(1,2) = round(w/100*DataOut.Fields{1}.size);
    for ii=2:DataOut.nFields
        fieldPos(ii,1) = fieldPos(ii-1,2);
        fieldPos(ii,2) = fieldPos(ii,1) + round(w/100*DataOut.Fields{ii}.size);
    end
end
%-----------------------------------------------------


%-----------------------------------------------------
function [nsbh,nfh,Fields] = removefield(h,hExists,fieldStr);
if ~hExists
    error('Status bar given in h does not exist');
end
fNum = parsefieldname(fieldStr);
Data = get(h,'UserData');
if (fNum > Data.nFields) | (fNum < 1)
    error('Non-existing field number given');
end

%% Data.Fields{fNum} = [];
%?? updatesb(h,hExists,Data);
%-----------------------------------------------------


%-----------------------------------------------------
function fNum = parsefieldname(fieldStr)
fNum = [];
if ~ischar(fieldStr)
    error('Field name must be given as string');
end
ind = strfind(lower(fieldStr),'field');
if isempty(ind) | (ind~=1) | length(fieldStr) < 6
    error('Wrong field string given: field<n> expected with n being a valid field number');
end
fNum = str2num(fieldStr(6:end));
if isempty(fNum)
    error('Wrong field string given: field<n> expected with n being a valid field number');
end
fNum = round(fNum);
%-----------------------------------------------------


%-----------------------------------------------------
function fh = createnewfig(H,title,modal,visible)
global W

if isempty(title); title = ''; end;
set(0,'Units','Pixels');
scr = get(0,'ScreenSize');
fh = figure('Visible','off');
set(fh,'Units','Pixels',...
       'Tag','sbFigure',...
       'Position',[scr(3)/2-W/2 scr(4)/2-H/2 W H],...
       'MenuBar','none',...
       'Resize','off',...
       'NumberTitle','off',...
       'Name',title);
if modal
    set(fh,'WindowStyle','modal');
end
if strcmpi(visible,'on')
    set(fh,'Visible','On');
end
%-----------------------------------------------------