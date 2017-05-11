function crunch = writeBancroftAnalyzeIt(crunch, subjnumbers, prestring, laststring, filename)

% get pre and last cubes (conditions,measures,subjects,prelast)
% templatelabels should be input

eval(sprintf('subjs = [%s];',subjnumbers));
% check bounds
subjs = subjs(find((subjs<=length(crunch.subjects) & (subjs>=1))));
preavg = [];
prestd = [];
lastavg = [];
laststd = [];
restavg = [];
desiredslices = 6; % # of original time slices in fully run subject, not including Pre and Last
normalslice = 1; % hardcode session 22 "all w.o EB"
templatelabels = {'Pre1' 'Pre2' 'Post16a' 'Post16b' 'Post32a' 'Post32b'};
for s=subjs
   % get data for "Pre", use strmatch
   subj=crunch.subjects(s);
   
   
   match = find(strcmp(prestring, subj.slice_labels));
   if ~isempty(match)
      preslice = match(1);
      preavg = cat(3,preavg,subj.data.avg(:,:,preslice));
      prestd = cat(3,prestd,subj.data.std(:,:,preslice));
   else
      warning(sprintf('Not all subjects have session named %s! Exiting...',prestring));
      return;
   end
   
   % some patients are "aggregate" so the first slice can be 3d
   firstslice = 1;
   matchlast = find(strcmp(laststring, subj.slice_labels));
   if ~isempty(match) & ~isempty(matchlast)
      if match==1 & matchlast==2
         firstslice = 3;
      end
   end
   
   % length(slice_names)-1 because we know
   lastslice = length(subj.slice_labels);
   lastispre = strcmp(prestring, subj.slice_labels{lastslice-1});
   if lastispre
      lastslice = lastslice - 1;
   end
   match = find(strcmp(laststring, subj.slice_labels));
   if ~isempty(match)
      lastslice = match;
   end
   lastavg = cat(3,lastavg,subj.data.avg(:,:,lastslice));
   laststd = cat(3,laststd,subj.data.std(:,:,lastslice));

   % hack to handle before I rework this code
   if lastslice==2
      lastslice = length(subj.slice_labels);
   end
   
   % for the rest, what to do
   % OK, have Pre and Last, but each subject is going to have their own setup, but monotone
   % increasing
   restset = setdiff([1:length(subj.slice_labels)],[preslice lastslice]);
   restlabels = subj.slice_labels(restset); % not used?
   [labeldiffs,missingindices] = setdiff(templatelabels, restlabels);
   presentindices = setdiff([1:length(templatelabels)],missingindices);
   subjrestavg = subj.data.avg(:,:,restset); 
   subjreststd = subj.data.std(:,:,restset); 
   
   missingslices = desiredslices - length(restset);
   if ~isempty(missingindices)
      % then we have to pad restavg with NaN's, assuming correct # of conditions and measures for current subj.
      % BUT might be missing intermediate slices, so we have to have the template...
      subjrestavg(:,:,presentindices) = subjrestavg; %???
      subjrestavg(:,:,missingindices) = ones([size(subjrestavg(:,:,1)) length(missingindices)])*NaN;
      subjreststd(:,:,presentindices) = subjreststd; %???
      subjreststd(:,:,missingindices) = ones([size(subjreststd(:,:,1)) length(missingindices)])*NaN;
      %subjrestavg = cat(3,subjrestavg,pad);
      %subjreststd = cat(3,subjreststd,pad);
   end 
   restavg = cat(4,restavg,subjrestavg);
   reststd = cat(4,reststd,subjreststd);

end
prelast = cat(4,preavg,lastavg);
prelaststd = cat(4,prestd,laststd);

% must permute the last 2 dims
restavg = permute(restavg,[1 2 4 3]);
reststd = permute(reststd,[1 2 4 3]);

prelast = cat(4,prelast,restavg);
prelaststd = cat(4,prelaststd,reststd);

% now what about Normals --
norm = crunch.subjects(1).data.avg(:,:,normalslice);
normdata = [];
for i=1:size(prelast,4)
   normdata = cat(4,normdata, norm);
end
prelast=cat(3,prelast,normdata);

% now for std
norm = crunch.subjects(1).data.std(:,:,normalslice);
normdata = [];
for i=1:size(prelaststd,4)
   normdata = cat(4,normdata, norm);
end
prelaststd=cat(3,prelaststd,normdata);


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
   timelabel = [timelabel {'Pre' 'Last2' 'Pre1' 'Pre2' 'Post16aRx' 'Post16bRx' 'Post32aRx' 'Post32bRx'}];
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
   fprintf(fid,'%s Means \n\n',char(crunch.conditions(i)));
   %   write ",<meas_1>,,<meas_2>,,...
   fprintf(fid,'%s\n',char(measurelabel));
   %   write out "Subject_ID
   fprintf(fid,'Subject ID');
   %   write table with rownames = patientnames, colnames = "Pre,Last,"*#measures
   tblappend(condi,char(timelabel),char([crunch.subject_names(subjs) {'Normals'}]),fid,',');
	%   write few blank lines
   fprintf(fid,'\n\n\n\n');
   
   % do the same for std's
   condi=prelaststd(i,:,:,:);
   %   squeeze and permute it so have 2 x measures x subjects
   condi=squeeze(condi);
   condi=permute(condi,[3 1 2]);
   %   reshape and transpose so have subjects x 2*measures
   condi = reshape(condi,size(condi,1)*size(condi,2),size(condi,3));
   condi = condi';
   %   write condition name for dataset
   fprintf(fid,'%s Standard Deviations\n\n',char(crunch.conditions(i)));
   %   write ",<meas_1>,,<meas_2>,,...
   fprintf(fid,'%s\n',char(measurelabel));
   %   write out "Subject_ID
   fprintf(fid,'Subject ID');
   %   write table with rownames = patientnames, colnames = "Pre,Last,"*#measures
   tblappend(condi,char(timelabel),char([crunch.subject_names(subjs) {'Normals'}]),fid,',');
	%   write few blank lines
   fprintf(fid,'\n\n\n\n');

end

fclose(fid);