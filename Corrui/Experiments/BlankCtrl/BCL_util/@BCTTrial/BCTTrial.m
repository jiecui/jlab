classdef BCTTrial < ExpTrial
	% Class BCTTRIAL offers basic operations for the trial info collected in BCT experiments

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
        sname                   % session name
        enum                    % for data selection
        samplerate              % Fs
        trialtime               % length of trial
        trial_props             % trial properties
        num_conditions          % NumberCondition
        LuminanceLevel = [0 25 50 75 100];  % luminancne level
    end % properties
 
    % the constructor
    methods 
        function this = BCTTrial(sname)
            % Inputs:
            %   sname   - session / block name

            this.sname = sname;
            % read the data in
            % ----------------
            vars = { 'enum', 'samplerate', 'trialtime', 'trial_props' };
            dat = CorruiDB.Getsessvars(sname, vars);
            
            if isfield(dat, 'enum')
                this.enum               = dat. enum;
            end
            
            if isfield(dat, 'samplerate')
                this.samplerate         = dat.samplerate;
            end
            
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
