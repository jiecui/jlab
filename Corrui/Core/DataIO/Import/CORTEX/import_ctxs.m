function [sessname, imported_data] = import_ctxs( this, directory, files, session_name)
% [sessname, imported_data, trial_length] = import_ctxs( tag, prefix [,directory, files, session_name ])
%
% Read CTX files and import the data into matlab vars
% Imput:
%	tag :		tag of the session that is being created
%   db :            CorruiDB object
%	prefix :	prefix for the session name
%	directory :     directory of the files
%	files :		list of files to import
%	session_name :	name of the session
% Output :
%	sessname:
%	imported_data.ctx_samples(:,1)	= 
%	imported_data.samples(:,7)		= [timestamps, left_x, left_y, right_x, right_y, left_pupil, right_pupil];
%	imported_data.blinkYesNo		= blinkYesNo(1:end-1);
%	imported_data.blinks			= timestamps and data for blinks
%	imported_data.events			= timestamps and data for events
%	imported_data.saccades			= timestamps and data for saccades
%	imported_data.nsamples			= number of samples that have been imported
%	imported_data.trial_length		= lenght of the trials in the experiment
%	imported_data.samplerate		= sample rate of the data
%	imported_data.isInTrial 		= Flags for the trials, 0 if it is
%                                       outside the trial 1 if its inside. There is always at least 1 zero in
%                                       between different trials

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

BLINKS_GAP	= 100;	% samples
SAMPLERATE	= 1000;

sessname		= [];
imported_data	= [];

%% -- Get the filenames to import

if ( ~exist( 'directory', 'var' ) )
	[filenames, getpathname, sessname] = import_files_dialog( prefix, tag, 'CTX',[],[10 70 120 10]);
	if ( isempty( filenames ) )
		return
	end
else
	sessname		= session_name;
	filenames		= files;
	getpathname		= directory;
end

%% -- Import the files into matlab variables
try
	%% -- Read the files to matlab variables
	hwait = waitbar(0,'Please wait while CTX Files are read...');
	for j=1:length(filenames)
		[ dat(j).times, dat(j).events, dat(j).eog_arr, dat(j).epp_arr, dat(j).header, dat(j).trialcount ] = get_ALLdata( [getpathname '\' char(filenames(j))] );
		dat(j).name = char(filenames(j));
        
		% HR: Remove incorrect trials
        idx = find(dat(j).header(13,:) ~= 0 );
        dat(j).header(:,idx ) = [];
        dat(j).times(:,idx) = [];
        dat(j).events(:,idx) = [];
        if (~isempty(dat(j).eog_arr))
            dat(j).eog_arr(:,idx) = [];
        end
        if (~isempty(dat(j).epp_arr))
            dat(j).epp_arr(:,idx) = [];
        end        
        dat(j).trialcount = size(dat(j).header, 2);
        
        
        
		waitbar( j/length(filenames), hwait);
	end
	close(hwait);
catch
	close(hwait);
	rethrow(lasterror);
end

for j=1:length(dat)
	% build timestamps
	timestamps = [];
	x = [];
	y = [];
    isInTrial = [];
	buttons = [];
	for k=1:size(dat(j).times,2)
        
        condition = dat(j).header(1,k) + 1;
        
		timestamp_begin = dat(j).times(find(dat(j).events(:,k)==8),k);
		timestamp_end	= dat(j).times(find(dat(j).events(:,k)==17),k);
		nsamples = (timestamp_end(1)-timestamp_begin);
		if ( isempty( timestamps ) )
			timestamps = (timestamp_begin:timestamp_end-1)';
            timestamp_offset = 0;
        else
            timestamp_offset = timestamps(end) + 1000;
			timestamps = [timestamps;timestamps(end) + 1000 + (timestamp_begin:timestamp_end-1)'];            
        end
        
        %HR: Get eye data or fill with NaNs if needed
        if ~isempty(dat.eog_arr)
            x = [x;dat.eog_arr( 1:2:(nsamples*2-1), k)];
            y = [y;dat.eog_arr( 2:2:nsamples*2, k)];
            if ( nsamples >= 1)
                isInTrial = [isInTrial; 0; ones(nsamples-1,1)];
            end
        else %HR: quick and dirty
            x = [x; nan(nsamples, 1)];
            y = [y; nan(nsamples, 1)];
        end
        
        %HR: Convert timestamps for events
        %Horrible way of saving the condition, fix this
        buttons = [buttons; (dat(j).times(1,k) + timestamp_offset), condition+1000; (dat(j).times(:,k) + timestamp_offset), dat(j).events(:,k)];         
        
    end
    buttons(buttons(:,1) == 0,:) = [];
    buttons(buttons(:,2) == 0,:) = [];
	dat(j).samples		= nan(length(x),7);
	dat(j).samples(:,1) = timestamps;
	dat(j).samples(:,2) = x;
	dat(j).samples(:,4) = y;
	dat(j).buttons		= buttons;
	dat(j).isInTrial    = isInTrial;
end

%% -- fix timestamps 
for j=1:length(dat)-1
	% find first and last timestamp
	lasttimestamp	= max( [dat(j).samples(end,1) dat(j).buttons(end,1)] );
	firsttimestamp	= min( [dat(j+1).samples(1,1) dat(j+1).buttons(1,1)] );
	% 	diff = lasttimestamp - firsttimestamp + 100; % small gap
	diff = lasttimestamp - firsttimestamp + 400000; % small gap to match time at breaks - xgt oct 23, 2006
	% redo sample timestamps
	dat(j+1).samples(:,1) = dat(j+1).samples(:,1) + diff;
	% redo blinks
	dat(j+1).blinks(:,1:2) = dat(j+1).blinks(:,1:2) + diff;
	% redo buttons
	dat(j+1).buttons(:,1) = dat(j+1).buttons(:,1) + diff;
	% saccades
	dat(j+1).saccades(:,1:2) = dat(j+1).saccades(:,1:2) + diff;
end


%% -- concatenate different data files
compdat = [];
compdat.samples = [];
compdat.buttons = [];
compdat.blinks = [];
compdat.saccades = []; 
compdat.isInTrial = [];
dat = rmfield(dat, 'eog_arr');
for d=dat
	compdat= vertcatstruct(compdat,d,{'samples' 'buttons' 'isInTrial'});
end
clear d

%% -- Pre-process eye data --------------------------------------
% 
% % -- Interpolate blinks in the data
% [samples blinkYesNo] = interpolate_blinks(compdat.samples, compdat.blinks, BLINKS_GAP);
blinkYesNo = get_coil_blinkYesNo( compdat.samples(:,2), compdat.samples(:,4) );


samples = compdat.samples;

% -- Convert to DVA ( Degrees of the Visual Angle )
% dva = HREF2dva(samples);
dva = NaN(size(samples(1:end-1,2:5)));
dva(:,[1 3]) = (samples(1:end-1,[2 3])*40)/4096;
dva(:,[2 4]) = (samples(1:end-1,[4 5])*30)/4096;

%% samples [LH RH LV RV]
%% imported_data.samples [LH LV RH RV]



%% -- commit final variables
imported_data.ctx_samples	= compdat.samples;
imported_data.samples(:,1)	= samples(1:end-1, 1);
imported_data.samples(:,2:5)= dva;
imported_data.samples(:,6:7)= samples(1:end-1, 6:7);

imported_data.blinkYesNo	= zeros(size(imported_data.samples(:,1)));
imported_data.blinks		= [];
imported_data.events		= compdat.buttons;
imported_data.saccades		= [];

imported_data.isInTrial     = compdat.isInTrial(1:end-1);

imported_data.nsamples		= length(dva);
imported_data.samplerate	= SAMPLERATE;

imported_data.filenames = filenames;
imported_data.folder    = getpathname;
imported_data.msg		= '';

imported_data.info.samplerate           = SAMPLERATE;
imported_data.info.import.folder        = getpathname;
imported_data.info.import.filenames     = filenames;
imported_data.info.import.date          = datestr(now);


% --------------------------------------------------------------------
function structcat = vertcatstruct(struct1,struct2,fldnames)
for fdn = fldnames
    structcat.(char(fdn)) = [struct1.(char(fdn));struct2.(char(fdn))];
end
