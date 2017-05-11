function updateNorm()

% remember where we are
orig_path = pwd;

% open file
[f,p] = uigetfile('*.cdt', 'Update Crunch File');
if ~p
   return
end

% load crunch
crunch = load(strcat(p,f), '-MAT');
names = fieldnames(crunch);
crunch = getfield(crunch,names{1});

% do normals
%cd E:\Matlab\work\DanaRWTdata\Normals
cd C:\MatlabR11\work\Normals
[normresults, normproject_files, normcomments, normlabels, measure_names, condition_names] = normcalc;
cached_results{1} = {normresults normcomments normlabels};

% try another call
% fix up measure_names
%measure_names = measure_names(:,2:length(measure_names));
%crunch = updateCrunch(crunch, condition_names, measure_names);
%make the patient
crunch = updateSubject(crunch, 'Normals', normcomments, normlabels, normresults);
% try a collapse
collapse = {{'Left Combined',[3 4 7 9 11 13 15 17]} {'Right Combined', [1 2 5 6 8 10 12 14 16]} {'Right Combined wo. EB', [2 5 6 8 10 12 14 16]} ...
      {'All Combined', [1:17]} {'All w/o EB', [2:17]} ...
      {'Young', [2 3 4 5 8 9 12 13]} {'Old w. EB', [1 6 7 10 11 14 15 16 17]} {'Old wo. EB', [6 7 10 11 14 15 16 17]} ...
      {'Male w. EB', [1 4 5 8 9 12 13 14 15]} {'Male wo. EB', [4 5 8 9 12 13 14 15]} {'Female', [2 3 6 7 10 11 16 17]}};
crunch = collapseSlices(crunch, 'Normals',collapse);


%save file
save(strcat(p,f), 'crunch');

% cd back to orig
cd(orig_path);