classdef MSCDrift < EyeDrift
	% Class MSCDRIFT offers basic operations for the drift data collected in MSC experiments

	% Copyright 2014-2016 Richard J. Cui. Created: Thu 02/06/2014 12:10:18.316 AM
	% $Revision: 0.3 $  $Date: Thu 08/18/2016  7:58:49.993 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
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
        [props_enum, props_size] = getEnum()
    end % static methods
end % classdef

% [EOF]
