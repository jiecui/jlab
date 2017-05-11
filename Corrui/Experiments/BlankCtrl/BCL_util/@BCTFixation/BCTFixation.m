classdef BCTFixation < EyeFixation
	% Class BCTFIXATION offers basic operations for the fixation data collected in BCT experiments

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
        enum                    % for data selection
        samplerate              % Fs
        left_fixation_props     % left eye fixation properties
        right_fixation_props    % right eye fixation properties
    end % properties
 
    % the constructor
    methods 
        function this = BCTFixation(sname)
            % Inputs:
            %   sname   - session / block name

            % read the data in
            % ----------------
            vars = { 'enum', 'samplerate', 'left_fixation_props', 'right_fixation_props' };
            dat = CorruiDB.Getsessvars(sname, vars);
            
            if isfield(dat, 'enum')
                this.enum               = dat. enum;
            end
            
            if isfield(dat, 'samplerate')
                this.samplerate         = dat.samplerate;
            end
            
            if isfield(dat, 'left_fixation_props')
                this.left_fixation_props   = dat.left_fixation_props;
            end % if
            
            if isfield(dat, 'right_fixation_props')
                this.right_fixation_props  = dat.right_fixation_props;
            end % if
            
        end
    end % methods
    
    % other methods
    methods

    end % methods
    
    methods ( Static )
        fixation_props_enum = getEnum()   
        fixation_props = getprops( blinkYesNo, saccadeYesNo, isInTrial, isInTrialSequence, isInTrialCond, samplerate, usacc_props, enum_usacc_props )
        fp_size = fixation_props_size()
    end % static methods
end % classdef

% [EOF]
