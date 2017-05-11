function [Tune_range, Chunk_range] = cell_contrast_exp_info( filenames, maxNumChunks )
% CELL_CONTRAST_EXP_INFO specifies chunk information for a uSacc-Contrast experiment
%
% Syntax:
%   Chunk_range = cell_contrast_exp_info( filenames, maxNumChunks )
% 
% Input(s):
%   filenames       - filename of RF data
%   maxNumChunks    - maximum number of chunks allowed by the program
%
% Output(s):
%   Tune_ragne      - [tune chunk id before exp, tune chunk id after exp] for
%                     orientation tuning exp
%   Chunk_ragne     - [begin chunk seq number, end number] for
%                     microsaccade-contrast exp
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created:Thu 08/02/2012  9:20:57.175 AM
% $Revision: 0.3 $  $Date: Thu 04/17/2014  1:04:02.299 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

if ~exist('maxNumChunks', 'var')
    maxNumChunks = 5000;
end % if

[ ~, fn ] =  fileparts(filenames{1});
ufn = upper( fn );
switch ufn  % rf2 data file name (only handle one file now)
    % ---------------------------------------------------------------------
    % Testing signals
    % ---------------------------------------------------------------------
    case 'H14D29A'  % test eye signal, fix position = 213/282 DUs
        Tune_range  = [];
        Chunk_range = [18, 196];
    
    case 'H14D29B'  % test eye signal, fix position = 320/240 DUs
        Tune_range  = [];
        Chunk_range = [2, 225];

    % ---------------------------------------------------------------------
    % Yoda - V1 cells
    % ---------------------------------------------------------------------
    % Note: filename should be in capital letters
    case 'Y11K23A'
        Tune_range  = [21, 1609];
        Chunk_range = [ 118, 1603 ];
      
    case 'Y11K28B'
        Tune_range = [2, 6];
        Chunk_range = [ 218, 1812];
        
    case 'Y11L13A'
        Tune_range  = [12, 1636];
        Chunk_range = [128, 1633];
    
    % ---------------------------------------------------------------------
    % Hellboy - V1 cells
    % ---------------------------------------------------------------------
    case 'H11L22A'
        Tune_range  = [24, 1243];
        Chunk_range = [298, 1241];
        
    case 'H12A04A1ST'
        Tune_range  = [33, 993];
        Chunk_range = [160, 991];
        
    case 'H12A04A2ND'
        Tune_range  = [993, 1891];
        Chunk_range = [997, 1889];
        
    case 'H12A06A'
        Tune_range = [13, 1444];
        Chunk_range = [268, 1442];
        
    case 'H12A06B'
        Tune_range  = [2, 1748];
        Chunk_range = [87, 1742];
        
    case 'H12A10A1ST'
        Tune_range  = [22, 1148];
        Chunk_range = [163, 1146];
        
    case 'H12A10A2ND'
        Tune_range  = [1148, 2333];
        Chunk_range = [1159, 2322];
    
    case 'H12A11A1ST'
        Tune_range  = [12, 975];
        Chunk_range = [177, 969];
    
    case 'H12A11A2ND'
         Tune_range  = [975, 1807];
         Chunk_range = [977, 1803];
        
    case 'H12A12A1ST'
        Tune_range  = [21, 996];
        Chunk_range = [218, 992];
        
    case 'H12A12A2ND'
        Tune_range = [996, 1771];
        Chunk_range = [998, 1769];
        
    case 'H12A13A1ST'
        Tune_range  = [18, 1083];
        Chunk_range = [306, 1079];
        
    case 'H12A13A2ND'
        Tune_range  = [1083, 1857];
        Chunk_range = [1085, 1855];
        
    case 'H12A18A'
        Tune_range  = [23, 1146];
        Chunk_range = [161, 1144];
        
    case 'H12A19A'
        Tune_range  = [130, 1794];
        Chunk_range = [262, 1792];
        
    case 'H12A23A1ST'
        Tune_range = [26, 978];
        Chunk_range = [174, 974];
        
    case 'H12A23A2ND'
        Tune_range = [978, 2476];
        Chunk_range = [980, 2472];
        
    case 'H12A30A'
        Tune_range = [14, 1596];
        Chunk_range = [189, 1594];
        
    case 'H12B02A'
        Tune_range = [1, 121];
        Chunk_range = [1165, 2499];
        
    case 'H12B03A1ST'
        Tune_range = [8, 889];
        Chunk_range = [121, 887];
        
    case 'H12B03A2ND'
        Tune_range = [889, 1645];
        Chunk_range = [891,1643];
        
    case 'H12B15A1ST'
        Tune_range = [23, 899];
        Chunk_range = [128,897];
        
    case 'H12B15A2ND'
        Tune_range = [899, 1751];
        Chunk_range = [901, 1745];
    
    case 'H12B29A'  % bad data
         Tune_range = [1, maxNumChunks];
         Chunk_range = [1, maxNumChunks];

    case 'H12C02A1ST'
        Tune_range = [24, 1380];
        Chunk_range = [243, 1376];
        
    case 'H12C02A2ND'
        Tune_range = [1380, 2471];
        Chunk_range = [1382, 2469];
        
    case 'H12C06A'
        Tune_range = [14, 1005];
        Chunk_range = [233, 1001];
        
    case 'H12C09A1ST'
        Tune_range  = [23, 970];
        Chunk_range = [220, 968];
        
    case 'H12C09A2ND'
        Tune_range  = [970, 1728];
        Chunk_range = [973, 1722];
        
    case 'H12C16A'
        Tune_range  = [31, 985];
        Chunk_range = [224, 979];
        
    case 'H12C22A'
        Tune_range  = [31, 1019];
        Chunk_range = [261, 1015];
        
    case 'H12C23A'
        Tune_range = [1, maxNumChunks];
        Chunk_range = [294, 1043];
        
    case 'H12C28A'
        Tune_range = [12, 1028];
        Chunk_range = [256, 1026];
        
    case 'H12D04A1ST'
        Tune_range = [15, 891];
        Chunk_range = [132, 887];
       
    case 'H12D04A2ND'
        Tune_range = [891, 1642];
        Chunk_range = [893, 1640];
    
    case 'H12D06A1ST'
        Tune_range = [20, 889];
        Chunk_range = [133, 887];
        
    case 'H12D06A2ND'
        Tune_range = [889, 1643];
        Chunk_range = [891, 1641];
    
    case 'H12D11A1ST'
        Tune_range = [20, 910];
        Chunk_range = [128, 908];
        
    case 'H12D11A2ND'
        Tune_range = [910, 1664];
        Chunk_range = [914, 1660];

    case 'H12D13A'
        Tune_range = [26, 1374];
        Chunk_range = [360, 1368];
        
    case 'H12D18A1ST'
        Tune_range = [27, 904];
        Chunk_range = [145,900 ];
        
    case 'H12D18A2ND'
        Tune_range = [904, 1657];
        Chunk_range = [906, 1653];

    case 'H12D19A'
        Tune_range = [27, 916];
        Chunk_range = [168, 914];

    case 'H12D25A1ST'
        Tune_range = [10, 930];
        Chunk_range = [163, 928];
        
    case 'H12D25A2ND'
        Tune_range = [930, 1712];
        Chunk_range = [947, 1710];

    case 'H12D27A'
        Tune_range = [192, 1124];
        Chunk_range = [315, 1122];

    case 'H12E01A'
        Tune_range = [23, 1008];
        Chunk_range = [219, 1002];

    case 'H12E02A1ST'
        Tune_range = [27, 903];
        Chunk_range = [147, 899];
        
    case 'H12E02A2ND'
        Tune_range = [903, 1657];
        Chunk_range = [906, 1651];

    case 'H12E03A1ST'
        Tune_range = [250, 993];
        Chunk_range = [254, 989];
        
    case 'H12E03A2ND'
        Tune_range = [993, 1749];
        Chunk_range = [997, 1747];

    case 'H12E04A'
        Tune_range = [24, 903];
        Chunk_range = [146, 899];
            
    case 'H12E09A'
        Tune_range = [34, 887];
        Chunk_range = [135, 885];

    case 'H12E10A1ST'
        Tune_range = [18, 951];
        Chunk_range = [199, 949];
        
    case 'H12E10A2ND'
        Tune_range = [951, 1706];
        Chunk_range = [953, 1702];

    case 'H12E11A'
        Tune_range = [20, 1016];
        Chunk_range = [182, 1012];

    case 'H12E16A'
        Tune_range = [2, 949];
        Chunk_range = [186, 945];
        
    case 'H12E18A'
        Tune_range = [28, 910];
        Chunk_range = [158, 908];
        
    case 'H12F20A'
        Tune_range = [28, 1053];
        Chunk_range = [260, 1052];
        
    case 'H12F28A'
        Tune_range = [24, 1035];
        Chunk_range = [233, 1034];
        
    case 'H12H20A'
        Tune_range = [45, 1030];
        Chunk_range = [270, 1028];
        
    % ---------------------------------------------------------------------
    % Plato - V1 cells
    % ---------------------------------------------------------------------
    case 'P13F26A'      % 
        Tune_range = [229, 711];
        Chunk_range = [713, 4234];
        
    case 'PMF27A2'      %
        Tune_range = [4, 1745];
        Chunk_range = [6, 1743];
            
    case 'PMG02A1'
        Tune_range = [3, 2220];
        Chunk_range = [5, 2218];

    case 'PMG12A0'
        Tune_range = [52, 2443];
        Chunk_range = [264, 2473];
    
    case 'PMG16A0'
        Tune_range = [50, 2203];
        Chunk_range = [405, 2200];

    case 'PMG18A0'
        Tune_range = [54, 4031];
        Chunk_range = [406, 4029];
        
    case 'PMG18A01ST'
        Tune_range = [54, 2056];
        Chunk_range = [406, 2054];

    case 'PMG18A02ND'
        Tune_range = [2056, 4031];
        Chunk_range = [2055, 4029];

    case 'PMH14A0'
        Tune_range = [59, 2201];
        Chunk_range = [454, 2194];

    case 'PMH20B0'
        Tune_range = [3, 1881];
        Chunk_range = [116, 1877];

    case 'PMH22A0'
        Tune_range = [217, 3322];
        Chunk_range = [220, 3320];
        
    case 'PMH22A01ST'
        Tune_range = [217, 1813];
        Chunk_range = [220, 1811];

    case 'PMH22A02ND'
        Tune_range = [1813, 3322];
        Chunk_range = [1817, 3320];

    case 'PMH26A0'
        Tune_range = [386, 1946];
        Chunk_range = [388, 1944];

    case 'PMH27A0'
        Tune_range = [69, 1962];
        Chunk_range = [412, 1958];

    case 'PMH28A0'
        Tune_range = [73, 2115];
        Chunk_range = [281, 2112];

    case 'PMI10A0'  % repeated spiketime
        Tune_range = [647, 1989];
        Chunk_range = [649, 1984];

    case 'PMI11A0'
        Tune_range = [51, 1433];
        Chunk_range = [127, 1431];

    case 'PMI13A0'
        Tune_range = [765, 2268];
        Chunk_range = [768, 2268];

    case 'PMI18A0'
        Tune_range = [4, 1812];
        Chunk_range = [188, 1810];

    case 'PMI20A0'
        Tune_range = [4, 1812];
        Chunk_range = [301, 1809];

    case 'PMI27A0'
        Tune_range = [3, 2117];
        Chunk_range = [237, 2115];

    case 'PMI30A0'
        Tune_range = [4, 1567];
        Chunk_range = [184, 1563];
        
    otherwise
        Tune_range = [1, maxNumChunks];
        Chunk_range = [ 1, maxNumChunks ];
        
        
end % switch

end % function MSC_data_info

% [EOF]
