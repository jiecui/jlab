classdef readBlankctrlChunks < importRF2.readChunks
	% Class READBLANKCTRLCHUNKS reads the information contained in the
	%       blank ctrol chunk of RF2 data file

	% Copyright 2012 Richard J. Cui. Created: Thu 08/09/2012  6:08:29.558 PM
	% $Revision: 0.1 $  $Date:Thu 08/09/2012  6:08:29.558 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties (SetAccess = protected, GetAccess = protected)
        ChunkID = bitor(hex2dec('ff'),bitshift(double('b'),8));
        ChunkType = 'Blankctrl';
        ChunkRange
        WholeName       % path and name of the file
    end % properties
 
    properties
        Data
        LastBctChunk   % last blankctrl chunk during blank control testing
    end % properties
    
    methods 
        function this = readBlankctrlChunks(wholename, values)
            this.WholeName = wholename;
            this.ChunkRange = values.Chunk_range;
            
            % get chunk information
            this.fileID = fopen(wholename);
            if this.fileID == -1
                error('readBlankctrlChunksClass:readBlankctrlChunks', ...
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
        getLastBctChunk(this)
        varargout = parseChunk(varargin)  % parse blankctrl chunk
    end % methods
    
end % classdef

% [EOF]
