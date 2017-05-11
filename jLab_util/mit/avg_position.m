function[avg] = avg_position(raw_data, trial_start, trial_end, sensor_string)
%     EXAMPLE: avg = avg_position(data, ii, iif, sens)
%
% calculate the spatial error between a specified point and the closest raw data point for each trial
%
% 'data' -- the result of loading a Kinematix .vr raw data file into Matlab with loadfile.m
%
% 'ii' ---- column vector with as many elements as trials in the raw data ('ii' is calculated when
%     you load the raw data file from 'showdata'
%
% 'iif' --- column of the row numbers in raw_data that are at the ends of each trial ('iif'
%     is also calculated by 'showdata').
%
% 'sens' -- variable from showdata that tells which sensors are present in the raw data
%
% 'avg' --- array with average values for each sensor and each trial
%
% avg_position calculates the average x/y/z position of each sensor for each trial
% The resulting 'avg' has as many rows as trials, and the columns correspond to the
% x, y, and z values for each sensor. For example, if there were 10 trials and 3 sensors
% in the raw data, 'avg' would have 10 rows and 9 columns. Columns 1 to 3 would contain
% the x, y, and z averages for the first sensor, columns 4 to 6 would correspond to the
% second sensor, and columns 7 through 9 would correspond to the third sensor.

sensor_data = str2num(sensor_string);
avg = zeros(length(trial_start), length(sensor_data) * 3); 
for i = 1:length(sensor_data),
   % determine where to put the trial averages for the current sensor
  	col_start = (i*3)-2;
  	col_end = i*3;
   % do a find for each trial
   for j = 1:length(trial_start),
   	% "real" data starts and ends 1 row after and before the "ends" of the trial indices, respectively
   	tr = raw_data(trial_start(j)+find(raw_data(trial_start(j)+1:trial_end(j)-1,1)==sensor_data(i)),:);
   	% x and y are reversed in the raw data files, but we ignore that for now
   	tr = tr( :, 3:5 );
   	% calculate the average
      tr_avg = mean(tr);
      avg(j, col_start:col_end) = tr_avg;
   end;
end;

	

   