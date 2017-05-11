classdef MSCBlink < EyeBlink
	% Class MSCBLINK offers basic operations for the saccade data collected in MSC experiments

	% Copyright 2014-2016 Richard J. Cui. Created: Thu 02/06/2014 12:10:18.316 AM
	% $Revision: 0.3 $  $Date: Thu 08/04/2016  9:54:05.715 PM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com

    properties 
        db          % database
        sname       % session name
    end % properties
 
    % the constructor
    methods 
        function this = MSCBlink(curr_exp, sname)
            % Inputs:
            %   sname   - session / block name
            this.db = curr_exp.db;
            this.sname = sname;
            this.import_basic_blink_vars;
        end
    end % methods
    
    % other methods
    methods
        blink_props = getprops( this, general_blink_props,  isInTrialNumber, isInTrialCond, isInCycle, isInTrialStage )
    end % methods
    
    methods ( Static )
        [props_enum, props_size] = getEnum()
    end % static methods
end % classdef

% [EOF]
