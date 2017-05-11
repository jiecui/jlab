function Chunk_range = cell_blankctrl_exp_info( filenames, maxNumChunks )
% CELL_GRATING_EXP_INFO specifies chunk information for blank control experiment
%
% Syntax:
%   Chunk_range = cell_blankctrl_exp_info( filenames, maxNumChunks )
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

% Copyright 2012 Richard J. Cui. Created: Thu 08/09/2012  5:19:24.499 PM
% $Revision: 0.2 $  $Date: Sun 09/15/2013  3:38:03.574 PM $
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
    % V1 - Hellboy
    % --------------
    % Note: filename should be in capital letters
    case 'H12H20A'
        Chunk_range = [147, 268];
    
    case 'H13C20A'
        Chunk_range = [472, 578];

    case 'H13C23A'
        Chunk_range = [23, 167];

    case 'H13C26A'
        Chunk_range = [53, 236];

    case 'H13C26B'
        Chunk_range = [4, 180];

    case 'H13C26C'
        Chunk_range = [8, 126];

    % --------------
    % V1 - Plato
    % --------------
    case 'P13F26A'
        Chunk_range = [317, 707];
                
    case 'PMG02A0'
        Chunk_range = [226, 533];

    case 'PMG03A0'
        Chunk_range = [78, 361];

    case 'PMG10A0'
        Chunk_range = [413, 747];

    case 'PMG11A0'
        Chunk_range = [37, 423];
        
    case 'PMG12A1'
        Chunk_range = [5, 472];

    case 'PMG15A0'
        Chunk_range = [415, 656];
        
    case 'PMG19A0'
        Chunk_range = [96, 327];

    case 'PMH13A0'
        Chunk_range = [309, 645];

    case 'PMH22A1'
        Chunk_range = [196, 443];
        
    case 'PMH22B0'
        Chunk_range = [278, 521];
        
    case 'PMH27A1'
        Chunk_range = [7, 297];

    case 'PMI05A0'
        Chunk_range = [374, 613];

    case 'PMI06A0'
        Chunk_range = [156, 399];

    case 'PMI09A0'
        Chunk_range = [194, 411];
        
    case 'PMI10A0'
        Chunk_range = [202, 422];

    case 'PMI11A0'
        Chunk_range = [1435, 1660];

    case 'PMI12B0'
        Chunk_range = [213, 450];

    case 'PMI13A0'
        Chunk_range = [255, 530];

    case 'PMI17A0'
        Chunk_range = [342, 729];

    case 'PMI18A0'
        Chunk_range = [1814, 2089];

    case 'PMI20A0'
        Chunk_range = [1814, 2135];

    case 'PMI26A0'
        Chunk_range = [355, 834];

    case 'PMJ09A0'
        Chunk_range = [354, 619];
        
    otherwise
        Chunk_range = [ 1, maxNumChunks ];
        
        
end % switch

end % function cell_blankctrl_exp_info

% [EOF]
