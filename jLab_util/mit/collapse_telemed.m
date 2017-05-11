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

% collapse across subjects for each session, keeping track of # samples
crunch=collapseSubjects(crunch,'1:7',{'Pre' 'Post15' 'Post30'},'Subjects 201-207');

% save it out
save(strcat(p,f), 'crunch');

% cd back to orig
cd(orig_path);