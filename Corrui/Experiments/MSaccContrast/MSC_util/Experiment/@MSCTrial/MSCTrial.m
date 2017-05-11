classdef MSCTrial < ExpTrial
	% Class MSCTRIAL offers basic operations for the trial information

	% Copyright 2014 Richard J. Cui. Created: 04/24/2013 11:38:10.909 PM
	% $Revision: 0.3 $  $Date: Thu 05/01/2014 11:34:17.493 AM $
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
        maxIndex        % maximum index of time
        trialMatrix     % Information about the trial, one column per trial; see process.m for details
        grattime        % length of each stage
        GaborDir        % direction of Gabor stimulus, zero at north, 90 deg at west
        NumberCondition % total number of condition
        NumberCycle     % number of cycles in this block
        CondInCycle     % a sequence of condition number in a cycle
        ContrastLevel = [0 10 20 30 40 50 60 70 80 90 100];     % percentage contrast used in MSC experiment
    end % properties
 
    % the constructor
    methods 
        function this = MSCTrial(curr_exp, sname)
            this.sname = sname;
            this.db = curr_exp.db;
            this.import_basic_trial_vars;
            
            % import msc trial vars
            this.getMaxIndex;
            
            vars = { 'enum', 'samplerate', 'trialMatrix', 'grattime', 'NumberCondition', ...
                     'LastConChunk', 'NumberCycle', 'CondInCycle', 'timestamps' };
            dat = this.db.Getsessvars(sname, vars);
            
            if isfield(dat, 'enum')
                this.enum = dat.enum;
            end
            
            if isfield(dat, 'samplerate')
                this.samplerate = dat.samplerate;
            end
            
            if isfield(dat, 'trialMatrix')
                this.trialMatrix = dat.trialMatrix;
            end
            
            if isfield(dat, 'grattime')
                this.grattime = dat.grattime;
            end
            
            if isfield(dat, 'LastConChunk')
                this.GaborDir = dat.LastConChunk.ConEnvVars.bangle;
            end 
            
            if isfield(dat, 'NumberCondition')
                this.NumberCondition = dat.NumberCondition;
            end
            
            if isfield(dat, 'NumberCycle')
                this.NumberCycle = dat.NumberCycle;
            end
            
            if isfield(dat, 'CondInCycle')
                this.CondInCycle = dat.CondInCycle;
            end 
            
            % check something
            % ---------------
            if this.grattime ~= 1300
                warning('Grattime of Session %s is not 1300 ms.', sname)
            end

        end
    end % methods
    
    % other methods
    methods
        TrialNum = cyc_cond_2_trialnum(this, cycle_idx, cond_idx);  % from cycle index and condition index to trial number
        maxIndex = getMaxIndex(this)        % get the maximum index / length of timestamps
        [trl_start_idx, trl_end_idx, s2nd_start] = getPairedStageTrlStartEndIdx(this, condidx, cycleidx, pairtype)    % gets trial start and end index of paired stage
        [s1st_on_idx, s1st_end_idx, s2nd_on_idx, s2nd_end_idx ] = getPairedStageOnEndIdx(this, pair_type)   % gets the start/end time index of paired stages    
        [cond_idx, stage_idx, cyc_idx] = Contrast2CycleCondStage(this, cont_level)    % find the indexes that has the specified contrast level
        numCond = Cont2Condnum(this, cont1, cont2)    % get condition number from the contrast pair
        [cont1, cont2] = Condnum2Cont(this, numCond)  % get contrast pair from condition number
        ts = timestamps(this)

    end % methods
    
    methods (Static)
        
    end % satics methods
    
end % classdef

% [EOF]
