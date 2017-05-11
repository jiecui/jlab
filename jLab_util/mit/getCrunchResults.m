function [mean, std] = getCrunchResults(crunchStruct, subject, normal, conditions, measure, slices, plotnorm)
% extracts a 2-D array of means and std's corresponding to one patient (or group), one normals slice (LComb, RComb, etc.)
% one measure, and some list of conditions (MailAbd, 70ReachSide, etc.). Since all data in crunchStruct is static,
% these arguments are numbers or arrays of numbers that correspond to the named rows and columns in the struct. The
% GUI will make the mapping from the names to the indices. NB: Assumes only ONE measure!

% first step is to select the subject of interest.
subj = crunchStruct.subjects(subject);
subjavg = squeeze(subj.data.avg(conditions,measure,slices));
subjstd = squeeze(subj.data.std(conditions,measure,slices));

% check if squeeze may have taken out one too many indices
if length(conditions)==1
   subjavg = subjavg';
   subjstd = subjstd';
end

if plotnorm
	% then get the normal data
	norm = crunchStruct.subjects(1);
	normavg = norm.data.avg(conditions,measure,normal);
	normstd = norm.data.std(conditions,measure,normal);

	% concat, and GUI will put labels on the rows and columns
	mean = [subjavg normavg];
   std = [subjstd normstd];
else
   mean = subjavg;
   std = subjstd;
end
