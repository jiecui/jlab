% ttest script pre1 vs. pre2

% remember where we are
orig_path = pwd;

% open file
[f,p] = uigetfile('*.cdt', 'Paired ttest Pre1 vs. Pre2 Crunch File');
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

% ttest
ttestPreLast(crunch,'2 4:10','whatever','Pre1','Pre2','tvals_pre1_pre2.csv');

% cd back to orig
cd(orig_path);