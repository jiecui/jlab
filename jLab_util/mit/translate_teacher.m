function [new_data, tch_data] = translate_teacher(session_info, tch, x, y, z)
si = session_info;
tch_data = si.data(si.tch_start(tch)+find(si.data(si.tch_start(tch)+1:si.tch_end(tch)-1,1)<5),:);
onz = ones(size(tch_data,1),1);
tch_data(:,[4 3 5]) = tch_data(:,[4 3 5]) + [onz*x onz*y -onz*z];
si.data(si.tch_start(tch)+1:si.tch_end(tch)-1,:) = tch_data;
new_data = si.data;