function session = calc_arm(session)

% get old variables
raw_data = session.data;
trial_start = session.trial_start;
trial_end = session.trial_end;

for t = 1:length(trial_start),
	s2dat = raw_data(trial_start(t)+find(raw_data(trial_start(t)+1:trial_end(t)-1,1)==2),:);
   s3dat = raw_data(trial_start(t)+find(raw_data(trial_start(t)+1:trial_end(t)-1,1)==3),:);
   if isempty(s2dat) | isempty(s3dat)
      session.has_arm = 0;
      return;
   else
	   %convert to gl transforms
   	s2dat = pol2gl(s2dat);
   	s3dat = pol2gl(s3dat);
      % now calculate for entire trial
      adat(t) = arm_model(s3dat,s2dat);
   end
end
session.has_arm = 1;
session.arm_data = adat;