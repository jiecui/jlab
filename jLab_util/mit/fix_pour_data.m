function[session] = fix_pour_data(session)
% fix_pour_data fills in sensor 4 readings for trial
% and associates trial and teacher start locations in the data matrix to them
dat = session.data;
ii = session.trial_start;
iif = session.trial_end;
ti = session.tch_start;
tif = session.tch_end;
% go through each session and get the trial name
% if it is one we know, AND if sensor 4 is missing, then fix it
% fix it by making a matrix of the right number of samples with "ones" * correct row
% and inserting this into data. As well, add the number of rows to the current
% trial's iif, and subsequent ii's and iif's and subsequent teacher's ti and tif's
nl =  [4  -2    44.500  13.800   3.500 ...
      		    -0.964  -0.108  -0.244 ...
          		 -0.136   0.986   0.099  ...
           		  0.230   0.129  -0.965];

nr = [4  -2    44.500 -14.500   3.500 ...
          -0.242  -0.970  -0.035 ...   
          -0.961   0.245  -0.131 ...    
           0.136   0.001  -0.991];

nc = [4 -2     44.500  -0.400   3.500 ...
          -0.004  -0.995  -0.097 ...
          -0.990   0.017  -0.141 ...
           0.142   0.096  -0.985];

fl = [4  -2    35.000  21.864   3.500 ...
          -0.981  -0.038  -0.192 ...
          -0.075   0.979   0.190 ...
           0.181   0.201  -0.963];

fr = [4  -2    35.000 -22.987   3.500  ...
 			  0.099  -0.992   0.075 ...
   		 -0.993  -0.103  -0.061 ...
          0.068  -0.069  -0.995];
    
fc = [4  -2    35.000  -0.566   3.500 ...
 		    -0.146  -0.985  -0.096 ...
          -0.977   0.159  -0.140 ...
           0.153   0.073  -0.985];

for t=1:length(session.scene_names)
   known = 1;
   switch session.scene_names{t},
   case {'RWTpourLnrL.VR','RWTpourRnrL.VR'}
      cond = nl;
   case {'RWTpourLnrR.VR','RWTpourRnrR.VR'}
      cond = nr;
   case {'RWTpourLnrctr.VR','RWTpourRnrctr.VR'}
      cond = nc;
   case {'RWTpourLfarL.VR','RWTpourRfarL.VR'}
      cond = fl;
   case {'RWTpourLfarR.VR','RWTpourRfarR.VR'}
      cond = fr;
   case {'RWTpourLfarctr.VR','RWTpourRfarctr.VR'}
      cond = fc;      
   otherwise
      cond = fc;
   end;
   
   if known>0,
   	tbegin = ii(t);
   	tend = iif(t);
      tdat = dat(tbegin+find(dat(tbegin+1:tend-1,1)==4),:);
      % just in case there are extra columns in the data
      if size(tdat,2) > size(cond,2),
          condfill = zeros(1,size(tdat,2) - size(cond,2));
          cond = [cond condfill];
      end
      if(size(tdat,1)==0),
         b = session.trial_in_block(t);
         nrows = size(dat(tbegin+find(dat(tbegin+1:tend-1,1)==1),:),1);
         filldat = ones(nrows,1)*cond;
         % to figure out where s4 should begin, we need to know how many intervening sensors are present
         active_sens = 1;
         for othersens=2:3
	         if size(dat(tbegin+find(dat(tbegin+1:tend-1,1)==othersens),:),1)
               active_sens = active_sens + 1;
            end
         end
         s4begin = tbegin+(active_sens*nrows);
         % need the new insertion point, for new data
         dat = [dat(1:s4begin,:);filldat;dat(s4begin+1:size(dat,1),:)];
         % update the ii
         for j=t+1:length(ii),
            ii(j) = ii(j)+nrows;
         end;
         % update the iif
         for j=t:length(iif),
            iif(j) = iif(j)+nrows;
         end;
         % update tch_start and tch_end
         for j=b+1:length(ti),
            ti(j) = ti(j)+nrows;
            tif(j) = tif(j)+nrows;
         end;
      end;
   end;
end;
session.data = dat;
session.trial_start = ii;
session.trial_end = iif;
session.tch_start = ti;
session.tch_end = tif;      