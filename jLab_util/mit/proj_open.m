newp.valid = 0;
% load scene from .prj file
[filename,pathname] = uigetfile('*.prj','Open Project File');

if (pathname == 0),
   % 'cancel' condition
   return
else
   % want to always come back to the last directory
   cd(pathname);
   clear newp.data;
   %filename = lower(newp.filename);
   % this gets all the data, including the teachers, but they are not indexed
   newp = load(strcat(pathname, filename), '-MAT');
   newp = newp.current_proj;
   newp.filename = filename;
   newp.pathname = pathname;
   % old version help
   if ~isfield(newp, 'stats_flags'),
      newp.stats_flags.path_length = 1;
   end;
   
   % set GUI controls to reflect results of file loading, clear GUI input boxes
   set(proj_info_box,'string',sprintf('File: %s;   Trials: %d;   Sensors:%s   Teachers: %d',newp.filename,newp.num,newp.sens,newp.num_teachers));
   set(proj_scenelist, 'Value', 1);
   set(proj_scenelist, 'string', newp.scene_info);
   newp.valid = 1;
   current_proj = newp;
   clear newp;
end


