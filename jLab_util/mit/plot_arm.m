% plot arm data of selected trials and teachers
% first find out if there is ANYTHING to plot
tr = get(trialbox,'string');
tch = get(teacherbox,'string');
sn = get(sensorbox,'string');
if (isempty(tch) & isempty(tr)), 
   % condition where there is either no trials and teachers   return;
else
   % we know we are going to try to plot something, so set up the plot environment
   smooth = 1;
   eval(sprintf('sensors = [%s];',sn));
   sensors = sensors(find((sensors<=4) & (sensors>=1)));
   clear dat;
   figure(fig); clf; orient tall;
   rotate3d off;
   tt = get(titlebox,'string');
   if ~isempty(tt),
      set(gcf,'name',tt);
   end;
   dt = length(sens)/240;
   
   % set up subplots
   sub1 = subplot(3,1,1);
   sub2 = subplot(3,1,2);
   sub3 = subplot(3,1,3);
   
   % plot selected trials
   if ~isempty(tr),
      eval(sprintf('trials = [%s];',tr));
      trials = trials(find((trials<=num) & (trials>=1)));
      for t=trials
         if session_info.has_arm
            dat = session_info.arm_data(t);
            if size(dat,1)>0
               tind = [0:size(dat.pshoulder,1)-1]*dt;
               shoulder_x = sav_golay(dat.pshoulder(:,1), smooth, 2, 0);
               shoulder_y = sav_golay(dat.pshoulder(:,2), smooth, 2, 0);
               shoulder_z = sav_golay(dat.pshoulder(:,3), smooth, 2, 0);
               shoulder_az = sav_golay(dat.eshoulder(:,1), smooth, 2, 0);
               shoulder_el = sav_golay(dat.eshoulder(:,2), smooth, 2, 0);
               shoulder_roll = sav_golay(dat.eshoulder(:,3), smooth, 2, 0);
               elbow_flex = sav_golay(dat.eelbow(:,2), smooth, 2, 0);
               forearm_ps_rot = sav_golay(dat.eelbow(:,3), smooth, 2, 0);
               wrist_flex = sav_golay(dat.ewrist(:,2), smooth, 2, 0);
               wrist_abad = sav_golay(dat.ewrist(:,1), smooth, 2, 0);
            else         
               dat = data(ii(t)+find(data(ii(t)+1:iif(t)-1,1)==5),:);
               if size(dat,1)>0,
                  tind = [0:size(dat,1)-1]*dt;
                  shoulder_x = sav_golay(dat(:,3), smooth, 2, 0);
                  shoulder_y = sav_golay(dat(:,4), smooth, 2, 0);
                  shoulder_z = sav_golay(dat(:,5), smooth, 2, 0);
                  shoulder_az = sav_golay(dat(:,6), smooth, 2, 0);
                  shoulder_el = sav_golay(dat(:,7), smooth, 2, 0);
                  shoulder_roll = sav_golay(dat(:,8), smooth, 2, 0);
                  elbow_flex = sav_golay(dat(:,9), smooth, 2, 0);
                  forearm_ps_rot = sav_golay(dat(:,10), smooth, 2, 0);
                  wrist_flex = sav_golay(dat(:,12), smooth, 2, 0);
                  wrist_abad = sav_golay(dat(:,11), smooth, 2, 0);
               end
            end
            
            if size(dat,1)   
               subplot(sub1);
               sx = plot(tind, shoulder_x, 'r'); hold on;
               sy = plot(tind, shoulder_y, 'g'); hold on;
               sz = plot(tind, shoulder_z, 'b'); hold on;
               
               subplot(sub2);
               saz = plot(tind, shoulder_az, 'r'); hold on;
               sel = plot(tind, shoulder_el, 'g'); hold on;
               sroll = plot(tind, shoulder_roll, 'b'); hold on;
               subplot(sub3);
               ef = plot(tind, elbow_flex, 'r'); hold on;
               frot = plot(tind, forearm_ps_rot, 'g'); hold on;
               wf = plot(tind, wrist_flex, 'b'); hold on;
               wa = plot(tind, wrist_abad, 'c'); hold on;
            end
         end
      end
      % now legends
      title(sprintf('File: %s, Trial(s): %s, Sensor(s): %s',name,tr,sn))
      subplot(sub1);
      legend([sx, sy, sz], 'Shoulder X', 'Shoulder Y', 'Shoulder Z');
      xlabel('time (seconds)'); ylabel('Position (cm)');
      subplot(sub2);
      legend([saz, sel, sroll], 'Shoulder Azimuth', 'Shoulder Elevation', 'Shoulder Roll');
      xlabel('time (seconds)'); ylabel('Rotation (deg.)');
      subplot(sub3);
		legend([ef, frot, wf, wa], 'Elbow Flexion', 'Forearm Rotation (Pro/Sup)', ...
                  'Wrist Flexion', 'Wrist Ab/Adduc');
      xlabel('time (seconds)'); ylabel('Rotation (deg.)');
   end   
end
















       
