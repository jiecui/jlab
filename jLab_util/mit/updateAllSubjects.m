function crunchStruct = updateAllSubjects(crunchStruct, cached_results)
cr = cached_results;
i = 0;
for s=crunchStruct.subject_names
   i = i + 1;
   crunchStruct = updateSubject(crunchStruct, s, cr{i}{2}, cr{i}{3}, cr{i}{1});
end
