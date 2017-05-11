% plot selected trials and teachers
% first find out if there is ANYTHING to plot
tr = get(trialbox,'string');
tch = get(teacherbox,'string');
sn = get(sensorbox,'string');
if ((isempty(tch) & isempty(tr)) | isempty(sn)), 
   % condition where there is either no trials and teachers, or no sensors specified
   return;
else
   % we know we are going to try to plot something, so set up the plot environment
   eval(sprintf('sensors = [%s];',sn));
   sensors = sensors(find((sensors<=4) & (sensors>=1)));
   clear dat;
   col = {'b','r','g','c'};
   tcol = {'k','y','m','r<'}; 
   figure(fig); clf; orient tall;
   rotate3d on;
   % following are some old things for velocity and what not
   %sub1 = subplot('position',[.1 .1 .5 .8]);
   %sub2 = subplot('position',[.7 .1 .2 .35]);
   %sub3 = subplot('position',[.7 .55 .2 .35]);
   tt = get(titlebox,'string');
   if ~isempty(tt),
      set(gcf,'name',tt);
   end;
   dt = length(sens)/120;
   
   % plot selected trials
   if ~isempty(tr),
      eval(sprintf('trials = [%s];',tr));
      trials = trials(find((trials<=num) & (trials>=1)));
      % Using iif which is the indices in data where the trials end
      for t=trials
         for s=sensors
            dat{s} = data(ii(t)+find(data(ii(t)+1:iif(t)-1,1)==s),:);
         end;
         for s=sensors
            if size(dat{s},1)>0,
               tind = [0:size(dat{s},1)-1]*dt;
               tind1 = [1:size(dat{s},1)-1]*dt;
               %         	subplot(sub1);
               sz = size(dat{s},1);
               sz1 = sz - round(sz/4);
               if s==1,
                  plot3(dat{s}(1:sz1,4),dat{s}(1:sz1,3),-dat{s}(1:sz1,5),col{s}); hold on;
                  plot3(dat{s}(sz1:sz,4),dat{s}(sz1:sz,3),-dat{s}(sz1:sz,5),'g:'); hold on;
               elseif (s==4),
                  %  & (t==trials(1)) TDYAR - this condition was in prev line, but I am going to draw one for each trial
                  %plot3(dat{s}(1,4)*dat{s}(1,7),dat{s}(1,3)*dat{s}(1,6),-dat{s}(1,5)*dat{s}(1,8),'ro'); hold on;
                  plot3(dat{s}(:,4),dat{s}(:,3),-dat{s}(:,5),'ro'); hold on;
               elseif s==3,
                  plot3(dat{s}(:,4),dat{s}(:,3),-dat{s}(:,5),'m'); hold on;             
               else
                  plot3(dat{s}(:,4),dat{s}(:,3),-dat{s}(:,5),col{s}); hold on;
               end; 
               % if we are showing orientations...
               % do Z first
               if (get(arrowsbox, 'Value')),
                  clear temp;
                  j=0;
                  for i = 1:10:size(dat{s},1)
                     j = j+1;
                     temp(j,:) = dat{s}(i,:);
                  end
                  gldat = pol2gl(temp);
                 	quiver3(gldat(1,4,:),gldat(2,4,:),gldat(3,4,:),gldat(1,1,:)*5,gldat(2,1,:)*5, gldat(3,1,:)*5,0,'r'); hold on;
               	quiver3(gldat(1,4,:),gldat(2,4,:),gldat(3,4,:),gldat(1,2,:)*5,gldat(2,2,:)*5, gldat(3,2,:)*5,0, 'y'); hold on;
                  quiver3(gldat(1,4,:),gldat(2,4,:),gldat(3,4,:),gldat(1,3,:)*5,gldat(2,3,:)*5, gldat(3,3,:)*5,0, 'm'); hold on;
                  % lets try to plot the targets
                  if session_info.orient_valid & ~isempty (session_info.orient_targets(:,:,t))
                     trg = session_info.orient_targets(:,:,t);
                     plot3(trg(1,4),trg(2,4),trg(3,4),'bo'); hold on;
                     quiver3(trg(1,4),trg(2,4),trg(3,4), trg(1,1)*5, trg(2,1)*5, trg(3,1)*5, 0,'r'); hold on;
               		quiver3(trg(1,4),trg(2,4),trg(3,4), trg(1,2)*5, trg(2,2)*5, trg(3,2)*5, 0, 'y'); hold on;
                     quiver3(trg(1,4),trg(2,4),trg(3,4), trg(1,3)*5, trg(2,3)*5, trg(3,3)*5, 0, 'm'); hold on;
                  end
               end;
               % how about some pour stats?
               try
%                    if ~isempty( session_info.pourdata{t} )
%                        pd = session_info.pourdata{t};
%                        plot3(pd(:,4),pd(:,3), -pd(:,5),'ro'); hold on;
%                        patch(session_info.pourvf(:,:,t), 'FaceAlpha', 0); hold on; 
%                    end;
               catch
               end
            end;
         end;
      end;
   end;
   
   % Now try to plot the specified teachers!!
   if ~isempty(tch), 
      eval(sprintf('teachers = [%s];',tch));
      teachers = teachers(find((teachers<=num) & (teachers>=1)));
      % check what I need to do here...
      clear dat;
      % Using tch_end which is the indices in data where the teachers end
      for t=teachers
         for s=sensors
            dat{s} = data(tch_start(t)+find(data(tch_start(t)+1:tch_end(t)-1,1)==s),:);
         end;
         for s=sensors
            if size(dat{s},1)>0,
               tind = [0:size(dat{s},1)-1]*dt;
               tind1 = [1:size(dat{s},1)-1]*dt;
               %         	subplot(sub1);
               sz = size(dat{s},1);
               sz1 = sz - round(sz/4);
               if s==1,
                  plot3(dat{s}(1:sz1,4),dat{s}(1:sz1,3),-dat{s}(1:sz1,5),tcol{s}); hold on;
                  plot3(dat{s}(sz1:sz,4),dat{s}(sz1:sz,3),-dat{s}(sz1:sz,5),'k:'); hold on;
               elseif (s==4),
                  %  & (t==trials(1)) TDYAR - this condition was in prev line, but I am going to draw one for each trial
                  %plot3(dat{s}(1,4)*dat{s}(1,7),dat{s}(1,3)*dat{s}(1,6),-dat{s}(1,5)*dat{s}(1,8),'ro'); hold on;
                  plot3(dat{s}(:,4),dat{s}(:,3),-dat{s}(:,5),'ro'); hold on;
               elseif s==3,
                  plot3(dat{s}(:,4),dat{s}(:,3),-dat{s}(:,5),'m'); hold on;             
               else
                  plot3(dat{s}(:,4),dat{s}(:,3),-dat{s}(:,5),tcol{s}); hold on;
               end;  
               % now for orientations
               if (get(arrowsbox, 'Value')),
               	quiver3(dat{s}(:,4),dat{s}(:,3),-dat{s}(:,5),dat{s}(:,7),dat{s}(:,6), -dat{s}(:,8), .15, 'r'); hold on;
               	quiver3(dat{s}(:,4),dat{s}(:,3),-dat{s}(:,5),dat{s}(:,10),dat{s}(:,9), -dat{s}(:,11), .15, 'y'); hold on;
                  quiver3(dat{s}(:,4),dat{s}(:,3),-dat{s}(:,5),dat{s}(:,13),dat{s}(:,12), -dat{s}(:,14), .15, 'm'); hold on;
               end;
            end;
         end;
      end;
   end;
   % test targets
   %plot3(targets(36:45,2), targets(36:45,1), -targets(36:45,3),'go')
   axis image; 
   xlabel('X cm'); ylabel('Y cm'); zlabel('Z cm'); 
   set(plot3(0,0,0,'ro'),'markersize',10);
   plot3([0 0],[0 -10],[0 0],'r');
   axis image; axis tight; set(gca,'box','on');
   title(sprintf('File: %s, Trial(s): %s, Sensor(s): %s',name,tr,sn));
   view([-150 20]);
   ax = get(axesbox,'string');
   if ~isempty(ax),
      eval(sprintf('axis([%s]);',ax));
   end
   %subplot(sub3); ylabel('Speed (cm/sec)'); xlabel('Time (sec)'); axis tight;
   %subplot(sub2); ylabel('Tilt (deg)'); xlabel('Time (sec)'); axis tight;
end
