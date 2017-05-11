function writeScriptFile(scriptname)
% WRITESCRIPFILE uses a Filewriter object to write a M-file script template

% Adapted from Matlab
% Copyright 2010-2017 Richard J. Cui. Created: 02/22/2010  4:06:34.491 PM
% $Revision: 0.6 $  $Date: Thu 05/11/2017  2:45:50.148 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
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
fw.writeToFile(sprintf('%% Copyright %s '))
fw.writeToFile(sprintf('%% Copyright %s Richard J. Cui. Created: %s',...
    datestr(now, 'yyyy'), datestr(now,'ddd mm/dd/yyyy HH:MM:SS.FFF AM')))
fw.writeToFile(sprintf('%% $Revision: 0.1 $  $Date: %s $',...
    datestr(now,'ddd mm/dd/yyyy HH:MM:SS.FFF AM')))
fw.writeToFile('%')
fw.writeToFile('% 3236 E Chandler Blvd Unit 2036')
fw.writeToFile('% Phoenix, AZ 85048, USA')
fw.writeToFile('%')
fw.writeToFile('% Email: richard.cui@utoronto.ca')
fw.writeToFile('')

% fw.writeToFile('% [EOF]')

delete(fw) % Delete object, which closes file

% open editor
edit(filename)

end

% [EOF]