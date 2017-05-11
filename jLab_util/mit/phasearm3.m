function phasearm3(session,trials, forder, filename)
figure
trialstring = trials;
eval(sprintf('trials = [%s];',trials));
trials = trials(find((trials<=length(session.trial_start) & (trials>=1))));
for t=trials
	prosup = session.arm_data(t).eelbow(:,3);
	elb = session.arm_data(t).eelbow(:,2);
	trunkerr = session.trialstats(t).trunk_spatial_error.data;
   if nargin==3
      prosup=sav_golay(prosup,11,2,forder);
      elb=sav_golay(elb,11,2,forder);
      trunkerr=trunkerr;
      % clip first and last samples
      lc=5;
      len=length(prosup);
      prosup=prosup(lc+1:len-lc);
      elb=elb(lc+1:len-lc);
		trunkerr=trunkerr(lc+1:len-lc);
   end
   [minerr, mi] = min(trunkerr);
   len = length(trunkerr);
   plot3(prosup(1:mi),elb(1:mi),trunkerr(1:mi)); hold on
   plot3(prosup(mi:len),elb(mi:len),trunkerr(mi:len),'g:'); hold on
end

box on
if nargin==3
   switch forder
   case 1
      xlabel('pro-sup velocity')
		ylabel('elbow flexion velocity')
      zlabel('trunk-error velocity')
   case 2
		xlabel('pro-sup acceleration')
		ylabel('elbow flexion acceleration')
      zlabel('trunk-error acceleration')
   otherwise      
      xlabel('pronation-supination')
		ylabel('elbow flexion')
      zlabel('trunk-corrected spatial error')
   end
else
   xlabel('pronation-supination')
	ylabel('elbow flexion')
   zlabel('trunk-corrected spatial error')
end
if nargin<4
   filename = '';
   title(sprintf('Arm Phase Plot, Trial(s): %s',trialstring));
else
   title(sprintf('Arm Phase Plot, File: %s, Trial(s): %d',filename,trialstring));
end

rotate3d
hold off
