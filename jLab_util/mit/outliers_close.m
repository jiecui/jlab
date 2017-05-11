function project = outliers_close(project, ok_canc_appl)
if ok_canc_appl == 1,
   % ok signal
   % save outliers info to current_proj by findobj(outliers_fig, ...)
   project.trials_list = get(project.prjui.trials_list, 'String');
   project.outliers_list = get(project.prjui.outliers_list, 'String');
   %project.
   close(project.prjui.outliers_fig);
elseif ok_canc_appl == 0,
   close(project.prjui.outliers_fig);
elseif ok_canc_appl == -1,
   % save outliers info to current_proj by findobj(outliers_fig, ...)
   project.trials_list = get(project.prjui.trials_list, 'String');
   project.outliers_list = get(project.prjui.outliers_list, 'String');
end;

