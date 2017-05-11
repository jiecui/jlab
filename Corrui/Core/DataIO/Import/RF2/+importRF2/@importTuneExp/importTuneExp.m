classdef importTuneExp < handle
	% Class IMPORTTUNEEXP imports the data from orientation tune experiment

	% Copyright 2011-12 Richard J. Cui. Created: Thu 08/02/2012  4:21:50.097 PM
	% $Revision: 0.1 $  $Date: Thu 08/02/2012  4:21:50.097 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
        % Tune data
        TuneChunkData       % Tune chunk raw data
    end % properties
    
    properties (SetAccess = protected)
        
    end % properties
 
    methods 
        function this = importTuneExp(filepath, filename, values)
            % ----------------
            % load into MatLab
            % ----------------
            wholename = [filepath, filesep, filename];      % can handle one file now
            
            % import Tune chunk
            % ----------------------
            tunedata = importRF2.readTuneChunks(wholename, values);
            tunedata.showChunkInfo;
            this.TuneChunkData = tunedata;
            tunedata.getBeforeAfterChunk;
        end
    end % methods
end % classdef

% [EOF]
