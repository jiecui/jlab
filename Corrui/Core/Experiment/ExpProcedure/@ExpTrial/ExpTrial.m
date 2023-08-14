classdef ExpTrial < handle
	% Class EXPTRIAL (summary)

	% Copyright 2014 Richard J. Cui. Created: 03/25/2014  4:18:57.190 PM
	% $Revision: 0.1 $  $Date: 03/25/2014  4:18:57.190 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    % =====================================================================
    % properties
    % =====================================================================
    properties (Abstract = true)
        db          % database
        sname       % session name
    end % abstract properties
    
    properties 
        enum                    % for data selection
        samplerate              % Fs
    end % properties
 
    % =====================================================================
    % methods
    % =====================================================================
    methods 
        function this = ExpTrial()
 
        end
    end % methods
    
    methods
        tp_size = trial_props_size(this)
        trial_props = getprops( this, trialMatrix, samplerate, left_fixation_props, right_fixation_props, enum_input )
        import_basic_trial_vars(this)
    end 
    
    methods (Static = true)
        trial_props_enum = getEnum()
    end % static methods
    
end % classdef

% [EOF]
