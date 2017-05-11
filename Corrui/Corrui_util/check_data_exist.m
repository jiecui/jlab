

%% == check_plotdat
function out = check_data_exist( data, variable_names )
% function check_plotdat( data, variable_names )
% check if the variables in variable_names are empty

if isempty( variable_names )
    out = 0;
	return
end

if ischar(variable_names)
    variable_names = { variable_names };
end

for variable_name = variable_names
    variable_name = char(variable_name);
    
    % Check if its empty -- not always
    if ~isfield(data, variable_name)
        out = 0;
        return;
    else
        out = 1;
    end
end