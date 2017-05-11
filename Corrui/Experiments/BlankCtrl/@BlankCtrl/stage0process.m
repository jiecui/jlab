function [imported_data, stage0_data] = stage0process(this, sname, options)
% BLANKCTRL.STAGE0PROCESS PreProcess trial infomation in Stage 0
%
% Syntax:
%
% Input(s):
%   sname       - get session name
%   opt         - stage 0 options
% 
% Output:
%   out_dat     - data structure of output
%    .isInTrial         : logic Y/N indicates if this time sample is a in
%                         valid trial
%    .isInTrialNumber   : trial number/sequence of this sample 
%    .isInTrialCond     : condition index of this smaple
% 
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: Sat 04/19/2014 10:49:06.238 PM
% $Revision: 0.1 $  $Date: Sat 04/19/2014 10:49:06.238 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% main
% =========================================================================

% get the variables from the imported data
% ---------------------------------------------
vars = {'info', 'timestamps', 'enum', 'LastBctChunk'};
imported_data = this.db.Getsessvars( sname, vars );

% -- process trial infomation: trial starts and stops,
% conditions, trial number
stage0_data = processTrial( imported_data );

end % function stage0process

% =========================================================================
% subroutines
% =========================================================================
function out_dat = processTrial(in_dat)
% Process trial infomation
% 
% Input:
%   in_dat      - data structure of input
% 
% Output:
%   out_dat     - data structure of output
%    .isInTrial         : logic Y/N indicates if this time sample is a in
%                         valid trial
%    .isInTrialNumber   : trial number/sequence of this sample 
%    .isInTrialCond     : condition index of this smaple
%    .bcttrialMatrix    : Matrix of bct trial information = [M, N], where M is
%                         number of items recorded in the matrix, N is
%                         number of trials
%                         (1,:) = trialCondIndex    - liminance index (1..5)
%                         (2,:) = trialStartIndex
%                         (3,:) = trialStopIndex
%                         (4,:) = trialStartTS      % time stamps
%                         (5,:) = trialStopTS

% =========================================================================
% Stimulus information of the session
% =========================================================================
% enum = in_dat.enum;
% enum = get_enum(enum);
timestamps = in_dat.timestamps;
LastBctChunk = in_dat.LastBctChunk;
SessStim = LastBctChunk.SessStim;
[numConditions, numTrial] = size(SessStim);   % number of conditions / luminance levels and trials
trialtime = LastBctChunk.BctEnvVars.trialtime;   % time for the presentation of one trial of stimuli (ms, fs = 1k Hz)

% =========================================================================
% process trial
% =========================================================================
nTS = length(timestamps);   % number of timestamps

isInTrial       = zeros(nTS, 1);
isInTrialCond   = zeros(nTS, 1);
isInTrialSequence = zeros(nTS, 1);

% fdnames = fieldnames(enum.bcttrialMatrix);
% numfield = length(fdnames);
% bcttrialMatrix = [];
for m = 1:numConditions
    % bcttrialMatrix_k = zeros(numfield,1);
    for n = 1:numTrial
        trial_seq = (m - 1) * numTrial + n;
        validtrial = true;
        
        % luminance of the trial
        % ----------------------
        stim = SessStim(m, n);
        valid_stim = check_stim_validity(stim);
        if ~valid_stim
            fprintf('Warning: Invalid luminance recorded, trial aborted.\n')
            validtrial = false;
        end % if
        
        % time of the trial
        % ------------------
        % start time index
        start_ts = stim.starttime;  % start time stamps
        start_ind = find(timestamps == start_ts, 1);  % have to use 'find', cuz timestamps are not continuous
        if isempty(start_ind)   % if recorded starttime of a trial is not in SAE chunk record
            tt = timestamps(timestamps < start_ts + 10 & timestamps > start_ts - 10);
            if isempty(tt)
                fprintf('Warning: Cannot find trial start time in timestamps: cond = %d, trial = %d. Trial aborted.\n', m, n)
                validtrial = false;
            else
                [~, mi] = min(abs(tt - start_ts));
                start_ind = find(timestamps == tt(mi));
            end % if
            % break
        end % if
        
        % trial end time index
        end_ts = start_ts + trialtime - 1;
        end_ind = find(timestamps == end_ts, 1);
        if isempty(end_ind)
            tt = timestamps(timestamps < end_ts + 10 & timestamps > end_ts - 10);
            if isempty(tt)
                fprintf('Warning: Use approximate trial end time index: cond = %d, trial = %d. \n', m, n)
                end_ind = start_ind + trialtime - 1;
            else
                [~, mi] = min(abs(tt - end_ts));
                end_ind = find(timestamps == tt(mi));
            end % if
        end % if
        
        % check point
        % -----------
        if start_ind >= end_ind
            fprintf('Warning: Trial time index error: cond = %d, trial = %d. Trial aborted\n', m, n)
            validtrial = false;
        end % if
        
        if validtrial
            % trial info yn
            % -------------
            % trial_k =start_ind:end_ind;
            trial_k = timestamps >= start_ts & timestamps <= end_ts;
            
            isInTrial(trial_k)          = 1;
            isInTrialSequence(trial_k)  = trial_seq;
            isInTrialCond(trial_k)      = m;
            
            % construct blankctrl trial matrix
            % --------------------------------
            % bcttrialMatrix_k(enum.bcttrialMatrix.trialCondIndex)    = m;
            % bcttrialMatrix_k(enum.bcttrialMatrix.trialStartIndex)   = start_ind;
            % bcttrialMatrix_k(enum.bcttrialMatrix.trialStopIndex)    = end_ind;
            % bcttrialMatrix_k(enum.bcttrialMatrix.trialStartTS)      = start_ts;
            % bcttrialMatrix_k(enum.bcttrialMatrix.trialStopTS)       = end_ts;
            % bcttrialMatrix_k(enum.bcttrialMatrix.trialSequence)     = trial_seq;
            
            % bcttrialMatrix = cat(2, bcttrialMatrix, bcttrialMatrix_k);
        end % if
    end % for
end % for


% =========================================================================
% commit
% =========================================================================
out_dat.isInTrial           = isInTrial;
out_dat.isInTrialSequence   = isInTrialSequence;
out_dat.isInTrialCond       = isInTrialCond;
% out_dat.bcttrialMatrix      = bcttrialMatrix;
out_dat.NumberCondition     = numConditions;    % totoal number of conditions
out_dat.trialtime           = trialtime;        % time for the presentation of one stage of stimuli (ms, fs = 1k Hz)
% out_dat.enum = enum;

end %funciton

% [EOF]
