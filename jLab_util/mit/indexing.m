% atomize projects
function crunch=index_addproj(crunch,proj,patient,session)
% I think for now just have a list of the projects in your "experiment", which will be
% chosen from a list on the plotting interface. Then the "showdata" trials/blocks list
% can be shown

idx = length(crunch.rawindex) + 1;
trial_id = proj.name;
trialfilenames=atomize(proj,trial_id);
crunch.rawindex{patient,session}.name = trial_id;
crunch.rawindex(patient,session}.scene_info = proj.scene_info;
crunch.rawindex{patient,session}.tialfiles = trialfilenames;


% atomize -- expects pwd to be correct
function trialsadded=atomize(project,idstart)
trialsadded = {};
si = project.session_info;
for ts=1:length(si.trial_start),
    dat.sensordata=si.data(si.trial_start(i):si.trial_end,:);
    dat.armdata=si.armdata(ts);
    trialid = sprintf('%s_%d.dat',idstart,ts);
    trialsadded{ts} = trialid;
    save(trialid,dat);
end

% external get trial
function [dat, crunch] = index_get(crunch,pat,sess,trial)
% arg checking?
try
    trialid = crunch.rawindex{pat,sess}.trialfiles{trial};
catch
    error(sprintf('Trial not in Index: Patient %d, Session %d, Trial %d', pat,sess,trial));
end
[crunch,dat] = index_gettrial(crunch,trialid); 


% internal, adds trial to internal cache if not there already
function [t,crunch]=index_gettrial(crunch,trial_id)
% trial_id is a string that will be the filename?
if ~isfield(cache,trial_id),
    dat=load(trial_id);
    setfield(cache,trial_id,dat.data);
    crunch.cache = cache;
end
t=cache.trial_id;

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