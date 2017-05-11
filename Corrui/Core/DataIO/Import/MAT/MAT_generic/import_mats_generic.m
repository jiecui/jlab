function [sessname, imported_data] = import_mats_generic( this, directory, files, session_name)
% [sessname, imported_data] = import_mats_generic( tag, prefix [,directory, files, session_name ])
%
% Read MAT files coming from RF2 and import the data into matlab vars
% Imput:
%	tag :		tag of the session that is being created
%   db :            CorruiDB object
%	prefix :	prefix for the session name
%	directory :     directory of the files
%	files :		list of files to import
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
	hwait = waitbar(0,'Please wait while MAT Files are read...');
	for j=1:length(filenames)
		fn = char(filenames(j));
		load( [getpathname '\' char(fn) ]);
		
		if ( ~exist('l') || isempty('l') )
			timestamps = r.t;
        elseif ( ~exist('r') || isempty('r') )
			timestamps = l.t;
        else
			timestamps = l.t;
		end
		dat(j).samples = nan(length(timestamps), 7);
		
		if ( exist('l') && ~isempty('l') )
			dat(j).samples(:,1) = l.t;
			dat(j).samples(:,2) = l.x;
			dat(j).samples(:,4) = l.y;
		end
		if ( exist('r') && ~isempty('r') )
			dat(j).samples(:,1) = r.t;
			dat(j).samples(:,3) = r.x;
			dat(j).samples(:,5) = r.y;
		end
		if ( exist('isInTrial') && ~isempty('isInTrial') )
			dat(j).isInTrial = isInTrial';
		end
		
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
if ( ~isfield(dat, 'isInTrial'))
    dat.isInTrial = ones(length(dat.samples),1);
end

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
compdat.isInTrial = [];
clear l;
for d=dat
	compdat= vertcatstruct( compdat, d, {'samples' 'isInTrial'} );
end


% xgt tst for importing RF2
if(~isfield(compdat,'isInTrial'))
    compdat.isInTrial = ones(size(compdat.samples,1),1);    
end
% end of xgt tst for importing RF2

SAMPLERATE = 1000;
%% -- find blinks and interpolate them in the data
% blinkYesNo = get_coil_blinkYesNo( compdat.samples(:,3), compdat.samples(:,5), SAMPLERATE );
if ( 0 )
blinkYesNo = get_coil_blinkYesNo( compdat.samples(:,3), compdat.samples(:,5));
else
    blinkYesNo = zeros(size(compdat.samples(:,3)));
end
% d = diff([blinks;0]);
% blink_starts    = find( d >0);
% blink_stops     = find( diff([blinks;0]) >0);
% blinks = [compdat.samples(blink_starts,1) compdat.samples(blink_stops,1)];
% [samples blinkYesNo] = interpolate_blinks(compdat.samples, blinks, 200/1000*SAMPLERATE);
samples = compdat.samples;

%% -- commit final variables
imported_data.samples		= samples(:,[1 2 4 3 5 6 7]);
% imported_data.blinks		= blinks;
imported_data.saccades		= rf2_findsaccades(samples);
improted_data.events		= [];
imported_data.samplerate	= round(1000/ mean(samples(2:end,1)-samples(1:end-1,1)) );
imported_data.blinkYesNo	= blinkYesNo;
imported_data.nsamples		= length(compdat.samples);

imported_data.isInTrial = compdat.isInTrial;

imported_data.info.samplerate           = SAMPLERATE;
imported_data.info.import.folder        = getpathname;
imported_data.info.import.filenames     = filenames;
imported_data.info.import.date          = datestr(now);


% --------------------------------------------------------------------
function structcat = vertcatstruct(struct1,struct2,fldnames)
for fdn = fldnames
	if ( isfield(struct1,fdn) && isfield(struct2,fdn))
		structcat.(char(fdn)) = [struct1.(char(fdn));struct2.(char(fdn))];
	end
end

function blinks = rf2_findblinks(samples)
	blinks = [];
	byn = (samples(:,3)<-19 | samples(:,2)<-19);
	byn(1) = 0;
	byn(end) = 0;
	bstarts = samples(find(diff(byn)>0),1);
	bends = samples(find(diff(byn)<0),1);
	
	blinks = zeros(length(bstarts),3);
	blinks(:,1) = bstarts;
	blinks(:,2) = bends;
	blinks(:,3) = 2;
	
function saccades = rf2_findsaccades(samples)
	saccades = [];
	
	
	
	