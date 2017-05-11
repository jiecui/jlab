function[score_struct] = rescore_data(data, blocks, trial_block, trial_string)
% this will prompt for the score file and then go through a specified (in a little edit box)
% number of trials and rescore them. All required info about the teachers and trials should be
% in the blocks struct

% load data file, parse
[filename,pathname] = uigetfile('*.sdf','Open Score Preference File');

if (pathname == 0),
   % 'cancel' condition
   return
else
   % want to always come back to the last directory
   cd(pathname);
   filename = lower(filename);

   % I BELIEVE the following is not needed!
   undscr = findstr(filename,'_');
   if undscr>1,
      fname = filename;
      for i=1:length(undscr),
         name = sprintf('%s\\%s', fname(1:undscr(i)+i-2), fname(undscr(i)+(i-1):length(fname)));
         fname = name;
      end;
      clear(fname);
   else
      name = filename;
   end;
   
   % now really read the file!
   fp = fopen(filename);
   line = fgets(fp); % skip header
   % process line 2
   line = fgets(fp);
   scr = sscanf(line, '%d')';
   score.transform = scr(1);
   score.correlation = scr(2);
   score.clipRange = scr(3);
   score.alignChoice = scr(4);
   score.subSample = scr(5);
   score.mean0 = scr(6);
   score.mean1 = scr(7);
   score.mean2 = scr(8);
   score.mean3 = scr(9);
   score.mean4 = scr(10);
   %process line 3
   line = fgets(fp);
   scr = sscanf(line, '%f')';
   score.shape = scr(1);
   score.smoothness = scr(2);
   score.speed = scr(3);
   score.velocityPeaks = scr(4);
   score.outliers = scr(5);
   score.duration = scr(6);
   score.inStart = scr(7);
   score.inEnd = scr(8);
   score.outStart = scr(9);
   score.outEnd = scr(10);
   score.power = scr(11); 
   score.senWt1 = scr(12);
   score.senWt2 = scr(13);
   score.senWt3 = scr(14); 
   score.WRpos = scr(15);
   score.WRvel = scr(16);
   score.WTpos = scr(17); 
   score.WTvel = scr(18);
   % process line 4
   line = fgets(fp);
   scr = sscanf(line, '%f')';
   score.sigma0 = scr(1); 
   sigma1 = scr(2);
   score.sigma2 = scr(3); 
   score.sigma3 = scr(4); 
   score.sigma4 = scr(5); 
   score.wgauss0 = scr(6); 
   score.wgauss1 = scr(7); 
   score.wgauss2 = scr(8);
   score.wgauss3 = scr(9); 
   score.wgauss4 = scr(10);
   % process line 5
   line = fgets(fp);
   scr = sscanf(line, '%f')';
   score.lower = scr(1);
   score.adapt = scr(2);
   score.num = scr(3);
end;
score_struct = score;

% great!! now we can try to rescore!
if ~isempty(trial_string),
      eval(sprintf('trials = [%s];',trial_string));
      trials = trials(find((trials<=num) & (trials>=1)));
      % Using iif which is the indices in data where the trials end
      for t=trials
         % we know which block each trial is "from" via the trial_block array
         
         for s=sensors
            dat{s} = data(ii(t)+find(data(ii(t)+1:iif(t)-1,1)==s),:);
         end;
