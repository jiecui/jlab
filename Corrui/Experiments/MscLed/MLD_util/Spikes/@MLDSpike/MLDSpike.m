classdef MLDSpike < SpikeProcess.SpikeRateEstimation % handle
	% Class MLDSPIKE offers basic operations for spike information

	% Copyright 2013 Richard J. Cui. Created: 04/25/2013  4:05:20.493 PM
	% $Revision: 0.1 $  $Date: 04/25/2013  4:05:20.493 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
        enum            % for data selection
        samplerate      % Fs
        spiketimes      % info of spike times
    end % properties
 
    % the constructor
    methods 
        function this = MLDSpike(sname)
            vars = { 'enum',  'samplerate', 'spiketimes' };
            dat = CorruiDB.Getsessvars(sname, vars);
            
            if isfield(dat, 'enum')
                this.enum               = dat.enum;
            end
            
            if isfield(dat, 'samplerate')
                this.samplerate         = dat.samplerate;
            end
            
            if isfield(dat, 'spiketimes')
                this.spiketimes         = dat.spiketimes;
            end
            
        end
    end % methods
    
    % other method
    methods
        
    end 
    
end % classdef

% [EOF]
