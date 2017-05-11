function Chunk_range = cell_tune_exp_info( filenames, maxNumChunks )
% CELL_TUNE_EXP_INFO specifies chunk information for an orientation tuning experiment
%
% Syntax:
%   Chunk_range = cell_tune_exp_info( filenames, maxNumChunks )
% 
% Input(s):
%   filenames       - filename of RF data
%   maxNumChunks    - maximum number of chunks allowed by the program
%
% Output(s):
%   Chunk_ragne     - [begin chunk seq number, end number] for
%                     orientation tuning exp
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: Thu 08/02/2012  4:21:50.097 PM
% $Revision: 0.2 $  $Date: Thu 07/04/2013  3:14:15.590 PM $
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
    
    % +++++++++++++++
    % Monkey Jayne
    % +++++++++++++++
    case 'CORS042700J2'
        Chunk_range = [313, 576];
    
    case 'CORS042800J2'
        Chunk_range = [211, 1326];
        
    case 'CORS051000J3'
        Chunk_range = [101, 581];

    case 'CORS051600J1'
        Chunk_range = [602, 1459];
    
    case 'CORS051800J1'
        Chunk_range = [655, 1335];
    
    case 'CORS052600J1'
        Chunk_range = [298, 1296];

    case 'CORS060600J1'
        Chunk_range = [330, 1006];

    case 'CORS060700J1'
        Chunk_range = [363, 1034];
    
    case 'CORS062700J1'
        Chunk_range = [427, 1119];
        
    case 'STAR062700J1'
        Chunk_range = [209, 427];
        
    case 'EDGE063000J1'
        Chunk_range = [1109, 1605];
        
    case 'STAR063000J1'
        Chunk_range = [187, 679];
        
    case 'CORS063000J1'
        Chunk_range = [679, 1107];
        
    case 'EDGE070300J1'
        Chunk_range = [274, 761];

    case 'STAR070300J1'
        Chunk_range = [761, 1119];

    case 'EDGE070300J2'
        Chunk_range = [246, 1233];

    case 'EDGE070500J2'
        Chunk_range = [247, 504];

    case 'STAR070500J2'
        Chunk_range = [504, 948];

    case 'EDGE070600J1'
        Chunk_range = [267, 702];
        
    case 'EDGE070600J2'
        Chunk_range = [220, 665];

    case 'STAR071000J4'
        Chunk_range = [443, 847];

    case 'EDGE071000J4'
        Chunk_range = [847, 1438];

    case 'CORS071000J4'
        Chunk_range = [1438, 1895];

    case 'STAR071200J1'
        Chunk_range = [384, 889];
        
    case 'STAR071400J1'
        Chunk_range = [269, 801];
        
    case 'STAR071400J3'
        Chunk_range = [247, 928];
        
    case 'STAR071700J2'
        Chunk_range = [478, 1184];
        
    case 'STAR071800J1'
        Chunk_range = [218, 820];

    case 'EDGE071800J1'
        Chunk_range = [820, 2230];

    case 'CORS071800J1'
        Chunk_range = [820, 2230];

    case 'STAR072100J1'
        Chunk_range = [159, 889];

    case 'STAR07240J1B'
        Chunk_range = [1, 477];

    % +++++++++++++
    % Monkey Yoda
    % +++++++++++++
    case 'Y11K23A'
        Chunk_range = [21, 1609];
        
    case 'Y11K28B'
        Chunk_range = [2, 6];
        
    case 'Y11L13A'
        Chunk_range = [12, 1636];
    
    % +++++++++++++++
    % Monkey Hellboy
    % +++++++++++++++
    case 'H11L22A'
        Chunk_range = [24, 1243];
        
    case 'H12A04A1ST'
        Chunk_range = [33, 993];
        
    case 'H12A04A2ND'
        Chunk_range = [993, 1891];
        
    case 'H12A06A'
        Chunk_range = [13, 1444];
        
    case 'H12A06B'
        Chunk_range = [2, 1748];
        
    case 'H12A10A1ST'
        Chunk_range = [22, 1148];
        
    case 'H12A10A2ND'
        Chunk_range = [1148, 2333];
    
    case 'H12A11A1ST'
        Chunk_range = [12, 975];
    
    case 'H12A11A2ND'
        Chunk_range = [975, 1807];
        
    case 'H12A12A1ST'
        Chunk_range = [21, 996];
        
    case 'H12A12A2ND'
        Chunk_range = [996, 1771];
        
    case 'H12A13A1ST'
        Chunk_range = [18, 1083];
        
    case 'H12A13A2ND'
        Chunk_range = [1083, 1857];
        
    case 'H12A18A'
        Chunk_range = [23, 1146];
        
    case 'H12A19A'
        Chunk_range = [130, 1794];
        
    case 'H12A23A1ST'
        Chunk_range = [26, 978];
        
    case 'H12A23A2ND'
        Chunk_range = [978, 2476];
        
    case 'H12A30A'
        Chunk_range = [14, 1596];
        
    case 'H12B02A'
        Chunk_range = [1, 121];
        
    case 'H12B03A1ST'
        Chunk_range = [8, 889];
        
    case 'H12B03A2ND'
        Chunk_range = [889, 1645];
        
    case 'H12B15A1ST'
        Chunk_range = [23, 899];
        
    case 'H12B15A2ND'
        Chunk_range = [899, 1751];
    
    case 'H12B29A'
        Chunk_range = [1, maxNumChunks];

    case 'H12C02A1ST'
        Chunk_range = [24, 1380];
        
    case 'H12C02A2ND'
        Chunk_range = [1380, 2471];
        
    case 'H12C06A'
        Chunk_range = [14, 1005];
        
    case 'H12C09A1ST'
        Chunk_range = [23, 970];
        
    case 'H12C09A2ND'
        Chunk_range = [970, 1728];
        
    case 'H12C16A'
        Chunk_range = [31, 985];
        
    case 'H12C22A'
        Chunk_range = [31, 1019];
        
    case 'H12C23A'
        Chunk_range = [];
        
    case 'H12C28A'
        Chunk_range = [12, 1028];
        
    case 'H12D04A1ST'
        Chunk_range = [15, 891];
       
    case 'H12D04A2ND'
        Chunk_range = [891, 1642];
    
    case 'H12D06A1ST'
        Chunk_range = [20, 889];
        
    case 'H12D06A2ND'
        Chunk_range = [889, 1643];
    
    case 'H12D11A1ST'
        Chunk_range = [20, 910];
        
    case 'H12D11A2ND'
        Chunk_range = [910, 1664];

    case 'H12D13A'
        Chunk_range = [26, 1374];
        
    case 'H12D18A1ST'
        Chunk_range = [27, 904];
        
    case 'H12D18A2ND'
        Chunk_range = [904, 1657];

    case 'H12D19A'
        Chunk_range = [27, 916];

    case 'H12D25A1ST'
        Chunk_range = [10, 930];
        
    case 'H12D25A2ND'
        Chunk_range = [930, 1712];

    case 'H12D27A'
        Chunk_range = [192, 1124];

    case 'H12E01A'
        Chunk_range = [23, 1008];

    case 'H12E02A1ST'
        Chunk_range = [27, 903];
        
    case 'H12E02A2ND'
        Chunk_range = [903, 1657];

    case 'H12E03A1ST'
        Chunk_range = [250, 993];
        
    case 'H12E03A2ND'
        Chunk_range = [993, 1749];

    case 'H12E04A'
        Chunk_range = [24, 903];
            
    case 'H12E09A'
        Chunk_range = [34, 887];

    case 'H12E10A1ST'
        Chunk_range = [18, 951];
        
    case 'H12E10A2ND'
        Chunk_range = [951, 1706];

    case 'H12E11A'
        Chunk_range = [20, 1016];

    case 'H12E16A'
        Chunk_range = [2, 949];
        
    case 'H12E18A'
        Chunk_range = [28, 910];
        
    case 'H12F20A'
        Chunk_range = [28, 1053];
        
    case 'H12F28A'
        Chunk_range = [24, 1035];
        
    case 'H12H20A'
        Chunk_range = [45, 1030];
        
    
    % +++++++++++++
    % Monkey Plato
    % +++++++++++++
    case 'P13F26A'
        Chunk_range = [229, 711];
            
    case 'PMG02A0'
        Chunk_range = [86, 537];
                
    case 'PMG03A0'
        Chunk_range = [62, 363];
        
    case 'PMI10A0'
        Chunk_range = [50, 424];
        
    otherwise
        Chunk_range = [ 1, maxNumChunks ];
        
        
end % switch

end % function MSC_data_info

% [EOF]
