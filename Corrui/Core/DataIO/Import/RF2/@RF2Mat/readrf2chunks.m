function readrf2chunks(RM,path_file_name)
% READRF2 reads raw chunks in RF file format and convert it into a Matlab
%       file structure
% 
% Input(s):
%   RM              - object of RF2Mat class
%   filename        - the path and name of the RF file
% 
% Output(s):
%   set RM properties - structure containing data read from RF file
%                     .filename   : file name of RF file
%                     .filelength : RF file size (Bytes)
%                     .num_chunks : number of chunks imported
%                     .chunks     : imported chunk structure
%                                   .position: begin position of the chunk in
%                                              RF binary files
%                                   .type:     chunk types
%                                   .length:   chunk length (Bytes)
%                                   .data:     data in chunk (uint8)
% 
% 
% Reference:
%   [1] openrf2fiel.m
%   [2] RF file structure.doc
% 
% See also parseSpikeAndEye.

% Copyright 2009-2010 Richard J. Cui. Created: 12/03/2009 11:02:47.551 AM
% $Revision: 0.6 $  $Date: 03/09/2010  9:18:39.310 AM $
% 
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
% 
% Email: jie@neurocorrleate.com

% =========================================================================
% parameters
% =========================================================================
[filepath,name,ext] = fileparts(path_file_name);
filename = [name,ext];

MAXCHUNKS = 2500; 	% from rf2files...I don't know why...seems limiting (Xoana)
numchunks = 0;      % number of chunks

% =========================================================================
% 1st scanning - check the fidelity of the file
% =========================================================================
% fid = fopen(filename);  % open file for reading only
fid = fopen(path_file_name);
if fid == -1
    error('Cannot open file %s.',filename)
end%if

% get file length
fseek(fid,0,'eof');
filelength = ftell(fid);

% reset the pointer
frewind(fid);           % Move file position indicator to beginning
chunkpos = ftell(fid);  % current chunk pointer position
pointerlist = [];       % list of chunk pointers
while chunkpos < filelength
    % check chunk head
    chunkhead = fread(fid,1,'uint8=>uint8');
    if chunkhead ~= 255
        error('Reading chunk error: Test of chunk head failed!')
    end%if
    % count chunk number
    pointerlist = cat(1,pointerlist,chunkpos);
    numchunks = numchunks+1;
    % get chunk length
    fseek(fid,1,'cof');     % put pointer to the length info
    chunklength = fread(fid,1,'ushort');    % current chunk length
    % set the pointer to the next chunk
    chunkpos = chunkpos+chunklength;
    fseek(fid,chunkpos,'bof');
end%while
fclose(fid);            % close RF2 file

% check
if chunkpos ~= filelength
    error('Reading file error.')
end%if

if numchunks > MAXCHUNKS
    error('Too many chunks in RF (illegal file). ')
end%if

if RM.ChunkRange(2) > numchunks
    RM.ChunkRange(2) = numchunks;
end % if

% =========================================================================
% 2nd scanning - imported the chunks
% =========================================================================
chunkrange = RM.ChunkRange;
chunk = struct('position',0,'type',[],'length',0,'data',0);
nChunkOfInt = diff(chunkrange)+1;   % number of chunks of interest
chunks = repmat(chunk,nChunkOfInt,1);

fid = fopen(path_file_name);    % open file for reading only
if fid == -1
    error('Cannot open file %s.',filename)
end%if

chunk_beg = chunkrange(1);
chunk_end = chunkrange(2);

wh = waitbar(0,sprintf('Importing session %s. Please wait...',name));
for k = chunk_beg:chunk_end
    ptr = k-chunk_beg+1;
    waitbar(ptr/nChunkOfInt)
    p_k = pointerlist(k);
    fseek(fid,p_k,'bof');
    % chunk position
    chunk.position = p_k+1;
    % chunk type/label
    fseek(fid,p_k+1,'bof');     % set pointer to the type
    chunktype = fread(fid,1,'uchar');
    type = convlabel(chunktype);
    chunk.type = type;
    % get chunk length
    fseek(fid,p_k+2,'bof');     % put pointer to the length info
    chunklength = fread(fid,1,'ushort');    % current chunk length
    chunk.length = chunklength;
    % get data
    datalength = chunklength-4;
    fseek(fid,p_k+4,'bof');     % put pointer to the data
    data = fread(fid,datalength,'uint8=>uint8');
    chunk.data = data;
    % output
    chunks(ptr) = chunk;
end%for
close(wh)
fclose(fid);

% output
RM.FileName     = filename;
RM.FilePath     = [filepath,'\'];
RM.FileLength   = filelength;
RM.numChunk     = numchunks;
RM.nChunkOfInt  = nChunkOfInt;
RM.chunks       = chunks;

end%function

% =========================================================================
% sub-rountings
% =========================================================================
function chunklabel = convlabel(chunktype)
% convert chunk type to chunk label
% 
% adapted from openrf2fie.m

switch chunktype
    case 'C',
        chunklabel = 'COMMENT';
    case 'T',
        chunklabel = 'TUNING';
    case 'S',
        chunklabel = 'oldspike';
    case 'B',
        chunklabel = 'DANCE';
    case 'R',
        chunklabel = 'SPARSE';
    case 'P',
        chunklabel = 'FIVEDOT';
    case 'M',
        chunklabel = 'MARK';
    case 's',
        chunklabel = 'spike';
    case 't',
        chunklabel = 'SpikeAndEye';
    case 'H',
        chunklabel = 'HERMANN';
    case 'D',
        chunklabel = 'DIAG';
    case 'c',
        chunklabel = 'CORNERS';
    case 'E',
        chunklabel = 'EDGECOMP';
    case 'F',
        chunklabel = 'FREEBAR';
    case 'f',
        chunklabel = 'FIXSIM';
    otherwise,
        chunklabel = 'unknown';
end

end%function


% [EOF]