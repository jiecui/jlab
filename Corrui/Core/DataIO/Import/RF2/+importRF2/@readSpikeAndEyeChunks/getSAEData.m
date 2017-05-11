function getSAEData(this)
% GETSAEDATA gets Spike and Eye data
%
% Syntax:
%   getSAEData(this)
% 
% Input(s):
%   this        - readSpikeAndEyeChunks ojbect
% 
% Output(s):
%
% Example:
%
% See also .

% Copyright 2011 Richard J. Cui. Created: 10/31/2011  9:44:34.252 PM
% $Revision: 0.1 $  $Date: 10/31/2011  9:44:34.283 PM $
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
chunk_pos = this.ChunkInfo.position;
chunk_seq = this.ChunkInfo.sequence;
fid = this.fileID;

saedata = struct([]);

% select chunks
idx = chunk_seq >= this.SAEChunkRange(1) & chunk_seq <= this.SAEChunkRange(2);
pos = chunk_pos(idx);

% read chunk one by one
N = length(pos);    % number of chunks

wh = waitbar(0,sprintf('Importing spike and eye chunks. Please wait...'));
for k = 1:N
    waitbar(k/N)
    p_k = pos(k);   % kth chunk posiiton pointer
    fseek(fid,p_k,'bof');
    % get chunk length
    fseek(fid,p_k+2,'bof');     % put pointer to the length info
    chunklength = fread(fid,1,'ushort');    % current chunk length
    % get data
    datalength = chunklength-4;
    fseek(fid,p_k+4,'bof');     % put pointer to the data
    data_k = fread(fid,datalength,'uint8=>uint8');
    
    % now parse the data
    saedata_k = importRF2.parseSpikeAndEye(data_k);
    if ~isempty(saedata_k)
        saedata = cat(1,saedata,saedata_k);
    end % if
end % for
close(wh)
this.SAEData = saedata;

end % function getSAEData

% [EOF]
