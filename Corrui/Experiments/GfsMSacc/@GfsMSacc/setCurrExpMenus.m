function exp_menu_obj = setCurrExpMenus(this, hfig)
% GFSMSACC.SETCURREXPMENUS setup current menus
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
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Fri 06/17/2016  1:38:55.259 PM
% $Revision: 0.4 $  $Date: Fri 07/15/2016  9:19:56.910 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com


hexp = findall(hfig, 'Type', 'uimenu', 'Tag', 'mnuExp');

hmd = uimenu(hexp, 'Label', 'Merge data...',... % '<html><p><font color="blue">Merge data...</font></p></html>',...
    'ForegroundColor', 'blue',...
    'CallBack', @(hObject, eventdata) this.mnuMergeData_Callback(hObject, ...
    eventdata, guidata(hObject)), 'Separator', 'on');

exp_menu_obj = {hmd};

end % function setCurrExpMenus

% [EOF]
