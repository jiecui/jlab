classdef readSpikeAndEyeChunks < importRF2.readChunks
	% Class READSPIKEANDEYECHUNK reads the information contained in the
	%       Spike And Eye chunk of RF2 data file

	% Copyright 2011 Richard J. Cui. Created: 10/31/2011  3:37:49.931 PM
	% $Revision: 0.1 $  $Date: 10/31/2011  3:37:49.931 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties (SetAccess = protected, GetAccess = protected)
        ChunkID = bitor(hex2dec('ff'),bitshift(double('t'),8));
        ChunkType = 'Spike and Eye';
        ChunkRange      % [begin, end] sequence
        WholeName       % path and name of the file
    end % properties
 
    properties
        Data            % stucture of SAE data
    end % properties
    
    methods 
        function this = readSpikeAndEyeChunks(wholename, values)
            this.WholeName = wholename;
            this.ChunkRange = values.Chunk_range;
            
            % get chunk infomation
            this.fileID = fopen(wholename);
            if this.fileID == -1
                error('readSpikeAndEyeChunksClass:readSpikeAndEyeChunks', ...
                    'Cannot open file %s.', wholename)
            end % if
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
        getSAEData(this)
        varargout = parseChunk(varargin)
    end % methods
    
end % classdef

% [EOF]
