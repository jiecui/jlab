classdef readGratChunks < importRF2.readChunks
	% Class READGRATCHUNK reads the information contained in the
	%       Grating chunk of RF2 data file

	% Copyright 2012 Richard J. Cui. Created: Thu 05/24/2012 10:21:05.226 AM
	% $Revision: 0.1 $  $Date: Thu 05/24/2012 10:21:05.226 AM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties (SetAccess = protected, GetAccess = protected)
        ChunkID = bitor(hex2dec('ff'),bitshift(double('g'),8));
        ChunkType = 'Grating';
        ChunkRange
        WholeName       % path and name of the file
    end % properties
 
    properties
        Data
        LastGratChunk   % last grating chunk during grating testing
    end % properties
    
    methods 
        function this = readGratChunks(wholename, values)
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
        getLastGratChunk(this)
        varargout = parseChunk(varargin)  % parse contrast chunk
    end % methods
    
end % classdef

% [EOF]
