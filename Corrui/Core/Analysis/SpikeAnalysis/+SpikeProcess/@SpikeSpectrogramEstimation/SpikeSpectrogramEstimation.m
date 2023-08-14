classdef SpikeSpectrogramEstimation < handle
	% Class SPIKESPECTRUMESTIMATION provides tools for estimating spike spectrogram

	% Copyright 2014 Richard J. Cui. Created: Wed 10/22/2014 11:28:47.717 AM
	% $Revision: 0.1 $  $Date: Wed 10/22/2014 11:28:47.717 AM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
 
    end % properties
 
    methods 
        function this = SpikeSpectrogramEstimation()
 
        end
    end % methods
    
    methods (Static)
        [S, t, f, R, Serr] = ChronuxSpikeSpectrogram(spiketimes, num_trials, trial_length, mt_params)
        
    end % methods static
end % classdef

% [EOF]
