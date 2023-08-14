function handles_out = updateCurrExpMenus(this, handles)
% EXPERIMENT.UPDATECURREXPMENUS update menu for current experiment
%
% Syntax:
%
% Input(s):
%   this        - Experiment object
%   handles     - gui data
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

% Copyright 2016 Richard J. Cui. Created: Thu 06/16/2016  4:01:26.142 PM
% $Revision: 0.1 $  $Date: Thu 06/16/2016  4:01:26.165 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% intializie
% -----------
handles_out = handles;
exp_menu_obj = handles.ExpDependMenuObj;

% add the menus
% -------------
if isempty(exp_menu_obj) == true
    hfig = handles.CorruiGUI;
    exp_menu_obj = this.setCurrExpMenus( hfig );
end % if

% update handles
handles_out.ExpDependMenuObj = exp_menu_obj;

end % function updateCurrExpMenus

% [EOF]
