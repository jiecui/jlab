function conditions = cond_import(project)
newp.valid = 0;
conditions = {};
% load scene from .prj file
[newp.filename,newp.pathname] = uigetfile('*.prj','Open Project File');

if (newp.pathname == 0),
   % 'cancel' condition
   return
else
   % want to always come back to the last directory
   cd(newp.pathname);
   clear newp.data;
   newp.filename = lower(newp.filename);
   % this gets all the data, including the teachers, but they are not indexed
   newp = load(strcat(newp.pathname, newp.filename), '-MAT');
   newp = newp.current_proj;
   conditions = newp.conditions_cells;
end;
