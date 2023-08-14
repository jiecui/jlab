function [COLORS, colors_array] = get_nice_colors()
% GET_NICE_COLORS find color indexes
%
% Syntax:
%   [COLORS, colors_array] = get_nice_colors()
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 11/13/2012  5:11:27.619 PM
% $Revision: 0.3 $  $Date: Tue 07/23/2013  8:50:11.555 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% global COLORS;
% global colors_array;

% define colors
% -------------
COLORS.MEDIUM_BLUE          = [0.1 0.5 0.8];
COLORS.MEDIUM_RED           = [0.9 0.2 0.2];
COLORS.MEDIUM_GREEN         = [0.5 0.8 0.3];
COLORS.MEDIUM_GOLD          = [0.9 0.7 0.1];
COLORS.MEDIUM_PURPLE        = [0.7 0.4 0.9];
COLORS.MEDIUM_PINK          = [1.0 0.5 0.8];
COLORS.MEDIUM_BLUE_GREEN    = [0.1 0.8 0.7];
COLORS.MEDIUM_ORANGE        = [1.0 0.6 0.15];
COLORS.LIGHT_BLUE           = [.5 .8 1];
COLORS.LIGHT_RED            = [1 .75 .75];
COLORS.LIGHT_GREEN          = [.5 1 .3];
COLORS.LIGHT_ORANGE         = [.9 .7 .1];
COLORS.DARK_GREEN           = [.0 .6 .3];
COLORS.WHITE                = [1 1 1];
COLORS.DARK_BLUE            = [0 20 80]/255;
COLORS.DARK_RED             = [130 10 0]/255;
COLORS.MEDIUM_BROWN         = [155 102 50]/255;
COLORS.GREY                 = [.5 .5 .5];
COLORS.DARK_BROWN           = [101 67 33]/255;
COLORS.LIGHT_BROWN          = [245 222 179]/255;
COLORS.LIGHT_PINK           = [1 0.8 0.9];
COLORS.MAGENTA              = [255 0 255]/255;
COLORS.DEEP_SKY_BLUE        = [0  154 205]/255;
COLORS.DARK_KHAKI           = [205 198 115]/255;
COLORS.MEDIUM_KHAKI         = [238 230 133]/255;
COLORS.ROYAL_BLUE           = [65 105 225]/255;
COLORS.SALMON               = [198 113 113]/255;
COLORS.TURQUOISE            = [0 245 255]/255;
COLORS.DARK_TURQUOISE       = [0 245 255]/255/2;
COLORS.TAN                  = [210 180 140]/255;
COLORS.MAGANESE_BLUE        = [0 245 255]/255;
COLORS.MEDIUM_SIENNA        = [255 130 71]/255;
COLORS.MEDIUM_SEA_GREEN     = [60 179 113]/255;
COLORS.DARK_SIENNA          = [205 104 57]/255;
COLORS.DARK_SEA_GREEN       = [143 188 143]/255;
COLORS.LIGHT_GOLDEN_ROD     = [255 236 139]/255;
COLORS.TEAL                 = [56 142 142]/255;
COLORS.PALE_GREEN           = [152 251 152]/255;
COLORS.LIGHT_KHAKI          = [255 246 143]/255;
COLORS.LIGHT_STEEL_BLUE     = [202 225 255]/255;
COLORS.ROYAL_PURPLE         = [120 81 169]/255;
COLORS.GRAY_155             = [155 155 155]/255;
COLORS.MAROON               = [128 0 0]/255;
COLORS.DARK                 = [0.0 0.0 0.0];

% get colors_array
% -----------------
fields = fieldnames(COLORS);
N = length(fields);     % nubmer of colors
colors_array = zeros(N, 3);
for k = 1:N
    colors_array(k,:) = COLORS.(fields{k});
end

end % function get_nice_colors

% [EOF]
