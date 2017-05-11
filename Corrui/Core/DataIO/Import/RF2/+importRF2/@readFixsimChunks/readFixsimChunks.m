classdef readFixsimChunks < importRF2.readChunks
	% Class READFIXSIMCHUNKS reads the information contained in the
	%       fixsim chunk of RF2 data file

	% Copyright 2014 Richard J. Cui. Created: Wed 01/22/2014  9:38:59.570 PM
	% $Revision: 0.1 $  $Date: Wed 01/22/2014  9:38:59.570 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties (SetAccess = protected, GetAccess = protected)
        ChunkID = bitor(hex2dec('ff'),bitshift(double('f'),8));
        ChunkType = 'Fixsim';
        ChunkRange
        WholeName       % path and name of the file
    end % properties
 
    properties
        Data
    end % properties
    
    methods 
        function this = readFixsimChunks(wholename, values)
            this.WholeName = wholename;
            this.ChunkRange = values.Chunk_range;
            
            % get chunk information
            this.fileID = fopen(wholename);
            if this.fileID == -1
                error('readFixsimChunksClass:readFixsimChunks', ...
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
        varargout = parseChunk(varargin)  % parse blankctrl chunk
    end % methods
    
end % classdef

% [EOF]
