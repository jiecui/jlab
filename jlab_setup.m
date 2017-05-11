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

% Copyright 2011-2016 Richard J. Cui. Created: Thu 11/08/2012  8:49:00.581 AM
% $Revision: 1.3 $  $Date: Sun 12/11/2016  4:50:51.702 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% remove current jLab and toolboxes from path
% =========================================================================
ext_tb = external_toolbox;
[ext_rem_path, ext_add_path] = genExtPath(ext_tb); % get paths of external toolboxes
exps_path = sprintf('[^%s]*(jLab|jlab|%s)[^%s]*%s', ...
    pathsep, ext_rem_path, pathsep, pathsep);
paths = regexpi(path, exps_path, 'match');

% if ( length( paths) == 0 )
%     paths=regexp(path,['[^;]*corrui[^;]*;'],'match');
% end

if ( ~isempty(paths) )
    
    disp('These folders will be removed from the path:')
    %     for k = 1:length(paths)
    %         fprintf('%s\n', paths{k});
    %     end % for
    disppaths(paths)
    response = input('Do you want to continue? ([y]/n)','s');
    if ( lower(response) ~= 'y')
        return
    end
    for p=paths
        s=char(p);
        rmpath(s);
    end
end

% =========================================================================
% add paths for jLab toolbox
% =========================================================================
new_jlab_folder = fileparts(mfilename('fullpath'));
pp = [ext_add_path, pathsep, genpath(new_jlab_folder)];
paths = regexpi(pp, exps_path, 'match');
% disp(paths')
disppaths(paths)
response = input('These new folders will be added to the path, continue? ([y]/n)','s');
if ( lower(response) ~= 'y')
    savepath
    return
end
exps_add = sprintf('[^%s]*\\(.svn)[^%s]*%s?', pathsep, pathsep, pathsep);   % '[^;]*\\(.svn)[^;]*;?';
pp = regexprep(pp, exps_add,'');
addpath(pp);

savepath

end % funciton

% =========================================================================
% subroutines
% =========================================================================
function [rem_path, add_path] = genExtPath(ext_toolbox)
% get paths of external toolboxes

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