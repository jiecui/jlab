function[tm] = movement_time(session, delay)
%   EXAMPLE: tm = movement_time(session_info, delay)
%
% calculate the movement time of each trial and makes an array of trial times
% 'session_info' - session struct, usually named session_info
% 'delay' -------- column vector with the same number of rows as there are trials in the raw data file. Each
%    number in 'delay' should be the number of seconds elapsed from recording start to movement start. You must
%    make this array on your own. See below.
%
% This function can be used to calculate the movement times of a large number of trials. The only input you have to 
% calculate yourself is the 'delay' array. In the simplest case, where your trials have a delay of zero, you only have
% to make an array of zeros. First find the number of trials by typing 'num' after you load a raw data file. For
% example, say you type 'num' and you get an answer of '16'. Then type 'delay = zeros(16,1)', which will output a
% column of zeros 16 rows long. You calculate movement time by typing 'movement_time(data, delay, ii, iif, sample_rate)'.
% What if you have a more complicated situation? Say the first eight trials were delayed 2 seconds but the last eight
% were delayed 0 seconds. You could get the correct 'delay' matrix by assigning the first 8 rows of 'delay' a value
% of 2 with 'delay(1:8,:) = 2'. Type the same 'movement_time' command as above to get the new movement times.

raw_data = session.data;
trial_start = session.trial_start;
trial_end = session.trial_end;

tm = zeros(length(trial_start),1);

sample_rate = 240/length(session.sensor_string);

% check for null delays
if nargin < 2,
   delay = zeros(length(trial_start),1);
end;

for i = 1:length(trial_start)
   trial_data = raw_data( trial_start(i)+find( raw_data( trial_start(i)+1:trial_end(i)-1,1 ) == 1 ),: );
   tm(i) = ( size(trial_data, 1) - delay(i) * sample_rate ) / sample_rate;
end





