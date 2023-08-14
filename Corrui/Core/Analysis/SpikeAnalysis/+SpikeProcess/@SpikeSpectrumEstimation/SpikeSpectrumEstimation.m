classdef SpikeSpectrumEstimation < handle
	% Class SPIKESPECTRUMESTIMATION provides tools for estimating spike spectrum

	% Copyright 2014 Richard J. Cui. Created: Wed 10/22/2014  9:45:48.490 AM
	% $Revision: 0.1 $  $Date: Wed 10/22/2014  9:45:48.599 AM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
 
    end % properties
 
    methods 
        function this = SpikeSpectrumEstimation()
 
        end
    end % methods
    
    methods (Static)
        [S, f, R, Serr] = ChronuxSpikeSpectrum(spiketimes, num_trials, trial_length, mt_params)
        
    end % methods static
end % classdef

% [EOF]
