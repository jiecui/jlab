function nofiltername = trim_filter_name( name, current_tag)
% removes the filtername at the end of the strings
%  for instance goes from pus_RealMotion to pus

% get all the filter names
filter_names = CorrGui.filter_conditions( 'get_condition_names', current_tag);

if ( ~iscell(name) )
    nofiltername = name;
    
    for i=1:length(filter_names)
        if ( length(name) > length(filter_names{i})+1 )
            if ( strcmp(['_' filter_names{i}], name(end-length(filter_names{i}):end)) )
                nofiltername = name(1:end-length(filter_names{i})-1);
                return
            end
        end
    end
    
else
    
    nofiltername = name;
    for j=1:length(name)
        for i=1:length(filter_names)
            if ( length(name{j}) > length(filter_names{i})+1 )
                if ( strcmp(['_' filter_names{i}], name{j}(end-length(filter_names{i}):end)) )
                    nofiltername{j} = name{j}(1:end-length(filter_names{i})-1);
                    continue;
                end
            end
        end
    end
    
end