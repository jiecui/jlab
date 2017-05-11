function [aligned_session] = align_data(good_session, good_first, good_last, skewed_session, first_trial, last_trial, sensor)
% function takes in a polhemus data sample (possibly averaged)
% as a target position and rotation, a starting polhemus
% sample, and the data to be transformed. Based on Emo's
% Align Teacher function in KELS/R, align_data computes
% the required translation and rotation to achieve the
% tend configuration and applies this transform to all
% the rows of skewed. Use this function to align a scene's
% data in another frame of reference. It is suggested that
% if you are using data samples as the tend and tstart\
% variables, that these should be averaged values

%sk_sensor_data = str2num(skewed_session.sensor_string);
%gd_sensor_data = str2num(good_session.sensor_string);

% first let's average the good data -- get the trial indices within good block, and find the
% sensor data there. Once we have that matrix, we can average it

gd_data = [];
for t = good_first:good_first,
   tbegin = good_session.trial_start(t);
   tend = good_session.trial_end(t);
   gd_data = [gd_data; good_session.data(tbegin + find(good_session.data(tbegin+1:tend-1,1)==sensor),:)];
end;
gd_config = mean(gd_data);
% maybe try the "robust" on the data before averaging?

%convert to opengl matrix and make local copy
gd_config = pol2gl(gd_config)
transform = gd_config;
translate = transform(4,1:3)*-1;

% find the configuration (location and rotation) of the skewed data
sk_data = [];
for t = first_trial:first_trial,
   tbegin = skewed_session.trial_start(t);
   tend = skewed_session.trial_end(t);
	sk_data = [sk_data; skewed_session.data(tbegin + find(skewed_session.data(tbegin+1:tend-1,1)==sensor),:)];
end;
sk_config = pol2gl(mean(sk_data))

% find the transformation between the two data sets
transform = inverttrans(transform)
transform = multtrans(sk_config, transform)
transform(4,1:3) = gd_config(4,1:3) - sk_config(4,1:3)
transform(3,1:3) = [0 0 1];

% for each sample 's' in each trial 't', convert to gl matrix, transform it, then convert back
% to polhemus format
for t = first_trial:last_trial,
   tbegin = skewed_session.trial_start(t) + 1;
   tend = skewed_session.trial_end(t) - 1;
   for sample = tbegin:tend,
      sk_data = skewed_session.data(sample,:);
      skewed_session.data(sample,3:14) = gl2pol(multtrans(pol2gl(sk_data),transform));
      skewed_session.data(sample,:);
   end;
end;

% check for teacher, and do the same
%if skewed_session.blocks(skewed_block).tch_ndata,
%   tbegin = skewed_session.tch_start(skewed_block) + 1;
%   tend = skewed_session.tch_end(skewed_block) - 1;
%   for sample = tbegin:tend,
%      sk_data = skewed_session.data(sample,:);
%   	skewed_session.data(sample,3:14) = gl2pol(multseparate(pol2gl(sk_data),transform));
%   end;
%end;
      
aligned_session = skewed_session;
  
