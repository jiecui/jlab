function [mn se] = AggUsaccTriggered1stPeak( curr_exp, sessionlist, S)
% AGGUSACCTRIGGERED1STPEAK Assembles the results for 1st peak of MS-triggered response analysis
% 
% Syntax:
%   [mn se] = AggUsaccTriggered1stPeak( curr_exp, sessionlist, S)
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

% Copyright 2013 Richard J. Cui. Created: Mon 03/04/2013  3:27:26.173 PM
% $Revision: 0.1 $  $Date: Mon 03/04/2013  3:27:26.173 PM $
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
% read the variable
numSess = length(sessionlist);  % number of sessions

% aggreate
% =========================================================================
% Spike Rate Difference
% =========================================================================
vars = {'UsaccTriggered1stPeak'};

SpikeRate = [];
SpikeRateDiff = [];
for k = 1:numSess
    data = CorruiDB.Getsessvars(sessionlist{k}, vars);
    spk_k = data.UsaccTriggered1stPeak.SpikeRate;
    spkdiff_k = data.UsaccTriggered1stPeak.SpikeRateDiff;
    
    SpikeRate = cat(3, SpikeRate, spk_k);
    SpikeRateDiff   = cat(3, SpikeRateDiff, spkdiff_k);
    
end % for


% =========================================================================
% SpikeRateWinCenter and other parameters
% =========================================================================
vars = {'UsaccTriggeredContrastResponse'};

data = CorruiDB.Getsessvars(sessionlist{1}, vars);
spk_c = data.UsaccTriggeredContrastResponse.SpikeRateWinCenter;
grattime = data.UsaccTriggeredContrastResponse.Paras.GratTime;
post_onset = data.UsaccTriggeredContrastResponse.Paras.PostOnsetIntv;
pre_ms = data.UsaccTriggeredContrastResponse.Paras.PreMSIntv;
post_ms = data.UsaccTriggeredContrastResponse.Paras.PostMSIntv;
trl_len = data.UsaccTriggeredContrastResponse.Paras.TrialLength;

% =======================================================
% commit results
% =======================================================
mn.SpikeRate            = SpikeRate;        % levels x signals x cells
mn.SpikeRateDiff        = SpikeRateDiff;    % levels x signals x cells

mn.SpikeRateWinCenter   = spk_c;
mn.GratTime             = grattime;
mn.PostOnsetIntv        = post_onset;
mn.PreMSIntv            = pre_ms;
mn.PostMSIntv           = post_ms;
mn.TrialLength          = trl_len;

se = [];

end % function MSaccStat

% =========================================================================
% subroutines
% =========================================================================

% [EOF]
