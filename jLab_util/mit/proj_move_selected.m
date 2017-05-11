function status = proj_move_selected(list1, list2)
% should move one or more trials from trial status to outlier status
cell1 = cellstr(get(list1, 'String'));
if isempty(cell1),
   return;
end;
cell2 = cellstr(get(list2, 'String'));
selected = get(list1, 'Value');
items = cellstr(cell1{selected});
if length(cell2) < 1 | length(cell2{1}) < 1,
   cell2 = items;
else
   cell2 = [cell2;items];
   for i=1:length(cell2),cell2i(i)=str2num(strtok(char(cell2(i)),':'));end;
	[srtd, indices] = sort(cell2i');
	cell2 = cell2([indices]);
 end;
set(list2, 'String', cell2);
cell1 = setdiff(cell1, cell2);
% bastard setdiff does a sort
if length(cell1) > 1,
   for i=1:length(cell1),cell1i(i)=str2num(strtok(char(cell1(i)),':'));end;
	[srtd, indices] = sort(cell1i');
	cell1 = cell1([indices]);
 end;
if get(list1, 'Value') > 1,
   set(list1, 'Value', selected-1);
end;
set(list1, 'String', cell1);
% mark as dirty, put it in ui_struct?