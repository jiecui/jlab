function info = registerSavedVars(this, sname, vars)
% EXPERIMENT.REGISTERSAVEDVARS register the var names of saved vars
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2015 Richard J. Cui. Created: Thu 03/05/2015 10:26:44.317 PM
% $Revision: 0.1 $  $Date: Thu 03/05/2015 10:26:44.319 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

% get info
dat = this.db.Getsessvars(sname, {'info'});
info = dat.info;
if isempty(info) 
    saved_vars = {};
elseif ~isfield(info, 'saved_variables')
    saved_vars = {};
else
    saved_vars = info.saved_variables;
end % if

% get var names
old_saved_vars = union(saved_vars, vars);
all_vars = this.db.GetVarNamesForSession(sname);
saved_vars = intersect(old_saved_vars, all_vars);   % update
info.saved_variables = saved_vars;

% save info
dat.info = info;
this.db.Addsessvars(sname, dat, 'unlock');

end % function registerSavedVars

% [EOF]
