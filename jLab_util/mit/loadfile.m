% load data file, parse
[filename,pathname] = uigetfile('*.dat;*.vr;*.mat;*.prj','Open Data File');

if (pathname == 0),
   % 'cancel' condition
   return
else
   % want to always come back to the last directory
   cd(pathname);
   clear data;
   filename = lower(filename);
   
	% Prefix underscores with '\'
   undscr = findstr(filename,'_');
   if undscr>1,
      fname = filename;
      for i=1:length(undscr),
         name = sprintf('%s\\%s', fname(1:undscr(i)+i-2), fname(undscr(i)+(i-1):length(fname)));
         fname = name;
      end;
      clear(fname);
   else
      name = filename;
   end;   
   
   % this gets all the data, including the teachers, but they are not indexed
   clear newp;
   clear pload;
   if findstr(filename, '.prj') > 0,
      % have project file, set flag
      pload = 1;
      % this gets all the data, including the teachers, but they are not indexed
      newp = load(strcat(pathname, filename), '-MAT');
      newp = newp.current_proj;
      newp.filename = filename;
      newp.pathname = pathname;
      
      session_info = newp.session_info;
      data = newp.data;
      ii = newp.ii;
      iif = newp.iif;
      tch_start = newp.tch_start;
   	tch_end = newp.tch_end;
      num = newp.num;
      sens = newp.sens;
      scene_info = newp.scene_info;
      num_teachers = newp.num_teachers;      
      
   else,
      
      data = load([pathname filename]);
      
      
      
      %eval(sprintf('data = %s;',num2str(name)));
      %clear(name);
      % ii and iif are the beginnings and ends of the trials, respectively
      ii = find(data(:,1)==-1003);
      iif = find(data(:,1)==-1004);
      % tch_start and tch_end are the beginnings and ends of the teacher recordings
      tch_start = find(data(:,1)==-1001);
      tch_end = find(data(:,1)==-1002);
      % num is the number of trials
      num = length(ii);
      % num_teachers is the number of teachers
      num_teachers = length(tch_start);
      
      sens = [];
      if ~isempty(find(data(:,1)==1)), 
         sens = [sens ' 1']; 
      end;
      
      if ~isempty(find(data(:,1)==2)), 
         sens = [sens ' 2']; 
      end;
      
      if ~isempty(find(data(:,1)==3)), 
         sens = [sens ' 3']; 
      end;
      
      if ~isempty(find(data(:,1)==4)), 
         sens = [sens ' 4']; 
      end;
      
      % call load_scene_data to get teacher and scene name info
      [num_scenes, scene_info, session_info] = load_scene_data(filename, data, ii, tch_start );
      session_info.data = data;
      session_info.sensor_string = sens;
      session_info.trial_start = ii;
      session_info.trial_end = iif;
      session_info.tch_start = tch_start;
      session_info.tch_end = tch_end;
   end;
   
   % fix for missing sensor 4 data -- comment out following 6 lines with %-sign at beg. of line
   session_info = fix_pour_data(session_info);
   data = session_info.data;
   ii = session_info.trial_start;
   iif = session_info.trial_end;
   tch_start = session_info.tch_start;
   tch_end = session_info.tch_end;
   
   % calculate some stats! -- radius set really high to get all samples
   session_info = dana_targets(session_info);
   if session_info.orient_valid
       session_info = dana_spatial_error(session_info);
       session_info = dana_orient_error(session_info);
   end
   [sr, session_info] = spill_stats(session_info, 10.395, 8.5, 10.495, 7.0, 6.2);
   
   eval(sprintf('sensors = [%s];',session_info.sensor_string));
   sensors = sensors(find((sensors<=4) & (sensors>=1)));
   if find(sensors==2) & find(sensors==3),
      %have arm sensor data
      if exist('pload')
         % loaded a project
      	% ask if we want to reload the arm
      	if isfield(session_info,'has_arm')
         	if session_info.has_arm
            	if strcmp('Yes', questdlg('Recalculate Arm data? Could take awhile!', 'Question!', 'Yes', 'No','Yes'))
                  session_info = dana_calc_arm(session_info);
                  newp.session_info = session_info;
                  current_proj = newp;
                  save(strcat(newp.pathname, newp.filename), 'current_proj');
               end
            end
         else
            if strcmp('Yes', questdlg('Calculate Arm data and save in this project? Could take awhile!', 'Question!', 'Yes', 'No', 'Yes'))
               session_info = dana_calc_arm(session_info);
               newp.session_info = session_info;
               current_proj = newp;
               save(strcat(newp.pathname, newp.filename), 'current_proj');
            end
         end
      else
         if strcmp('Yes', questdlg('Calculate Arm data for this session? Could take awhile!', 'Question!', 'Yes', 'No', 'Yes'))
            session_info = dana_calc_arm(session_info);
         end
		end
   end
   
   % set GUI controls to reflect results of file loading, clear GUI input boxes
   summary = sprintf('File: %s;   Trials: %d;   Sensors:%s   Teachers: %d',filename,num,sens,num_teachers);
   set(infobox,'string', summary);
   set(scenelist, 'Value', 1);
   set(scenelist, 'string', scene_info);
   set(trialbox,'string','');   
   set(sensorbox,'string','');
   set(teacherbox, 'string', '');
   session_info.scenelist = scene_info;
   session_info.summary = summary;
   session_info.selectedtrials = '';
   session_info.filename = name;
end


