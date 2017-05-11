classdef readContrastChunks < importRF2.readChunks
	% Class READCONTRASTCHUNK reads the information contained in the
	%       Contrast chunk of RF2 data file

	% Copyright 2011 Richard J. Cui. Created: 10/31/2011  3:37:49.931 PM
	% $Revision: 0.3 $  $Date: Tue Thu 01/19/2012  5:43:02.013 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties (SetAccess = protected, GetAccess = protected)
        ChunkID = bitor(hex2dec('ff'),bitshift(double('m'),8));
        ChunkType = 'Contrast';
        ChunkRange
        WholeName       % path and name of the file
    end % properties
 
    properties
        Data
        LastConChunk    % last contrast chunk
    end % properties
    
    methods 
        function this = readContrastChunks(wholename, values)
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
        getLastConChunk(this)
        varargout = parseChunk(varargin)  % parse contrast chunk
    end % methods
    
end % classdef

% [EOF]
