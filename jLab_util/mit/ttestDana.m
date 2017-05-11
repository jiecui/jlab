% ttest script pre vs. Post30 rx

% remember where we are
orig_path = pwd;

% open file
[f,p] = uigetfile('*.cdt', 'Paired ttest for Dana Crunch File');
if ~p
   return
end

% load crunch
crunch = load(strcat(p,f), '-MAT');
names = fieldnames(crunch);
crunch = getfield(crunch,names{1});

% ttests

ttestSlices(crunch,'2 4:10','Pre1','Pre2','tvals_pre1_pre2.csv');
ttestSlices(crunch,'2 4:10','Pre','Post10','tvals_pre_post10.csv');
ttestSlices(crunch,'2 4:10','Pre','Post20a','tvals_pre_post20a.csv');
ttestSlices(crunch,'2 4:10','Pre','Post20b','tvals_pre_post20b.csv');
ttestSlices(crunch,'2 4:10','Pre','Post30','tvals_pre_post30.csv');
% try these again using Pre2
ttestSlices(crunch,'2 4:10','Pre2','Post10','tvals_pre2_post10.csv');
ttestSlices(crunch,'2 4:10','Pre2','Post20a','tvals_pre2_post20a.csv');
ttestSlices(crunch,'2 4:10','Pre2','Post20b','tvals_pre2_post20b.csv');
ttestSlices(crunch,'2 4:10','Pre2','Post30','tvals_pre2_post30.csv');
% and how about some of the others?
ttestSlices(crunch,'2 4:10','Post20a','Post30','tvals_post20a_post30.csv');
ttestSlices(crunch,'2 4:10','Post20b','Post30','tvals_post20b_post30.csv');
ttestSlices(crunch,'2 4:10','Post20a','Post20b','tvals_post20a_post20b.csv');
ttestSlices(crunch,'2 4:10','Post10','Post20a','tvals_post10_post20a.csv');
ttestSlices(crunch,'2 4:10','Post10','Post20b','tvals_post10_post20b.csv');
ttestSlices(crunch,'2 4:10','Post10','Post30','tvals_post10_post30.csv');
ttestSlices(crunch,'2 4:10','Pre2','Post10','tvals_pre2_post10.csv');
ttestSlices(crunch,'2 4:10','Pre2','Post20a','tvals_pre2_post20a.csv');
ttestSlices(crunch,'2 4:10','Pre2','Post20b','tvals_pre2_post20b.csv');
ttestSlices(crunch,'2 4:10','Pre1','Post10','tvals_pre1_post10.csv');
ttestSlices(crunch,'2 4:10','Pre1','Post20a','tvals_pre1_post20a.csv');
ttestSlices(crunch,'2 4:10','Pre1','Post20b','tvals_pre1_post20b.csv');
ttestSlices(crunch,'2 4:10','Pre1','Post30','tvals_pre1_post30.csv');


% cd back to orig
cd(orig_path);