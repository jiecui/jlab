function ext_tb = external_toolbox()
% EXTERNAL_TOOLBOX list of folders of external toolboxes
%
% Syntax:
%   ext_tb = external_toolbox()
% 
% Input(s):
%
% Output(s):
%
% Example:
% 
% Noate:
%   It is assumed that the folders of external toolboxes are just one level
% above jLab folder.
%
% See also .

% Copyright 2014-2019 Richard J. Cui. Created: 03/02/2014  4:46:03.176 PM
% $Revision: 0.7 $  $Date: Thu 01/02/2020  3:34:37.411 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.jie.cui@gmail.com

ext_tb = {};
% ext_tb = cat(1, ext_tb, 'time_frequency_analysis');
% ext_tb = cat(1, ext_tb, 'neural_signals_analysis');
ext_tb = cat(1, ext_tb, 'eye_movement_analysis');

end % function external_toolbox

% [EOF]
