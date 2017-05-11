classdef GMSTrial < ExpTrial
	% Class GMSTRIAL offers basic operations for the trial information of GMS experiment

	% Copyright 2016 Richard J. Cui. Created: Tue 03/29/2016  5:03:35.634 AM
    % $Revision: 0.2 $  $Date: Thu 07/07/2016  8:00:58.609 PM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com

    properties 
        db              % database
        sname           % session name
    end % properties
 
    properties
        MonkeyID        % monkey name
        RelLatShort     % level release latency relative to surround onset (ms)
        RelLatAll       % all latency < 10000 ms
        TrialLength     % trial length (ms)
        TargetOnset     % target onset time relative to trial start (ms)
        SurroundOnset   % sourround onset time relative to TargetOnset (ms)
        MaskOnset       % mask onset time relative to SurroundOnset? (ms)
        TargetPos       % target position (dva)
        SubjDispTrialNumber     % number of trials of condition SubjDisp
        SubjNoDispTrialNumber   % number of trials of condition SubjNoDisp
        PhysDispTrialNumber     % number of trials of condition PhysDisp

        CorAreaID       % cortical area identification
        ElectrodNum     % electrode number of identification
        GridIndex       % grid index
        ChannelNumber   % number of channels
    end % properties
    
    % the constructor
    methods 
        function this = GMSTrial(curr_exp, sname)
            this.sname = sname;
            this.db = curr_exp.db;
            this.import_basic_trial_vars;   % enum & samplerate
            this.samplerate = 1000;         % Hz
            
            getSessInfo(this)
            getTrialNumber(this)
        end
    end % methods
    
    % other methods
    methods
        [area_code, electrode_num, grid_idx] = gms_exp_channle_info(this)   % get channle/electrode information
        getSessInfo( this )     % get session information
        [chan, eye_samples, lfp, mua] = gms_trial_valid_index( this )   % get valid trial indexes
        ntrl = getTrialNumber(this)
    end % methods
    
    methods (Static)
        
    end % satics methods
    
end % classdef

% [EOF]
