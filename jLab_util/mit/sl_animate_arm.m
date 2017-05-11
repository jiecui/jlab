function armvec = sl_animate_arm(simtime)
global s1data s2data session_info tr parms armfig armaxis

si = session_info;
if ~si.has_arm
   return
end

recalc = 1; % set to 0 if you want to just use what is in the session_info

armdat = si.arm_data(tr);

gcf = armfig;
gca = armaxis;
% convert simtime to a sample!
sens = si.sensor_string;
dt = length(sens)/240;
cursample = round(simtime/dt);
cursample = min(cursample,size(armdat.wrist,3));
if cursample == 0
   cursample = 1;
end

if isempty(parms)
   setarmparm;
end

if recalc
   [sess, armdat] = dana_calc_arm(si,tr,cursample);
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
   armvec = [armdat.pshoulder armdat.eshoulder armdat.eelbow armdat.ewrist];
else
   w = armdat.wrist(:,:,cursample);
	f = armdat.forearm(:,:,cursample);	
	e = armdat.elbow(:,:,cursample);
	rw = armdat.raw_wrist(:,:,cursample);
	re = armdat.raw_elbow(:,:,cursample);
	fe = armdat.forearm_elbow(:,:,cursample);
	sh = armdat.shoulder(:,:,cursample);
	ev1 = armdat.env1(:,:,cursample);
	ev2 = armdat.env2(:,:,cursample);
   ev3 = armdat.env3(:,:,cursample);
   armvec = [armdat.pshoulder(cursample,:) armdat.eshoulder(cursample,:) armdat.eelbow(cursample,:) armdat.ewrist(cursample,:)];
end

arrows = 1;
lines = 1;

lh = [];

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
   h = quiver3(fe(1,4),fe(2,4),fe(3,4),fe(1,1)*5, fe(2,1)*5, fe(3,1)*5, 0, 'r--', 'filled'); hold on;
   lh = [lh; h];
   set(gca,'View', [az elv]);
   h = quiver3(fe(1,4),fe(2,4),fe(3,4),fe(1,2)*5, fe(2,2)*5, fe(3,2)*5, 0, 'y--'); hold on;
   lh = [lh; h];
   h = quiver3(fe(1,4),fe(2,4),fe(3,4),fe(1,3)*5, fe(2,3)*5, fe(3,3)*5, 0, 'm--'); hold on;
   lh = [lh; h];
   %quiver3(w(1,4),w(2,4),w(3,4),w(1,1)*5, w(2,1)*5, w(3,1)*5, 0,'r'); hold on;
   %quiver3(w(1,4),w(2,4),w(3,4),w(1,2)*5, w(2,2)*5, w(3,2)*5, 0, 'y'); hold on;
   %quiver3(w(1,4),w(2,4),w(3,4),w(1,3)*5, w(2,3)*5, w(3,3)*5, 0, 'm'); hold on;
   h = quiver3(rw(1,4),rw(2,4),rw(3,4),rw(1,1)*5, rw(2,1)*5, rw(3,1)*5, 0,'r'); hold on;
   lh = [lh; h];
   h = quiver3(rw(1,4),rw(2,4),rw(3,4),rw(1,2)*5, rw(2,2)*5, rw(3,2)*5, 0, 'y'); hold on;
   lh = [lh ;h];
   h = quiver3(rw(1,4),rw(2,4),rw(3,4),rw(1,3)*5, rw(2,3)*5, rw(3,3)*5, 0, 'm'); hold on;
   lh = [lh; h];
   h = quiver3(e(1,4),e(2,4),e(3,4),e(1,1)*5, e(2,1)*5, e(3,1)*5, 0, 'r'); hold on;
   lh = [lh;h];
   h = quiver3(e(1,4),e(2,4),e(3,4),e(1,2)*5, e(2,2)*5, e(3,2)*5, 0, 'y'); hold on;
   lh = [lh ;h];
   h = quiver3(e(1,4),e(2,4),e(3,4),e(1,3)*5, e(2,3)*5, e(3,3)*5, 0, 'm'); hold on;
   lh = [lh ;h];
   %quiver3(ev1(1,4),ev1(2,4),ev1(3,4),ev1(1,1)*5, ev1(2,1)*5, ev1(3,1)*5, 0, 'r'); hold on;
   %quiver3(ev1(1,4),ev1(2,4),ev1(3,4),ev1(1,2)*5, ev1(2,2)*5, ev1(3,2)*5, 0, 'y'); hold on;
   %quiver3(ev1(1,4),ev1(2,4),ev1(3,4),ev1(1,3)*5, ev1(2,3)*5, ev1(3,3)*5, 0, 'm'); hold on;
   %quiver3(ev2(1,4),ev2(2,4),ev2(3,4),ev2(1,1)*5, ev2(2,1)*5, ev2(3,1)*5, 0, 'r'); hold on;
   %quiver3(ev2(1,4),ev2(2,4),ev2(3,4),ev2(1,2)*5, ev2(2,2)*5, ev2(3,2)*5, 0, 'y'); hold on;
   %quiver3(ev2(1,4),ev2(2,4),ev2(3,4),ev2(1,3)*5, ev2(2,3)*5, ev2(3,3)*5, 0, 'm'); hold on;
   %quiver3(ev3(1,4),ev3(2,4),ev3(3,4),ev3(1,1)*5, ev3(2,1)*5, ev3(3,1)*5, 0, 'r'); hold on;
   %quiver3(ev3(1,4),ev3(2,4),ev3(3,4),ev3(1,2)*5, ev3(2,2)*5, ev3(3,2)*5, 0, 'y'); hold on;
   %quiver3(ev3(1,4),ev3(2,4),ev3(3,4),ev3(1,3)*5, ev3(2,3)*5, ev3(3,3)*5, 0, 'm'); hold on;
   h = quiver3(sh(1,4),sh(2,4),sh(3,4),sh(1,1)*5, sh(2,1)*5, sh(3,1)*5, 0, 'r'); hold on;
   lh = [lh ;h];
   h = quiver3(sh(1,4),sh(2,4),sh(3,4),sh(1,2)*5, sh(2,2)*5, sh(3,2)*5, 0, 'y'); hold on;
   lh = [lh; h];
   h = quiver3(sh(1,4),sh(2,4),sh(3,4),sh(1,3)*5, sh(2,3)*5, sh(3,3)*5, 0, 'm'); hold on;
   lh = [lh;h];
   h = quiver3(re(1,4),re(2,4),re(3,4),re(1,1)*5, re(2,1)*5, re(3,1)*5, 0, 'r'); hold on;
   lh = [lh; h];
   h = quiver3(re(1,4),re(2,4),re(3,4),re(1,2)*5, re(2,2)*5, re(3,2)*5, 0, 'y'); hold on;
   lh = [lh; h];
   h = quiver3(re(1,4),re(2,4),re(3,4),re(1,3)*5, re(2,3)*5, re(3,3)*5, 0, 'm'); hold on;
   lh = [lh; h];
   set(lh,'LineWidth',2);
end

if lines
   %draw lines
   %lh = [];
   h=plot3([w(1,4);f(1,4)],[w(2,4);f(2,4)],[w(3,4);f(3,4)],'ro-','LineWidth',3); hold on;
   %lh = [lh; h];
   h=plot3([f(1,4);e(1,4)],[f(2,4);e(2,4)],[f(3,4);e(3,4)],'bo-','LineWidth',3); hold on;
   
   h=plot3([e(1,4);sh(1,4)],[e(2,4);sh(2,4)],[e(3,4);sh(3,4)],'go-','LineWidth',3); hold on;
   
   h=plot3(rw(1,4),rw(2,4),rw(3,4),'b+','LineWidth',3); hold on;
   
   h=plot3(re(1,4),re(2,4),re(3,4),'m+','LineWidth',3); hold on;
   
end

%axis image; 
AXIS([-50 50 -10 100 -10 50]);
xlabel('X cm'); ylabel('Y cm'); zlabel('Z cm'); 
set(plot3(0,0,0,'ro'),'markersize',10);
plot3([0 0],[0 -10],[0 0],'r');
%axis image;
AXIS([-10 50 -10 100 -10 50]);

hold off;

      %wrist
      %forearm
      
   