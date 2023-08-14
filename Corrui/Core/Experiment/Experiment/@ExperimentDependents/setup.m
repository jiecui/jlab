function setup(this)
% EXPERIMENTDEPENDENTS.SETUP setup dependents of the experiment
%
% Syntax:
%   setup(this)
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2020 Richard J. Cui. Created: Tue 03/31/2020 11:28:43.088 AM
% $Revision: 0.1 $  $Date: Tue 03/31/2020 11:28:43.101 AM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% parse inputs
% =========================================================================

% =========================================================================
% main
% =========================================================================
deps = this.ExpDependents;

if isempty(deps), return, end % if

num_deps = numel(deps);
for k = 1:num_deps
    dep_k = deps(k);
    cprintf('Comments', 'setup toolbox %s ...\n', dep_k.Name)
    fun_k = str2func(['setup_', lower(dep_k.Name)]);
    fun_k(this, dep_k); % initialize the toolbox
end % for

end % function setup

% =========================================================================
% subroutines
% =========================================================================

% [EOF]
