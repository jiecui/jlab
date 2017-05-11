% load data file, parse
[filename,pathname] = uigetfile('*.dat;*.vr;*.mat','Open Data File');

if (pathname == 0),
   % 'cancel' condition
   return
else
   % want to always come back to the last directory
   cd(pathname);
   clear data;
   filename = lower(filename);
   % this gets all the data, including the teachers, but they are not indexed
   data = load([pathname filename]);
   % I BELIEVE the following is not needed!
   %ind = findstr(filename,'.');
   %if ind>1,
   %   name = filename(1:ind-1);
   %else
   %   name = filename;
   %end;

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
   % set GUI controls to reflect results of file loading, clear GUI input boxes
   set(infobox,'string',sprintf('File: %s;   Trials: %d;   Sensors:%s   Teachers: %d',filename,num,sens,num_teachers));
   set(scenelist, 'string', scene_info);
   set(trialbox,'string','');   
   set(sensorbox,'string','');
   set(teacherbox, 'string', '');
end


