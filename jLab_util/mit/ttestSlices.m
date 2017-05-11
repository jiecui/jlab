function crunch = ttestSlices(crunch, subjnumbers, slice1, slice2, filename)
% function to compare 2 time slices with paired ttest. If either slice is missing from
% a subject, that subject is omitted from the analysis with a warning

if ~isfield(crunch, 'subject_names')
   disp('Uninitialized crunchStruct! Must at least have subject_names field');
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
   match1 = find(strcmp(slice1, subj.slice_labels));
   match2 = find(strcmp(slice2, subj.slice_labels));
   if ~isempty(match1) & ~isempty(match2)
      preavg = cat(3,preavg,subj.data.avg(:,:,match1(1)));
      prestd = cat(3,prestd,subj.data.std(:,:,match1(1)));
      lastavg = cat(3,lastavg,subj.data.avg(:,:,match2(1)));
      laststd = cat(3,laststd,subj.data.std(:,:,match2(1)));
   else
      disp(sprintf('Subject %d does not have session named %s or %s! Continuing...', s, slice1, slice2));
      continue;
   end
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
   end
end

if nargin==5
   tblwrite(tvals,char(crunch.measures),char(crunch.conditions),filename,',');
else
   tblwrite(tvals,char(crunch.measures),char(crunch.conditions),'tvals_prelast.csv',',');
end

      
%preavg = mean(preavg,3)
%prestd = mean(prestd,3);
%lastavg = mean(lastavg,3);
%laststd = mean(laststd,3);
