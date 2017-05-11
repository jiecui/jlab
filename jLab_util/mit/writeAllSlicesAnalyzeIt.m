function writeAllSlicesAnalyzeIt(crunch, subjnumbers, prestring, filename)

% get pre and last cubes (conditions,measures,subjects,prelast)

eval(sprintf('subjs = [%s];',subjnumbers));
% check bounds
subjs = subjs(find((subjs<=length(crunch.subjects) & (subjs>=1))));
preavg = [];
prestd = [];
lastavg = [];
laststd = [];
restavg = [];
for s=subjs
   % get data for "Pre", use strmatch
   subj=crunch.subjects(s);
   match = find(strcmp(prestring, subj.slice_labels));
   if ~isempty(match)
      preavg = cat(3,preavg,subj.data.avg(:,:,match(1)));
   else
      warning(sprintf('Not all subjects have session named %s! Exiting...',prestring));
      return;
   end
   % length(slice_names)-1 because we know
   lastslice = length(subj.slice_labels);
   lastispre = strcmp(prestring, subj.slice_labels{lastslice});
   if lastispre
      lastslice = lastslice - 1;
   end
   lastavg = cat(3,lastavg,subj.data.avg(:,:,lastslice));
   % for the rest, what to do
   % OK, have Pre and Last, but each subject is going to have their own setup, but monotone
   % increasing
   subjrestavg = subj.data.avg(:,:,1:lastslice); 
   if lastslice < 6
      % then we have to pad restavg with NaN's
      missingslices = 6-lastslice;
      pad = ones([size(restavg(:,:,1)) missingslices])*NaN;
      subjrestavg = cat(3,subjrestavg,pad);
   end 
   restavg = cat(4,restavg,subjrestavg);
end
prelast = cat(4,preavg,lastavg);
% must permute the last 2 dims
restavg = permute(restavg,[1 2 4 3]);
prelast = cat(4,prelast,restavg);
% open file
fid = fopen(filename,'w');

if fid == -1
   disp('Unable to open file.');
   return
end

% pre-cache strings used over and over
measurelabel = ',';
firstmeas = 1;
for meas=crunch.measures
   if firstmeas
      measurelabel = strcat(measurelabel,meas);
      firstmeas = 0;
   else
	   measurelabel = strcat(measurelabel,',,,,,,,,',meas);
   end
end
timelabel = [];
for i=1:length(crunch.measures)
   timelabel = [timelabel {'Pre' 'Last' 'Pre1' 'Pre2' 'Post10Rx' 'Post20aRx' 'Post20bRx' 'Post30Rx'}];
end
   
% for each condition get 1 x measures x subjects slice x 2(prelast)
for i=1:size(prelast,1)
   condi=prelast(i,:,:,:);
   %   squeeze and permute it so have 2 x measures x subjects
   condi=squeeze(condi);
   condi=permute(condi,[3 1 2]);
   %   reshape and transpose so have subjects x 2*measures
   condi = reshape(condi,size(condi,1)*size(condi,2),size(condi,3));
   condi = condi';
   %   write condition name for dataset
   fprintf(fid,'%s Data\n\n',char(crunch.conditions(i)));
   %   write ",<meas_1>,,<meas_2>,,...
   fprintf(fid,'%s\n',char(measurelabel));
   %   write out "Subject_ID
   fprintf(fid,'Subject ID');
   %   write table with rownames = patientnames, colnames = "Pre,Last,"*#measures
   tblappend(condi,char(timelabel),char(crunch.subject_names(subjs)),fid,',');
	%   write few blank lines
   fprintf(fid,'\n\n\n\n');
end

fclose(fid);