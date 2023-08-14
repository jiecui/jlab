function list = get_variable_list( curr_exp, type, agg_only_these_vars, filters_to_use )
% EXPERIMENTAGGREGATE.GET_VARIABLE_LIST gets list of variables to be aggreagated
%
% Syntax:
%   list = get_variable_list( curr_exp, type, agg_only_these_vars, filters_to_use )
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012-2020 Richard J. Cui. Created: 10/24/2012  9:25:40.196 AM
% $Revision: 0.2 $  $Date: Wed 04/08/2020  7:08:17.484 AM $
%
% Multimodel Neuroimaging Lab (Dr. Dora Hermes)
% Mayo Clinic St. Mary Campus
% Rochester, MN 55905, USA
%
% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)

list = {};
if ~exist('agg_only_these_vars', 'var')
    data = load('corrui_variable_db_editor.mat');
    data = data.data;
    for i=1:size(data, 1)
        % check if the variable has to be aggregated by this type
        if ( strcmp( data{i, 4}, type ) )
            list = cat(2, list, data{i, 1});
        end
    end
else
    fnames = fieldnames(agg_only_these_vars);
    
    for k = 1:length(fnames)
        var_k = fnames{k};
        if agg_only_these_vars.(var_k)
            list = cat(2, list, var_k);            
        end % if       
    end % for
    % for each variable add the corresping (filtered) version for each filter
    % --------------------------------------------------------------------
    % it is a bit excessive, because for most of the variables there are no
    % filter versions but it is the only way right now
    
    filters = CorrGui.filter_conditions( 'get_condition_names', curr_exp );
    filters = filters(filters_to_use);
    listtemp = list;
    for i = 1:length(filters)
        for j = 1:length(list)
            % listtemp{end+1} = [list{j} '_' filters{i}];
            listtemp = cat(2, listtemp, [list{j} '_' filters{i}]);
        end
    end
    list = listtemp;
end

end % function get_variable_list

% [EOF]
