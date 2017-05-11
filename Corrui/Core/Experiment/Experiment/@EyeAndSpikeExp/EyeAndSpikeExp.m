classdef EyeAndSpikeExp < EyeMovementExp & Spike
	% Class EYEANDSPIKEEXP experiment to study correlation between eye movement and spike activity 

	% Copyright 2014 Richard J. Cui. Created: 03/15/2014  7:24:33.571 PM
	% $Revision: 0.2 $  $Date: Mon 11/17/2014  4:12:43.125 PM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
 
    end % properties
 
    methods 
        function this = EyeAndSpikeExp()
            % Prefix for the name of the sessions from this experiment
            this.prefix = 'EAS';
            
            % Name of the experiment (can contain spaces)
            this.name = 'Eye-Spike Experiment';
            
            % which files can be imported for this type of experiment
            this.filetypes = { };

        end
    end % methods
end % classdef

% [EOF]
