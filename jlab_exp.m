function add_dir = jlab_exp()
% JLAB_EXP directories of additional experiments for jLab gui
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%   Searchs inside the default folder (jLab/Corrui/Experiments) and
% additional folders for class names (tag).  The folder name is the tag
% name.  Put the folders under MatLab pathways.
%
% References:
%
% See also .

% Copyright 2018-2019 Richard J. Cui. Created: Sat 05/19/2018  9:01:31.718 PM
% $Revision: 0.5 $  $Date: Tue 03/17/2020 10:46:40.905 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

add_dir = {};

% elife_gamma_oscillation
% -----------------------
add_dir = cat(1, add_dir, fullfile(getuserdir, ['Documents/Richard',...
    '/Projects/PostDocProjects/mayo/elife2019_data_analysis/analysis',...
    '/code/jlab_exp']));

% gfs_msacc
% ---------
% need eye_movement_analysis external toolbox
add_dir = cat(1, add_dir, fullfile(getuserdir, ['Documents/Richard',...
    '/Projects/other_projects/gfs_msacc/Analysis/codes/jlab_exp']));

% mSaccade and contrast perception
% --------------------------------
% need eye_movement_analysis external toolbox

% add_dir = cat(1, add_dir, fullfile(getuserdir, ['Documents/Richard',...
%     '/Projects/PostDocProjects/barrow/mSaccade and contrast perception',...
%     '/jlab_exp']));

end % function jlab_exp

% [EOF]
