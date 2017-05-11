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
colcell = {{'Pre',[1 2]}};
crunch = collapseSlicesSubjects(crunch, '2:10', colcell);

% collapse Pre and Last Rx to new subject
crunch=collapsePreLast(crunch,'2:10','All Subjects','Pre','Last');

% collapse across subjects for each session, keeping track of # samples
crunch=collapseSubjects(crunch,'2:10',{'Pre1' 'Pre2' 'Post10' 'Post20a' 'Post20b' 'Post30'},'All Subjects');

% save it out
save(strcat(p,f), 'crunch');

% cd back to orig
cd(orig_path);