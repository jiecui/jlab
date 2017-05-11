%% ----------------------------------------------------------------------
% Last modified by Richard J. Cui at Tue 12/30/2014 10:46:33.004 AM

% Get current session value of listbox
function [Selection,SelectionIndex] = GetCurrentValue(listbox)

% [Selection,SelectionIndex] = GetCurrentValue(listbox_handle)
% 
% Returns a string containing the current selection in the specified listbox.
% Also return the index to the item in a second output argument.

ListItems = get(listbox,'string');
SelectionIndex = get(listbox,'value');
if SelectionIndex ~= 0
    if isscalar(SelectionIndex)
        Selection = ListItems{SelectionIndex};
    else
        Selection = ListItems(SelectionIndex);
    end
else
    Selection = [];
    SelectionIndex = [];
end % if
