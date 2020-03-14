function save_data=quiet_filter(save_data,quiet_time)
% filter out usaccs that are preceded by usaccs that end less than
% "quiet_time" in the past. Default is 10 samples (msec)

usacc_dis_filter = 10;
try
    usacc_dis_filter = quiet_time;
catch
end

% filter out "bad" usaccs: first for blinks, then for ones preceded by any
% saccade (micro or macro)
% where to do this?!?! Need to kill all surrounding eye movements? No, just
% the stuff in the 10 ms after the blink.
% On second thought, killing whatever eyemovement happens before this would
% help get rid of big mvmts...
eye_movement_vector = save_data(:,8);
possible_starts = find(diff(eye_movement_vector) > 0);
possible_stops = find(diff(eye_movement_vector) < 0);
prefilter_eye_mvmt = eye_movement_vector;

blink_pre_filter = 0;
blink_post_filter = 0;
% flip _dis_ to 10 for 10-msec quiet period filter


% for j=1:length(possible_starts)
%     psrt = possible_starts(j);
%     pstp = possible_stops(j);
%     if find(blinks>psrt-blink_pre_filter&blinks<pstp+blink_post_filter)
%         eye_movement_vector(psrt:pstp) = 0;
%     end
% end

% 
% for j=1:length(blinks)
%     b=blinks(j);
%     eye_movement_vector(b:b+10) = 0;
% end

% filter out stuff that has movement 10 ms before AND after
for j=2:length(possible_starts)
    psrt = possible_starts(j);
    pstp = possible_stops(j);
    if psrt-usacc_dis_filter >0
        if find(prefilter_eye_mvmt((psrt-usacc_dis_filter):psrt))
            % there are eye_movement happening within the 10 ms "quiet period"
            eye_movement_vector(psrt:pstp) = 0;
            % now for the previous movement, if it exists
            %psrt = possible_starts(j-1);
            %pstp = possible_stops(j-1);
            %eye_movement_vector(psrt:pstp) = 0;
        end
    end
end

save_data(:,8)=eye_movement_vector;

clear possible_starts;
clear possible_stops;
clear j;
clear start;
clear stop;