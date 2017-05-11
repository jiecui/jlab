function armvec = sl_mail_arm_model(pulse)
global s1data s2data 
blendelbow = [0 0 reshape(s2data',1,12)];
blendwrist = [0 0 reshape(s1data',1,12)];

parms.PALMLEN = 12;%not used
parms.FOREARMLEN = 30;%not used
parms.UPPERARMLEN = 30;

parms.SHOULDERWIDTH = 6;%not used
parms.ELBOWWIDTH = 4.5;%not used
parms.WRISTWIDTH = 2.8;%not used
parms.FINGERWIDTH = 4;%not used
parms.PALMASPECT = 0.5;%not used

parms.WRISTOFF = 5.5;
parms.WRISTDEPTH = 4.5;
parms.WRISTROT = 10/180*pi;
parms.ELBOWOFF = 8;
parms.ELBOWDEPTH = 7;
parms.ELBOWROT = -13/180*pi;


armdat = arm_model(pol2gl(blendwrist),pol2gl(blendelbow), 2, 1, parms);
armvec = [armdat.pshoulder' armdat.eshoulder armdat.eelbow armdat.ewrist];

% plot3??

w = armdat.wrist;
f = armdat.forearm;
e = armdat.elbow;
rw = armdat.raw_wrist;
re = armdat.raw_elbow;
fe = armdat.forearm_elbow;
sh = armdat.shoulder;
ev1 = armdat.env1;
ev2 = armdat.env2;
ev3 = armdat.env3;
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
      quiver3(w(1,4),w(2,4),w(3,4),w(1,1)*5, w(2,1)*5, w(3,1)*5, 0,'r'); hold on;
      quiver3(w(1,4),w(2,4),w(3,4),w(1,2)*5, w(2,2)*5, w(3,2)*5, 0, 'y'); hold on;
      quiver3(w(1,4),w(2,4),w(3,4),w(1,3)*5, w(2,3)*5, w(3,3)*5, 0, 'm'); hold on;
      quiver3(e(1,4),e(2,4),e(3,4),e(1,1)*5, e(2,1)*5, e(3,1)*5, 0, 'r'); hold on;
      quiver3(e(1,4),e(2,4),e(3,4),e(1,2)*5, e(2,2)*5, e(3,2)*5, 0, 'y'); hold on;
      quiver3(e(1,4),e(2,4),e(3,4),e(1,3)*5, e(2,3)*5, e(3,3)*5, 0, 'm'); hold on;
      quiver3(ev1(1,4),ev1(2,4),ev1(3,4),ev1(1,1)*5, ev1(2,1)*5, ev1(3,1)*5, 0, 'r'); hold on;
      quiver3(ev1(1,4),ev1(2,4),ev1(3,4),ev1(1,2)*5, ev1(2,2)*5, ev1(3,2)*5, 0, 'y'); hold on;
      quiver3(ev1(1,4),ev1(2,4),ev1(3,4),ev1(1,3)*5, ev1(2,3)*5, ev1(3,3)*5, 0, 'm'); hold on;
      quiver3(ev2(1,4),ev2(2,4),ev2(3,4),ev2(1,1)*5, ev2(2,1)*5, ev2(3,1)*5, 0, 'r'); hold on;
      quiver3(ev2(1,4),ev2(2,4),ev2(3,4),ev2(1,2)*5, ev2(2,2)*5, ev2(3,2)*5, 0, 'y'); hold on;
      quiver3(ev2(1,4),ev2(2,4),ev2(3,4),ev2(1,3)*5, ev2(2,3)*5, ev2(3,3)*5, 0, 'm'); hold on;
		quiver3(ev3(1,4),ev3(2,4),ev3(3,4),ev3(1,1)*5, ev3(2,1)*5, ev3(3,1)*5, 0, 'r'); hold on;
      quiver3(ev3(1,4),ev3(2,4),ev3(3,4),ev3(1,2)*5, ev3(2,2)*5, ev3(3,2)*5, 0, 'y'); hold on;
      quiver3(ev3(1,4),ev3(2,4),ev3(3,4),ev3(1,3)*5, ev3(2,3)*5, ev3(3,3)*5, 0, 'm'); hold on;
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
      
   