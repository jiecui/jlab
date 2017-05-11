% first things first, simple test

% open a crunch file
% open file
[f,p] = uigetfile('*.cdt', 'Add Index info to Crunch File');
if ~p
    return
end
crunch = load(strcat(p, f), '-MAT');
crunch = crunch.crunch;


% open a project file
[f,p] = uigetfile('*.prj','Open Project File');

if ~p,
    return
else
    newp = load(strcat(p, f), '-MAT');
    newp = newp.current_proj;
    
    % cd to the right dir
    cd('C:\work\matlab\crunch');

    % atomize
    crunch = index_addproj(crunch, newp);
    
    % query crunch file for a trial
    proj = input('name the project: ','s');
    trial = str2num(input('trial number: ','s'));
    [dat,crunch] = index_get(crunch,proj,trial);
    disp(dat);
end