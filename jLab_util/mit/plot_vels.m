% plot velociteis of selected trials and teachers
% first find out if there is ANYTHING to plot
%axis auto
% putting in a trick to get network-collected data to plot right
global ttimes
ts = [];
timestamps = 0;
if ~isempty(ttimes)
	timestamps = 1;
	ts = ttimes;
end


tr = get(trialbox,'string');
tch = get(teacherbox,'string');
sn = get(sensorbox,'string');
if ((isempty(tch) & isempty(tr)) | isempty(sn)), 
   % condition where there is either no trials and teachers, or no sensors specified
   return;
else
   % we know we are going to try to plot something, so set up the plot environment
   max_tind = 0;;
   eval(sprintf('sensors = [%s];',sn));
   sensors = sensors(find((sensors<=4) & (sensors>=1)));
   clear dat;
   col = {'b','r','g','c'};
   tcol = {'k','y','m','r<'}; 
   figure(fig); clf; orient tall;
   rotate3d off;
   % following are some old things for velocity and what not
   sub1 = subplot('position',[.1 .5 .8 .45]);
   sub2 = subplot('position',[.1 .28 .8 .15]);
   sub3 = subplot('position',[.1 .1 .8 .12]);
   tt = get(titlebox,'string');
   if ~isempty(tt),
      set(gcf,'name',tt);
   end;
   dt = length(sens)/240;
   
   % plot selected trials
   if ~isempty(tr),
       eval(sprintf('trials = [%s];',tr));
       trials = trials(find((trials<=num) & (trials>=1)));
       % Using iif which is the indices in data where the trials end
       for t=trials
           for s=sensors
               dat{s} = data(ii(t)+find(data(ii(t)+1:iif(t)-1,1)==s),:);
           end;
           
           for s=sensors(1)
               if size(dat{s},1)>0,        
                   subplot(sub1);
                   scname = session_info.scene_names(t);
                   tind = [0:size(dat{s},1)-1]*dt;
                   if timestamps
                       curts = ts(find(ts(:,1)==t), 2);
                       if ~isempty(curts)
                           tind = curts/1000;
                       end
                   end
                   tind1 = [1:size(dat{s},1)-1]*dt;
                   vels = sqrt(sum(([dat{s}(:,3:5);0 0 0]-[0 0 0;dat{s}(:,3:5)]).^2,2));
                   vels = vels(2:size(vels,1)-1,:)./dt;
                   vels = sav_golay(vels,11,2,0);
                   % calculate peaks and plot them
                   for i=3:size(vels,1)-2
                       if vels(i)>vels(i-1) & ...
                               vels(i-1)>vels(i-2) & ...
                               vels(i)>vels(i+1) & ...
                               vels(i+1)>vels(i+2) & ...
                               vels(i)>3,
                           plot(tind1(i),vels(i), 'ro'); hold on;
                       end
                   end 
                   % plot the velocities
                   plot(tind1,vels); hold on;
                   % plot the z-orientation vertices
                   subplot(sub2);
                   or_diffs = [];
                   % second condition for below: & size(session_info.orient_diffs,1) >= iif(t)-1
                   if session_info.orient_valid %& ~timestamps 
                       %or_diffs = session_info.trialstats(t).
                       %or_diffs = session_info.orient_diffs(ii(t)+find(data(ii(t)+1:iif(t)-1,1)==s),:);
                       % plot sqrt(orientation^2) for ERROR
                       % also want to add plot for absolute euler angles
                       yawp = plot(tind,session_info.trialstats(t).yaw_error.data, 'y'); hold on;
                       pitchp = plot(tind,session_info.trialstats(t).pitch_error.data, 'm'); hold on;
                       rollp = plot(tind,session_info.trialstats(t).roll_error.data, 'r'); hold on;
                       minp = plot(tind(session_info.trialstats(t).roll_error.best_idx),session_info.trialstats(t).roll_error.best_val, 'bo'); hold on;
                   end
                   
                   %plot(tind,dat{s}(:,12:13)); hold on;
                   %45 - acos(dat{s}(:,14))*180/pi - 180
                   %pdata = atan2(dat{s}(:,14), dat{s}(:,13))*180/pi;
                   %pdata([find(pdata < 0)]) = pdata([find(pdata < 0)]) + 360;
                   %plot(tind,-(45-(pdata)), 'b'); hold on;
                   %plot(tind,acos(-dat{s}(:,14))*180/pi, 'b'); hold on;
                   if size(tind,2) > size(max_tind,2),
                       max_tind = tind;
                   end;
                   % plot the positions
                   subplot(sub3);
                   plot(tind,dat{s}(:,3:4)); hold on;
                   plot(tind,-dat{s}(:,5), 'r'); hold on;
                   legend('y','x','z',2);
               end;        
           end;
       end;
   end;
end;
   
   % Now try to plot the specified teachers!
   if ~isempty(tch), 
      eval(sprintf('teachers = [%s];',tch));
      teachers = teachers(find((teachers<=num) & (teachers>=1)));
      % check what I need to do here...
      clear dat;
      % Using tch_end which is the indices in data where the teachers end
      for t=teachers
         % find out what sensors are available for this teacher
         tch_sens = [];
  			if ~isempty(find(data(tch_start(t)+1:tch_end(t)-1,1)==1)), 
      		tch_sens = [tch_sens ' 1']; 
   		end;
   		if ~isempty(find(data(tch_start(t)+1:tch_end(t)-1,1)==2)), 
      		tch_sens = [tch_sens ' 2']; 
   		end;
  			if ~isempty(find(data(tch_start(t)+1:tch_end(t)-1,1)==3)), 
      		tch_sens = [tch_sens ' 3']; 
   		end;
   		if ~isempty(find(data(tch_start(t)+1:tch_end(t)-1,1)==4)), 
      		tch_sens = [tch_sens ' 4']; 
         end;
         tch_dt = length(tch_sens)/240;
         
         for s=sensors
            dat{s} = data(tch_start(t)+find(data(tch_start(t)+1:tch_end(t)-1,1)==s),:);
         end;
         for s=sensors
            if size(dat{s},1)>0,
               % do first plot
               subplot(sub1);
               if s==1,
                  
               	tind = [0:size(dat{s},1)-1]*tch_dt;
	               tind1 = [1:size(dat{s},1)-1]*tch_dt;
   	            vels = sqrt(sum(([dat{s}(:,3:5);0 0 0]-[0 0 0;dat{s}(:,3:5)]).^2,2));
      	         vels = vels(2:size(vels,1)-1,:)./tch_dt;
         	      vels = sav_golay(vels,11,2,0);
            	   % calculate peaks
               	for i=3:size(vels,1)-2
	                  if vels(i)>vels(i-1) & ...
   	                     vels(i-1)>vels(i-2) & ...
      	                  vels(i)>vels(i+1) & ...
         	               vels(i+1)>vels(i+2) & ...
            	            vels(i)>3,
               	      plot(tind1(i),vels(i), 'ko'); hold on;
                  	end
               	end
                  plot(tind1,vels, 'g'); hold on;
               	% do second plot
	               subplot(sub2);
                  plot(tind,dat{s}(:,12:13), ':'); hold on;
                  plot(tind,acos(-dat{s}(:,14))*180/pi, 'g'); hold on;
                  if size(tind,2) > size(max_tind,2),
                     max_tind = tind;
                  end;
                  subplot(sub3);
                  plot(tind,dat{s}(:,3:4), ':'); hold on;
                  plot(tind,-dat{s}(:,5), 'r:'); hold on;
               end;
            end;
         end;
      end;
   end;
   
   
   
   %axis image; 
   subplot(sub1);
   ylabel('velocity (cm/sec)');
   title(sprintf('File: %s, Trial(s): %s, Sensor(s): %s',name,tr,sn))
   ax = get(axesbox,'string');
   if ~isempty(ax),
      eval(sprintf('axis([%s]);',ax));
   end
   subplot(sub2); ylabel('Orientation error(deg)'); axis tight;
   plot(max_tind, ones(size(max_tind,2),1)*90, 'k:');
   plot(max_tind, zeros(size(max_tind,2),1), 'k:');
  	%legend([yawp, pitchp, rollp, minp], 'Yaw (x-y)', 'Pitch (x-z)', 'Roll (y-z)','Min', 2);
   subplot(sub3); ylabel('Pos(cm)'); xlabel('Time (sec)'); axis tight;
	
end
