function crunchStruct = updateCrunch(crunchStruct, conditions, measures)
% updates the main crunch struct. Groups of conditions are compiled, and the names of the subjects, measures,
% and conditions are updated

if ~isfield(crunchStruct, 'subject_names')
   crunchStruct.subject_names = {};
end
crunchStruct.conditions = conditions;
crunchStruct.measures = measures;