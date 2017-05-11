function[session, err, trunk_err] = dana_spatial_error(session)

% wrapper to set target positions for known scene names

% get old variables
raw_data = session.data;
trial_start = session.trial_start;
trial_end = session.trial_end;

sp_targs = session.spatial_targets;
or_targs = session.orient_targets;
%[sp_targs, or_targs, session] = dana_targets(session);

[err, idx, errdata] = spatial_error(session, sp_targs, 1);

% now we put this data into the session
for i=1:length(trial_start)
   session.trialstats(i).spatial_error.data = errdata{i};
   session.trialstats(i).spatial_error.best_val = err(i);
   session.trialstats(i).spatial_error.best_idx = idx(i);
end

% Now adjust the errors based on the movement of the trunk
trunk_err = err';

for i = 1:length(trial_start),
   % check scene name
   trunk_pos = raw_data(trial_start(i)+find(raw_data(trial_start(i)+1:trial_end(i)-1,1)==3),:);
   num_samps = min(size(trunk_pos,1),30);
   start_pos = mean(trunk_pos(1:num_samps, 3:5));
   trunk_movement = (start_pos'*ones(1,size(trunk_pos,1)))' - trunk_pos(:, 3:5);
   switch session.scene_names{i},
   case{'RmailctrRWT.VR','LmailctrRWT.VR',...
            'RsleevepullRWT.VR','LsleevepullRWT.VR'}
      %  use -x,not x -- only add for/back trunk motion
      session.trialstats(i).trunk_spatial_error.data = errdata{i} - min(0,trunk_movement(:,1))';
      [val,curridx] = min(session.trialstats(i).trunk_spatial_error.data);
      session.trialstats(i).trunk_spatial_error.best_val = val;
      session.trialstats(i).trunk_spatial_error.best_idx = curridx;
      trunk_err(i) = val;
   case{'R30ReachSideRightRWT.VR', 'R45ReachSideRightRWT.VR', 'R60ReachSideRightRWT.VR', 'R75ReachSideRightRWT.VR', 'RSupineReachexactRWT.VR'...
            'L30ReachSideLeftRWT.VR', 'L45ReachSideLeftRWT.VR', 'L60ReachSideLeftRWT.VR', 'L75ReachSideLeftRWT.VR', 'LSupineReachexactRWT.VR', ...
            'L30ReachSideRightRWT.VR', 'L45ReachSideRightRWT.VR', 'L60ReachSideRightRWT.VR', 'L75ReachSideRightRWT.VR',...
            'RReachBegRWT.VR','LReachBegRWT.VR',...
            'RkeylockboxRWT.VR','LkeylockboxRWT.VR',...
            'LmailabdRWT.VR', 'LmailaddRWT.VR', 'SupineMailDiagL.VR',...
            'RmailabdRWT.VR', 'RmailaddRWT.VR', 'SupineMailDiagR.VR',...
            'RhandshakeRWT.VR','LhandshakeRWT.VR'}
      % use the length of the projection of the trunk movement along the axis of the
      % vector from the trunk sensor to the target
      trunkerror = find_projection(start_pos,trunk_movement,sp_targs(i,:));
      trunkerror = errdata{i} + max(0,trunkerror)';
      [val,curridx] = min(trunkerror);
      session.trialstats(i).trunk_spatial_error.best_val = val;
      session.trialstats(i).trunk_spatial_error.best_idx = curridx;
      session.trialstats(i).trunk_spatial_error.data = trunkerror;
      trunk_err(i) = val;
   otherwise
      % just copy from regular spatial error
      session.trialstats(i).trunk_spatial_error.best_val = err(i);
      session.trialstats(i).trunk_spatial_error.best_idx = idx(i);
      session.trialstats(i).trunk_spatial_error.data = errdata{i};
   end;
end;

trunk_err = trunk_err';




