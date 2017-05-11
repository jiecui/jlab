function crunch = collapseSubjects(crunch, subjectnumbers, slicelabels, newsubjectname)
% crunch = collapseSubjects(crunch, subjectnumbers, slicelabels, newsubjectname)
% collapses the subjects specified in subjectnumbers string (e.g. '2:10'), proceeding
% by slicelabels, and putting new averaged data into subject named newsubjectname

% first check for newsubjectname
try
   % search for subject
   subj_idx = strmatch(newsubjectname, crunch.subject_names);
   if isempty(subj_idx)
      subj_idx = length(crunch.subject_names)+1;
   end
catch
   warning('Uninitialized crunchStruct! Must at least have subject_names field');
   return;
end

% get subjects to collapse
eval(sprintf('subjs = [%s];',subjectnumbers));
% check bounds
subjs = subjs(find((subjs<=length(crunch.subjects) & (subjs>=1))));
newavg = [];
newstd = [];
newnames = {};
for slice=slicelabels
   n=0;
   slavg = [];
   slstd = [];
   for s=subjs
      subj=crunch.subjects(s);
		match = find(strcmp(slice, subj.slice_labels));
      if ~isempty(match)
         n = n + 1;
         slavg = cat(3,slavg,subj.data.avg(:,:,match(1)));
         slstd = cat(3,slstd,subj.data.std(:,:,match(1)));
      end
   end
   % compute slice stats
   newavg = cat(3,newavg,mean(slavg,3));
   newstd = cat(3,newstd,mean(slstd,3));
   newnames = [newnames {sprintf('%s Rx (N=%d)',slice{1},n)}];
end

% put into new subject
crunch.subject_names{subj_idx} = newsubjectname;
crunch.subjects(subj_idx).id = newsubjectname;
if ~isfield(crunch.subjects(subj_idx).data, 'avg')
    %crunch.subjects(subj_idx).data = [];
    crunch.subjects(subj_idx).data.avg = [];
    crunch.subjects(subj_idx).data.std = [];
end

% avoid adding new data when this is a "repeat" operation
nslice=0;
for lbl=slicelabels
   nslice = nslice+1;
   match = find(strcmp(lbl,crunch.subjects(subj_idx).slice_labels));
   if ~isempty(match)
      % update
      crunch.subjects(subj_idx).slice_names{match(1)} = newnames{nslice};
      crunch.subjects(subj_idx).slice_labels{match(1)} = slicelabels{nslice};
      crunch.subjects(subj_idx).data.avg(:,:,nslice) = newavg(:,:,nslice);
      crunch.subjects(subj_idx).data.std(:,:,nslice) = newstd(:,:,nslice);
   else
      crunch.subjects(subj_idx).slice_names = [crunch.subjects(subj_idx).slice_names {newnames{nslice}}];
		crunch.subjects(subj_idx).slice_labels = [crunch.subjects(subj_idx).slice_labels {slicelabels{nslice}}];
		crunch.subjects(subj_idx).data.avg = cat(3,crunch.subjects(subj_idx).data.avg,newavg(:,:,nslice));
      crunch.subjects(subj_idx).data.std = cat(3,crunch.subjects(subj_idx).data.std,newstd(:,:,nslice));
   end
end


   
   