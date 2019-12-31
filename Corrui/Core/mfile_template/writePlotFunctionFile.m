function writePlotFunctionFile(funname)
% WRITEPLOTFUNCTIONFILE uses a Filewriter object to write a function template for SPLCorrui plot function

% Adapted from Matlab
% Copyright 2015-2016 Richard J. Cui. Created: Mon 02/09/2015 10:11:40.240 PM
% $Revision: 0.5 $  $Date: Mon 12/30/2019 10:10:39.249 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.cui@utoronto.ca

% ask user to provide the file and class names
% ---------------------------------------------
if nargin < 1
    funname = input('Please input function of plot name [myNewPlotFun]: ','s');
    if isempty(funname)
        funname = 'myNewPlotFun';
    end % if
    
    funclassname = input('Please input the name of plot class [myPlotClass]: ','s');
    if isempty(funclassname)
        funclassname = 'myPlotClass';
    end % if
end % if

filename = [funname '.m'];
fw = Filewriter(filename);

% syntax of function of analysis
fun_syn = sprintf('result_dat = %s(current_tag, sname, S)', funname);
fw.writeToFile(['function ' fun_syn])

% write template file
% -------------------
% summary
fw.writeToFile(sprintf('%% %s.%s (summary)',upper(funclassname), upper(funname)))
fw.writeToFile('%')
fw.writeToFile('% Syntax:')
fw.writeToFile(sprintf('%%   %s', fun_syn))
fw.writeToFile('%')
fw.writeToFile('% Input(s):')
fw.writeToFile('%')
fw.writeToFile('% Output(s):')
fw.writeToFile('%')
fw.writeToFile('% Example:')
fw.writeToFile('%')
fw.writeToFile('% See also .')

% copywrite infomation
fw.writeToFile('')
fw.writeToFile(sprintf('%% Copyright %s Richard J. Cui. Created: %s',...
    datestr(now, 'yyyy'), datestr(now,'ddd mm/dd/yyyy HH:MM:SS.FFF AM')))
fw.writeToFile(sprintf('%% $ Revision: 0.1 $  $ Date: %s $',...
    datestr(now,'ddd mm/dd/yyyy HH:MM:SS.FFF AM')))
fw.writeToFile('%')
fw.writeToFile('% 1026 Rocky Creek Dr NE')
fw.writeToFile('% Rochester, MN 55906, USA')
fw.writeToFile('%')
fw.writeToFile('% Email: richard.cui@utoronto.ca')

% options of the funtion
fw.writeToFile('')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% Input parameters and options')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% specific options for the current process')
fw.writeToFile('if strcmpi(current_tag, ''get_options'')')
fw.writeToFile(sprintf('\t%% opt.example = {2, ''AR order'', [1 Inf]};'))
fw.writeToFile(sprintf('\topt = [];'))
fw.writeToFile(sprintf('\tresult_dat = opt;'))
fw.writeToFile('')
fw.writeToFile(sprintf('\treturn'))
fw.writeToFile('end % if')

% get options and data
fw.writeToFile('')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% Get options and parameters')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% example = S.([mfilename, ''_options'']).example;')

% get data
fw.writeToFile('')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% Get data')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% dat_var = { ''example_dat'' }')
fw.writeToFile('% dat = CorruiDB.Getsessvars(sname, dat_var);')
fw.writeToFile('% example_dat = dat.example_dat')

% main function body
fw.writeToFile('')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% Plot')
fw.writeToFile('% =========================================================================')
fw.writeToFile('')
fw.writeToFile(sprintf('end %% function %s',funname))

% subroutines
fw.writeToFile('')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% Subroutines')
fw.writeToFile('% =========================================================================')
fw.writeToFile('')
fw.writeToFile('% [EOF]')

% close file
% ------------
delete(fw) % Delete object, which closes file

% open editor
edit(filename)

end

% [EOF]