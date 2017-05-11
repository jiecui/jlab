classdef NeuSpike < SpikeProcess.SpikeRateEstimation & SpikeProcess.SpikeSpectrumEstimation & SpikeProcess.SpikeSpectrogramEstimation
	% Class NEUSPIKE parent class for all experiment depended 'spike time' events.

	% Copyright 2014 Richard J. Cui. Created: 05/29/2013  4:36:05.965 PM
	% $Revision: 0.3 $  $Date: Mon 10/20/2014 11:31:05.312 PM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com
    
    properties (Abstract = true)
        
    end % abstract properties
    
    properties
        sname           % session name
        db              % database of the experiment
        enum            % for data selection
        samplerate      % Fs
        spiketimes      % info of spike times
    end % properties
 
    methods 
        function this = NeuSpike(sname, db)
            this.sname = sname;
            this.db = db;
        end
    end % methods

    methods
        import_basic_spike_vars(this)
        spkt = getSpktimes(this)

    end

    methods (Static)
        out_enum = getEnum(in_enum)
    end % static methods
end % classdef

% [EOF]
