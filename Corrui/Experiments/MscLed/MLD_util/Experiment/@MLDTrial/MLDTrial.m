classdef MLDTrial < ExpTrial
	% Class MLDTRIAL offers basic operations for the trial info collected in MLD experiments

	% Copyright 2013 Richard J. Cui. Created: Tue 05/07/2013  9:40:19.627 AM
	% $Revision: 0.1 $  $Date: Tue 05/07/2013  9:40:19.627 AM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
        db                      % database
        sname                   % session name
        trialtime               % length of trial
        trial_props             % trial properties
        num_conditions          % NumberCondition
        LuminanceLevel = 0;     % luminancne level, total darkness
    end % properties
 
    % the constructor
    methods 
        function this = MLDTrial(curr_exp, sname)
            % Inputs:
            %   sname   - session / block name
            this.sname = sname;
            this.db = curr_exp.db;
            this.import_basic_trial_vars;

            % import MLD trial vars
            % ---------------------
            vars = { 'trialtime', 'trial_props' };
            dat = curr_exp.db.Getsessvars(sname, vars);
                        
            if isfield(dat, 'trialtime')
                this.trialtime   = dat.trialtime;
            end % if
            
            if isfield(dat, 'trial_props')
                this.trial_props  = dat.trial_props;
            end % if
            
        end
    end % methods
    
    % other methods
    methods
        tp_size = trial_props_size(this)

    end % methods
    
    methods ( Static )
        trial_props_enum = getEnum()    
        trial_props = getprops( timestamps, isInTrialCond, isInTrialSequence )
        num_cond = getNumberCondition()
    end % static methods
end % classdef

% [EOF]
