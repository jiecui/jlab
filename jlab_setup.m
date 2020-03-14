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
% $Revision: 1.7 $  $Date: Sat 03/14/2020 12:19:41.747 AM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% remove current jLab, toolboxes and exp from path
% =========================================================================
restoredefaultpath
new_jlab_folder = fileparts(mfilename('fullpath'));
addpath(genpath(new_jlab_folder));

% get paths of jlab toolbox folders
% ---------------------------------
ext_tb = external_toolbox;
[ext_rem_path, ext_add_path] = genExtPath(ext_tb); % get paths of external toolboxes

% get paths of jlab_exp folders
% -----------------------------
jlab_exp_path = genJlabexpPath(jlab_exp);

% remove pathes
% -------------
if isempty(ext_rem_path) && isempty(jlab_exp_path)
    exps_path = sprintf('[^%s]*(jLab|jlab)[^%s]*%s', ...
        pathsep, pathsep, pathsep);
elseif ~isempty(ext_rem_path) && isempty(jlab_exp_path)
    exps_path = sprintf('[^%s]*(jLab|jlab|%s)[^%s]*%s', ...
        pathsep, ext_rem_path, pathsep, pathsep);
elseif isempty(ext_rem_path) && ~isempty(jlab_exp_path)
    exps_path = sprintf('[^%s]*(jLab|jlab|%s)[^%s]*%s', ...
        pathsep, jlab_exp_path, pathsep, pathsep);
elseif ~isempty(ext_rem_path) && ~isempty(jlab_exp_path)
    exps_path = sprintf('[^%s]*(jLab|jlab|%s|%s)[^%s]*%s', ...
        pathsep, ext_rem_path, jlab_exp_path, pathsep, pathsep);
end % if
paths = regexpi(path, exps_path, 'match');

if ~isempty(paths)
    disppaths(paths)
    response = input('These folders will be removed from the path, continue? ([y]/n)','s');
    if isempty(response) || lower(response) == 'y'
        pp = cell2mat(paths);
        rmpath(pp)
    end % if
end

% =========================================================================
% add paths for jLab, toolbox and exp
% =========================================================================
new_jlab_folder = fileparts(mfilename('fullpath'));
pp = [jlab_exp_path, pathsep, ext_add_path, pathsep, genpath(new_jlab_folder)];
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

function [rem_path, add_path] = genExtPath(ext_toolbox)
% Get paths of external toolboxes
% 
% It is assumed that the folders of external toolboxes are just one level
% above jLab folder.
% 
% Inputs:
%   ext_toolbox     - cell string of folders of toolboxes
% 
% Outputs:
%   rem_path        - string vector for regexp process
%   add_path        - string vector for adding path

cur_folder = cd(sprintf('..%s', filesep));
upper_folder = pwd;
cd(cur_folder)

rem_path = [];
add_path = [];
N = length(ext_toolbox);
for k = 1:N
    rem_path = strcat(rem_path, ext_toolbox{k});
    if k ~= N
        rem_path = strcat(rem_path, '|');
    end % if
    
    s_k = sprintf('%s%s%s', upper_folder, filesep, ext_toolbox{k});
    add_path = strcat(add_path, genpath(s_k));
    if k ~= N
        add_path = strcat(add_path, pathsep);
    end % if
end % for

end

function disppaths(paths)

for k = 1:length(paths)
    paths_k = cell2mat( regexpi(paths{k}, sprintf('[\\W\\w]*[^%s]', pathsep), 'match') );
    fprintf('%s\n', paths_k);
end % for


end % function

% [EOF]