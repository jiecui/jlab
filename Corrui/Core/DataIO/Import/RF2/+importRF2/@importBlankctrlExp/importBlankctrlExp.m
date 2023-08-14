classdef importBlankctrlExp < handle
	% Class IMPORTBLANKCTRLEXP imports the data from blank control
	%       experiment

	% Copyright 2012 Richard J. Cui. Created: Thu 08/09/2012  5:19:24.499 PM
	% $Revision: 0.1 $  $Date: Thu 08/09/2012  5:19:24.499 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
        % Blankctrl exp data
        SAEChunkData        % Spike and Eye chunk raw data
        BctChunkData        % blank control raw data
    end % properties
    
    % contrast experiment parameters
    properties
        HorAngle = 40;      % horizonal visual angle span
        VerAngle = 30;      % vertical visual angle span
        samplerate = 1000;  % sampling rate (Hz)
        timestamps          % machine time stamps of every sample points
        samples             % eye positions in deg
        spiketimes          % spike times
        blinkYesNo          % blink logical
    end % properties
    
    properties (SetAccess = protected)
        
    end % properties
 
    methods 
        function this = importBlankctrlExp(filepath, filename, values)
            % ----------------
            % load into MatLab
            % ----------------
            wholename = [filepath, filesep, filename];      % single file now
            
            % ===== import Spike and Eye (time-stamp) chunks =====
            seadata = importRF2.readSpikeAndEyeChunks(wholename, values);
            seadata.showChunkInfo;
            this.SAEChunkData = seadata;
            % extract spike and eye data for analysis stage
            data_extracted = importRF2.extractSAEdata(this);
            this.timestamps = data_extracted.timestamps;
            this.samples = data_extracted.samples;
            this.spiketimes = data_extracted.spiketimes;
            this.blinkYesNo = data_extracted.blinkYesNo;

            % ===== import Blankctrl chunk =====
            bctdata = importRF2.readBlankctrlChunks(wholename, values);
            bctdata.showChunkInfo;
            this.BctChunkData = bctdata;
            bctdata.getLastBctChunk;
           
        end
    end % methods
end % classdef

% [EOF]
