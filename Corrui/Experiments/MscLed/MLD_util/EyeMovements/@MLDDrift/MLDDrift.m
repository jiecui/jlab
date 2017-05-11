classdef MLDDrift < EyeDrift
	% Class MLDDRIFT offers basic operations for the drift data collected in MLD experiments

	% Copyright 2014 Richard J. Cui. Created: Thu 02/06/2014 12:10:18.316 AM
	% $Revision: 0.2 $  $Date: Thu 04/17/2014  8:35:58.541 AM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
        db              % database
        sname           % session name
    end % properties
 
    % the constructor
    methods 
        function this = MSCDrift(curr_exp, sname)
            % Inputs:
            %   sname   - session / block name
            this.db = curr_exp.db;
            this.sname = sname;
            this.import_basic_drift_vars;
        end
    end % methods
    
    % other methods
    methods

    end % methods
    
    methods ( Static )

    end % static methods
end % classdef

% [EOF]
