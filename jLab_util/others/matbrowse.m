function res=matbrowse(command)
%MATBROWSE  -  MAT-File manager. Allows one to:
%              - browse MAT-file contents and select variables;
%              - separately load selected variables to workspace (as RES);
%              - separately keep selected variables to MAT-File.
% Usage: MATBROWSE  -
%              Opens matbrowse GUI.
%        MATBROWSE [path]filenam.ext -
%              Opens matbrowse GUI with the variable list of the file filenam.ext .
%              If the file is not a valid MATLAB data file (ASCII or MAT format)
%             or the file is not found, an empty matbrowse GUI is opened with the 
%             appropriate message.
%        MATBROWSE BWS -
%              Opens matbrowse GUI with the variable list of Base Workspace.

%  Dr Igor Kaufman   November 9, 1997.
%  Copyright (c) School of Physics and Chemistry, Lancaster University, UK

% Files participating in matbrowse rn:
%    matbrowse.m       - main function for MAT-File manager.
%    matbrowse_gui.m   - GUIDE-made GUI description
%    matbrowse_gui.mat - data for GUI

%  Joshua Malina   October 29, 1999.
%  Copyright (c) ELTA, Inc.
%  $Revision: 1.01 $ $Date 21-Nov-1999 13:12:41 $
%             edFile edit box activated.
%  $Revision: 1.10 $ $Date 21-Nov-1999 13:12:41 $
%             Loading variables directly to base workspace added.
%             Saving variables from base workspace added.

persistent fname var svar isopen selected clf out ascflg wsflg duminfo

if ~nargin
   command='cmInit';
end

switch command
  case 'cmInit'
     ascflg = logical(0);
     wsflg = logical(0);
     res=[];
     clf=[];
     out=[];
     gui_init;

     set(uitag('pbSelect'),'enable','off');
     set(uitag('pbSelectAll'),'enable','off');
     set(uitag('pbRemove'),'enable','off');
     set(uitag('pbRemoveAll'),'enable','off');
     set(uitag('pbLoad'),'enable','off');
     set(uitag('pbLoadAll'),'enable','off');
     set(uitag('pbLoadWS'),'enable','off');
     set(uitag('pbLoadAllWS'),'enable','off');
     set(uitag('pbSaveSel'),'enable','off');
     
     setstatus('Use Browse pushbutton to open MAT-File');
     clf = 0;  

  case 'cmOpen'
    set(uitag('edFile'),'string',fname);
    svar=[];
    if(ascflg)
       [path,s1,ext] = fileparts(fname);
       var = {s1};
       s=blanks(16);
       m=min([16 length(s1)]);
       s(1:m)=s1(1:m);
       s2=blanks(12);
       s2tmp = [num2str(duminfo.size(1)) 'x' num2str(duminfo.size(2))];
       m=min([12 length(s2tmp)]);
       s2(12:-1:12-m+1)=s2tmp(m:-1:1);
       cl=blanks(12);
       m=min([12 length(duminfo.class)]);
       cl(1:m)=duminfo.class(1:m);
       svar{1}=sprintf('%16s %12s %12s %8i',s, s2, cl, duminfo.bytes);
    else
       var=who('-file', fname);
       info=whos('-file',fname);
       for  i=1:length(info)
          s=blanks(16);
          s1=var{i};
          m=min([16 length(s1)]);
          s(1:m)=s1(1:m);
          s2=blanks(12);
          s2tmp = [num2str(info(i).size(1)) 'x' num2str(info(i).size(2))];
          m=min([12 length(s2tmp)]);
          s2(12:-1:12-m+1)=s2tmp(m:-1:1);
          cl=blanks(12);
          m=min([12 length(info(i).class)]);
          cl(1:m)=info(i).class(1:m);
          svar{i}=sprintf('%16s %12s %12s %8i',s, s2, cl,info(i).bytes);
       end
    end
    
    
    set(uitag('lbFile'),'string',svar,'value',1);
    set(uitag('lbSelected'),'value',1,'string','');
    selected=[];
    isopen=1;

    if(length(svar)), 
       set(uitag('pbSelect'),'enable','on');
       set(uitag('pbSelectAll'),'enable','on');
       set(uitag('pbLoadAll'),'enable','on');
       set(uitag('pbLoadAllWS'),'enable','on');
    end
    set(uitag('pbRemove'),'enable','off');
    set(uitag('pbRemoveAll'),'enable','off');
    set(uitag('pbLoad'),'enable','off');
    set(uitag('pbLoadWS'),'enable','off');
    set(uitag('pbSaveSel'),'enable','off');

    setstatus(['Mat-file <' fname '> is opened']);

  case 'pbBrowse'
     [f p]=uigetfile('*.mat');
     if f
        newname=fullfile(p,f);
        if ~isempty(who('-file',newname))
           fname=newname;
           wsflg = logical(0);
           ascflg = logical(0);
           matbrowse cmOpen;
        else
           try
              j1f = logical(1);
              dummy = load(newname,'-ascii');
           catch
              j1f = logical(0);
              set(uitag('edFile'),'string',fname);
              msgbox([newname ' is not valid MAT-File'],'matbrowse warning','warn','modal');
           end
           if j1f   
              fname=newname;
              wsflg = logical(0);
              ascflg = logical(1);
              duminfo = whos('dummy');
              matbrowse cmOpen;
           end
        end
     end

  case 'pbLoadWSVar'
     wsflg = logical(1);
     set(uitag('edFile'),'string','Base workspace');
     fname = 'Base workspace';
     svar=[];
     evalin('base',['global var_in_base_ws var_info_base_ws;' ... 
            'var_in_base_ws = who;var_info_base_ws = whos;']);
     global var_in_base_ws var_info_base_ws; 
     var =  var_in_base_ws;
     info = var_info_base_ws;
     evalin('base','clear global var_in_base_ws var_info_base_ws;');
     IVarIn = sort([find(strcmp(var,'var_in_base_ws')) ...
           find(strcmp(var,'var_info_base_ws'))]);
     var(IVarIn) =  [];
     info(IVarIn) = [];
     
     for  i=1:length(info)
        s=blanks(16);
        s1=var{i};
        m=min([16 length(s1)]);
        s(1:m)=s1(1:m);
        s2=blanks(12);
        s2tmp = [num2str(info(i).size(1)) 'x' num2str(info(i).size(2))];
        m=min([12 length(s2tmp)]);
        s2(12:-1:12-m+1)=s2tmp(m:-1:1);
        cl=blanks(12);
        m=min([12 length(info(i).class)]);
        cl(1:m)=info(i).class(1:m);
        svar{i}=sprintf('%16s %12s %12s %8i',s, s2, cl,info(i).bytes);
     end
    
     set(uitag('lbFile'),'string',svar,'value',1);
     set(uitag('lbSelected'),'value',1,'string','');
     selected=[];
     isopen=1;

     set(uitag('pbRemove'),'enable','off');
     set(uitag('pbRemoveAll'),'enable','off');
     set(uitag('pbLoad'),'enable','off');
     set(uitag('pbLoadWS'),'enable','off');
     set(uitag('pbLoadAllWS'),'enable','off');
     set(uitag('pbSaveSel'),'enable','off');
     set(uitag('pbLoadAll'),'enable','off');
     if(length(info)),
        set(uitag('pbSelect'),'enable','on');
        set(uitag('pbSelectAll'),'enable','on');
        set(uitag('pbLoadAll'),'enable','on');
     end

     setstatus(['Base workspace variables are loaded']);
    
 case 'edFile'
     newname = get(uitag('edFile'),'string');
     if (exist(newname,'file')==2)
        if ~isempty(who('-file',newname))
           fname=newname;
           wsflg = logical(0);
           ascflg = logical(0);
           matbrowse cmOpen;
        else
           try
              j1f = logical(1);
              dummy = load(newname,'-ascii');
           catch
              j1f = logical(0);
              set(uitag('edFile'),'string',fname);
              msgbox([newname ' is not valid MAT-File'],'matbrowse warning','warn','modal');
           end
           if j1f
              fname=newname;
              wsflg = logical(0);
              ascflg = logical(1);
              duminfo = whos('dummy');
              matbrowse cmOpen;
           end
        end
     elseif(strcmp(newname,'BWS'))
        wsflg = logical(1);
        ascflg = logical(0);
        matbrowse pbLoadWSVar;
     else
        set(uitag('edFile'),'string',fname);
        msgbox(['File ' newname ' not found on MATLAB''s search path'],'matbrowse warning', ...
           'warn','modal');
        drawnow;
     end
  
  case 'pbSelect'
     if isopen & ~isempty(var)
       next=get(uitag('lbFile'),'value');
       if next<length(var)
          set(uitag('lbFile'),'value',next+1);
       else
          set(uitag('lbFile'),'value',1);
       end

        if isempty(selected)
          selected=next;
        elseif isempty(find(selected==next))
          selected=[selected next];
        end

        for i=1:length(selected)
           s{i}=svar{selected(i)};
        end
        set(uitag('lbSelected'),'string',s, 'value', length(s));

        if(length(selected)==length(var))
           set(uitag('pbSelect'),'enable','off');
           set(uitag('pbSelectAll'),'enable','off');
        end
        set(uitag('pbRemove'),'enable','on');
        set(uitag('pbRemoveAll'),'enable','on');
        set(uitag('pbLoad'),'enable','on');
        if(~wsflg),
           set(uitag('pbLoadWS'),'enable','on');
        end;
        set(uitag('pbSaveSel'),'enable','on');

        setstatus(['Variable <' var{selected(end)} '> is selected']);
     end

  case 'pbSelectAll'
     selected=1:length(var);
     set(uitag('lbSelected'),'string',svar, 'value',length(var));

     set(uitag('pbSelect'),'enable','off');
     set(uitag('pbSelectAll'),'enable','off');
     set(uitag('pbRemove'),'enable','on');
     set(uitag('pbRemoveAll'),'enable','on');
     set(uitag('pbLoad'),'enable','on');
     set(uitag('pbLoadAll'),'enable','on');
     if(~wsflg),
        set(uitag('pbLoadWS'),'enable','on');
        set(uitag('pbLoadAllWS'),'enable','on');
     end
     set(uitag('pbSaveSel'),'enable','on');

     setstatus('All variables are selected');

  case 'pbRemove'
     k=get(uitag('lbSelected'),'value');
     if ~isempty(selected)
        setstatus(['Variable <' var{selected(k)} '> is removed from select list']);
        selected(k)=[];
        if ~isempty(selected)
           for i=1:length(selected)
             s{i}=svar{selected(i)};
           end
           set(uitag('lbSelected'),'string',s,'value',min([k length(selected)]));

           set(uitag('pbSelect'),'enable','on');
           set(uitag('pbSelectAll'),'enable','on');
         else
            matbrowse pbRemoveAll;
         end
     end

  case 'pbRemoveAll'
     selected=[];
     set(uitag('lbSelected'),'string','','value',1);

     set(uitag('pbSelect'),'enable','on');
     set(uitag('pbSelectAll'),'enable','on');
     set(uitag('pbLoad'),'enable','off');
     set(uitag('pbLoadWS'),'enable','off');
     set(uitag('pbSaveSel'),'enable','off');
     set(uitag('pbRemove'),'enable','off');
     set(uitag('pbRemoveAll'),'enable','off');

     setstatus('All variables are removed from select list');

  case 'pbSaveSel'
     if ~isempty(selected)
       [f p]=uiputfile('*.mat');
       if f
          sname=fullfile(p,f);
          save_selected(fname,sname,var,selected,ascflg,wsflg)
          setstatus(['selected variables are stored in <' sname '>']);
          if strcmp(sname,fname)
             matbrowse cmOpen;
          end
       end
     end

  case 'pbLoad'
     if isopen & ~isempty(selected)
        selvar=var(selected);
        if wsflg
           tmpstr = strcat('''',selvar,''','); 
           evalin('base',['save(''tmp_sav_file.mat'',' tmpstr{:} ...
                 '''-mat'');']);
           out=load('tmp_sav_file.mat',selvar{1:end},'-mat');
           delete tmp_sav_file.mat;
        elseif ascflg
           [path,s1,ext] = fileparts(fname);
           out=struct(s1,load(fname,'-ascii'));
        else
           out=load(fname,selvar{1:end},'-mat');
        end
        close;
     end

  case 'pbLoadAll'
     if isopen
        if wsflg
           evalin('base',['save(''tmp_sav_file.mat'');']);
           out=load('tmp_sav_file.mat','-mat');
           delete tmp_sav_file.mat;
        elseif ascflg
           [path,s1,ext] = fileparts(fname);
           out=struct(s1,load(fname,'-ascii'));
        else
           out=load(fname,'-mat');
        end
        close;
     end

  case 'pbLoadWS'
     if isopen & ~isempty(selected)
        selvar=var(selected);
        assignin('base','fname',fname);
        assignin('base','selvar',selvar);
        if ascflg
           [path,s1,ext] = fileparts(fname);
           evalin('base','load(fname,''-ascii'');');
           out=struct(s1,load(fname,'-ascii'));
        else
           evalin('base','load(fname,selvar{1:end},''-mat'');');
           out=load(fname,selvar{1:end},'-mat');
        end
        evalin('base','clear fname selvar;');
     end

  case 'pbLoadAllWS'
     if isopen
        assignin('base','fname',fname);
        if ascflg
           [path,s1,ext] = fileparts(fname);
           evalin('base','load(fname,''-ascii'');');
           out=struct(s1,load(fname,'-ascii'));
        else
           evalin('base','load(fname,''-mat'');');
           out=load(fname,'-mat');
        end
        evalin('base','clear fname;');
     end
     
  case 'pbClose'
     close(gcf);
     res = out;
     
  case 'lbSelected'
     if isopen & ~isempty(var)
        next=get(uitag('lbSelected'),'value');
        setstatus(['Variable <' var{selected(next)} '> is selected']);
     end
     
  case 'lbFile'
     if isopen & ~isempty(var)
        next=get(uitag('lbFile'),'value');
        setstatus(['Variable <' var{next} '> is selected']);
     end
     
  case 'BWS'
     ascflg = logical(0);
     res=[];
     out=[];
     gui_init;
     matbrowse pbLoadWSVar;
     clf=0;

  otherwise
     wsflg = logical(0);
     ascflg = logical(0);
     res=[];
     clf=[];
     out=[];
     gui_init;
     newname = which(command);
     if isempty(exist(newname,'file'))
        msgbox(['File ' command ' not found on MATLAB''s search path'],'matbrowse warning', ...
           'warn','modal');
        setstatus(['Mat-file <' command '> is not found on MATLAB''s search path']);
        drawnow;
        clf = 0;  
     elseif (exist(newname,'file')==2)
        if ~isempty(who('-file',newname))
           fname=newname;
           matbrowse cmOpen;
           clf = 0;  
        else
           try
              j1f = logical(1);
              dummy = load(newname,'-ascii');
           catch
              j1f = logical(0);
              msgbox([newname ' is not valid MAT-File'],'matbrowse warning','warn','modal');
              drawnow;
              setstatus(['Mat-file <' command '> is not a valid MAT-File']);
              clf = 0;  
           end
           if j1f
              fname=newname;
              ascflg = logical(1);
              duminfo = whos('dummy');
              matbrowse cmOpen;
              clf = 0;  
           end
        end
     end
end

if (~isempty(clf) & ~clf)
   clf = [];
   uiwait;
   fname=[];
   var=[];
   svar=[];
   isopen=[];
   selected=[];
   res = out;
   out=[];
   ascflg = [];
   duminfo = [];
end
clf = [];
return;

function h=gui_init
%GUI initialisation

h=matbrowse_gui;
uictl={...
      'pbClose',...
      'pbBrowse',...
      'pbLoadWSVar'...   
      'pbLoad',...
      'pbLoadAll',...
      'pbLoadWS',...
      'pbLoadAllWS',...
      'pbSelect',...
      'pbSelectAll',...
      'pbRemove',...
      'pbRemoveAll',...
      'pbSaveSel',...
      'lbFile',...
      'lbSelected',...
      'edFile'...
     };
for i=1:length(uictl)
  set(uitag(uictl{i}),'callback',['matbrowse ' uictl{i} ';']);
end

function h=uitag(tagstr)
%UITAG finds uicontrol by tag
h=findobj(gcf,'tag',tagstr);

function save_selected(fname,sname,var,selected,ascflg,wsflg)
%Save selected variables
if wsflg
   clear CCblanks;
   [CCblanks{1:length(selected),1}] = deal(' ');
   sav_sel_var = strcat(CCblanks,var(selected));
   evalin('base',['save ' sname [sav_sel_var{:}] ';']);
   clear CCblanks sav_sel_var;
elseif ascflg
   tmpvar = load(fname,'-ascii');
   save(sname,'tmpvar','-ascii','-double');
else
   load(fname,var{selected},'-mat');
   save(sname,var{selected},'-mat');
end   
