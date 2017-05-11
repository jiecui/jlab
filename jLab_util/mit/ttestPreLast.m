function crunch = ttestPreLast(crunch, subjnumbers, newsubjectname, prestring, laststring, filename)
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
      warning(sprintf('Subject %d does not have session named %s! Continuing...', s, prestring));
      continue;
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
tvals = zeros(size(preavg(:,:,1)));
for i=1:size(preavg,1)
   for j=1:size(preavg,2)
       % what about NaN's? lyngby doesn't like them, so let's 2-way filter
       keepset = intersect(find(~isnan(preavg(i,j,:))),find(~isnan(lastavg(i,j,:))));
       vals1 = preavg(i,j,keepset);
       vals2 = lastavg(i,j,keepset);
       tvals(i,j) = lyngby_ts_pttest(vals1, vals2);
       if tvals(i,j) < 0.05,
           bar([squeeze(vals1) squeeze(vals2)]); tvals(i,j)
       end
   end
end

if nargin==6
   tblwrite(tvals,char(crunch.measures),char(crunch.conditions),filename,',');
else
   tblwrite(tvals,char(crunch.measures),char(crunch.conditions),'tvals_prelast.csv',',');
end

      
%preavg = mean(preavg,3)
%prestd = mean(prestd,3);
%lastavg = mean(lastavg,3);
%laststd = mean(laststd,3);


