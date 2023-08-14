classdef readDiagChunks < importRF2.readChunks
	% Class IMPORTRF2.READDIAGCHUNKS read Diag chunk
    %       reads the information contained in the Diag/Star chunk of RF2
    %       data file

	% Copyright 2013 Richard J. Cui. Created: Mon 06/03/2013 12:48:24.558 PM
	% $Revision: 0.1 $  $Date: Mon 06/03/2013 12:48:24.558 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties (SetAccess = protected, GetAccess = protected)
        ChunkID = bitor(hex2dec('ff'),bitshift(double('D'),8));     % ID of Diag chunk
        ChunkType = 'Diag/Star';
        ChunkRange
        WholeName       % path and name of the file
    end % properties
 
    properties
        Data
    end % properties
    
    methods 
        function this = readDiagChunks(wholename, values)
            this.WholeName = wholename;
            this.ChunkRange = values.Chunk_range;
            
            % get chunk information
            this.fileID = fopen(wholename);
            this.getChunkInfo_gate;
            
            if this.ChunkInfo.ChunkFound
                % set chunk range
                if isempty(this.ChunkRange)
                    startchunk = this.ChunkInfo.sequence(1);
                    endchunk = this.ChunkInfo.sequence(end);
                    this.ChunkRange = [startchunk, endchunk];
                end % if
                
                % read data
                this.Data = this.getChunkData;
            end % if
        end
    end % methods
    
    methods
        varargout = parseChunk(varargin)  % parse contrast chunk
    end % methods
    
end % classdef

% [EOF]
