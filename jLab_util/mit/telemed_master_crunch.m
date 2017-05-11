% master script for generating a crunch struct from telemed data
% TO DO:
%       [X] put delays in each project file and remove references to input delays
%       [X] remove reference to input targets, if verifiably unnecessary
%       [x] collapse all individual subjects' "calc" scripts into this master-level script
%       [x] put comments and labels into each project file
%       [ ] make updating existing project work

% update = 1 => update some patients, put those in updatepats
update = 1;
updatepats = 4;

dataloc = 'G:\work\';
original_dir = pwd;
trialfile = '_TrCnd.csv';
preprostfile = '_PrePost.csv';
patientinfo = ...
    [{{'s201\RWT\',...
            {'201_1_plus_3.prj','Pre','Pre MH lft inv.';...
            '201_19.prj', 'Post15', 'Post 15 Rx MH lft inv.';...
            '201_38.prj', 'Post30', 'Post 30 Rx MH lft inv.'}}},...
        {{'s202\RWT\',...
            {'202_1_trim.prj', 'Pre', 'Pre RS rght inv.';...
            '202_19_trim.prj', 'Post15', 'Post 15 Rx RS rght inv.';...
            '202_39_trim.prj', 'Post30', 'Post 30 Rx RS rght inv.'}}},...
        {{'s203\RWT\',...
            {'203_1_fixed_trim.prj', 'Pre', 'Pre JF lft inv.';...
            '203_26_trim.prj', 'Post15', 'Post 15 Rx JF lft inv.';...
            '203_45_trim_fixed.prj', 'Post30', 'Post 30 Rx JF lft inv.'}}},...
        {{'s204\RWT\',...
            {'204_1_trim.prj', 'Pre', 'Pre DG rght inv.';...
            '204_21_trim.prj', 'Post15', 'Post 15 Rx DG rght inv.';...
            '204_42_43_trim.prj', 'Post30', 'Post 30 Rx DG rght inv.'}}},...
        {{'s205\RWT\',...
            {'205_2_trim.prj','Pre','Pre LR lft inv.';...
            '205_20_trim.prj', 'Post15', 'Post 15 Rx LR lft inv.';...
            '205_49_trim.prj', 'Post30', 'Post 30 Rx LR lft inv.'}}},...
        {{'s206\RWT',...
            {'206_1.prj','Pre','Pre AV lft inv.';...
            '206_22.prj', 'Post15', 'Post 15 Rx AV lft inv.';...
            '206_46.prj', 'Post30', 'Post 30 Rx AV lft inv.'}}},...
        {{'s207\RWT',...
            {'207_1.prj','Pre','Pre GS rght inv.';...
            '207_23.prj', 'Post15', 'Post 15 Rx GS rght inv.';...
            '207_44.prj', 'Post30', 'Post 30 Rx GS rght inv.'}}},...
];
conditions = {'MailDiag','MailHoriz','SupinPronRep','SleevePull','SupinPron',};
measures = {};
cached_results = {};

if update,
    % open file
    [f,p] = uigetfile('*.cdt', 'Update Crunch File');
    if ~p
        return
    end
    crunch = load(strcat(p,f), '-MAT');
    names = fieldnames(crunch);
    crunch = getfield(crunch,names{1});
    patientinfo = patientinfo(updatepats);
else
    crunch = [];
    crunch = updateCrunch(crunch, conditions, measures);
end

tic
for i=1:length(patientinfo),
    pat=patientinfo(i);
    cd(strcat(dataloc,pat{1}{1}));
    % generate csv filenames from the first 4 letters of pat{1}
    patstring = pat{1}{1}(1:4);
    tf=strcat(patstring,trialfile);
    ppf=strcat(patstring,preprostfile);
    % run telemed_calc_sessions
    projfiles = pat{1}{2}(:,1);
    labels = pat{1}{2}(:,2);
    comments = pat{1}{2}(:,3);
    [cond_results, measure_names, condition_names] = telemed_calc_sessions(tf, ppf, projfiles, comments);
    cached_results = [cached_results {cond_results comments labels}];
    crunch = updateSubject(crunch, patstring, comments, labels, cond_results);
end

% fix up measure_names
measure_names = measure_names(:,2:length(measure_names));
crunch = updateCrunch(crunch, conditions, measure_names);
crunch.cached_results = cached_results;

% collapse
crunch=collapseSubjects(crunch,'1:7',{'Pre' 'Post1' 'Post2'},'Subjects 201-207');

toc
cd(original_dir);

save(strcat('telemed_',date),'patientinfo','cached_results','crunch');

% save crunchStruct!
[f,p] = uiputfile('*.cdt', 'Save Crunch Data');
if ~findstr(f,'.cdt')
   f = strcat(f,'.cdt');
end
save(strcat(p,f), 'crunch');





























