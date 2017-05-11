function compdat = read_labs( filenames, pathname )
dat = [];
if ischar(filenames)
	filenames = {filenames};
end
% -- read data of the different files
hwait = waitbar(0,'Please wait while LAB Files are read...');
for j=1:length(filenames)
	fn = char(filenames(j));
	[dat(j).samples] = lab_read_file( char(fn), pathname );
	dat(j).name = fn;
	waitbar(j/length(filenames),hwait);
end
close(hwait);

combdata = combine_data( dat );

% -- sort by timestamp
for j=1:length(dat)
	if ~isempty(dat(j).samples),
		ts(j) = dat(j).samples(1,1);
	else
		ts(j) = -Inf;
	end
end
[ts,i] = sort(ts);
dat = dat(i);

% -- fix timestamps
for j=1:length(dat)-1
	% find first and last timestamp
	lasttimestamp	= dat(j).samples(end,1);
	firsttimestamp	= dat(j+1).samples(1,1);
% 	diff = lasttimestamp - firsttimestamp + 100; % small gap
    diff = lasttimestamp - firsttimestamp + 400000; % small gap to match time at breaks - xgt oct 23, 2006
	% redo sample timestamps
	dat(j+1).samples(:,1) = dat(j+1).samples(:,1) + diff;
end

compdat = [];
compdat.samples = [];
for d=dat
	compdat= vertcatstruct(compdat,d,{'samples'});
end
