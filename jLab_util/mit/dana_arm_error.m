function [max_sup, min_flex, sup_min_flex, flex_max_sup, flex_dist, dist_flex, sup_dist, dist_sup] = dana_arm_error(session)

% get old variables
si = session;
trial_start = si.trial_start;
trial_end = si.trial_end;

max_sup = zeros(1,length(trial_start));
min_flex = zeros(1,length(trial_start));
sup_min_flex = zeros(1,length(trial_start));
flex_max_sup = zeros(1,length(trial_start));

% check for arm
if ~session.has_arm
   return
end

% go through trials
flex_dist = [];
dist_flex = [];
sup_dist = [];
dist_sup = [];
adat = si.arm_data;
% for each trial get the max, min, indices
for i = 1:length(trial_start)
   [min_flex(i), minflex_idx(i)] = min(adat(i).eelbow(:,2));
   [max_sup(i), maxsup_idx(i)] = max(adat(i).eelbow(:,3));
   % read alternate measure with best index
   sup_min_flex(i) = adat(i).eelbow(minflex_idx(i),3);
   flex_max_sup(i) = adat(i).eelbow(maxsup_idx(i),2);
   trunk_corrected_idx = session.trialstats(i).trunk_spatial_error.best_idx;
   flex_dist = [flex_dist; adat(i).eelbow(trunk_corrected_idx,2)];
   dist_flex = [dist_flex; si.trialstats(i).trunk_spatial_error.data(minflex_idx(i))];
	sup_dist = [sup_dist; adat(i).eelbow(trunk_corrected_idx,3)];
   dist_sup = [dist_sup; si.trialstats(i).trunk_spatial_error.data(maxsup_idx(i))];
 end

 % Set to NaN the trials with bad sensor 2 data
 if isfield(si, 'bad_sensor_2_trials'),
     bad_2 = si.bad_sensor_2_trials(si.kepttrials);
     bad_2i = find(bad_2 > 0);
     min_flex(bad_2i) = NaN;
     max_sup(bad_2i) = NaN;
     sup_min_flex(bad_2i) = NaN;
     flex_max_sup(bad_2i) = NaN;
     flex_dist(bad_2i) = NaN;
     dist_flex(bad_2i) = NaN;
     sup_dist(bad_2i) = NaN;
     dist_sup(bad_2i) = NaN;
 end
 
min_flex = min_flex';
max_sup = max_sup';
sup_min_flex = sup_min_flex';
flex_max_sup = flex_max_sup';
flex_dist = flex_dist;
dist_flex = dist_flex;
sup_dist = sup_dist;
dist_sup = dist_sup;