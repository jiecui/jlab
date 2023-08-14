function dat = preload_analysis_vars( this, sname, S, analysis_name )
% EXPERIMENT.PRELOAD_ANALYSIS_VARS preload var data for analysis
%
% Syntax:
%
% Input(s):
%   this            - Experiment object
%   sname           - session name
%   S               - options
%   analysis_name   - name of analysis (cell array)
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: 03/17/2014  9:30:27.070 AM
% $Revision: 0.3 $  $Date: Sun 04/20/2014  3:51:15.341 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

if ~exist('analysis_name', 'var')
    analysis_name = this.getProcessAnalysisList();
end % if

analysis_vars = {};
for  i =  1:length(analysis_name)
    try
        if isfield(S.Stage_2_Options, ( analysis_name{i} ) ) && S.Stage_2_Options.(analysis_name{i})
            % vars = this.analysisClass.(analysis_name{i})('get_big_vars_to_load');
            vars = this.analysisClass.(analysis_name{i})('get_big_vars_to_load',[],S);  % RJC Sun 09/11/2011  7:09:30 PM
            if ( ~isempty(vars) )
                analysis_vars = union(analysis_vars, vars);
            end
        end
    catch err
        fprintf('Cannot load vars in analysis %s\n', analysis_name{i})
        err.getReport()
        rethrow(err)
    end
end

% load the variables
dat = this.db.getsessvars(sname, analysis_vars);


end % function preload_analysis_vars

% [EOF]
