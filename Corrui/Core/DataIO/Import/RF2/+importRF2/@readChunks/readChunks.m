classdef readChunks < handle
	% Class READCHUNK converts RF data into Matlab MAT data

	% Copyright 2011 Richard J. Cui. Created: 10/31/2011  5:36:51.468 PM
	% $Revision: 0.3 $  $Date: Sun 11/27/2011  4:00:43.818 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties (Abstract = true, SetAccess = protected, GetAccess = protected)
        ChunkID         % decides chunk type
        ChunkType       % string of chunk type
        ChunkRange      % range of sequence of chunks to be used
    end % properties
 
    properties (SetAccess = protected, GetAccess = protected)
        fileID          % ID of the data file
        
    end % properties
    
    properties
        ChunkInfo       % see getChunkInfo()
    end % properties
    
    % ==========================
    % constructor
    % ==========================
    methods 
        function this = readChunks()
            
        end
    end % methods
    
    % ==========================
    % other
    % ==========================
    methods (Abstract)
        
        varargout = parseChunk(varargin)    % parse a single specified chunk
        
    end % abstract methods
    
    
    methods
        function getChunkInfo_gate(this)
            chunkid = this.ChunkID;
            fid = this.fileID;
            chunk_range = this.ChunkRange;
            this.ChunkInfo = importRF2.getChunkInfo( fid, chunkid, chunk_range );
        end
        
        chunk_data = getChunkData(this)
        showChunkInfo( this )
        
    end % methods
    
 
end % classdef

% [EOF]
