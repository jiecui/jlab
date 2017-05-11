function project = cond_del(project)
% delete the currently selected condition
lb = project.prjui.conditions_listbox;
conds = get(lb, 'String');
row = get(lb, 'Value');
selected = conds(row,:);
if length(selected) < 1,
   return;
   end;
[conds, indices] = setdiff(conds, selected, 'rows');
if row ~= 1,
   row = row - 1;
end;
set(lb, 'Value', row);
set(lb, 'String', conds);
% delete from the "backing store"
conds = project.prjui.temp_cond;
if ~isempty(conds),
   conds = conds([indices],:);
end;
% conds = setdiff(char(conds), selected, 'rows');
project.prjui.temp_cond = conds;