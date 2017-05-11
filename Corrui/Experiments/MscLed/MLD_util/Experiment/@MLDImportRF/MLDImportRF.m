classdef MLDImportRF < handle
	% Class MLDIMPORTRF imports the data from MSC LED experiment

	% Copyright 2013-2014 Richard J. Cui. Created: Tue 09/03/2013 11:14:20.891 AM
	% $Revision: 0.2 $  $Date: Tue 07/01/2014  4:15:40.650 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
        % Mscled exp data
        SAEChunkData        % Spike and Eye chunk raw data
        BctChunkData        % blank control chunk raw data
        
        % Tune data
        TuneChunkData       % Tune chunk raw data                
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
        ImportPara          % imported parameters of the experiment
    end % properties
    
    properties (SetAccess = protected)
        
    end % properties
 
    methods 
        function this = MLDImportRF(filepath, filename, values)
            % -----------
            % check paras
            % -----------
            if isfield(values, 'Hor_ver_deg')
                hvd = values.Hor_ver_deg;
                this.HorAngle = hvd(1);
                this.VerAngle = hvd(2);
            end % if
            
            this.ImportPara = values;
            
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
           
            % ===== import Tuning chunk =====
            tune_value.Chunk_range = values.Tune_range;
            tunedata = importRF2.readTuneChunks(wholename, tune_value);
            tunedata.showChunkInfo;
            this.TuneChunkData = tunedata;
            tunedata.getBeforeAfterChunk;
                        
        end
    end % methods
end % classdef

% [EOF]
