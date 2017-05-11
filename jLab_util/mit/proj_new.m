% Should be the New Project callback function
newp.valid = 0; % newp is the new project
% load scene from .vr file
[filename,pathname] = uigetfile('*.dat;*.vr;*.mat','Open Data File');

if (pathname == 0),
   % 'cancel' condition
   return
else
   % want to always come back to the last directory
   cd(pathname);
   clear newp.data;

   % this gets all the data, including the teachers, but they are not indexed
   newp.data = load([pathname filename]);
   
   % Prefix underscores with '\'
   % find last '.'
   undscr = findstr(filename,'.');
   if length(undscr)<1,
      % no extension
      newp.name = filename;
   else
      newp.name = sprintf('%s', filename(1:undscr(length(undscr))-1));
   end;
   clear undscr;
   newp.filename = strcat(newp.name, '.prj');
   newp.pathname = pathname;
   
   % set dialog variables (list boxes, etc.)
   % ii and iif are the beginnings and ends of the trials, respectively
   newp.ii = find(newp.data(:,1)==-1003);
   newp.iif = find(newp.data(:,1)==-1004);
   % tch_start and tch_end are the beginnings and ends of the teacher recordings
   newp.tch_start = find(newp.data(:,1)==-1001);
   newp.tch_end = find(newp.data(:,1)==-1002);
   % num is the number of trials
   newp.num = length(newp.ii);
   % num_teachers is the number of teachers
   newp.num_teachers = length(newp.tch_start);
   
   newp.sens = [];
   if ~isempty(find(newp.data(:,1)==1)), 
      newp.sens = [newp.sens ' 1']; 
   end;
   
   if ~isempty(find(newp.data(:,1)==2)), 
      newp.sens = [newp.sens ' 2']; 
   end;
   
   if ~isempty(find(newp.data(:,1)==3)), 
      newp.sens = [newp.sens ' 3']; 
   end;
   
   if ~isempty(find(newp.data(:,1)==4)), 
      newp.sens = [newp.sens ' 4']; 
   end;
   
   % call load_scene_data to get teacher and scene name info
   [newp.num_scenes, newp.scene_info, newp.session_info] = load_scene_data(filename, newp.data, newp.ii, newp.tch_start );
   newp.session_info.data = newp.data;
   newp.session_info.sensor_string = newp.sens;
   newp.session_info.trial_start = newp.ii;
   newp.session_info.trial_end = newp.iif;
   newp.session_info.tch_start = newp.tch_start;
   newp.session_info.tch_end = newp.tch_end;
   % fix for missing sensor 4 data -- comment out following 6 lines with %-sign at beg. of line
   newp.session_info = fix_pour_data(newp.session_info);
   newp.data = newp.session_info.data;
   newp.ii = newp.session_info.trial_start;
   newp.iif = newp.session_info.trial_end;
   newp.tch_start = newp.session_info.tch_start;
   newp.tch_end = newp.session_info.tch_end;
   newp.trials_list = proj_populate_trials_list(newp);
   newp.outliers_list = {};
   newp.conditions_cells = {};
   newp.stats_flags.path_length = 1;
   % set GUI controls to reflect results of file loading, clear GUI input boxes
   set(proj_info_box,'string',sprintf('File: %s;   Trials: %d;   Sensors:%s   Teachers: %d',newp.filename,newp.num,newp.sens,newp.num_teachers));
   set(proj_scenelist, 'Value', 1);
   set(proj_scenelist, 'string', newp.scene_info);
   newp.valid = 1;
   current_proj = newp;
   clear newp;
end
