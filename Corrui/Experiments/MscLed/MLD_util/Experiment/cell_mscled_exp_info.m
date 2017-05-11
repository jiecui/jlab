function [Tune_range, Chunk_range, Cond_range, Hor_ver_deg] = cell_mscled_exp_info( filenames, maxNumChunks )
% CELL_MSCLED_EXP_INFO specifies chunk information for MSC-LED experiment
%
% Syntax:
%   Chunk_range = cell_mscled_exp_info( filenames, maxNumChunks )
% 
% Input(s):
%   filenames       - filename of RF data
%   maxNumChunks    - maximum number of chunks allowed by the program
%
% Output(s):
%   Tune_ragne      - [tune chunk id before exp, tune chunk id after exp] for
%                     orientation tuning exp
%   Chunk_ragne     - [begin chunk seq number, end number] for
%                     LED (total darkness) exp
%   Cond_range      - [begin cond, end cond], using BlankCtrl block to
%                     record information. The condition range that used to
%                     record the information
%   Hor_ver_deg     - horizontal and vertical subtended angle in dva
%
% Example:
%
% See also .

% Copyright 2013-2014 Richard J. Cui. Created: Tue 09/03/2013  9:48:39.721 AM
% $Revision: 0.2 $  $Date: Tue 07/01/2014 10:28:24.490 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

if ~exist('maxNumChunks', 'var')
    maxNumChunks = 5000;
end

[ ~, fn ] =  fileparts(filenames{1});
ufn = upper( fn );
switch ufn  % only one file
    % --------------
    % V1 - Plato
    % --------------
    case 'PMF27A1'
        Tune_range  = [2, 351];
        Chunk_range = [6, 348];
        Cond_range  = [1, 2];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMG02A0'
        Tune_range  = [541, 817];
        Chunk_range = [543, 815];
        Cond_range  = [1, 2];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMG10A0'
        Tune_range  = [35, 405];
        Chunk_range = [37, 401];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMG12A1'
        Tune_range  = [474, 942];
        Chunk_range = [476, 938];
        Cond_range  = [1, 3];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMG15A0'
        Tune_range  = [664, 965];
        Chunk_range = [662, 963];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMG19A0'
        Tune_range  = [330, 602];
        Chunk_range = [332, 600];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMH22B0'
        Tune_range  = [523, 523];   % no checking tuning
        Chunk_range = [525, 833];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMH27A1'
        Tune_range  = [301, 611];
        Chunk_range = [305, 608];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMI05A0'
        Tune_range  = [25, 867];
        Chunk_range = [617, 861];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMI06A0'
        Tune_range  = [401, 706];
        Chunk_range = [403, 703];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMI09A0'
        Tune_range  = [413, 649];
        Chunk_range = [415, 645];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMI10A0'
        Tune_range  = [50, 424];
        Chunk_range = [426, 645];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMI11A0'
        Tune_range  = [1662, 1946];
        Chunk_range = [1664, 1944];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMI12B0'
        Tune_range  = [452, 732];
        Chunk_range = [454, 731];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMI13A0'
        Tune_range  = [507, 765];
        Chunk_range = [509, 761];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMI17A0'
        Tune_range  = [731, 1123];
        Chunk_range = [733, 1119];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMI18A0'  % left eye only
        Tune_range  = [2091, 2671];
        Chunk_range = [2093, 2668];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMI20A0'
        Tune_range  = [2139, 2678];
        Chunk_range = [2141, 2674];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMI26A0'
        Tune_range  = [836, 1229];
        Chunk_range = [838, 1227];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    case 'PMJ09A0'
        Tune_range  = [621, 879];
        Chunk_range = [623, 875];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
    % --------------
    % V1 - Hellboy
    % --------------
    case 'H14F24A'
        Tune_range  = [21, 177];
        Chunk_range = [24, 175];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14F25A'
        Tune_range  = [13, 184];
        Chunk_range = [16, 182];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14F25B'
        Tune_range  = [2, 123];
        Chunk_range = [2, 123];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14F26A'
        Tune_range  = [28, 153];
        Chunk_range = [30, 151];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14F26B'
        Tune_range  = [2, 141];
        Chunk_range = [6, 137];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14G02A'
        Tune_range  = [23, 258];
        Chunk_range = [25, 256];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14G03A'
        Tune_range  = [23, 215];
        Chunk_range = [25, 209];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14G08A'
        Tune_range  = [14, 487];
        Chunk_range = [16, 483];
        Cond_range  = [1, 2];       % monkey did not work well. only partial data useful
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14G09A'
        Tune_range  = [215, 215];   % forgot to record tuning before the exp
        Chunk_range = [18, 133];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14G09B'
        Tune_range  = [2, 122];   
        Chunk_range = [4, 120];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14G10A'
        Tune_range  = [18, 146];   
        Chunk_range = [20, 144];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14G11A'
        Tune_range  = [24, 257];   
        Chunk_range = [26, 252];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14G14A'
        Tune_range  = [23, 174];   
        Chunk_range = [27, 168];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14G17A'
        Tune_range  = [19, 389];   
        Chunk_range = [21, 379];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    case 'H14G21A'
        Tune_range  = [15, 211];   
        Chunk_range = [17, 209];
        Cond_range  = [1, 5];
        Hor_ver_deg = [55, 42];     % Distance from screen = 40 cm

    otherwise
        Tune_range  = [1, maxNumChunks];
        Chunk_range = [1, maxNumChunks];
        Cond_range  = [1, 5];
        Hor_ver_deg = [40, 30];     % Distance from screen = 57 cm
        
end % switch

end % function cell_blankctrl_exp_info

% [EOF]
