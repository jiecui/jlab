classdef SpikeRateEstimation < handle
	% Class SPIKERATEESTIMATION provides tools for estimating spike rate

	% Copyright 2012-2014 Richard J. Cui. Created: 06/11/2012  9:57:31.335 AM
	% $Revision: 0.2 $  $Date: Mon 10/20/2014 10:38:28.078 PM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 

    end % properties
 
    methods 
        function this = SpikeRateEstimation()
 
        end
    end % methods
    
    methods (Static)
        [win_centers, spk_rate, rate_mean, rate_sem] = PSTHEst(spktimes, num_trial, trl_length, win_width, win_step)
        [winc, fr] = ChronuxEst(SpikeYN, movingwin, params)
    end % methods statics
    
end % classdef

% [EOF]
