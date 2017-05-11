function cellArray = proj_fill_conditions_listbox(project)
% project should be current_proj...
% make a cell array of strings
cellArray = {};
if ~isempty(project.conditions_cells),
	for i=1:size(project.conditions_cells, 1),
   	condnm = project.conditions_cells{i}{1};
   	scenenm = project.conditions_cells{i}{2};
   	% add comment here?
   	cellArray{i} = sprintf('%s      %s', condnm, scenenm);
   end;
end;
% put project representation into userData for temp storage while editing
% will put back on OK or Apply
project.prjui.temp_cond =  project.conditions_cells;
