function[err] = spatial_error(raw_data, target, trial_start, trial_end, sensor_no)

%     EXAMPLE: err = spatial_error(data, target, ii, iif, sensor_number)
%
% calculate the spatial error between a specified point and the closest raw data point for each trial
%
% 'data' -------- the result of loading a Kinematix .vr raw data file into Matlab with loadfile.m
%
% 'target' ------ array with 3 columns and as many rows as there are trials. Each row should contain the
%     x/y/z target positions against which you want to measure the spatial error.
%
% 'ii' ---------- column vector with as many elements as trials in the raw data ('ii' is calculated when
%     you load the raw data file from 'showdata'
%
% 'iif' --------- column of the row numbers in raw_data that are at the ends of each trial ('iif'
%     is also calculated by 'showdata').
%
% 'sensor_no' --- the number of the sensor you want to measure, usually 1, but can be 1 through 4
%
% 'err' --------- column vector of the spatial errors
%
% This function searches each trial for the raw data point that is closest to the target x/y/z position.
% It then returns an array that has a spatial error for each trial. See the help for the other scripts for
% hints on how to make the 'target' array. Also ask your local MatLab expert ;-)

% err is the return value that will contain all the errors
err = zeros(length(trial_start)-1,1);

for i = 1:(length(trial_start)-1)
   % "real" data starts and ends 1 row after and before the "ends" of the trial indices, respectively
   tr = raw_data(trial_start(i)+find(raw_data(trial_start(i)+1:trial_end(i)-1,1)==sensor_no),:);
   % x and y are reversed in the raw data files
   tr = tr( :, [4, 3, 5] );
   % Following Matlab mouthful sizes the target data, gets the delta-x/y/z, computes the distance,
   % and then finds the minimum, which is the data sample that is closest to the target x/y/z location
	err(i) = min( sqrt( sum( ( tr - ones( size( tr, 1), 1 ) * target( i, : ) )'.^2 ) ) );
end






