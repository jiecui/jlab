function plot_limbs(session,trial,sample,arrows,lines)

if ~session.has_arm
   warning('no arm data!');
   return;
end
s=sample;
adat = session.arm_data(trial);
w = adat.wrst(s,:,:);
f = adat.fore(s,:,:);
e = adat.elb(s,:,:);
sh = adat.sh(s,:,:);
rw = adat.rwrst(s,:,:);
re = adat.relb(s,:,:);
fe = adat.forelb(s,:,:);



if arrows
   %quiver the components
   %quiver3(w(:,1,4),w(:,2,4),w(:,3,4),w(:,1,1),w(:,2,1), w(:,3,1),'r'); hold on;
	%quiver3(w(:,1,4),w(:,2,4),w(:,3,4),w(:,1,2),w(:,2,2), w(:,3,2), 'y'); hold on;
   %quiver3(w(:,1,4),w(:,2,4),w(:,3,4),w(:,1,3),w(:,2,3), w(:,3,3), 'm'); hold on;
	%quiver3(f(:,1,4),f(:,2,4),f(:,3,4),f(:,1,1),f(:,2,1), f(:,3,1),'r--'); hold on;
	%quiver3(f(:,1,4),f(:,2,4),f(:,3,4),f(:,1,2),f(:,2,2), f(:,3,2), 'y--'); hold on;
   %quiver3(f(:,1,4),f(:,2,4),f(:,3,4),f(:,1,3),f(:,2,3), f(:,3,3), 'm--'); hold on;
   quiver3(fe(:,1,4),fe(:,2,4),fe(:,3,4),fe(:,1,1),fe(:,2,1), fe(:,3,1),'r--'); hold on;
	quiver3(fe(:,1,4),fe(:,2,4),fe(:,3,4),fe(:,1,2),fe(:,2,2), fe(:,3,2), 'y--'); hold on;
   quiver3(fe(:,1,4),fe(:,2,4),fe(:,3,4),fe(:,1,3),fe(:,2,3), fe(:,3,3), 'm--'); hold on;
   %quiver3(e(:,1,4),e(:,2,4),e(:,3,4),e(:,1,1),e(:,2,1), e(:,3,1),'r'); hold on;
	%quiver3(e(:,1,4),e(:,2,4),e(:,3,4),e(:,1,2),e(:,2,2), e(:,3,2), 'y'); hold on;
   %quiver3(e(:,1,4),e(:,2,4),e(:,3,4),e(:,1,3),e(:,2,3), e(:,3,3), 'm'); hold on;
   %quiver3(sh(:,1,4),sh(:,2,4),sh(:,3,4),sh(:,1,1),sh(:,2,1), sh(:,3,1),'r'); hold on;
	%quiver3(sh(:,1,4),sh(:,2,4),sh(:,3,4),sh(:,1,2),sh(:,2,2), sh(:,3,2), 'y'); hold on;
   %quiver3(sh(:,1,4),sh(:,2,4),sh(:,3,4),sh(:,1,3),sh(:,2,3), sh(:,3,3), 'm'); hold on;
   %quiver3(re(:,1,4),re(:,2,4),re(:,3,4),re(:,1,1),re(:,2,1), re(:,3,1),'r'); hold on;
	%quiver3(re(:,1,4),re(:,2,4),re(:,3,4),re(:,1,2),re(:,2,2), re(:,3,2), 'y'); hold on;
   %quiver3(re(:,1,4),re(:,2,4),re(:,3,4),re(:,1,3),re(:,2,3), re(:,3,3), 'm'); hold on;

end

if lines
   %draw lines
   plot3([w(:,1,4);f(:,1,4)],[w(:,2,4);f(:,2,4)],[w(:,3,4);f(:,3,4)],'ro-'); hold on;
	plot3([f(:,1,4);e(:,1,4)],[f(:,2,4);e(:,2,4)],[f(:,3,4);e(:,3,4)],'bo-'); hold on;
   plot3([e(:,1,4);sh(:,1,4)],[e(:,2,4);sh(:,2,4)],[e(:,3,4);sh(:,3,4)],'go-'); hold on;
   plot3(rw(:,1,4),rw(:,2,4),rw(:,3,4),'b+'); hold on;
   plot3(re(:,1,4),re(:,2,4),re(:,3,4),'m+'); hold on;

end
hold off;
      
   