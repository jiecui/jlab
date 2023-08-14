classdef Spike < handle
	% Class SPIKE parent class for all 'spike time' events.

	% Copyright 2014 Richard J. Cui. Created: 05/29/2013  4:36:05.965 PM
	% $Revision: 0.2 $  $Date: Sat 03/29/2014 10:13:13.325 AM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
 
    end % properties
 
    methods 
        function this = Spike()
 
        end
    end % methods

    methods
        dat = detect_spike_events( this, sname, S, import_variables )

    end

    methods (Static)
        spkidx = getSpktimeInd(timestamps, spiketimes, Fs)

    end % static methods
end % classdef

% [EOF]
