function project = proj_stats_close(project, ok_canc_appl)
% close the stats window, and apply changes if necessary
ui = project.prjui;
if ok_canc_appl == 1 | ok_canc_appl == -1,
   project.stats_flags.path_length = get(ui.path_length_cb, 'Value');
   % add more as we go
   if ok_canc_appl == 1,
      close(ui.stats_fig);
   end;
elseif ok_canc_appl == 0,
   close(ui.stats_fig);
end;