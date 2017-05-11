function[spill_stats, session] = spill_stats(session, target_cup_h, target_cup_diam, held_cup_h, held_cup_diam, held_cup_bottom_diam)
%    EXAMPLE: [st,pt,xymn,xystd,xylen,xyzmn,xyzstd,xyzlen]= spill_stats(session_info, 12, 8.5, 12, 7)
%
%  spill_stats.
%  st, ------ seconds spilled
%  pt, ------ seconds poured
%  xymn, ---- mean of the sample-to-sample distance during pouring in the x-y plane
%  xystd, --- standard dev. of the  "         "         "     "   "        "    "
%  xylen, --- path length during pouring in the x-y plane
%  xyzmn, --- mean of the sample-to-sample distance during pouring in the x-y-z plane
%  xyzstd, -- standard dev. of the  "         "         "     "   "        "    "
%  xyzlen --- path length during pouring in the x-y-z plane
%
%  = spill_seconds
%  (session, -------- session information, usually "session_info"
%   target_cup_h, --- target cup height
%   target_cup_diam,  target cup diameter
%   held_cup_h, ----- held cup height
%   held_cup_diam) -- held cup diameter
%
% calculates the number of seconds the patient was "spilling" during each trial. "Spilling" is defined
% as instant in time when the cup held by the patient is tilted below horizontal, and the bottom lip
% of the held cup is not directly over the target cup, so that material pouring from the cup would not
% fall inside the cup. This calculation ignores dynamics of the fluid and interactions with the velocity
% of the cup.

% use new calculation for figuring out the "flange" angle of the held_cup to determine pouring
if nargin > 5,
   use_cup_flange = 1;
else
   use_cup_flange = 0;
end;

spill_time = zeros(length(session.trial_start),1);
pour_time = zeros(length(session.trial_start),1);
%pour_xy_d_mn = zeros(length(session.trial_start),1);
%pour_xy_d_std = zeros(length(session.trial_start),1);
%pour_xy_d_len = zeros(length(session.trial_start),1);
%pour_xyz_d_mn = zeros(length(session.trial_start),1);
%pour_xyz_d_std = zeros(length(session.trial_start),1);
%pour_xyz_d_len = zeros(length(session.trial_start),1);
pour_x_mn = zeros(length(session.trial_start),1);
pour_y_mn = zeros(length(session.trial_start),1);
pour_z_mn = zeros(length(session.trial_start),1);
pour_x_std = zeros(length(session.trial_start),1);
pour_y_std = zeros(length(session.trial_start),1);
pour_z_std = zeros(length(session.trial_start),1);
pour_std_volume = zeros(length(session.trial_start),1);
pour_enclose_volume = zeros(length(session.trial_start),1);

dt = length(session.sensor_string)/240;
for t=1:length(session.trial_start)
   d_xyz = 0;
   d_xy = 0;
   s_x = 0;
   s_y = 0;
   s_z = 0;
   tbegin = session.trial_start(t);
   tend = session.trial_end(t);
   held_data = session.data(tbegin+find(session.data(tbegin+1:tend-1,1)==1),:);
   target_data = session.data(tbegin+find(session.data(tbegin+1:tend-1,1)==4),:);
   if isempty(target_data),
      warning('Warning: trial has no target data!');
      break;
   end;
   % adjust for cup height
   held_data(:,3:5) = held_data(:,12:14).*(ones(size(held_data,1),3)*held_cup_h) + held_data(:,3:5);
   % drop down to rim of cup
   rim_theta = ones(size(held_data,1),1)*pi/2 - asin(held_data(:,14));
   held_data(:,5) = held_data(:,5) + sin(rim_theta)*(held_cup_diam/2);
   held_data(:,3) = held_data(:,3) - held_data(:,12).*(cos(rim_theta)*held_cup_diam/2);
   held_data(:,4) = held_data(:,4) - held_data(:,13).*(cos(rim_theta)*held_cup_diam/2);
   % calculate the held_cup flange angle and normalize to come up with a pour cutoff
   if use_cup_flange > 0,
      tb_diff = (held_cup_diam - held_cup_bottom_diam)/2;
      held_flange_angle = atan(tb_diff/held_cup_h);
      cutoff_z = -sin(held_flange_angle);
   else,
      cutoff_z = 0;
   end;  
   % alternate way to get pour data uses the find function
   pour_data = held_data(find(held_data(:,14)>cutoff_z),:);
   if ~isempty(pour_data),
       % clip end, since in RWT tests, pouring of oatmeal only lasts so long...
       %disp(t);disp(size(pour_data));
       if size(pour_data,1) > (1/dt),
           pour_data = pour_data(1:1/dt,:);
       end
       pour_time(t) = size(pour_data,1)*dt;
       pour_x_mn(t) = mean(pour_data(:,4));
       pour_x_std(t) = std(pour_data(:,4));
       pour_y_mn(t) = mean(pour_data(:,3));
       pour_y_std(t) = std(pour_data(:,3));
       pour_z_mn(t) = mean(-pour_data(:,5));
       pour_z_std(t) = std(-pour_data(:,5));
       pour_std_volume(t) = pour_x_std(t)*pour_y_std(t)*pour_z_std(t);
       minx = min(pour_data(:,4));
       maxx = max(pour_data(:,4));
       miny = min(pour_data(:,3));
       maxy = max(pour_data(:,3));
       minz =  min(-pour_data(:,5));
       maxz = max(-pour_data(:,5));
       pour_enclose_volume(t) = (maxx - minx)*(maxy - miny)*(maxz - minz);
       % now we want to save pour data for plotting
       session.pourvf(:,:,t).vertices = [minx miny minz;...
               maxx miny minz;...
               minx maxy minz;...
               maxx maxy minz;...
               minx miny maxz;...
               maxx miny maxz;...
               minx maxy maxz;...
               maxx maxy maxz];
           session.pourvf(:,:,t).faces = [1 3 7 5;1 5 6 2;2 6 8 4;4 3 7 8;5 7 8 6;1 2 4 3];
           session.pourdata{t} = pour_data;
           
           
     
   end;
   % now look and see if spilling
   for samp=1:size(pour_data,1)
       % spatial xyz data
%       if ~(samp==1), %skip 1st sample
 %          d_xyz = [d_xyz;sqrt(sum((pour_data(samp-1,3:5)-pour_data(samp,3:5)).^2))];
  %         d_xy =  [d_xy;sqrt(sum((pour_data(samp-1,3:4)-pour_data(samp,3:4)).^2))];
   %        % calc distance from center of target cup
   %   end
       dist = sqrt(sum((pour_data(samp,3:4)-target_data(samp,3:4)).^2));
       if dist>target_cup_diam/2
           spill_time(t) = spill_time(t) + dt;
       end
   end
   % calc stats
%   pour_xy_d_mn(t) = mean(d_xy);
%   pour_xy_d_std(t) = std(d_xy);
%   pour_xy_d_len(t) = sum(d_xy);
%   pour_xyz_d_mn(t) = mean(d_xyz);
%   pour_xyz_d_std(t) = std(d_xyz);
%   pour_xyz_d_len(t) = sum(d_xyz);
end

%spill_time
%pour_time
%pour_xy_d_mn
%pour_xy_d_std
%pour_xy_d_len
%pour_xyz_d_mn
%pour_xyz_d_std
%pour_xyz_d_len
%pour_x_mn
%pour_x_std
%pour_y_mn
%pour_y_std
%pour_z_mn
%pour_z_std

% fill struct
spill_stats.spill_time = spill_time;
spill_stats.pour_time = pour_time;
%spill_stats.pour_xy_d_mn = pour_xy_d_mn;
%spill_stats.pour_xy_d_std = pour_xy_d_std;
%spill_stats.pour_xy_d_len = pour_xy_d_len;
%spill_stats.pour_xyz_d_mn = pour_xyz_d_mn;
%spill_stats.pour_xyz_d_std = pour_xyz_d_std;
%spill_stats.pour_xyz_d_len = pour_xyz_d_len;
spill_stats.pour_x_mn = pour_x_mn;
spill_stats.pour_x_std = pour_x_std;
spill_stats.pour_y_mn = pour_y_mn;
spill_stats.pour_y_std = pour_y_std;
spill_stats.pour_z_mn = pour_z_mn;
spill_stats.pour_z_std = pour_z_std;
spill_stats.pour_std_volume = pour_std_volume;
spill_stats.pour_enclose_volume = pour_enclose_volume;
