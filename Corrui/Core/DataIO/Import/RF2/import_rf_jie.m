function [sessname, imported_data] = import_rf_jie( tag, pathname, filename, sessname, options)
% IMPORT_RF imports RF2 files

% Copyright 2013 Richard J. Cui. Created: Mon 03/28/2011  5:59:26 PM
% $Revision: 0.4 $  $Date: Sat 04/27/2013 10:42:54.381 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% sessname		= [];
imported_data	= [];

% % -- Get the filenames to import from the dialog
wholename = [pathname, filesep ,filename];

% create RF file object
stimtype = options.Stim_type;
chunkrange = options.Chunk_range;
excldrange = options.Excluded_chunk_range;
preset_cor_point = options.Preset_cor_point;
option.saveRF2Mat = options.Save_RF2_mat_file;
option.loadRF2Mat = options.Load_RF2_mat_file;

% create RF file object
% filename,stimtype,chunkrange,option,excldrange
rfdata = RF2Mat(wholename,stimtype,chunkrange,option,excldrange);

%% -- Import the files into matlab variables
% concatenate time, eye positions and spiketimes
ep = rfdata.EyePos;     % eye positions
n_seg = length(ep);     % num of continuous segments

timestamp = [];
x1 = [];
y1 = [];

for k = 1:n_seg
    timestamp = cat(1,timestamp,ep(k).time);
    x1 = cat(1,x1,ep(k).eye_x);
    y1 = cat(1,y1,ep(k).eye_y);
end % for
% don't care 2nd eye now
x2 = zeros(size(x1));
y2 = zeros(size(y1));

rf2_samples = [double(timestamp),double(x1),double(y1),x2,y2];

% -- Convert to DVA ( Degrees of the Visual Angle ) and centralize
horangle = rfdata.ParaDisp.HorAngle;
verangle = rfdata.ParaDisp.VerAngle;
imported_data.rf2_samples = rf2_samples;
imported_data.samples = rf2_samples;
imported_data.samples(:,2) = imported_data.rf2_samples(:,2)/60-horangle/2;
imported_data.samples(:,3) = imported_data.rf2_samples(:,3)/60-verangle/2;
imported_data.samples(:,4) = imported_data.rf2_samples(:,2)/60-horangle/2;
imported_data.samples(:,5) = imported_data.rf2_samples(:,3)/60-verangle/2;
imported_data.spiketimes   = rfdata.SpikeTime;


%% -- Interpolate blinks in the data
imported_data.blinkYesNo = get_coil_blinkYesNo( imported_data.samples(:,2), imported_data.samples(:,4) );


%% -- commit final variables
imported_data.samplerate                = rfdata.Fs;
imported_data.info.samplerate           = imported_data.samplerate;
imported_data.info.import.folder        = pathname;
imported_data.info.import.filenames     = filename;
imported_data.info.import.date          = datestr(now);

% (1) ABS commit
if strcmpi(tag,'AlternatingBrightnessStar')
    rfdata.renderStim;
    imported_data.Stimulus                  = rfdata.Stimulus;
    imported_data.EstFix                    = rfdata.EstFix;
    imported_data.FixCorner                 = rfdata.FixCorner;
    imported_data.ParaDisp                  = rfdata.ParaDisp;
    imported_data.FixGrid                   = rfdata.FixGrid;
    imported_data.EyePos                    = rfdata.EyePos;
    imported_data.StimTime                  = rfdata.StimTime;
    imported_data.PresetCorPoint            = preset_cor_point;
end % if

% -------------------
% subroutines
% -------------------
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