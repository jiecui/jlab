function crunch = collapsePreLast(crunch, subjnumbers, newsubjectname, prestring, laststring)
% function to collapse the "Pre" and "last" sessions for a number of patients together

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

eval(sprintf('subjs = [%s];',subjnumbers));
% check bounds
subjs = subjs(find((subjs<=length(crunch.subjects) & (subjs>=1))));
preavg = [];
prestd = [];
lastavg = [];
laststd = [];
for s=subjs
   % get data for "Pre", use strmatch
   subj=crunch.subjects(s);
   match = find(strcmp(prestring, subj.slice_labels));
   if ~isempty(match)
      preavg = cat(3,preavg,subj.data.avg(:,:,match(1)));
      prestd = cat(3,prestd,subj.data.std(:,:,match(1)));
   else
      warning(sprintf('Not all subjects have session named %s! Exiting...',prestring));
      return;
   end
   % length(slice_names)-1 because we know
   lastslice = length(subj.slice_labels);
   lastispre = strcmp(prestring, subj.slice_labels{lastslice});
   if lastispre
      lastslice = lastslice - 1;
   end
   lastavg = cat(3,lastavg,subj.data.avg(:,:,lastslice));
  	laststd = cat(3,laststd,subj.data.std(:,:,lastslice));
end

% compute!
preavg = mean(preavg,3);
prestd = mean(prestd,3);
lastavg = mean(lastavg,3);
laststd = mean(laststd,3);

% put into new struct array index
crunch.subject_names{subj_idx} = newsubjectname;
crunch.subjects(subj_idx).id = newsubjectname;
crunch.subjects(subj_idx).slice_names = {prestring laststring};
crunch.subjects(subj_idx).slice_labels = {prestring laststring};
crunch.subjects(subj_idx).data.avg(:,:,1) = preavg;
crunch.subjects(subj_idx).data.std(:,:,1) = prestd;
crunch.subjects(subj_idx).data.avg(:,:,2) = lastavg;
crunch.subjects(subj_idx).data.std(:,:,2) = laststd;
