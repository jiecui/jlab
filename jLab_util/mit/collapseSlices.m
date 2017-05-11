function crunchStruct = collapseSlices(crunchStruct, subject_id, collapsed_info)
% takes some "time slices" of a given subject, and calculates then stores the
% new means and standard deviations as additional rows and columns in the
% data struct as additional "slices"

%first see if the patient is there
try
   % search for subject
   subj_idx = strmatch(subject_id, crunchStruct.subject_names);
   if isempty(subj_idx)
      warning(strcat('Subject ', subject_id, 'does not exist!'));
      return;
   end
catch
   warning('Uninitialized crunchStruct! Must at least have subject_names field');
   return;
end

subj = crunchStruct.subjects(subj_idx);
% know what's needed here. first get intersect indices for each collapse group
% format is {{group1name, [idx1, idx2, ...]}, {group2name, [idx3,...]}, ...}
groups = cell(length(collapsed_info),1);
for i=1:length(groups)
   groups{i} = collapsed_info{i}{1};
   avg_subset = subj.data.avg(:,:,collapsed_info{i}{2});
   std_subset = subj.data.std(:,:,collapsed_info{i}{2});
   new_avg = mean(avg_subset,3);
   new_std = mean(std_subset,3);
   match = find(strcmp(collapsed_info{i}{1}, subj.slice_labels)); % must match exactly, then take first one
   if ~isempty(match)
   	subj.data.avg(:,:,match(1)) = new_avg;
      subj.data.std(:,:,match(1)) = new_std;
   else
      subj.data.avg(:,:,size(subj.data.avg,3)+1) = new_avg;
      subj.data.std(:,:,size(subj.data.std,3)+1) = new_std;
      subj.slice_names = [subj.slice_names {' '}];
		subj.slice_labels = [subj.slice_labels {groups{i}}];  
   end
end

crunchStruct.subjects(subj_idx) = subj;
