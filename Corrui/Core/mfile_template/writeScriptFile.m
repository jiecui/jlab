function writeScriptFile(scriptname)
% WRITESCRIPFILE uses a Filewriter object to write a M-file script template

% Adapted from Matlab
% Copyright 2010-2020 Richard J. Cui. Created: 02/22/2010  4:06:34.491 PM
% $Revision: 1.0 $  $Date: Fri 06/26/2020 12:21:11.016 PM $
%
% Multimodal Neuroimaging Lab
% Mayo Clinic St. Mary Campus
% Rochester, MN 55905, USA
%
% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)

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
fw.writeToFile('% Multimodal Neuroimaging Lab')
fw.writeToFile('% Mayo Clinic St. Mary Campus')
fw.writeToFile('% Rochester, MN 55905, USA')
fw.writeToFile('%')
fw.writeToFile('% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)')
fw.writeToFile('')

% fw.writeToFile('% [EOF]')

delete(fw) % Delete object, which closes file

% open editor
edit(filename)

end

% [EOF]