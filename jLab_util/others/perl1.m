function [result status] = perl1(cmdString)
%PERL1 Execute Perl command and return the result.
% PERL1(COMMANDSTRING) calls perl with options in COMMANDSTRING
% PC only...
perlCmd = fullfile(matlabroot, 'sys\perl\win32\bin\');
cmdString = ['perl ' cmdString];
perlCmd = ['set PATH=',perlCmd, ';%PATH%&' cmdString];
[status, result] = dos(perlCmd);