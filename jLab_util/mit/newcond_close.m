function project = newcond_close(project, ok_canc_appl)
if ok_canc_appl == 1 | ok_canc_appl == -1,
   % ok signal
   % set UserData and 'String' of conditions
   name = get(project.prjui.newcond_editbox, 'String');
   if length(name) > 0,
      % valid condition name
      % set the 'String' of the listbox first
      popup_contents = cellstr(get(project.prjui.newcond_scene_popup, 'String'));
		selected = get(project.prjui.newcond_scene_popup, 'Value');
      scene_name = popup_contents{selected};
      pad = '                                                                               ';
      name = name(1:min([length(name) 25]));
      cond_string = sprintf('%s%s%s', name, pad(1:(30 - length(name))),scene_name);
      listbox_contents = get(project.prjui.conditions_listbox, 'String');
      if length(listbox_contents) < 1 | length(listbox_contents(1)) < 1,
         listbox_contents = cond_string;
      else
         listbox_contents = strvcat(listbox_contents, cond_string);
      end;
      set(project.prjui.conditions_listbox, 'String', listbox_contents);
      % now set the "backing store" of the figure
      old_conditions = project.prjui.temp_cond;
      if isempty(old_conditions),
         total_conditions = {name scene_name};
      else
         total_conditions = [old_conditions;{name scene_name}];
      end;
      project.prjui.temp_cond = total_conditions;
      if ok_canc_appl == 1,
         close(project.prjui.newcond_fig);
      end;
   end;
elseif ok_canc_appl == 0,
   close(project.prjui.newcond_fig);
end;
