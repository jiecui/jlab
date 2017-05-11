function[session, orient_err, euler_err, roll_dist, dist_roll] = dana_orient_error(session)

% wrapper to set target positions for known scene names
% now setting orientation targets. For now, all we have to do for each different trial
% is figure out which way the "hand" sensor should be pointing, and measure degrees away
% from that. For the mailbox scenes, the sensor on the envelope should be pointing straight "up"
% Except for the "reclined" ones, in which the sensor should be pointing along the "y" axis.
% To calculate the angle of the sensor, we take the acos of the z vector
% plot(tind,acos(-dat{s}(:,14))*180/pi, 'b'); hold on;
% That is from the plot_vels. We will use this for those that have sensor on hand.
% For the mailbox scenes, sensor is "upside down" so we need to take positive sens. 14 data,
% and 
% vars for equipment setup
%[sp_targs, or_targs, session, signs, offsets, emethods] = dana_targets(session);
or_targs = session.orient_targets;
signs = session.signflags;
offsets = session.offset_matrices;
emethods = session.emethods;
[orient_err, euler_err, idx, errdat] = orientation_error(session, or_targs, 1, signs, offsets, emethods);
roll_dist = [];
dist_roll = [];

for i=1:length(session.trial_start)
   errordata = errdat{i};
   % overall error -- at best roll
   session.trialstats(i).orientation_error.data = sum(abs(errordata'));
   session.trialstats(i).orientation_error.best_val = orient_err(i);
   session.trialstats(i).orientation_error.best_idx = idx(i);
   % yaw error
   [val,curridx] = min(abs(errordata(:,1)));
   session.trialstats(i).yaw_error.data = errordata(:,1)';
   session.trialstats(i).yaw_error.best_val = val;
   session.trialstats(i).yaw_error.best_idx = curridx;
   % pitch error
   [val,curridx] = min(abs(errordata(:,2)));
	session.trialstats(i).pitch_error.data = errordata(:,2)';
   session.trialstats(i).pitch_error.best_val = val;
   session.trialstats(i).pitch_error.best_idx = curridx;
   % pitch error -- somewhat redundant
   [val,curridx] = min(abs(errordata(:,3)));
	session.trialstats(i).roll_error.data = errordata(:,3)';
   session.trialstats(i).roll_error.best_val = val;
   session.trialstats(i).roll_error.best_idx = curridx;
   % combo errors
   trunk_corrected_idx = session.trialstats(i).trunk_spatial_error.best_idx;
   roll_dist = [roll_dist; errordata(trunk_corrected_idx,3)];
   dist_roll = [dist_roll; session.trialstats(i).trunk_spatial_error.data(idx(i))];
end





