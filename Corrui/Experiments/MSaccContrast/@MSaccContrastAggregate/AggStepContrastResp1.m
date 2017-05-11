function [mn se] = AggStepContrastResp( curr_exp, sessionlist, S)
% AGGSTEPCONTRASTRESP aggregates variables for step cotnrast response
%       analysis
%
% Syntax:
%   [mn se] = AggStepContrastResp( curr_exp, sessionlist, S)
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

% Copyright 2012 Richard J. Cui. Created: Tue 06/12/2012 10:13:50.468 AM
% $Revision: 0.2 $  $Date: Thu 06/21/2012 10:25:31.238 AM $
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

% % =======================================================
% % change to dbDirectory
% % =======================================================
% old_path = pwd;
% dbdir = getpref('corrui','dbDirectory');
% cd(dbdir)

numSess = length(sessionlist);  % number of sessions
vars = {'StepContrastAnalysisResult'};

% =======================================================
% (1) DynamicFiringRate - firing rate for selected trials (no usacc)
% =======================================================
dfr = [];
for k = 1:numSess
    % data = load([sessionlist{k} '_DynamicFiringRate']);  % in arcmin
    data = CorruiDB.Getsessvars(sessionlist{k}, vars);
    dfr_k = data.StepContrastAnalysisResult.DynamicFiringRate;
    dfr = cat(3, dfr, dfr_k);
end % for

% average
mean_dfr = nanmean(dfr, 3);
% std
std_dfr  = nanstd(dfr, 0, 3);
% sem
sem_dfr = std_dfr/sqrt(numSess);

% =======================================================
% (2) noExcludeFR - firing rate for all trials
% =======================================================
nefr = [];
for k = 1:numSess
    data = CorruiDB.Getsessvars(sessionlist{k}, vars);
    nefr_k = data.StepContrastAnalysisResult.NoExcludeFR;
    nefr = cat(3, nefr, nefr_k);
end % for

% average
mean_nefr = nanmean(nefr, 3);
% std
std_nefr = nanstd(nefr, 0, 3);
% sem
sem_nefr = std_nefr/sqrt(numSess);

% =======================================================
% (3) window centers
% =======================================================
data = CorruiDB.Getsessvars(sessionlist{1}, vars);
WindowCenters = data.StepContrastAnalysisResult.WindowCenters;

% =======================================================
% (4) ConEnvVars
% =======================================================
% data = load([sessionlist{1} '_lastConChunk']);
data = CorruiDB.Getsessvars(sessionlist{1}, {'LastConChunk'});
ConEnvVars = data.LastConChunk.ConEnvVars;

% =======================================================
% (5) UsaccOnlyTrialFR - firing rate for usacc trials only
% =======================================================
uofr = [];
for k = 1:numSess
    data = CorruiDB.Getsessvars(sessionlist{k}, vars);
    uofr_k = data.StepContrastAnalysisResult.UsaccOnlyTrialFR;
    uofr = cat(3, uofr, uofr_k);
end % for

% average
mean_uofr = nanmean(uofr, 3);
% std
std_uofr = nanstd(uofr, 0, 3);
% sem
sem_uofr = std_uofr/sqrt(numSess);


% % =======================================================
% % change back to old path
% % =======================================================
% cd(old_path)

% =======================================================
% commit results
% =======================================================
mn.AggDynamicFiringRate.mean    = mean_dfr;     % selected no usacc trials
mn.AggDynamicFiringRate.std     = std_dfr;
mn.AggDynamicFiringRate.sem     = sem_dfr;

mn.AggNoExcludeFR.mean    = mean_nefr;          % all trials
mn.AggNoExcludeFR.std     = std_nefr;
mn.AggNoExcludeFR.sem     = sem_nefr;

mn.AggUsaccOnlyTrialFR.mean     = mean_uofr;    % selected trials usacc only
mn.AggUsaccOnlyTrialFR.std      = std_uofr;
mn.AggUsaccOnlyTrialFR.sem      = sem_uofr;

mn.AggWindowCenters    = WindowCenters;

mn.ConEnvVars   = ConEnvVars;

se = [];

end % function MSaccStat

% [EOF]
