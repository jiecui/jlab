function writeScriptFile(scriptname)
% WRITESCRIPFILE uses a Filewriter object to write a M-file script template

% Adapted from Matlab
% Copyright 2010-2020 Richard J. Cui. Created: 02/22/2010  4:06:34.491 PM
% $Revision: 1.1 $  $Date: Sat 09/05/2020  1:57:38.934 PM $
%
% Rocky Creek Dr. NE
% Rochester, MN 55906
% USA
%
% Email: richard.cui@utoronto.ca

% ask user to provide file name
if nargin < 1
    scriptname = input('Please input script name [myNewFile]: ','s');
    if isempty(scriptname)
        scriptname = 'myNewFile';
    end % if
end % if

filename = [scriptname '.m'];
fw = Filewriter(filename);

% summary
fw.writeToFile(sprintf('%% %s (summary)',upper(scriptname)))

% function body
fw.writeToFile('')
fw.writeToFile('% write your code here')

% copywrite infomation
fw.writeToFile('')
fw.writeToFile(sprintf('%%%% Copyright %s Richard J. Cui', datestr(now, 'yyyy')))
fw.writeToFile(sprintf('%% Created: %s;', datestr(now,'ddd mm/dd/yyyy HH:MM:SS.FFF AM')))
fw.writeToFile(sprintf('%% Revision: 0.1  Date: %s',...
    datestr(now,'ddd mm/dd/yyyy HH:MM:SS.FFF AM')))
fw.writeToFile('%')
fw.writeToFile('% Rocky Creek Dr. NE')
fw.writeToFile('% Rochester, MN 55906, USA')
fw.writeToFile('%')
fw.writeToFile('% Email: richard.cui@utoronto.ca')
fw.writeToFile('')

% fw.writeToFile('% [EOF]')

delete(fw) % Delete object, which closes file

% open editor
edit(filename)

end

% [EOF]