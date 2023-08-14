classdef readTuneChunks < importRF2.readChunks
	% Class READTUNECHUNK reads the information contained in the
	%       Tune chunk of RF2 data file

	% Copyright 2012-2014 Richard J. Cui. Created: Tue 05/22/2012  1:38:34.466 PM
	% $Revision: 0.2 $  $Date: Tue 04/29/2014  4:10:32.462 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties (SetAccess = protected, GetAccess = protected)
        ChunkID = bitor(hex2dec('ff'),bitshift(double('T'),8));
        ChunkType = 'Tune';
        ChunkRange
        WholeName       % path and name of the file
    end % properties
 
    properties
        Data
        BeforeExpTuneChunk      % tuning before the experiment
        AfterExpTuneChunk       % tuning after the experiment
    end % properties
    
    methods 
        function this = readTuneChunks(wholename, values)
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
            else
                disp('No Tune chunks found')
            end % if
        end
    end % methods
    
    methods
        getBeforeAfterChunk(this)
        varargout = parseChunk(varargin)  % parse contrast chunk
    end % methods
    
end % classdef

% [EOF]
