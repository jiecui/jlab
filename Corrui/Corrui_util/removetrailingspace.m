% --- Function to strip text after 1st non-white-space chars (trim)
function txt = removetrailingspace(txt)
if iscell(txt)
	for iRow = 1:size(txt,1)
		spaces = find(isspace(txt{iRow}));
		if ~isempty(spaces) & spaces(1)~=1
			txt{iRow} = txt{iRow}(1:spaces(1)-1);
		end
	end
else
	spaces = find(isspace(txt));
	if ~isempty(spaces) & spaces(1)~=1
			txt = txt(1:spaces(1)-1);
	end
end