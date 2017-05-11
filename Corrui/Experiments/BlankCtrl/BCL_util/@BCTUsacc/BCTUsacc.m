classdef BCTUsacc < EyeUsacc
	% Class BCTUSACC offers basic operations for the microsaccade data collected in BCT experiments

	% Copyright 2013 Richard J. Cui. Created: Mon 05/06/2013 11:40:33.064 AM
	% $Revision: 0.1 $  $Date: Mon 05/06/2013 11:40:33.064 AM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 

    end % properties
 
    % the constructor
    methods 
        function this = BCTUsacc(sname)
            % Inputs:
            %   sname   - session / block name

            % read the data in
            % ----------------
            vars = { 'enum', 'samplerate', 'left_usacc_props', 'right_usacc_props' };
            dat = CorruiDB.Getsessvars(sname, vars);
            
            if isfield(dat, 'enum')
                this.enum               = dat. enum;
            end
            
            if isfield(dat, 'samplerate')
                this.samplerate         = dat.samplerate;
            end
            
            if isfield(dat, 'left_usacc_props')
                this.left_usacc_props   = dat.left_usacc_props;
            end % if
            
            if isfield(dat, 'right_usacc_props')
                this.right_usacc_props  = dat.right_usacc_props;
            end % if
            
        end
    end % methods
    
    % other methods
    methods

    end % methods
    
    methods ( Static )
        usacc_props_enum = getEnum()    
        usacc_props = getprops( eyedat, usac , samplerate, isInTrialSequence, isInTrialCond, em_events, enum_event )
        up_size = usacc_props_size()     % overwrite
    end % static methods
end % classdef

% [EOF]
