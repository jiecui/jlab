function opt = getProcessOptions( this )
% EXPERIMENT.GETPROCESSOPTIONS (summary)
%
% Syntax:
%
% Input(s):
%   this        - Experiment obj
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014-2016 Richard J. Cui. Created: 03/16/2014  8:55:26.986 PM
% $Revision: 0.2 $  $Date: Mon 07/11/2016  4:16:36.452 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com


% Parallel options -------------------------------------------
opt.Parallel_Process = { {'{0}','1'} };

c = parcluster('local');
opt.Parallel_Process_Options.Number_of_Workers  = c.NumWorkers;    % RJC Thu 03/31/2011  5:28:50 PM

% signal processing stages
opt.Do_Stage_0 = { {'{0}','1'} };
opt0 = this.getProcessStage0Options( );
if ~isempty(opt0)
    opt.Stage_0_Options = opt0;
end % if

opt.Do_Stage_1 = { {'{0}','1'} };
opt1 = this.getProcessStage1Options( );
if ~isempty(opt1)
    opt.Stage_1_Options = opt1;
end % if

opt.Do_Stage_2 = { {'{0}','1'} };
opt2 = this.getProcessStage2Options( );
if ~isempty(opt2)
    opt.Stage_2_Options = opt2;
end % if


end % function getProcessOptions

% [EOF]
