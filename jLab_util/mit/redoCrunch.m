function crunch = redoCrunch(cached_results, subject_names)

crunch = [];
conditions = {'30ReachSideRight','45ReachSideRight','60ReachSideRight',...
      '75ReachSideRight','HandLumbar','Handshake','KeyLockBox','MailAbd',...
      'MailAdd','MailCtr','ReachBeg','SleevePull','SupineMailDiag','SupineReachSideExact'};
measures = {};
crunch = updateCrunch(crunch, conditions, measures);


% save big cell array of results
output_dir = 'E:\DanaGraphs'
original_dir = pwd;
tic

% do normals
cd E:\Matlab\work\DanaRWTdata\Normals
[normresults, normproject_files, normcomments, measure_names, condition_names] = normcalc;


% try another call
% fix up measure_names
measure_names = measure_names(:,2:length(measure_names));
crunch = updateCrunch(crunch, conditions, measure_names);
%make the patient
crunch = updateSubject(crunch, 'Normals', normcomments, normresults);
% try a collapse
collapse = {{'Left Combined',[2 3]}};
crunch = collapseSlices(crunch, 'Normals',collapse); 



% try to init the first patient
disp('calculating S101 data...');
disp(datestr(now));
cd E:\Matlab\work\DanaRWTdata\S1data\RightRWT
[results, project_files, comments, measure_names, condition_names] = s101_COMBINEDcalc;

crunch = updateSubject(crunch, 'S101R', comments, results);

disp('calculating S102 data...');
disp(datestr(now));
cd E:\Matlab\work\DanaRWTdata\S2data\LeftRWT
[results, project_files, comments, measure_names, condition_names] = s102Lcalc;

crunch = updateSubject(crunch, 'S102L', comments, results);

disp('calculating S103 data...');

crunch = updateSubject(crunch, 'S103L', comments, results);

disp('calculating S104 data...');

[results, project_files, comments, measure_names, condition_names] = s104Lcalc;

crunch = updateSubject(crunch, 'S104L', comments, results);

disp('calculating S105 data...');

crunch = updateSubject(crunch, 'S105R', comments, results);

disp('calculating S106 data...');

crunch = updateSubject(crunch, 'S106L', comments, results);

disp('calculating S107 data...');

crunch = updateSubject(crunch, 'S107R', comments, results);

disp('calculating S108 data...');

crunch = updateSubject(crunch, 'S108R', comments, results);

disp('calculating S109 data...');

%cached_results{10} = {results comments};
crunch = updateSubject(crunch, 'S109L', comments, results);



% save crunchStruct!
%[f,p] = uiputfile('*.cdt', 'Save Crunch Data');
%save(strcat(p,f,'.cdt'), 'crunch');


% try to get some data!
%[mn, std] = getCrunchResults(crunch, 2, 8, [1 3 5], 5, [2 6]);
