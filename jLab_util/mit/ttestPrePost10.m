% ttest script pre vs. Post10 rx

% remember where we are
orig_path = pwd;

% open file
[f,p] = uigetfile('*.cdt', 'Paired ttest Pre vs. Post10 Rx Crunch File');
if ~p
   return
end

% load crunch
crunch = load(strcat(p,f), '-MAT');
names = fieldnames(crunch);
crunch = getfield(crunch,names{1});

% ttest
ttestPreLast(crunch,'2 4:10','whatever','Pre','Post10','tvals_pre_post10.csv');

% cd back to orig
cd(orig_path);