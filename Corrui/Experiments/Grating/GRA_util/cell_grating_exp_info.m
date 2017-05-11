function Chunk_range = cell_grating_exp_info( filenames, maxNumChunks )
% CELL_GRATING_EXP_INFO specifies chunk information for grating experiment
%
% Syntax:
%   Chunk_range = cell_grating_exp_info( filenames, maxNumChunks )
% 
% Input(s):
%   filenames       - filename of RF data
%   maxNumChunks    - maximum number of chunks allowed by the program
%
% Output(s):
%   Chunk_ragne     - [begin chunk seq number, end number] for
%                     grating exp
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Fri 08/03/2012  4:18:46.588 PM
% $Revision: 0.1 $  $Date: Fri 08/03/2012  4:18:46.588 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

[ ~, fn ] =  fileparts(filenames{1});
ufn = upper( fn );
switch ufn  % only one file
    % -------
    % V1
    % -------
    % Note: filename should be in capital letters
    case 'Y11K23A'
        Chunk_range = [38, 117];
        
    case 'Y11K28B'
        Chunk_range = [41, 167];
        
    case 'Y11L13A'
        Chunk_range = [16, 127];
    
    case 'H11L22A'
        Chunk_range = [137, 297];
        
    case 'H12A04A1ST'
        Chunk_range = [35, 159];
        
    case 'H12A04A2ND'
        Chunk_range = [35, 159];
        
    case 'H12A06A'
        Chunk_range = [122, 267];
        
    case 'H12A06B'
        Chunk_range = [15, 66];
        
    case 'H12A10A1ST'
        Chunk_range = [25, 162];
        
    case 'H12A10A2ND'
        Chunk_range = [25, 162];
    
    case 'H12A11A1ST'
        Chunk_range = [22, 127];
    
    case 'H12A11A2ND'
        Chunk_range = [22, 127];
        
    case 'H12A12A1ST'
        Chunk_range = [163, 217];
        
    case 'H12A12A2ND'
        Chunk_range = [163, 217];
        
    case 'H12A13A1ST'
        Chunk_range = [86, 197];
        
    case 'H12A13A2ND'
        Chunk_range = [86, 197];
        
    case 'H12A18A'
        Chunk_range = [26, 125];
        
    case 'H12A19A'
        Chunk_range = [133, 259];
        
    case 'H12A23A1ST'
        Chunk_range = [39, 146];
        
    case 'H12A23A2ND'
        Chunk_range = [39, 146];
        
    case 'H12A30A'
        Chunk_range = [19, 141];
        
    case 'H12B02A'
        Chunk_range = [1023, 1164];
        
    case 'H12B03A1ST'
        Chunk_range = [13, 120];
        
    case 'H12B03A2ND'
        Chunk_range = [13, 120];
        
    case 'H12B15A1ST'
        Chunk_range = [28, 127];
        
    case 'H12B15A2ND'
        Chunk_range = [28, 127];
    
    case 'H12B29A'
        Chunk_range = [1, maxNumChunks];

    case 'H12C02A1ST'
        Chunk_range = [159, 242];
        
    case 'H12C02A2ND'
        Chunk_range = [159, 242];
        
    case 'H12C06A'
        Chunk_range = [123, 232];
        
    case 'H12C09A1ST'
        Chunk_range = [31, 136];
        
    case 'H12C09A2ND'
        Chunk_range = [31, 136];
        
    case 'H12C16A'
        Chunk_range = [144, 213];
        
    case 'H12C22A'
        Chunk_range = [148, 260];
        
    case 'H12C23A'
        Chunk_range = [];
        
    case 'H12C28A'
        Chunk_range = [107, 218];
        
    case 'H12D04A1ST'
        Chunk_range = [17, 131];
       
    case 'H12D04A2ND'
        Chunk_range = [17, 131];
    
    case 'H12D06A1ST'
        Chunk_range = [22, 132];
        
    case 'H12D06A2ND'
        Chunk_range = [22, 132];
    
    case 'H12D11A1ST'
        Chunk_range = [22, 127];
        
    case 'H12D11A2ND'
        Chunk_range = [22, 127];

    case 'H12D13A'
        Chunk_range = [245, 304];
        
    case 'H12D18A1ST'
        Chunk_range = [29, 144];
        
    case 'H12D18A2ND'
        Chunk_range = [29, 144];

    case 'H12D19A'
        Chunk_range = [33, 167];

    case 'H12D25A1ST'
        Chunk_range = [15, 162];
        
    case 'H12D25A2ND'
        Chunk_range = [15, 162];

    case 'H12D27A'
        Chunk_range = [196, 314];

    case 'H12E01A'
        Chunk_range = [39, 98];

    case 'H12E02A1ST'
        Chunk_range = [41, 145];
        
    case 'H12E02A2ND'
        Chunk_range = [41, 145];

    case 'H12E03A1ST'
        Chunk_range = [131, 228];
        
    case 'H12E03A2ND'
        Chunk_range = [131, 228];

    case 'H12E04A'
        Chunk_range = [28, 145];
            
    case 'H12E09A'
        Chunk_range = [39, 134];

    case 'H12E10A1ST'
        Chunk_range = [20, 198];
        
    case 'H12E10A2ND'
        Chunk_range = [20, 198];

    case 'H12E11A'
        Chunk_range = [1, maxNumChunks];

    case 'H12E16A'
        Chunk_range = [88, 184];
        
    case 'H12E18A'
        Chunk_range = [121, 157];
        
    case 'H12F20A'
        Chunk_range = [156, 259];
        
    case 'H12F28A'
        Chunk_range = [32, 232];
        
    case 'H12H20A'
        Chunk_range = [62, 158];

    otherwise
        Chunk_range = [ 1, maxNumChunks ];
        
        
end % switch

end % function MSC_data_info

% [EOF]
