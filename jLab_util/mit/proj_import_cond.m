function project = proj_import_cond(project)
import_cells = cond_import(project);
if ~isempty(import_cells),
   % add on to the string
	cond_array = [];
	pad = '                                                                               ';
	for i=1:size(import_cells, 1),
   	name = char(import_cells(i,1));
   	scene_name = char(import_cells(i,2));
   	cond_string = sprintf('%s%s%s', name, pad(1:(30 - length(name))),scene_name);
   	cond_array = strvcat(cond_array, cond_string);
   end;
   lb = project.prjui.conditions_listbox;
   old_conds = get(lb, 'String');
   if isempty(old_conds),
      new_conds = cond_array;
   else
      new_conds = unique(strvcat(old_conds, cond_array), 'rows');
   end;
   set(lb, 'String', new_conds);
   % update 'backing store'
   if isempty(project.prjui.temp_cond),
      project.prjui.temp_cond = import_cells;
   else
      project.prjui.temp_cond = [project.prjui.temp_cond;import_cells];
      [conds, indices] = unique(project.prjui.temp_cond(:,1));
      project.prjui.temp_cond = project.prjui.temp_cond([indices],:);
   end;
end;


   