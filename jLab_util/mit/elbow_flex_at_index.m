function extension = elbow_flex_at_index(session, indices)
si = session;
dat = si.data;
extension = [];
for i=1:length(si.trial_start),
   tdat = dat(si.trial_start(i)+find(dat(si.trial_start(i)+1:si.trial_end(i)-1,1)==5),:);
   extension(i) = dat(indices(i),9);
end;
extension = extension';

