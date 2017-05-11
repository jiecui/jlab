classdef MSaccContrastAggregate < EyeMovementAggregate
	% Class MSACCCONTRASTAGGREGATE (summary)

	% Copyright 2012-2014 Richard J. Cui. Created: 03/20/2012  5:57:58.270 PM
	% $Revision: 0.2 $  $Date: Thu 10/23/2014  1:20:40.119 PM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
 
    end % properties
 
    methods
        function this = MSaccContrastAggregate()
            
        end
    end % methods
    
    methods (Static)
        [ag, se] = AggMSaccStat( curr_exp, sessionlist, S)
        [mn, se] = AggStepContrastResp( curr_exp, sessionlist, S)
        [mn, se] = AggTrialNumAnalysisPool( curr_exp, sessionlist, S)
        [mn, se] = AggAssembleResponseSortedTrials( curr_exp, sessionlist, S)
        [mn, se] = AggResponseSortedPercentage( curr_exp, sessionlist, S)
        [mn, se] = AggUsaccTriggeredContrastResponse( curr_exp, sessionlist, S)
        [mn, se] = AggMSCFRChange( curr_exp, sessionlist, S)
        [mn, se] = AggCombineSCMT( curr_exp, sessionlist, S)
        [mn, se] = AggMSAdaptation( curr_exp, sessionlist, S)
        [mn, se] = AggUsaccTriggered1stPeak( curr_exp, sessionlist, S)
        [mn, se] = AggUsaccTriggered2ndPeak( curr_exp, sessionlist, S)
        [mn, se] = AggUsaccTriggered1stTrough( curr_exp, sessionlist, S)
        [mn, se] = AggMSTrigContResp( curr_exp, sessionlist, S)
        [mn, se] = AggSaccadeProps(curr_exp, sessionlist, S)
        [mn, se] = AggMSTrigSpikeSpecgram( curr_exp, sessionlist, S)
    end % static methods
    
end % classdef

% [EOF]
