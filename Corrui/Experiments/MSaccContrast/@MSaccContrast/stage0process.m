function [imported_data, stage0_data] = stage0process(this, sname, options)
% MSACCCONTRAST.STAGE0PROCESS PreProcess trial infomation in Stage 0
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

% Copyright 2014 Richard J. Cui. Created: 03/17/2014 10:34:22.854 AM
% $Revision: 0.1 $  $Date: Wed 03/19/2014  5:29:37.047 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% Convert pixels to visual angle
% =========================================================================

% get the variables from the imported data
% ---------------------------------------------
vars = {'info', 'timestamps', 'enum', 'LastConChunk'};
imported_data = this.db.Getsessvars( sname, vars );

% -- process trial infomation: trial starts and stops,
% conditions, trial number
stage0_data = processTrial( this, sname, imported_data );

end % function stage0process

% =========================================================================
% subroutines
% =========================================================================
function valid_cyc = check_cycle_validity(stim, exp_trial)

mingray1 = stim.mingray1;
maxgray1 = stim.maxgray1;
mingray2 = stim.mingray2;
maxgray2 = stim.maxgray2;
bad_gray = mingray1 < 0 || mingray1 > 255 || mingray2 < 0 || mingray2 > 255 ...
           || maxgray1 < 0 || maxgray1 > 255 || maxgray2 < 0 || maxgray2 > 255;

con1 = Michelson(mingray1, maxgray1);     % find the contrast 1 in stage 2
con2 = Michelson(mingray2, maxgray2);     % find the contrast 2 in stage 3
bad_con = con1 < 0 || con1 > 100 || con2 < 0 || con2 > 100;

% find Condition number from con1 & con2
numCond = exp_trial.Cont2Condnum(con1, con2);                 % numCond = condition index
oddeven = mod(numCond, 2) == 1 || mod(numCond ,2) == 0;
bad_numCond = ~oddeven || numCond < 1 || numCond > 121 || con1 < 0 || con2 < 0;

if bad_gray || bad_con || bad_numCond     % if a bad cycle
    valid_cyc = false;
else
    valid_cyc = true;
end % if


end 


function out_dat = processTrial(cur_exp, sname, in_dat)
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
%    .isInTrialStage    : stage of the trial (1, 2 or 3)
%    .isInCycle         : Cycel index of this sample
%    .trialMatrix       : Matrix of trial information = [M, N], where M is
%                         number of items recorded in the matrix, N is
%                         number of trials
%                         (1,:) = trialCondIndex
%                         (2,:) = trialStartIndex
%                         (3,:) = trialStopIndex
%                         (4,:) = trialStartTS      % time stamps
%                         (5,:) = trialStopTS
%                         (6,:) = trialStage1StartIndex
%                         (7,:) = trialStage2StartIndex
%                         (8,:) = trialStage3StartIndex
%                         (9,:) = trialStage1StartTS
%                        (10,:) = trialStage2StartTS
%                        (11,:) = trialStage3StartTS
%                        (12,:) = trialCycleIndex

% =========================================================================
% Stimulus information of the session
% =========================================================================
enum = in_dat.enum;
enum = get_enum(enum);
timestamps = in_dat.timestamps;
LastConChunk = in_dat.LastConChunk;
SessStim = LastConChunk.SessStim;
maxCycles= size(SessStim, 1);
numConditions = size(SessStim, 2) - 1;   % last condition is used for coding, don't account it
grattime = LastConChunk.ConEnvVars.grattime;   % time for the presentation of one stage of stimuli (ms, fs = 1k Hz)

exp_trial = cur_exp.Trial(sname);

% =========================================================================
% process trial
% =========================================================================
nTS = length(timestamps);   % number of timestamps

isInTrial       = zeros(nTS, 1);
isInTrialNumber = zeros(nTS, 1);
isInTrialStage  = zeros(nTS, 1);
isInTrialCond   = zeros(nTS, 1);
isInCycle       = zeros(nTS, 1);

trialMatrix = [];
for m = 1:maxCycles
    trialMatrix_k = zeros(11,1);
    for n = 1:numConditions
        trialnum = (m - 1) * numConditions + n;
        stim = SessStim(m, n);
        valid_cyc = check_cycle_validity(stim, exp_trial);
        if valid_cyc
            % condition index
            % ---------------
            con1 = Michelson(stim.mingray1, stim.maxgray1);     % find the contrast 1 in stage 2
            con2 = Michelson(stim.mingray2, stim.maxgray2);     % find the contrast 2 in stage 3
            % find Condition number from con1 & con2
            numCond = exp_trial.Cont2Condnum(con1, con2);                 % numCond = condition index
        else
            break
        end % if
        % oddeven = mod(numCond, 2) == 1 || mod(numCond ,2) == 0;
        % if ~oddeven || numCond < 1 || numCond > 121 || con1 < 0 || con2 < 0     % if a bad cycle
        %     break
        % end % if
        
        % time of the trial
        % ------------------
        % stage1: Blank start time index
        time0 = stim.thistime0;
        time0_ind = find(timestamps == time0, 1);  % have to use 'find', cuz timestamps are not continuous
        if isempty(time0_ind)
            tt = timestamps(timestamps < time0 + 10 & timestamps > time0 - 10);
            if isempty(tt)
                error('Cannot find stage start time.')
            else
                [~, mi] = min(abs(tt - time0));
                time0_ind = find(timestamps == tt(mi));
            end % if
            % break
        end % if
        
        % stage2: contrast-1 start time
        time1 = stim.thistime1;
        time1_ind = find(timestamps == time1, 1);
        if isempty(time1_ind)
            tt = timestamps(timestamps < time1 + 10 & timestamps > time1 - 10);
            if isempty(tt)
                error('Cannot find stage start time.')
            else
                [~, mi] = min(abs(tt - time1));
                time1_ind = find(timestamps == tt(mi));
            end % if
        end % if

        % stage3: contrast-2 start time
        time2 = stim.thistime2;
        time2_ind = find(timestamps == time2, 1);
        if isempty(time2_ind)
            tt = timestamps(timestamps < time2 + 10 & timestamps > time2 - 10);
            if isempty(tt)
                error('Cannot find stage start time.')
            else
                [~, mi] = min(abs(tt - time2));
                time2_ind = find(timestamps == tt(mi));
            end % if
        end % if
        
        % check point
        % -----------
        if (time0_ind >= time1_ind) || (time1_ind >= time2_ind)
            error('Stage start index error')
        end % if
        
        % process
        % -------
        stage1_k =time0_ind:(time1_ind - 1); 
        stage2_k =time1_ind:(time2_ind - 1); 
        stage3_k =time2_ind:(time2_ind + grattime - 1); 
        trial_k = [stage1_k, stage2_k, stage3_k];
        
        isInTrial(trial_k) = 1;
        isInTrialNumber(trial_k) = trialnum;
        isInTrialStage(stage1_k) = 1;
        isInTrialStage(stage2_k) = 2;
        isInTrialStage(stage3_k) = 3;
        isInTrialCond(trial_k) = numCond;
        isInCycle(trial_k) = stim.cyclenum;
        
        trialMatrix_k(enum.trialMatrix.trialCondIndex)  = numCond;
        trialMatrix_k(enum.trialMatrix.trialStartIndex) = stage1_k(1);
        trialMatrix_k(enum.trialMatrix.trialStopIndex)  = stage3_k(end);
        trialMatrix_k(enum.trialMatrix.trialStartTS)    = timestamps(stage1_k(1));
        trialMatrix_k(enum.trialMatrix.trialStopTS)     = timestamps(stage3_k(end));
        trialMatrix_k(enum.trialMatrix.trialStage1StartIndex)   = time0_ind;
        trialMatrix_k(enum.trialMatrix.trialStage2StartIndex)   = time1_ind;
        trialMatrix_k(enum.trialMatrix.trialStage3StartIndex)   = time2_ind;
        trialMatrix_k(enum.trialMatrix.trialStage1StartTS)      = timestamps(time0_ind);
        trialMatrix_k(enum.trialMatrix.trialStage2StartTS)      = timestamps(time1_ind);
        trialMatrix_k(enum.trialMatrix.trialStage3StartTS)      = timestamps(time2_ind);
        trialMatrix_k(enum.trialMatrix.trialCycleIndex)         = m;
        trialMatrix = cat(2, trialMatrix, trialMatrix_k);
    end % for
end % for

% =================================
% Find CondinCycle
% =================================
CondInCycle = zeros(1, numConditions);
for n = 1:numConditions     % trial sequence
    stim = SessStim(1, n);
    con1 = Michelson(stim.mingray1, stim.maxgray1);     % find the contrast 1 at stage 2
    con2 = Michelson(stim.mingray2, stim.maxgray2);     % find the contrast 2 at stage 3
    % find Condition number from con1 & con2
    numCond = exp_trial.Cont2Condnum(con1, con2);
    CondInCycle(n) = numCond;
end %for

% =========================================================================
% commit
% =========================================================================
out_dat.isInTrial       = isInTrial;
out_dat.isInTrialNumber = isInTrialNumber;
out_dat.isInTrialStage  = isInTrialStage;
out_dat.isInTrialCond   = isInTrialCond;
out_dat.isInCycle       = isInCycle;
out_dat.trialMatrix     = trialMatrix;
out_dat.NumberCondition = numConditions;    % totoal number of conditions
out_dat.grattime        = grattime;         % time for the presentation of one stage of stimuli (ms, fs = 1k Hz)
out_dat.NumberCycle     = max(isInCycle);
out_dat.CondInCycle     = CondInCycle;      % condition sequence in one cycle
out_dat.enum = enum;

end %funciton

function out_enum = get_enum(enum)

% enum
enum.trialMatrix.trialCondIndex     = 1;
enum.trialMatrix.trialStartIndex    = 2;
enum.trialMatrix.trialStopIndex     = 3;
enum.trialMatrix.trialStartTS       = 4;
enum.trialMatrix.trialStopTS        = 5;
enum.trialMatrix.trialStage1StartIndex  = 6;
enum.trialMatrix.trialStage2StartIndex  = 7;
enum.trialMatrix.trialStage3StartIndex  = 8;
enum.trialMatrix.trialStage1StartTS     = 9;
enum.trialMatrix.trialStage2StartTS     = 10;
enum.trialMatrix.trialStage3StartTS     = 11;
enum.trialMatrix.trialCycleIndex        = 12;

out_enum = enum;

end %funciton

% [EOF]
