function [sessname, imported_data] = import_rf_others( tag, prefix, getpathname, filenames, sessname)
% IMPORT_RF imports RF2 files

% Copyright 2013 Richard J. Cui. Created: Mon 03/28/2011  5:59:26 PM
% $Revision: 0.2 $  $Date: Sat 04/27/2013 10:42:54.381 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% sessname		= sessname;
imported_data	= [];

% -- Get the filenames to import from the dialog
if ( ~exist( 'getpathname', 'var' ) )
    S=[];
    % [filenames, getpathname, sessname, S] = import_files_dialog( prefix, tag, 'RF', S );
    [filenames, getpathname, sessname] = import_files_dialog( prefix, tag, 'RF', S );
    if ( isempty( filenames ) )
        return
    end
end

%% -- Import the files into matlab variables
try
    %% -- Read the files to matlab variables
    hwait = waitbar(0,'Please wait while RF2 Files are read...');
    if (~iscell(filenames) )
        filenames = {filenames};
    end
    for j=1:length(filenames)
        dat(j) = readrf2file( getpathname, filenames{j} );
        waitbar( j/length(filenames), hwait);
    end
    close(hwait);
catch ex
    close(hwait);
    rethrow(ex);
end

%% -- fix timestamps for concatenated files
% so one timestamps is always higher than the previous one
for j=1:length(dat)-1
    
    % find first and last timestamp
    if ( ~isempty(dat(j).spiketimes) )
        lasttimestamp	= max( [dat(j).rf2_samples(end,1) dat(j).spiketimes(end) ] );  
        firsttimestamp = min( [dat(j+1).rf2_samples(1,1) dat(j+1).spiketimes(1)] );
    else
        lasttimestamp	= max( dat(j).rf2_samples(end,1) );
        firsttimestamp	= min( dat(j+1).rf2_samples(1,1) );
    end
    % 	diff = lasttimestamp - firsttimestamp + 100; % small gap
    diffe = lasttimestamp -  firsttimestamp + 400000; % small gap to match time at breaks - xgt oct 23, 2006
    

    % redo sample timestamps
    dat(j+1).rf2_samples(:,1) = dat(j+1).rf2_samples(:,1) + diffe;
    % redo buttons
    if ( ~isempty(dat(j+1).spiketimes))
        dat(j+1).spiketimes(:) = dat(j+1).spiketimes(:) + double(diffe);
    end
end



%% -- concatenate files
% first calculate how much space we need
fldnames = {'rf2_samples' 'spiketimes'};
for fdn = fldnames
    size.(char(fdn)) = 0;
    START = 1;
    for i = 1:length(dat)
        if ~isempty(dat(i).(char(fdn)))
            size.(char(fdn)) = length(dat(i).(char(fdn))(:,1)) + size.(char(fdn));
            start.(char(fdn))(i) = START;
            stop.(char(fdn))(i) = START + length(dat(i).(char(fdn))(:,1))-1;
            START = START + length(dat(i).(char(fdn))(:,1));
        else
            size.(char(fdn)) = 0;
        end
    end
end
imported_data.rf2_samples = zeros(size.rf2_samples,3);
imported_data.spiketimes = zeros(size.spiketimes,1);
for i=1:length(dat);
    for fdn = fldnames
        if ~isempty(dat(1).(char(fdn)))
            imported_data.(char(fdn))(start.(char(fdn))(i):stop.(char(fdn))(i),:) =  dat(1).(char(fdn));
        else
            imported_data.(char(fdn)) =  [];
        end
    end
    dat(1) = [];
end


%% -- Convert to DVA ( Degrees of the Visual Angle )
imported_data.samples = imported_data.rf2_samples;
imported_data.samples(:,2) = imported_data.rf2_samples(:,2)/4096*40-20;
imported_data.samples(:,3) = imported_data.rf2_samples(:,3)/4096*40-15;
imported_data.samples(:,4) = imported_data.rf2_samples(:,2)/4096*40-20;
imported_data.samples(:,5) = imported_data.rf2_samples(:,3)/4096*40-15;

% -- Interpolate blinks in the data
imported_data.blinkYesNo = get_coil_blinkYesNo( imported_data.samples(:,2), imported_data.samples(:,4) );


%% -- commit final variables
imported_data.samplerate = 1000/round(median(diff(imported_data.rf2_samples(:,1))));
imported_data.info.samplerate           = imported_data.samplerate;
imported_data.info.import.folder        = getpathname;
imported_data.info.import.filenames     = filenames;
imported_data.info.import.date          = datestr(now);

function blinkYesNo  = get_coil_blinkYesNo(x,y)

% function [blinkYesNo blinkYesNo1]  = get_coil_blinkYesNo(x,y)

smooth_param1 = 31;
% smooth_param2 = 31;
v_thres = 3/1000;
blinkGap = 50;

diff_x = diff([x(1); x]);
diff_y = diff([y(1); y]);

diff_x = newboxcar(diff_x, smooth_param1);
diff_y = newboxcar(diff_y, smooth_param1);
v = sqrt(diff_x.^2 + diff_y.^2);

v = v > v_thres;

blinkYesNo1 = newboxcar(double(v),200);
blinkYesNo2 = blinkYesNo1 > 0.7; %?


loidx	= max( find( diff(blinkYesNo2) > 0 ) - blinkGap , 1);
hiidx	= min( find( diff(blinkYesNo2) < 0 ) + blinkGap, length(blinkYesNo2));


% if there is nan at the end add the last low
if ( blinkYesNo2(end) == 1 )
	hiidx(end+1) = length(blinkYesNo2);
end
% if there is nan at the begining add the first hi
if ( blinkYesNo2(1) == 1 )
	loidx = [1;loidx];
end

blinkYesNo = zeros(length(blinkYesNo2),1);
blinkYesNo(lohi2idx(loidx,hiidx)) = 1;