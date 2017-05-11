function  handles =  plot_reaction_time_patch(ax, reaction_times, before_or_after_time_zero, groups)
% function  handles =  plot_reaction_time_patch(ax, reaction_times, before_or_after_time_zero, groups)
% INPUT: 
%       ax:
%       reaction_times: reaction times in (ms)
%       before_or_after_time_zero: 'before' or 'after' depending on where
%       you want the reaction time plot relative to time zero
%       groups: if not empty then calculates the average across subjects
%       using groups as a marker for where individual subject data is
%

axes(ax);
if isempty(groups)
    std_rt = std(reaction_times);
    mean_rt = mean(reaction_times);
else
    num_groups = length(unique(groups));
    for igroup = 1:num_groups
        group_idx = groups == igroup;
        
        mean_rt(igroup) = mean(reaction_times(group_idx));
        std_rt(igroup) = std(reaction_times(group_idx));
        
    end
    std_rt = mean(std_rt);
    mean_rt = mean(mean_rt);
    
end

mean_minus_std = mean_rt - std_rt;
mean_plus_std = mean_rt + std_rt;

switch before_or_after_time_zero
    
    case 'before'
        mean_rt = -mean_rt;
        mean_minus_std = -mean_minus_std;
        mean_plus_std =-mean_plus_std;
        
    case 'after'
        
end

handles.reaction_time_mean = plot(ax,[mean_rt mean_rt ], get(ax,'ylim'),'linestyle','--','color','k','linewidth',2);
verts = [mean_minus_std  min(get(ax,'ylim')); mean_minus_std max(get(ax,'ylim')); mean_plus_std  min(get(ax,'ylim')); mean_plus_std max(get(ax,'ylim'))];
face = [1 2 4 3];
handles.reaction_time_patch = patch('Faces',face,'Vertices',verts,'FaceColor', 'k','FaceAlpha',.15,'MarkerEdgeColor','k');

end