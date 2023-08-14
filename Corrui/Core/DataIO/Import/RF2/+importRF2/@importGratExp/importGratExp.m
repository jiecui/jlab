classdef importGratExp < handle
    % Class IMPORTGRATEXP imports the data from microsaccade contrast
    %       experiment
    
    % Copyright 2011-12 Richard J. Cui. Created: Fri 08/03/2012  4:54:38.002 PM
    % $Revision: 0.1 $  $Date: Fri 08/03/2012  4:54:38.002 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com
    
    properties
        % Grating data
        SAEChunkData
        GratChunkData       % Grating chunk raw data
    end % properties
    
    % grating experiment parameters
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
        function this = importGratExp(filepath, filename, values)
            % ----------------
            % load into MatLab
            % ----------------
            wholename = [filepath, filesep, filename];    % single file now
            
            % ===== import Spike and Eye (time-stamp) chunks =====
            seadata = importRF2.readSpikeAndEyeChunks( wholename, values);
            seadata.showChunkInfo;
            this.SAEChunkData = seadata;
            % extract spike and eye data for analysis stage
            data_extracted = importRF2.extractSAEdata(this);
            this.timestamps = data_extracted.timestamps;
            this.samples = data_extracted.samples;
            this.spiketimes = data_extracted.spiketimes;
            this.blinkYesNo = data_extracted.blinkYesNo;
            
            % ===== import Grat chunk =====
            gratdata = importRF2.readGratChunks(wholename, values);
            gratdata.showChunkInfo;
            this.GratChunkData = gratdata;
            gratdata.getLastGratChunk;
            
        end
    end % methods
end % classdef

% [EOF]
