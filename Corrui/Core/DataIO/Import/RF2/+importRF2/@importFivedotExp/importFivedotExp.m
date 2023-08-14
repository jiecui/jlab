classdef importContrastExp < handle
	% Class IMPORTCONTRASTEXP imports the data from microsaccade contrast
	%       experiment

	% Copyright 2011-12 Richard J. Cui. Created: 10/31/2011  4:00:24.495 PM
	% $Revision: 0.3 $  $Date: Thu 08/02/2012  1:02:42.422 PM $
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
        
        % Grating data
        % GratSAEChunkData
        GratChunkData       % Grating chunk raw data
    end % properties
    
    % contrast experiment parameters
    properties
        HorAngle = 40;      % horizonal visual angle span
        VerAngle = 30;      % vertical visual angle span
        samplerate = 1000;  % sampling rate (Hz)
    end % properties
    
    properties (SetAccess = protected)
        
    end % properties
 
    methods 
        function this = importContrastExp(filepath, filename, values)
            % ----------------
            % load into MatLab
            % ----------------
            wholename = [filepath, '\', filename{1}];    % single file now
            
            % import data of microssacde-contrast exp data
            % --------------------------------------------
            if values.Import_ContrastExp_data == true
                % ===== import Spike and Eye (time-stamp) chunks =====
                seadata = importRF2.readSpikeAndEyeChunks(wholename, values);
                seadata.showChunkInfo;
                this.SAEChunkData = seadata;
                
                % ===== import Contrast chunk =====
                condata = importRF2.readContrastChunks(wholename, values);
                condata.showChunkInfo;
                this.ConChunkData = condata;
                condata.getLastConChunk;
                
            else
                this.SAEChunkData = [];
                this.ConChunkData = [];
            end % if

            % import Tune chunk
            % ----------------------
            if values.Import_Tuning_data == true
                tunedata = importRF2.readTuneChunks(wholename, values);
                tunedata.showChunkInfo;
                this.TuneChunkData = tunedata;
                tunedata.getBeforeAfterChunk;
            else
                this.TuneChunkData = [];
            end % if
            
            % import Grat chunk
            % -------------------
            if values.Import_Grating_data == true
                gratdata = importRF2.readGratChunks(wholename, values);
                gratdata.showChunkInfo;
                this.GratChunkData = gratdata;
                gratdata.getLastGratChunk;
            else
                this.GratChunkData = [];
            end % if

        end
    end % methods
end % classdef

% [EOF]
