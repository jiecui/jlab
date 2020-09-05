function writeFunctionFile(funname)
% WRITEFUNCTIONFILE uses a Filewriter object to write a function template

% Adapted from Matlab
% Copyright 2010-2020 Richard J. Cui. Created: Sun 11/16/2010 10:44:16.029 AM
% $Revision: 1.0 $  $Date: Sat 09/05/2020  1:57:38.934 PM $
%
% Rocky Creek Dr. NE
% Rochester, MN 55906
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
fw.writeToFile('% Rocky Creek Dr. NE')
fw.writeToFile('% Rochester, MN 55906, USA')
fw.writeToFile('%')
fw.writeToFile('% Email: richard.cui@utoronto.ca')
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