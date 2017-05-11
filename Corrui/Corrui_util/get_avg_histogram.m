function [histos, histos_errs] = get_avg_histogram(data, groups, edges, Type)

num_groups = length(unique(groups));
for jgroup = 1:num_groups
    data_idx = groups == jgroup;
    group_histos{jgroup}	= histc( data(data_idx) , edges);
    
    switch( Type )
        case 'Percentage'
            group_histos{jgroup} = group_histos{jgroup}/ sum(group_histos{jgroup}) ;
        case 'Percentmax'
            group_histos{jgroup} = group_histos{jgroup} / max(group_histos{jgroup});
        case 'Density'
            density = ksdensity(log(data(data_idx{jgroup})), log(edges));
            group_histos{jgroup} = density/sum(density)*sum(group_histos{jgroup});
        otherwise

    end
    
end
histos = mean(cat(3, group_histos{:}),3);
histos_errs = std(cat(3, group_histos{:}),0,3)/sqrt(num_groups);