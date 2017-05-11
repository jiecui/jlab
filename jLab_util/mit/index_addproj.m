function crunch=index_addproj(crunch,proj,patient,session)
% I think for now just have a list of the projects in your "experiment", which will be
% chosen from a list on the plotting interface. Then the "showdata" trials/blocks list
% can be shown
%idx = length(crunch.rawindex) + 1;
%ifpatient) | isempty(session)
    % auto
    %end

trial_id = proj.name;
undrscr=findstr(trial_id,'_');
if undrscr
    patient = trial_id(1:undrscr-1);
    session = trial_id(undrscr+1:length(trial_id)-1);
end
trialfilenames=atomize(proj,trial_id);

% first check for existing project, if not there, add to end. 
try
    ri = crunch.rawindex;
catch
    ri.name = trial_id;
end

sidx = findstr([ri.name],trial_id);
if sidx
    % update entry
    insertidx = sidx(1);
else
    % insert new at end
    insertidx = length(ri)+1;
end
% just store enough for a ligthweight view of the data
ri(insertidx).name = trial_id;
ri(insertidx).scene_info = proj.scene_info;
ri(insertidx).trialfiles = trialfilenames;
crunch.rawindex = ri;

    
% atomize, internal -- expects pwd to be correct
function trialsadded=atomize(project,idstart)
trialsadded = {};
si = project.session_info;
for i=1:length(si.trial_start),
    dat.sensordata=si.data(si.trial_start(i):si.trial_end(i),:);
    dat.armdata=si.arm_data(i);
    trialid = sprintf('%s_%d.dat',idstart,i);
    trialsadded{i} = trialid;
    save(trialid,'dat');
end

%function raw_plot(dat,varargin)

% for i=1:length(varargin):2,
%     switch(varargin{i})
%     case 'type',
%         switch(varargin{1+1})
%         case 'sensor'
%         case '    
%         end
% optnames = varargin(1:2:length(varargin));
% 
% %types = {'
% 
% plottype = 'sensor';
% try
%     plottype=varargin(strmatch('type',optnames)+1);
% catch
% end
% 
% switch(plottype)
% case 'sensor'
% case 'arm data'
% case 'velocities'
% end



% should be like a db.

% crunch will have a new field, 'raw_cache'