function [mn se] = AggTrialNumAnalysisPool( curr_exp, sessionlist, S)
% AGGTRIALNUMANALYSISPOOL aggregates variables for step cotnrast response
%       analysis as a function of trial numbers
%
% Syntax:
%   [mn se] = AggTrialNumAnalysisPool( curr_exp, sessionlist, S)
% 
% Input(s):
%
% Output(s):
%   mn      - store
%   se      - not store
% 
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Wed 06/20/2012  8:49:22.313 AM
% $Revision: 0.1 $  $Date: Wed 06/20/2012  8:49:22.313 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% options
if ( nargin == 1 )
    switch( curr_exp)
        case 'get_options'
            % variables_avg = EyeMovementAggregate.get_variable_list( curr_exp, 'Average' );
            % 
            % options = [];
            % for i=1:length( variables_avg )
            %     options.(variables_avg{i}) = { {'{0}', '1'} };
            % end
            % mn = options;
            
            mn = { {'{0}', '1'} };
            
            return
    end
end

% =======
% main
% =======
% new_session_name    = S.Name_of_New_Averaged_Session;
% str = 'fixgridstat';
% disp(str)

% =======================================================
% change to dbDirectory
% =======================================================
% old_path = pwd;
% dbdir = getpref('corrui','dbDirectory');
% cd(dbdir)

% read the variable
numSess = length(sessionlist);  % number of sessions

% aggreate
% =======================================================
% (1) TrialNumAnalysisFR - firing rate and number of tirlas involved
% see StepContrastTrialNumAnalysis.m
% =======================================================
vars = {'TrialNumAnalysisFR'};

fr_5trl = [];       % max 5 trials
fr_10trl = [];      % max 10 trials
for k = 1:numSess
    % data = load([sessionlist{k} '_TiralNumAnalysisFR']);  
    data = CorruiDB.Getsessvars(sessionlist{k}, vars);
    fr_k = data.TrialNumAnalysisFR;
    maxtrlsize = size(fr_k,2);
    if maxtrlsize == 5
        fr_5trl = cat(4, fr_5trl, fr_k);
    elseif maxtrlsize == 10
        fr_10trl = cat(4, fr_10trl, fr_k);
    end % if
end % for

% =======================================================
% (2) window centers
% =======================================================
vars = {'WindowCenters'};
data = CorruiDB.Getsessvars(sessionlist{1}, vars);
wc = data.WindowCenters;

% =======================================================
% change back to old path
% =======================================================
% cd(old_path)

% =======================================================
% commit results
% =======================================================
mn.AggTrialNumAnalysisFR.max10trl  = fr_10trl;
mn.AggTrialNumAnalysisFR.max5trl  = fr_5trl;
mn.AggWindowCenters = wc;

se = [];

end % function MSaccStat

% [EOF]
