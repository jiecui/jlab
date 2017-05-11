function crunchStruct = updateSubject(crunchStruct, id, slice_names, slice_labels, results)
% updates the results for given subject. If 'id' is not found, this subject
% is added to the end of the array. For convention, Normals will be subject 0
try
   % search for subject
   subj_idx = strmatch(id, crunchStruct.subject_names);
   if isempty(subj_idx)
      subj_idx = length(crunchStruct.subject_names)+1;
      % add subject!
      crunchStruct.subject_names{subj_idx} = id;
   end
catch
   warning('Uninitialized crunchStruct! Must at least have subject_names field');
   return;
end

crunchStruct.subjects(subj_idx).id = id;

crunchStruct.subjects(subj_idx).slice_names = slice_names;
crunchStruct.subjects(subj_idx).slice_labels = slice_labels;

% now re-do results so we have a multi-dim array
% .avg and .std include a column for the trial number that I want to get rid of!
for i=1:length(results)
   slice = results(i);
   data.avg(:,:,i) = slice.avg(:,2:size(slice.avg,2));
   data.std(:,:,i) = slice.std(:,2:size(slice.avg,2));
end 
crunchStruct.subjects(subj_idx).data = data;
      