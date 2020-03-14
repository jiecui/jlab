function [option_selected] = optionsdlg( title, varname, options, default_option, position)

if ( exist('default_option') )
	default_index			= find( strcmp( lower(options), lower(default_option)));
	options{default_index}	= ['{' options{default_index} '}'];
end


str_options = '';
for i=1:length(options)
	if ( i == 1 )
	str_options = options{i};
	else
	str_options = [str_options '|' options{i}];
	end
end
S.(strrep(varname,' ', '_')) = { str_options };

res = StructDlg(S, title, [], position);

if ( isempty(res) )
	option_selected = [];
else
	option_selected = res.(strrep(varname,' ', '_'));
end