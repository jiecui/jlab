function[dis] = pathlength(session, sensor_no, smp, delays)

%   EXAMPLE: dis = pathlength(session_info, sensor_no, smp)
%
% Calculate lengths of trials, with a down-sampling rate 1/smp
%
% 'session_info  session information, usually named session_info
%
% 'sensor_no' -- number of the sensor you want to measure, usually 1, but can be in the range of 1 to 4.
%
% 'smp' -------- down-sampling divisor. E.g. if you have an original sampling rate of 30Hz and want to now sample
%   at 1/3 the rate, or 10Hz, you would set smp = 3.
%
% dis ---------- column vector of the path lengths for all the trials
%
% This function is meant to be used in concert with the showdata package. After a load of a raw data
% file, showdata generates several internal variables that are then exploited by pathlength().
% Typing 'ii' at the command prompt after loading a raw data file will produce a column vector of
% integers. Each number is the boundary of one of the trials.
% Typing 'iif' shows where each trial ends in the 'data' array.
% 'dis' will give the traveled distance of each trial
raw_data = session.data;
trial_start = session.trial_start;
trial_end = session.trial_end;
rate = 240/length(session.sensor_string);
if nargin < 4,
   samples = zeros(length(trial_start),1);
else,
   samples = round(delays*rate);
end;

dis = zeros(length(trial_start) - 1,1);
cumdis = 0;
for i = 1:length(trial_start)
   trial_data = raw_data(trial_start(i)+find(raw_data(trial_start(i)+1:trial_end(i)-1,1)==sensor_no),:);
   for j = 1+smp+samples:smp:size(trial_data,1)
      p1 = trial_data(j,3:5);
   	p2 = trial_data(j-smp,3:5);
      cumdis = cumdis + sqrt(sum((p1-p2).^2));
   end
	dis(i) = cumdis;
   cumdis=0;
end





