function writeClassFile(classname,superclass)
% WRITECLASSFILE uses a Filewriter object to write a class template

% Adapted from Matlab
% Copyright 2014-2020 Richard J. Cui. Created: Sun 11/16/2014 10:45:20.718 AM
% $Revision: 0.7 $  $Date: Tue 04/07/2020  6:21:16.815 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% ask user to provide classname
if nargin < 1
    classname = input('Please input Class name [myNewClass]: ','s');
    if isempty(classname)
        classname = 'myNewClass';
    end % if
end % if

if nargin < 2
    superclass = input('Please input Superclass name, if applicable [handle]: ','s');
    if isempty(superclass)
        superclass = 'handle';
    end % if
end % if

filename = [classname '.m'];
fw = Filewriter(filename);

if nargin > 1 || ~isempty(superclass)
    fw.writeToFile(['classdef ' classname ' < ' superclass])
else
    fw.writeToFile(['classdef ' classname])
end

% summary
fw.writeToFile(sprintf('\t%% Class %s (summary)',upper(classname)))
% copywrite infomation
fw.writeToFile('')
fw.writeToFile(sprintf('\t%% Copyright %s Richard J. Cui. Created: %s',...
    datestr(now, 'yyyy'), datestr(now,'ddd mm/dd/yyyy HH:MM:SS.FFF AM')))
fw.writeToFile(sprintf('\t%% $Revision: 0.1 $  $Date: %s $',...
    datestr(now,'ddd mm/dd/yyyy HH:MM:SS.FFF AM')))
fw.writeToFile(sprintf('\t%%'))
fw.writeToFile(sprintf('\t%% Multimodel Neuroimaging Lab (Dr. Dora Hermes)'))
fw.writeToFile(sprintf('\t%% Mayo Clinic St. Mary Campus'))
fw.writeToFile(sprintf('\t%% Rochester, MN 55905, USA'))
fw.writeToFile(sprintf('\t%%'))
fw.writeToFile(sprintf('\t%% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)'))
fw.writeToFile('')

% class body
fw.writeToFile('    properties ')
fw.writeToFile(' ')
fw.writeToFile('    end % properties')
fw.writeToFile(' ')
fw.writeToFile('    methods ')
fw.writeToFile(['        function this = ' classname '()'])
fw.writeToFile(' ')
fw.writeToFile('        end')
fw.writeToFile('    end % methods')
fw.writeToFile('end % classdef')
fw.writeToFile('')
fw.writeToFile('% [EOF]')

delete(fw) % Delete object, which closes file

% open editor
edit(filename)

end

% [EOF]