classdef MSCUsacc < EyeUsacc
    % Class MSCUSACC offers basic operations for the microsaccade data collected in MSC experiments
    
    % Copyright 2013-2016 Richard J. Cui. Created: 04/24/2013  4:20:50.446 PM
    % $Revision: 0.3 $  $Date: Thu 08/04/2016  9:54:05.715 PM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com
    
    properties
        sname       
        db          % database
    end % properties
    
    % the constructor
    methods
        function this = MSCUsacc(curr_exp, sname)
            % Inputs:
            %   curr_exp    - current experiment
            %   sname       - session / block name
            this.sname = sname;
            this.db = curr_exp.db;
            this.read_basic_eyeusacc_vars;
        end
    end % methods
    
    % other methods
    methods        
        usacc_props = getprops( this, general_usacc_props, isInTrialNumber, isInTrialCond, isInCycle, isInTrialStage ) % MSC specific usacc_props
    end % methods
    
    methods ( Static )
        [props_enum, props_size] = getEnum()
    end % static methods
end % classdef

% [EOF]
