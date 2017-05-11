classdef readCornersChunks < importRF2.readChunks
	% Class IMPORTRF2.READCONTRASTCHUNK reads the information contained in
	%       the Corner chunk of RF2 data file

	% Copyright 2013 Richard J. Cui. Created: Sat 05/25/2013  5:10:09.306 PM
	% $Revision: 0.1 $  $Date: Sat 05/25/2013  5:10:09.306 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties (SetAccess = protected, GetAccess = protected)
        ChunkID = bitor(hex2dec('ff'),bitshift(double('c'),8));     % ID of Corners chunk
        ChunkType = 'Corners';
        ChunkRange
        WholeName       % path and name of the file
    end % properties
 
    properties
        Data
        % LastCorChunk    % last Corners chunk in ChunkRange
    end % properties
    
    methods 
        function this = readCornersChunks(wholename, values)
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
        % getLastCorChunk(this)
        varargout = parseChunk(varargin)  % parse contrast chunk
    end % methods
    
end % classdef

% [EOF]
