function crunch = collapseSlicesSubjects(crunch, subjnumbers, collapsecell)
% function to apply same collapse command to several subjects
% get array indicating which subjects
eval(sprintf('subjs = [%s];',subjnumbers));
% check bounds
subjs = subjs(find((subjs<=length(crunch.subjects) & (subjs>=1))));
for s=subjs
   sname = crunch.subject_names{s};
   crunch=collapseSlices(crunch, sname, collapsecell);
end
