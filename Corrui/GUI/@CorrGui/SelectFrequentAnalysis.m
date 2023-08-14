function [stage2Opt1, stage2Opt2] = SelectFrequentAnalysis(curr_exp, stage2Opt)
% CORRGUI.SELECTFREQUENTANALYSIS Select to display the most popular analyses
%
% Syntax:
%   [stage2Opt1, stage2Opt2] = SelectFrequentAnalysis(curr_exp, stage2Opt)
% 
% Input(s):
%   curr_exp    - Current experiment tag / object
%   stage2Opt   - options of stage 2 process
% 
% Output(s):
%   stage2Opt1  - options of stage 2 process part 1
%   stage2Opt2  - options of stage 2 process part 2
% 
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2015 Richard J. Cui. Created: Sun 10/18/2015  3:21:12.086 PM
% $Revision: 0.1 $  $Date: Sun 10/18/2015  3:21:12.089 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% get exp obj
curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag

% parse inputs
if ( isempty( stage2Opt ) )
    stage2Opt1 = [];
    stage2Opt2 = [];
end

analysisList = curr_exp.getProcessAnalysisList();   % Note: at least one analysis fun should be provided
if isempty(analysisList)
    stage2Opt1 = [];
    stage2Opt2 = [];    
    return
end % if

% select now
analysis_counts = getpref('corrui', ['analysis_counts_' class(curr_exp)] , []);

% if analysis_counts has never been saved, initialize
for i=1:length(analysisList)
    if ~isfield( analysis_counts, analysisList{i})
        analysis_counts.(analysisList{i}) = 0;
    end
end

% get the analysis_counts into an array
fields = fieldnames(analysis_counts);
counts = zeros(1,length(fields));
for i=1:length(fields)
    counts(i) = analysis_counts.(fields{i});
end

% select a threshold
counts = -sort(-counts(counts>0));
if ( ~isempty(counts) )
    if ( length(counts) > 12 )
        th = counts(10);
    else
        th = min(counts);
    end
else
    th = 0;
end

% for each plot
analysis = fieldnames(stage2Opt);
i = 0;
while i < numel(analysis)
    i = i+1;
    if ( isempty(intersect(analysisList, analysis{i})) || (isfield(analysis_counts, analysis{i}) && analysis_counts.(analysis{i})  >= th ))
        stage2Opt1.(analysis{i}) = stage2Opt.(analysis{i});
        if ( i<length(analysis) && strcmp(analysis{i+1}, [analysis{i} '_options'] )  )
            stage2Opt1.(analysis{i+1}) = stage2Opt.(analysis{i+1});
            i = i+1;
        end
    else
        stage2Opt2.(analysis{i}) = stage2Opt.(analysis{i});
        if ( i<length(analysis) && strcmp(analysis{i+1}, [analysis{i} '_options'] )  )
            stage2Opt2.(analysis{i+1}) = stage2Opt.(analysis{i+1});
            i = i+1;
        end
    end
end

if ( ~exist('stage2Opt2','var') )
    stage2Opt2 = [];
end

end % function SelectFrequentAnalysis

% [EOF]
