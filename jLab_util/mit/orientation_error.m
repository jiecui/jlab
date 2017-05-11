function [err, euler_angles, index, errdat] = orientation_error(session_info, targets, sensor_no, signs, offsets, emethods)
si = session_info;

% get old variables
raw_data = si.data;
trial_start = si.trial_start;
trial_end = si.trial_end;

si.orient_targets = targets;
si.orient_diffs = [];

% quick hack to get supination out of orientation error
%left = 0;
%if isfield(si, 'leftarm'),
%    left = si.leftarm;
%end

for i = 1:length(trial_start),
   % get data
   trial_data = raw_data(trial_start(i)+find(raw_data(trial_start(i)+1:trial_end(i)-1,1)==sensor_no),:);
   trial_data = pol2gl(trial_data);
   % filter for samples within target_radius distance from average
   if isempty(targets)
      err = [];
      euler_angles = [];
      index = [];
      dist_at_best_or = [];
      or_at_best_dist = [];
      return
   end
   
   % apply offset orientations
   if offsets(:,:,i) ~= eye(4,4)
      for j=1:size(trial_data,3)
         trial_data(:,:,j) = trial_data(:,:,j) * offsets(:,:,i);
      end
      targets(:,:,i) = targets(:,:,i) * offsets(:,:,i);
   end
   
   % calculate the euler angles that will be used for plotting
   eulers = findeuler(trial_data,targets(:,:,i),emethods(i)).*((ones(size(trial_data,3),1))*signs(i,:));
   errdat{i} = eulers;
   % find the minimum "euler distance" from the target -- may want to change
   % so that we are only getting the minimum "roll" rather than all angles
   [roll_err, index(i)] = max(eulers(:,3)); % we are interested in where the roll is greatest -- works when sign is correct
   err(i,:) = sum(abs(eulers(index(i),:)));
   euler_angles(i,:) = eulers(index(i),:);
end;

