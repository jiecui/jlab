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
% $Revision: 0.2 $  $Date: Mon 01/28/2019  4:12:21.709 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

add_dir = {};
add_dir = cat(1, add_dir, '/Users/Jie/Documents/Richard/Projects/other_projects/gfs_msacc/jlab_exp');
add_dir = cat(1, add_dir, '/Users/Jie/Documents/Richard/Projects/PostDocProjects/barrow/mSaccade and contrast perception/jlab_exp');

end % function jlab_exp

% [EOF]
