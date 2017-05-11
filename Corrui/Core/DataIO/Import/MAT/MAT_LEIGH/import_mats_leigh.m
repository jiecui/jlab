function [sessname, imported_data] = import_mats_leigh( this, directory, files, session_name)
% [sessname, imported_data] = import_mats_leigh( tag, prefix [,directory, files, session_name ])
%
% Read LAB files and import the data into matlab vars
% Imput:
%	tag :			tag of the session that is being created
%   db :            CorruiDB object
%	prefix :		prefix for the session name
%	directory :     directory of the files
%	files :			list of files to import
%	session_name :	name of the session
% Output :
%	sessname:
%	imported_data.samples(:,1)	= [timestamps, left_x, left_y, right_x, right_y, left_pupil, right_pupil];
%	imported_data.blinkYesNo	= blinkYesNo(1:end-1); (all 1's)
%	imported_data.blinks		= timestamps and data for blinks (empty)
%	imported_data.events		= timestamps and data for events (empty)
%	imported_data.saccades		= timestamps and data for saccades (empty)
%	imported_data.nsamples		= number of samples that have been imported
%	imported_data.samplerate	= sample rate of the data
%	imported_data.filenames		= names of the files that are part of the session
%	improted_data.folder		= folder where the files were.

% Copyright 2013 Richard J. Cui. Created: Mon 03/28/2011  5:59:26 PM
% $Revision: 1.7 $  $Date: Tue 09/03/2013 10:10:14.838 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

tag = class(this);
prefix = this.prefix;

SAMPLERATE		= 500;

imported_data	= [];
sessname		= [];

%% -- Get the filenames to import
if ( ~exist( 'directory', 'var' ) )
	[filenames, getpathname, sessname] = import_files_dialog( prefix, tag, 'MAT', [] );
	if ( isempty( filenames ) )
		return
	end
else
	sessname		= session_name;
    filenames		= files;
    getpathname		= directory;
end

%% -- Read the files to matlab variables
try
	% -- read data of the different files
	hwait = waitbar(0,'Please wait while LAB Files are read...');
	for j=1:length(filenames)
		fn = char(filenames(j));
		[dat(j).samples] = mat_leigh_read_file( char(fn), getpathname );
		dat(j).name = fn;
		waitbar(j/length(filenames),hwait);
	end
	close(hwait);
catch
	close(hwait);
	rethrow(lasterror);
end


%% -- sort by timestamp
for j=1:length(dat)
	if ~isempty(dat(j).samples),
		ts(j) = dat(j).samples(1,1);
	else
		ts(j) = -Inf;
	end
end
[ts,i] = sort(ts);
dat = dat(i);

%% -- fix timestamps for combining sessions
for j=1:length(dat)-1
	% find first and last timestamp
	lasttimestamp	= dat(j).samples(end,1);
	firsttimestamp	= dat(j+1).samples(1,1);
    diffe = lasttimestamp - firsttimestamp + 400000;
	% redo sample timestamps
	dat(j+1).samples(:,1) = dat(j+1).samples(:,1) + diffe;
end

%% -- combine files into one unique session
compdat = [];
compdat.samples = [];
for d=dat
	compdat= vertcatstruct( compdat, d, {'samples'} );
end
raw_samples = compdat.samples;

%% -- detect left or right component that are only noise or constant
LEFT = 1;RIGHT =1;
if ( sum(diff(compdat.samples(:,4))) == 0 || (max(compdat.samples(:,[2]))-min(compdat.samples(:,[2]))) < 0.5 || (max(compdat.samples(:,[4]))-min(compdat.samples(:,[4]))) < 0.5)
    warning([dat.name ' : ' 'Data not present for the left eye']);
    compdat.samples(:,[2 4]) = NaN;
    LEFT = 0;
end
if ( sum(diff(compdat.samples(:,5))) == 0 || (max(compdat.samples(:,[3]))-min(compdat.samples(:,[3]))) < 0.5 || (max(compdat.samples(:,[5]))-min(compdat.samples(:,[5]))) < 0.5)
    compdat.samples(:,[3 5]) = NaN;
    warning([dat.name ' : ' 'Data not present for the right eye']);
    RIGHT = 0;
end
%% -- find blinks and interpolate them in the data
if ( LEFT )
    blinks = get_coil_blinkYesNo( compdat.samples(:,2), compdat.samples(:,4), SAMPLERATE );
else
    blinks = get_coil_blinkYesNo( compdat.samples(:,3), compdat.samples(:,5), SAMPLERATE );
end
blink_starts    = find( diff([0;blinks]) >0);
blink_stops     = find( diff([blinks;0]) <0);
blinks = [compdat.samples(blink_starts,1) compdat.samples(blink_stops,1)];
[samples blinkYesNo] = interpolate_blinks(compdat.samples, blinks, 100/1000*SAMPLERATE);

%% -- commit final variables
imported_data.samples		= compdat.samples(:,[1 2 4 3 5]);
imported_data.blinks		= [];
imported_data.saccades		= [];
improted_data.events		= [];
imported_data.samplerate	= SAMPLERATE;
imported_data.blinkYesNo	= blinkYesNo;
imported_data.nsamples		= length(compdat.samples);
imported_data.mat_samples   = raw_samples;

imported_data.info.samplerate           = SAMPLERATE;
imported_data.info.import.folder        = getpathname;
imported_data.info.import.filenames     = filenames;
imported_data.info.import.date          = datestr(now);





% --------------------------------------------------------------------
function structcat = vertcatstruct(struct1,struct2,fldnames)
for fdn = fldnames
	structcat.(char(fdn)) = [struct1.(char(fdn));struct2.(char(fdn))];
end

