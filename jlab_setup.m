function jlab_setup()
% JLAB_SETUP Setup jLab of Integrated Environment for Signal Processing
% 
% Syntax:
%   jlab_setup()
% 
% Example:
%   jlab_setup
% 
% See also .

% Copyright 2012-2020 Richard J. Cui. Created: Thu 11/08/2012  8:49:00.581 AM
% $Revision: 1.9 $  $Date: Fri 04/17/2020 10:27:52.589 AM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% remove current jLab, toolboxes and exp from path
% =========================================================================
disp('restoring default pathes...')
restoredefaultpath
new_jlab_folder = fileparts(mfilename('fullpath'));
addpath(genpath(new_jlab_folder));

% get paths of jlab_exp folders
% -----------------------------
jlab_exp_path = genJlabexpPath(jlab_exp);

% remove pathes
% -------------
if isempty(jlab_exp_path)
    exps_path = sprintf('[^%s]*(jLab|jlab)[^%s]*%s', ...
        pathsep, pathsep, pathsep);
elseif isempty(jlab_exp_path)
    exps_path = sprintf('[^%s]*(jLab|jlab|%s)[^%s]*%s', ...
        pathsep, pathsep, pathsep);
elseif ~isempty(jlab_exp_path)
    exps_path = sprintf('[^%s]*(jLab|jlab|%s)[^%s]*%s', ...
        pathsep, jlab_exp_path, pathsep, pathsep);
elseif ~isempty(jlab_exp_path)
    exps_path = sprintf('[^%s]*(jLab|jlab|%s|%s)[^%s]*%s', ...
        pathsep, jlab_exp_path, pathsep, pathsep);
end % if

% =========================================================================
% add paths for jLab, toolbox and exp
% =========================================================================
new_jlab_folder = fileparts(mfilename('fullpath'));
pp = [jlab_exp_path, pathsep, pathsep, genpath(new_jlab_folder)];
% remove hidden directories of version control from the path
exps_rm = sprintf('[^%s]*\\.(git|svn)[^%s]*%s?', pathsep, pathsep, pathsep);   % '[^;]*\\(.svn)[^;]*;?';
pp = regexprep(pp, exps_rm,'');

paths = regexpi(pp, exps_path, 'match');
disppaths(paths)
response = input('These new folders will be added to the path, continue? ([y]/n)','s');
if isempty(response) || lower(response) == 'y'
    addpath(pp);
end
% savepath

end % funciton

% =========================================================================
% subroutines
% =========================================================================
function add_path = genJlabexpPath(jlab_exp)
% Get paths of external jlab_exp folders
% 
% Assume that jlab_exp are absolute directories

add_path = [];
N = length(jlab_exp);
for k = 1:N    
    s_k = jlab_exp{k};
    add_path = strcat(add_path, genpath(s_k));
    if k ~= N
        add_path = strcat(add_path, pathsep);
    end % if
end % for

end % funciton

function disppaths(paths)

for k = 1:length(paths)
    paths_k = cell2mat( regexpi(paths{k}, sprintf('[\\W\\w]*[^%s]', pathsep), 'match') );
    fprintf('%s\n', paths_k);
end % for


end % function

% [EOF]