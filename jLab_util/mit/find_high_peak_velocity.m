function[max_vel, max_time] = find_high_peak_velocity(session, smoothing_factor, minimum_velocity, sensor_no)
%   EXAMPLE: [peak, time_at_peak] = find_high_peak_velocity(session_info, 11, 5, 1)
%
% calculate the speed and time (% of movement time) at which highest velocity peak occurred
%
% 'session_info' ------ defined after a data file is loaded. This contains all the necessary
%                       information about all the trials in a session
% 'smoothing_factor' -- positive, odd integer that is used by the smoothing algorithm
% 'minimum_velocity' -- minimum velocity at which to record a peak
% 'sensor_no' --------- sensor number for which to calculate the velocity peaks
%
% A velocity peak is defined as an instant in time (a sample) where the instantaneous velocity
% of the preceding two samples are successively decreasing, and also the following two velocity
% readings are successively decreasing, and also that the velocity at that point is above the
% specified minimum velocity. E.g., if the velocities in a trial are 10, 11, 15, 14, 11,
% a velocity peak would be recorded at the third reading.
peaks = zeros(length(session.trial_start),1);
dt = length(session.sensor_string)/240;
max_vel = zeros(length(session.trial_start),1);
max_time = zeros(length(session.trial_start),1);
for t=1:length(session.trial_start)
   tbegin = session.trial_start(t);
   tend = session.trial_end(t);
   trial_data = session.data(tbegin+find(session.data(tbegin+1:tend-1,1)==sensor_no),:);
   % calculate smoothed velocity
   vels = sqrt(sum(([trial_data(:,3:5);0 0 0]-[0 0 0;trial_data(:,3:5)]).^2,2));
   vels = vels(2:size(vels,1)-1,:)./dt;
   vels = sav_golay(vels,smoothing_factor,2,0);
   % calculate peaks
   for i=3:size(vels,1)-2
      if vels(i)>vels(i-1) & ...
            vels(i-1)>vels(i-2) & ...
            vels(i)>vels(i+1) & ...
            vels(i+1)>vels(i+2) & ...
            vels(i)>minimum_velocity,
         peaks(t) = peaks(t) + 1;
         if vels(i) >= max_vel(t),
            max_vel(t) = vels(i);
            max_time(t) = i/size(vels,1);
         end
      end
   end
end

      