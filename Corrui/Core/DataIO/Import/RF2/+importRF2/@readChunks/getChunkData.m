function chunk_data = getChunkData(this)
% GETCHUNKDATA gets the data from the specified chunks
%
% Syntax:
%   getSAEData(this)
% 
% Input(s):
%   this        - readChunks ojbect
% 
% Output(s):
%   chunk_data  - data from the chunks
% 
% Example:
%
% See also .

% Copyright 2011 Richard J. Cui. Created: 11/01/2011  2:30:25.885 PM
% $Revision: 0.2 $  $Date: Thu 11/24/2011  4:31:08.311 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% ===================
% main
% ===================
chunk_data = struct([]);
pos = this.ChunkInfo.position;
% read chunk one by one
N = length(pos);    % number of chunks

wh = waitbar(0,sprintf('Importing %s chunks. Please wait...',this.ChunkType));
for k = 1:N
    waitbar(k/N)
    p_k = pos(k);   % kth chunk posiiton pointer
    
    % now parse the data
    % chunkdata_k = this.parseChunk(data_k,p_k);
    chunkdata_k = this.parseChunk( p_k );
    if ~isempty(chunkdata_k)
        chunk_data = cat(1,chunk_data,chunkdata_k);
    end % if
end % for
close(wh)

end % function getSAEData

% [EOF]
