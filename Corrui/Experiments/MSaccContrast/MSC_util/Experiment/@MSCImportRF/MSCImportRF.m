classdef MSCImportRF < handle
    % Class MSCIMPORTRF imports RF2 data from microsaccade contrast experiment
    %
    % Note: single session / block
    
    % Copyright 2014 Richard J. Cui. Created: 10/31/2011  4:00:24.495 PM
    % $Revision: 0.5 $  $Date: Sat 03/15/2014  5:05:42.078 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com
    
    properties
        % MS-Contrast exp data
        SAEChunkData        % Spike and Eye chunk raw data
        ConChunkData        % Contrast chunk raw data
        
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
    end % properties
    
    properties (SetAccess = protected)
        
    end % properties
    
    methods
        function this = MSCImportRF(filepath, filename, values)
            % ----------------
            % load into MatLab
            % ----------------
            wholename = [filepath, filesep, filename];    % single file only
            
            % import data of microsaccade-contrast exp data
            % --------------------------------------------
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
            
            % ===== import Contrast chunk =====
            condata = importRF2.readContrastChunks(wholename, values);
            condata.showChunkInfo;
            this.ConChunkData = condata;
            condata.getLastConChunk;

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
