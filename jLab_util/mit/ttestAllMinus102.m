% collapse patients script

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

% collapse pre-post
%colcell = {{'Pre',[1 2]}};
%crunch = collapseSlicesSubjects(crunch, '2 4:10', colcell);

% collapse Pre and Last Rx to new subject
ttestPreLast(crunch,'2 4:10','All Subjects Minus 102L','Pre','Last');

crunch.subjects(2).condition_order = [10 8 9 2 1 3 4 11 6 12 5 7 13 14];
crunch.subjects(4).condition_order = [14 13 8 9 10 12 5 6 7 11 3 1 4 2];
crunch.subjects(5).condition_order = [4 1 3 2 11 6 7 9 10 8 13 14 5 12];
crunch.subjects(6).condition_order = [6 7 11 4 3 2 1 14 13 8 10 9 12 5];
crunch.subjects(7).condition_order = [13 14 5 12 10 9 8 6 7 11 3 4 1 2];
crunch.subjects(8).condition_order = [13 14 12 5 6 7 11 4 2 3 1 9 8 10];
crunch.subjects(9).condition_order = [5 12 2 3 4 1 11 6 7 10 9 8 13 14];
crunch.subjects(10).condition_order = [10 8 9 6 7 11 1 2 3 4 5 12 14 13];

ttestPreLastOrder(crunch,'2 4:10','All Subjects Minus 102L','Pre','Last', 'pvalsOrder.csv');
%writePreLastAnalyzeIt(crunch, '2 4:10', 'Pre', 'analyzeitvals.csv');
%crunch = writeAggregAllSlicesAnalyzeIt(crunch, '2 4:12', 'Pre', 'Last', 'analyzeAGGREGATEslices.csv');

% collapse across subjects for each session, keeping track of # samples
%crunch=collapseSubjects(crunch,'2 4:10',{'Pre1' 'Pre2' 'Post10' 'Post20a' 'Post20b' 'Post30'},'All Subjects Minus 102L');

% save it out
%save(strcat(p,f), 'crunch');

% cd back to orig
cd(orig_path);