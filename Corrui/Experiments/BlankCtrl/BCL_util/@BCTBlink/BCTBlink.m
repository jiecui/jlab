classdef BCTBlink < EyeBlink
	% Class BCTBLINK offers basic operations for the saccade data collected in BCT experiments

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
        enum                % for data selection
        samplerate          % Fs
        left_blink_props    % left eye blink properties
        right_blink_props   % right eye blink properties
    end % properties
 
    % the constructor
    methods 
        function this = BCTBlink(sname)
            % Inputs:
            %   sname   - session / block name

            % read the data in
            % ----------------
            vars = { 'enum', 'samplerate', 'left_blink_props', 'right_blink_props' };
            dat = CorruiDB.Getsessvars(sname, vars);
            
            if isfield(dat, 'enum')
                this.enum               = dat. enum;
            end
            
            if isfield(dat, 'samplerate')
                this.samplerate         = dat.samplerate;
            end
            
            if isfield(dat, 'left_blink_props')
                this.left_blink_props   = dat.left_blink_props;
            end % if
            
            if isfield(dat, 'right_blink_props')
                this.right_blink_props  = dat.right_blink_props;
            end % if
            
        end
    end % methods
    
    % other methods
    methods

    end % methods
    
    methods ( Static )
        blink_props_enum = getEnum()   
        blink_props = getprops( blinkYesNo, samplerate, isInTrialSequence, isInTrialCond, em_events, enum_event )
        bp_size = blink_props_size()
    end % static methods
end % classdef

% [EOF]
