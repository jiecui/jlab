%% contribution_pie_charts
function handles = plot_contribution_pie_charts(contr_table,event_labels,sname,trial_type,S,ax1,ax2,do_legend)
% global COLORS
% global colors_array

[COLORS colors_array] = CorrGui.get_nice_colors();

explode = zeros(length(event_labels),1);
% % % % contr_colors = cat(1,COLORS.DARK_BLUE, COLORS.MEDIUM_BROWN, COLORS.DARK_GREEN,...
% % % %     COLORS.MEDIUM_ORANGE, COLORS.DARK_RED, COLORS.MEDIUM_PURPLE , COLORS.MEDIUM_PINK,COLORS.GREY );

 contr_pie_colors = cat(1,COLORS.DARK_GREEN, COLORS.MEDIUM_BROWN, COLORS.LIGHT_KHAKI,COLORS.MEDIUM_ORANGE,...
            COLORS.DARK_RED, COLORS.SALMON , COLORS.MEDIUM_PINK,COLORS.WHITE ,COLORS.GREY);

contr_table(contr_table < 1 | isnan(contr_table)) = .0009;

handles.prob_peak_event_axes = ax1;
handles.prob_peak_event_children = pie(ax1,[contr_table(1:end-1,2); 100-contr_table(end,2)],explode);
colormap(ax1, contr_colors )
if do_legend==1
    legend(ax2,event_labels);
end
title(ax1,[sname ' ' trial_type ' P(peak event)'],'fontsize',12);

handles.contribution_axes = ax2;
handles.contribution_children = pie(ax2,[contr_table(1:end-1,1); 100-contr_table(end,1)],explode);
colormap(ax2, contr_colors )
if do_legend==1
    legend(ax2,event_labels);
end
title(ax2,[sname ' ' trial_type ' Contribution'],'fontsize',12);



set(ax1,'fontsize',10);
set(ax2,'fontsize',10);
h = get(ax1,'children');
for jj = 2:2:length(h)
    set(h(jj),'cdatamapping','direct')
end
for jj = 1:2:length(h)
    if strmatch('< 1',get(h(jj),'String'))
        set(h(jj),'Visible','off');
        continue
    end
    set(h(jj),'fontsize',10);
    y=get(h(jj),'String');
    set(h(jj),'string',y(1:end-1));
end

h = get(ax2,'children');
for jj = 2:2:length(h)
    set(h(jj),'cdatamapping','direct')
end
for jj = 1:2:length(h)
    if strmatch('< 1',get(h(jj),'String'))
        set(h(jj),'Visible','off');
        continue
    end
    set(h(jj),'fontsize',10);
    y=get(h(jj),'String');
    set(h(jj),'string',y(1:end-1));
end
end