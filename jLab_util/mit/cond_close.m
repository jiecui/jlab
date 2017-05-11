function project = cond_close(project, ok_canc_appl)
% close the conditions dialog, saving the conditions
% to the project if needs be
if ok_canc_appl == 1,
   % ok signal
   % save conditions info to current_proj by findobj(outliers_fig, ...)
   project.conditions_cells = project.prjui.temp_cond;
   %project.
   close(project.prjui.conditions_dlg);
   project.prjui.conditions_fig_open = 0;
elseif ok_canc_appl == 0,
   close(project.prjui.conditions_dlg);
   project.prjui.conditions_fig_open = 0;
elseif ok_canc_appl == -1,
   % save conditions info to current_proj by findobj(outliers_fig, ...)
   project.conditions_cells = project.prjui.temp_cond;
end;
