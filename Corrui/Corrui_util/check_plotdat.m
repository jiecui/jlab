

%% == check_plotdat
function check_plotdat( plotdat, variable_names )
% function check_plotdat( plotdat, variable_names )
% check if the variables in variable_names are empty

if isempty( variable_names )
	return
end

if ischar(variable_names)
	variable_names = { variable_names };
end

for variable_name = variable_names
	variable_name = char(variable_name);

	% Check if its empty -- not always
	if ~isfield(plotdat, variable_name)
		error( ['The variable ' variable_name ' doesn''t exist and is necessary for this plot'] );
	end
	if isempty(plotdat.(variable_name))
		error( ['The variable ' variable_name ' is empty and is necessary for this plot'] );
	end
end