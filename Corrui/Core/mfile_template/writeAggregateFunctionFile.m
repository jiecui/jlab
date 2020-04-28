function writeAggregateFunctionFile(funname)
% WRITEAGGREGATEFUNCTIONFILE uses a Filewriter object to write a function template for jLAB aggregate function

% Adapted from Matlab
% Copyright 2015-2020 Richard J. Cui. Created: Mon 02/09/2015 10:11:40.240 PM
% $Revision: 0.8 $  $Date: Mon 04/27/2020 10:28:43.107 PM $
%
% Multimodal Neuroimaging Lab (Dr. Dora Hermes)
% Mayo Clinic St. Mary Campus
% Rochester, MN 55905, USA
%
% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)

% ask user to provide the file and class names
% ---------------------------------------------
if nargin < 1
    funname = input('Please input function of aggregate name [myNewAggregateFun]: ','s');
    if isempty(funname)
        funname = 'myNewAggregateFun';
    end % if
    
    funclassname = input('Please input the name of aggregate class [myAggregateClass]: ','s');
    if isempty(funclassname)
        funclassname = 'myAggregateClass';
    end % if
end % if

filename = [funname '.m'];
fw = Filewriter(filename);

% write template file
% -------------------
% syntax of function of analysis
fun_syn = sprintf('[mn, se] = %s(curr_tag, sessionlist, S)', funname);
fw.writeToFile(['function ' fun_syn])

% summary
fw.writeToFile(sprintf('%% %s.%s (summary)',upper(funclassname), upper(funname)))
fw.writeToFile('%')
fw.writeToFile('% Syntax:')
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
fw.writeToFile('% Multimodal Neuroimaging Lab (Dr. Dora Hermes)')
fw.writeToFile('% Mayo Clinic St. Mary Campus')
fw.writeToFile('% Rochester, MN 55905, USA')
fw.writeToFile('%')
fw.writeToFile('% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)')

% options of the funtion
fw.writeToFile('')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% Input options')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% specific options for the current process')
fw.writeToFile('if nargin == 1')
fw.writeToFile(sprintf('\tswitch( curr_tag )'))
fw.writeToFile(sprintf('\t\tcase ''get_options'''))
fw.writeToFile('')
fw.writeToFile(sprintf('\t\t\t%% opt.select = { {''{0}'', ''1''} };\t%% select this or not'))
fw.writeToFile(sprintf('\t\t\t%% mn = opt;'))
fw.writeToFile('')
fw.writeToFile(sprintf('\t\t\tmn = { {''{0}'', ''1''} };\t%% select this or not;'))
fw.writeToFile('')
fw.writeToFile(sprintf('\t\treturn'))
fw.writeToFile(sprintf('\tend %% switch'))
fw.writeToFile('end % if')

% get options
fw.writeToFile('')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% Get the options')
fw.writeToFile('% =========================================================================')

% main function body
fw.writeToFile('')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% Main process')
fw.writeToFile('% =========================================================================')
fw.writeToFile('if isobject(current_tag) == true')
fw.writeToFile('    curr_exp = current_tag;')
fw.writeToFile('end % if')
fw.writeToFile('')
fw.writeToFile('se = [];')
fw.writeToFile('')
fw.writeToFile('mn = AggExample(curr_exp, sessionlist, S);')
fw.writeToFile('')
fw.writeToFile(sprintf('end %% function %s',funname))

% subroutines
fw.writeToFile('')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% Subroutines')
fw.writeToFile('% =========================================================================')
fw.writeToFile('function mn = AggExample(curr_exp, sessionlist, S)')
fw.writeToFile('')
fw.writeToFile('this = curr_exp.aggregateClass;')
fw.writeToFile('n_sess = length(sessionlist); % number of session')
fw.writeToFile('')
fw.writeToFile('% ----------------------------')
fw.writeToFile('% copy')
fw.writeToFile('% ----------------------------')
fw.writeToFile('% S.Copy = [];')
fw.writeToFile('% S.Copy.select = true;')
fw.writeToFile('% S.Copy.options.example = true;')
fw.writeToFile('% mn_copy = this.Copy(curr_exp, sessionlist, S);')
fw.writeToFile('')
fw.writeToFile('% -------------------------')
fw.writeToFile('% concatenate')
fw.writeToFile('% -------------------------')
fw.writeToFile('% S.Concatenate = [];')
fw.writeToFile('% S.Concatenate.options.example = true;')
fw.writeToFile('% mn_concatenate = this.Concatenate(curr_exp, sessionlist, S);')
fw.writeToFile('')
fw.writeToFile('% -------------------------')
fw.writeToFile('% Other data aggregate')
fw.writeToFile('% -------------------------')
fw.writeToFile('')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% Commit')
fw.writeToFile('% =========================================================================')
fw.writeToFile('% mn = mergestructs(mn_copy, mn_concatenate, mn_lrconcate);')
fw.writeToFile('% mn = mn_concatenate;')
fw.writeToFile('mn = [];')
fw.writeToFile('')
fw.writeToFile('end % AggSpect')
fw.writeToFile('')
fw.writeToFile('% [EOF]')

% close file
% ------------
delete(fw) % Delete object, which closes file

% open editor
edit(filename)

end

% [EOF]