function crunch = redoSubjects(crunch)

for i=1:length(crunch.subjects)
   crunch.subjects(i).data.avg = crunch.subjects(i).data.avg(:,2:17,:);
   crunch.subjects(i).data.std = crunch.subjects(i).data.std(:,2:17,:);
end

