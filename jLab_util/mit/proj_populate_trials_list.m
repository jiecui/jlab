function cellArray = proj_populate_trials_list(project)
% project should be current_proj...
% make a cell array of strings
for i=1:length(project.session_info.trial_start),
   cellArray{i} = sprintf('%s:    %s', num2str(i), project.session_info.scene_names{i});
end;

   
   