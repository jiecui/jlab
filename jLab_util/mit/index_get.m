function [dat, crunch] = index_get(crunch,proj_id,trial)
% external get trial
% arg checking?
dat = [];
try
    ri = crunch.rawindex;
catch
    warn('No raw data index in this crunch struct.');
    return;
end

idx = findstr([ri.name],proj_id);
if idx
    trials = ri(idx).trialfiles;
    trialid = trials{trial};
    [dat,crunch] = index_gettrial(crunch,trialid); 
else
    error(sprintf('Trial not in Index: Project: %s, Trial %d', proj_id,trial));
end


% internal, adds trial to internal cache if not there already
function [t,crunch]=index_gettrial(crunch,trial_id)

if ~isfield(crunch,'cache')
    crunch.cache = [];
end

% trial_id is a string that will be the filename?
if ~isfield(crunch.cache,trial_id),
    dat=load(trial_id, '-MAT');
    dat = dat.dat;
    cache=setfield(crunch.cache,trial_id,dat);
    crunch.cache=cache;
end
t=getfield(crunch.cache,trial_id);