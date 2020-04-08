function writeFunctionFile(funname)
% WRITEFUNCTIONFILE uses a Filewriter object to write a function template

% Adapted from Matlab
% Copyright 2010-2020 Richard J. Cui. Created: Sun 11/16/2010 10:44:16.029 AM
% $Revision: 0.8 $  $Date: Tue 04/07/2020  6:21:16.815 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048
% USA
%
% Email: richard.cui@utoronto.ca

% ask user to provide classname
if nargin < 1
    funname = input('Please input function name [myNewFun]: ','s');
    if isempty(funname)
        funname = 'myNewFun';
    end % if
end % if

filename = [funname '.m'];
fw = Filewriter(filename);

fw.writeToFile(['function ' funname])

% summary
fw.writeToFile(sprintf('%% %s (summary)',upper(funname)))
fw.writeToFile('%')
fw.writeToFile('% Syntax:')
fw.writeToFile('%')
fw.writeToFile('% Input(s):')
fw.writeToFile('%')
fw.writeToFile('% Output(s):')
fw.writeToFile('%')
fw.writeToFile('% Example:')
fw.writeToFile('%')
fw.writeToFile('% Note:')
fw.writeToFile('%')
fw.writeToFile('% References:')
fw.writeToFile('%')
fw.writeToFile('% See also .')

% copywrite infomation
fw.writeToFile('')
fw.writeToFile(sprintf('%% Copyright %s Richard J. Cui. Created: %s',...
    datestr(now, 'yyyy'), datestr(now,'ddd mm/dd/yyyy HH:MM:SS.FFF AM')))
fw.writeToFile(sprintf('%% $Revision: 0.1 $  $Date: %s $',...
    datestr(now,'ddd mm/dd/yyyy HH:MM:SS.FFF AM')))
fw.writeToFile('%')
fw.writeToFile('% Multimodel Neuroimaging Lab (Dr. Dora Hermes)')
fw.writeToFile('% Mayo Clinic St. Mary Campus')
fw.writeToFile('% Rochester, MN 55905, USA')
fw.writeToFile('%')
fw.writeToFile('% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)')
fw.writeToFile('')

% function body
fw.writeToFile(sprintf('end %% function %s',funname))
fw.writeToFile('')
fw.writeToFile('% [EOF]')

delete(fw) % Delete object, which closes file

% open editor
edit(filename)

end

% [EOF]