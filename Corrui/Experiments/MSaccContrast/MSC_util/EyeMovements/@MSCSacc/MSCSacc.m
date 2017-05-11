classdef MSCSacc < EyeSacc
    % Class MSCSACC Basic operations for the saccade data collected in AEC experiments
    
    % Copyright 2013-2016 Richard J. Cui. Created:Sun 05/26/2013 12:56:33.517 PM
    % $Revision: 0.2 $  $Date: Thu 08/04/2016  9:54:05.715 PM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com
    
    properties
        sname
        db
    end % properties
    
    % the constructor
    methods
        function this = MSCSacc(curr_exp, sname)
            % Inputs:
            %   sname   - session / block name
            this.db = curr_exp.db;
            this.sname = sname;
            
            this.read_basic_eyesacc_vars;
        end
    end % methods
    
    % other methods
    methods
        saccade_props = getprops( this, general_saccade_props, isInTrialNumber, isInTrialCond, isInCycle, isInTrialStage ) % MSC specific saccade_props
    end % methods
    
    methods ( Static )
        [props_enum, props_size] = getEnum()
    end % static methods
end % classdef

% [EOF]
