% just a little script to try out the new stuff
% first we set up the crunchStruct with default info
crunch = [];
conditions = {'30ReachSideRight','45ReachSideRight','60ReachSideRight',...
      '75ReachSideRight','HandLumbar','Handshake','KeyLockBox','MailAbd',...
      'MailAdd','MailCtr','ReachBeg','SleevePull','SupineMailDiag','SupineReachSideExact'};
measures = {};
crunch = updateCrunch(crunch, conditions, measures);


% save big cell array of results
cached_results = {};
cached_results{9} = {};
output_dir = 'E:\DanaGraphs'
original_dir = pwd;
tic

% do normals
cd E:\Matlab\work\DanaRWTdata\Normals
[normresults, normproject_files, normcomments, normlabels, measure_names, condition_names] = normcalc;
cached_results{1} = {normresults normcomments normlabels};

% try another call
% fix up measure_names
measure_names = measure_names(:,2:length(measure_names));
crunch = updateCrunch(crunch, conditions, measure_names);
%make the patient
crunch = updateSubject(crunch, 'Normals', normcomments, normlabels, normresults);
% try a collapse
collapse = {{'Left Combined',[3 4 7 9 11 13 15 17]} {'Right Combined', [1 2 5 6 8 10 12 14 16]} {'Right Combined wo. EB', [2 5 6 8 10 12 14 16]} ...
      {'All Combined', [1:17]} {'All w/o EB', [2:17]} ...
      {'Young', [2 3 4 5 8 9 12 13]} {'Old w. EB', [1 6 7 10 11 14 15 16 17]} {'Old wo. EB', [6 7 10 11 14 15 16 17]} ...
      {'Male w. EB', [1 4 5 8 9 12 13 14 15]} {'Male wo. EB', [4 5 8 9 12 13 14 15]} {'Female', [2 3 6 7 10 11 16 17]}};
crunch = collapseSlices(crunch, 'Normals',collapse);



% try to init the first patient
disp('calculating S101 data...');
disp(datestr(now));
cd E:\Matlab\work\DanaRWTdata\S1data\RightRWT
[results, project_files, comments, labels, measure_names, condition_names] = s101_COMBINEDcalc;
cached_results{2} = {results comments labels};
crunch = updateSubject(crunch, 'S101R', comments, labels, results);

disp('calculating S102 data...');
disp(datestr(now));
cd E:\Matlab\work\DanaRWTdata\S2data\LeftRWT
[results, project_files, comments, labels, measure_names, condition_names] = s102Lcalc;
cached_results{3} = {results comments labels};
crunch = updateSubject(crunch, 'S102L', comments, labels, results);

disp('calculating S103 data...');
disp(datestr(now));
cd E:\Matlab\work\DanaRWTdata\S3data\LeftRWT
[results, project_files, comments, labels, measure_names, condition_names] = s103Lcalc;
cached_results{4} = {results comments labels};
crunch = updateSubject(crunch, 'S103L', comments, labels, results);

disp('calculating S104 data...');
disp(datestr(now));
cd E:\Matlab\work\DanaRWTdata\S4data\LeftRWT
[results, project_files, comments, labels, measure_names, condition_names] = s104Lcalc;
cached_results{5} = {results comments labels};
crunch = updateSubject(crunch, 'S104L', comments, labels, results);

disp('calculating S105 data...');
disp(datestr(now));
cd E:\Matlab\work\DanaRWTdata\S5data\RightRWT
[results, project_files, comments, labels, measure_names, condition_names] = s105Rcalc;
cached_results{6} = {results comments labels};
crunch = updateSubject(crunch, 'S105R', comments, labels, results);

disp('calculating S106 data...');
disp(datestr(now));
cd E:\Matlab\work\DanaRWTdata\S6data\LeftRWT
[results, project_files, comments, labels, measure_names, condition_names] = s106Lcalc;
cached_results{7} = {results comments labels};
crunch = updateSubject(crunch, 'S106L', comments, labels, results);

disp('calculating S107 data...');
disp(datestr(now));
cd E:\Matlab\work\DanaRWTdata\S7data\RightRWT
[results, project_files, comments, labels, measure_names, condition_names] = s107Rcalc;
cached_results{8} = {results comments labels};
crunch = updateSubject(crunch, 'S107R', comments, labels, results);

disp('calculating S108 data...');
disp(datestr(now));
cd E:\Matlab\work\DanaRWTdata\S8data\RightRWT
[results, project_files, comments, labels, measure_names, condition_names] = s108Rcalc;
cached_results{9} = {results comments labels};
crunch = updateSubject(crunch, 'S108R', comments, labels, results);

disp('calculating S109 data...');
disp(datestr(now));
cd E:\Matlab\work\DanaRWTdata\S9data\LeftRWT
[results, project_files, comments, labels, measure_names, condition_names] = s109Lcalc;
cached_results{10} = {results comments labels};
crunch = updateSubject(crunch, 'S109L', comments, labels, results);

cd(original_dir);


% save crunchStruct!
[f,p] = uiputfile('*.cdt', 'Save Crunch Data');
if ~findstr(f,'.cdt')
   f = strcat(f,'.cdt');
end
save(strcat(p,f), 'crunch');


% try to get some data!
[mn, std] = getCrunchResults(crunch, 2, 8, [1 3 5], 5, [2 6]);
