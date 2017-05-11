% read rf2file
function data = readrf2file( path, filename )
file = openrf2file( [path '\'], filename);
[eyetimes eyex1 eyey1 spiketimes] = loadchunks( file );

data.rf2_samples = [double(eyetimes)' double(eyex1)' double(eyey1)'];
data.spiketimes = spiketimes';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%									OPENRF2FILE
% 	This function opens an *.rf data file and returns the raw data as a matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function file = openrf2file( pathname, filename)


if filename == 0
    return;
end

if pathname == 0
    return;
end


file.name = filename;
file.rawdata = fread( fopen( [pathname filename] ), 'uint8=>uint8' );
filelengthinbytes = length(file.rawdata);

%is this an *.rf file???
if file.rawdata(1) ~= 255   % first byte of each chunk is 255
    error('not an *.rf file!');
end

% since we just read in the file, zero the chunk stuff
file.numchunks = 0;
lbufaddress = 1;     % pointer to infilebuffer, start at 1 in MATLAB
MAXCHUNKS = 2500; 	% from rf2files...I don't know why...seems limiting

%get the addresses and types of chunks
for current_chunks = 1:MAXCHUNKS,
    % is this really a chunk?
    if file.rawdata(lbufaddress) ~= 255   % first byte of each chunk is 255
        break;
    end
    
    %what type of chunk?
    chunklabel = setstr(double(file.rawdata(lbufaddress+1)));
    
    %how many bytes in chunk?
    uchunklength = shortfrombytes(double(file.rawdata(lbufaddress+2:lbufaddress+3)));
    % uchunklength = bitshift( double(file.rawdata(lbufaddress+3)) ,8 ) + double(file.rawdata(lbufaddress+2)); % shortfrombytes didn't work in matlab2009 - xgt may'09
    if uchunklength == 0
        break;          % error: zero length chunk
    end
    
    file.numchunks = file.numchunks + 1;
    if(file.numchunks >= MAXCHUNKS)
        file.numchunks = file.numchunks - 1;
    end
    
    file.inchunkaddr(file.numchunks) = lbufaddress;  	% address of first byte in chunk
    file.inchunktype(file.numchunks) = chunklabel;		% type of chunk
    
    lnextbufaddress = lbufaddress + uchunklength;
    lbufaddress = lnextbufaddress;  				% point next chunk
    
    if lbufaddress >= filelengthinbytes
        break;          % end of the file
    end
end

%create a list of available chunks
for c = 1:file.numchunks,
    switch char(file.inchunktype(c))
        case 'C',
            chunklabels{c} = ['COMMENT ' num2str(c)];
        case 'T',
            chunklabels{c} = ['TUNING ' num2str(c)];
        case 'S',
            chunklabels{c} = ['oldspike ' num2str(c)];
        case 'B',
            chunklabels{c} = ['DANCE ' num2str(c)];
        case 'R',
            chunklabels{c} = ['SPARSE ' num2str(c)];
        case 'P',
            chunklabels{c} = ['FIVEDOT ' num2str(c)];
        case 'M',
            chunklabels{c} = ['MARK ' num2str(c)];
        case 's',
            chunklabels{c} = ['spike ' num2str(c)];
        case 't',
            chunklabels{c} = ['SpikeAndEye ' num2str(c)];
        case 'H',
            chunklabels{c} = ['HERMANN ' num2str(c)];
        case 'D',
            chunklabels{c} = ['DIAG ' num2str(c)];
        case 'c',
            chunklabels{c} = ['CORNERS ' num2str(c)];
        case 'E',
            chunklabels{c} = ['EDGECOMP ' num2str(c)];
        case 'F',
            chunklabels{c} = ['FREEBAR ' num2str(c)];
        case 'f',
            chunklabels{c} = ['FIXSIM ' num2str(c)];
        otherwise,
            chunklabels{c} = ['?????? ' num2str(c)];
    end
end

%load the list into the chunklist object
set(findobj('Tag', 'chunklist'), 'Value', 1);
set(findobj('Tag', 'chunklist'), 'String', chunklabels);
file.chunklabels = chunklabels;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%									Load Chunks
% 	Get data from rawbuffer and return it as a  list.
%   Chunk values to parse are determined by numbered chunkrange
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [eyetimes eyex1 eyey1 spiketimes] = loadchunks( file )


    exper.rf2.lflag.CEYE 			= 10;
    exper.rf2.lflag.CNEYE 			= 2;     % 2 shorts of data
    exper.rf2.lflag.CEYE2 			= 6;         % keep compatible with doris
    exper.rf2.lflag.CSPIKEA 		= 20;
    exper.rf2.lflag.CNSPIKEA 		= 0;  % no data, just the flag
    exper.rf2.lflag.CSPIKEB 		= 21;
    exper.rf2.lflag.CNSPIKEB  		= 0;
    exper.rf2.lflag.CSTIMON 		= 30;      % room for multi stims
    exper.rf2.lflag.CNSTIMON 		= 2;  % location of stim
    exper.rf2.lflag.CSTIMON1 		= 31;
    exper.rf2.lflag.CNSTIMON1 		= 2;
    
    
eyechunks = find(file.inchunktype=='t');

total_nummilliseconds = 0;
total_numspikes = 0;
llasttime = 0;


fprintf('\n');
for i=1:length(eyechunks)
    n = eyechunks(i);
    fprintf('\r%d\\%d',n,length(eyechunks));
    
    currentchunkstart = file.inchunkaddr(n);
    nextchunkstart 	  = shortfrombytes(double(file.rawdata((currentchunkstart+2) :(currentchunkstart+3)))) + currentchunkstart;
    datastartbytes 	  = shortfrombytes(double(file.rawdata((currentchunkstart+4) :(currentchunkstart+5))));
    flaglongflag   	  = shortfrombytes(double(file.rawdata((currentchunkstart+6) :(currentchunkstart+7))));
    maxeyeres	      = shortfrombytes(double(file.rawdata((currentchunkstart+20):(currentchunkstart+21))));
    
    k = currentchunkstart+datastartbytes;
    
    for m = (currentchunkstart+datastartbytes): nextchunkstart, %this for loop counter does nothing
        ltime = longfrombytes(double(file.rawdata(k:(k+3))));
        k = k+4;
        if llasttime ~= ltime
            total_nummilliseconds = total_nummilliseconds + 1;
        end
        
        llasttime = ltime;
        
        if flaglongflag
            lflag = longfrombytes (double(file.rawdata(k:(k+3)))); k = k+4;
        else
            lflag = shortfrombytes(double(file.rawdata(k:(k+1)))); k = k+2;
        end
        
        if lflag == exper.rf2.lflag.CEYE
            k = k+4;
        elseif lflag == exper.rf2.lflag.CEYE2
            k = k+4;
        elseif lflag == exper.rf2.lflag.CSPIKEA
            total_numspikes = total_numspikes + 1;
        elseif lflag == exper.rf2.lflag.CSTIMON
            k = k+4;
        elseif lflag == exper.rf2.lflag.CSTIMON1
            k = k+4;
        end
        
        if k >= nextchunkstart
            break;
        end
    end         
end     
fprintf('\r%s','done')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       THEN PARSE DATA      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nummilliseconds = 0;
numspikes = 0;
numstimON = 0;
numstimON2 = 0;
numstimOFF = 0;
numstimOFF2 = 0;

llasttime = 0;
ltime = 0;


%allocate memory for time and eye positions
eyetimes    = uint32(zeros(1, total_nummilliseconds));
eyex1       = uint16(zeros(1, total_nummilliseconds)); 	%eyex1
eyey1       = uint16(zeros(1, total_nummilliseconds)); 	%eyey1

%allocate spike times
% spiketimes = uint32(zeros(1, total_numspikes));
spiketimes = [];

%     the_matrix_all = []; % xgt tst

for i=1:length(eyechunks)
    n = eyechunks(i);
    if ( ~mod(n,10) )
        fprintf('\r%d\\%d',n,length(eyechunks));
    end
    
    currentchunkstart   = file.inchunkaddr(n);
    nextchunkstart      = currentchunkstart + shortfrombytes(double(file.rawdata((currentchunkstart+2):(currentchunkstart+3))));
    datastartbytes      = shortfrombytes(double(file.rawdata((currentchunkstart+4) :(currentchunkstart+5))));
    flaglongflag        = shortfrombytes(double(file.rawdata((currentchunkstart+6) :(currentchunkstart+7))));
    stimtype 		    = shortfrombytes(double(file.rawdata((currentchunkstart+8) :(currentchunkstart+9))))+1;%this is readstim in rf2files
    datainfo			= shortfrombytes(double(file.rawdata((currentchunkstart+10):(currentchunkstart+11))));
    maxeyeres		    = shortfrombytes(double(file.rawdata((currentchunkstart+20):(currentchunkstart+21))));
    
    %initialize counters
    k = currentchunkstart+datastartbytes;
    
    for m = (currentchunkstart+datastartbytes): nextchunkstart, %this for loop counter does nothing
        
        ltime = longfrombytes(double(file.rawdata(k:(k+3))));
        k = k+4;
        if llasttime ~= ltime
            nummilliseconds = nummilliseconds + 1;
            eyetimes(nummilliseconds) = uint32(ltime);
        end
        
        llasttime = ltime;
        
        if flaglongflag
            lflag = longfrombytes (double(file.rawdata(k:(k+3)))); k = k+4;
        else
            lflag = shortfrombytes(double(file.rawdata(k:(k+1)))); k = k+2;
        end
        
        if lflag == exper.rf2.lflag.CEYE
            eyex = shortfrombytes(double(file.rawdata(k:(k+1)))); k = k+2;
            eyey = shortfrombytes(double(file.rawdata(k:(k+1)))); k = k+2;
            eyex1(nummilliseconds) = uint16(eyex);
            eyey1(nummilliseconds) = uint16(eyey);
        elseif lflag == exper.rf2.lflag.CEYE2
            k = k+4;
        elseif lflag == exper.rf2.lflag.CSPIKEA
            spiketimes = cat(2,spiketimes,ltime);   % RJC
        elseif lflag == exper.rf2.lflag.CSPIKEB
        elseif lflag == exper.rf2.lflag.CSTIMON
            k = k+2;
            k = k+2;
        elseif lflag == exper.rf2.lflag.CSTIMON1
            k = k+2;
            k = k+2;
        end
        
        if k >= nextchunkstart
            break;
        end
    end
end
fprintf('\r%s\n','parsing done')
    
end