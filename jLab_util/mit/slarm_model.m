function armvec = slarm_model(pulse)
global s2data s3data
blendelbow = [0 0 reshape(s2data',1,12)];
blendwrist = [0 0 reshape(s3data',1,12)];
armdat = arm_model(pol2gl(blendwrist),pol2gl(blendelbow));
armvec = [armdat.pshoulder' armdat.eshoulder armdat.eelbow armdat.ewrist];

% plot3??
w = wrist;
f = forearm;
e = elbow;
rw = raw_wrist;
re = raw_elbow;
fe = forearm_elbow;
arrows = 1;
lines = 1;

if (toc > .5)
   tic
   [az,elv] = view;
   if arrows
      %quiver the components
      %quiver3(w(:,1,4),w(:,2,4),w(:,3,4),w(:,1,1),w(:,2,1), w(:,3,1),'r'); hold on;
      %quiver3(w(:,1,4),w(:,2,4),w(:,3,4),w(:,1,2),w(:,2,2), w(:,3,2), 'y'); hold on;
      %quiver3(w(:,1,4),w(:,2,4),w(:,3,4),w(:,1,3),w(:,2,3), w(:,3,3), 'm'); hold on;
      %quiver3(f(:,1,4),f(:,2,4),f(:,3,4),f(:,1,1),f(:,2,1), f(:,3,1),'r--'); hold on;
      %quiver3(f(:,1,4),f(:,2,4),f(:,3,4),f(:,1,2),f(:,2,2), f(:,3,2), 'y--'); hold on;
      %quiver3(f(:,1,4),f(:,2,4),f(:,3,4),f(:,1,3),f(:,2,3), f(:,3,3), 'm--'); hold on;
      
      set(gca,'View', [az elv]);
      axis([0 50 -40 20 -10 50]);
      quiver3(fe(1,4),fe(2,4),fe(3,4),fe(1,1)*5, fe(2,1)*5, fe(3,1)*5, 0, 'r--'); hold on;
      set(gca,'View', [az elv]);
      quiver3(fe(1,4),fe(2,4),fe(3,4),fe(1,2)*5, fe(2,2)*5, fe(3,2)*5, 0, 'y--'); hold on;
      quiver3(fe(1,4),fe(2,4),fe(3,4),fe(1,3)*5, fe(2,3)*5, fe(3,3)*5, 0, 'm--'); hold on;
      quiver3(e(1,4),e(2,4),e(3,4),e(1,1)*5, e(2,1)*5, e(3,1)*5, 0, 'r'); hold on;
      quiver3(e(1,4),e(2,4),e(3,4),e(1,2)*5, e(2,2)*5, e(3,2)*5, 0, 'y'); hold on;
      quiver3(e(1,4),e(2,4),e(3,4),e(1,3)*5, e(2,3)*5, e(3,3)*5, 0, 'm'); hold on;
      quiver3(sh(1,4),sh(2,4),sh(3,4),sh(1,1)*5, sh(2,1)*5, sh(3,1)*5, 0, 'r'); hold on;
      quiver3(sh(1,4),sh(2,4),sh(3,4),sh(1,2)*5, sh(2,2)*5, sh(3,2)*5, 0, 'y'); hold on;
      quiver3(sh(1,4),sh(2,4),sh(3,4),sh(1,3)*5, sh(2,3)*5, sh(3,3)*5, 0, 'm'); hold on;
      %quiver3(re(:,1,4),re(:,2,4),re(:,3,4),re(:,1,1),re(:,2,1), re(:,3,1),'r'); hold on;
      %quiver3(re(:,1,4),re(:,2,4),re(:,3,4),re(:,1,2),re(:,2,2), re(:,3,2), 'y'); hold on;
      %quiver3(re(:,1,4),re(:,2,4),re(:,3,4),re(:,1,3),re(:,2,3), re(:,3,3), 'm'); hold on;
      
   end
   
   if lines
      %draw lines
      plot3([w(1,4);f(1,4)],[w(2,4);f(2,4)],[w(3,4);f(3,4)],'ro-'); hold on;
      plot3([f(1,4);e(1,4)],[f(2,4);e(2,4)],[f(3,4);e(3,4)],'bo-'); hold on;
      plot3([e(1,4);sh(1,4)],[e(2,4);sh(2,4)],[e(3,4);sh(3,4)],'go-'); hold on;
      plot3(rw(1,4),rw(2,4),rw(3,4),'b+'); hold on;
      plot3(re(1,4),re(2,4),re(3,4),'m+'); hold on;
      
   end
   
   axis image; 
   xlabel('X cm'); ylabel('Y cm'); zlabel('Z cm'); 
   set(plot3(0,0,0,'ro'),'markersize',10);
   plot3([0 0],[0 -10],[0 0],'r');
   axis image;

   
   hold off;
   
end
      %wrist
      %forearm
      
   