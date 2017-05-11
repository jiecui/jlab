function [start_idx, end_idx, s2nd_start] = getPairedStageTrlStartEndIdx(this, cond_idx, cycle_idx, pair_type)
% GETPAIREDSTAGETRLSTARTENDIDX gets trial start and end index of paired stage
%
% Syntax:
%   [start_idx, end_idx] = getPairedStageTrlStartEndIdx(this, cond_idx, cycle_idx, pair_type)
%
% Input(s):
%
% Output(s):
%   s2nd_start      - start time index of 2nd stage
%
% Note:
%   Trials are aglined at the onset of 2nd stage onset, length = 2 *
%   grattime
%
% Example:
%
% See also .

% Copyright 2013-2014 Richard J. Cui. Created: 04/25/2013 12:23:22.844 PM
% $Revision: 0.3 $  $Date: Tue 04/29/2014  5:14:39.090 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

trialMatrix = this.trialMatrix;
grattime = this.grattime;
enum = this.enum;
max_trialnum = size(trialMatrix, 2);

trialnum = this.cyc_cond_2_trialnum(cycle_idx, cond_idx);
if trialnum > max_trialnum
    start_idx = [];
    end_idx = [];
    s2nd_start = [];
    return
end % if

trial = trialMatrix(:, trialnum);

switch pair_type
    case '1->2'
        stage2_start = trial(enum.trialMatrix.trialStage2StartIndex);
        s2nd_start = stage2_start;  % start time index of 2nd stage
        
    case '2->3'
        stage3_start = trial(enum.trialMatrix.trialStage3StartIndex);
        s2nd_start = stage3_start;  % start time index of 2nd stage
        
    otherwise
        start_idx = [];
        end_idx = [];
        s2nd_start = [];
        return
end % switch

start_idx = s2nd_start - grattime;
end_idx = s2nd_start + grattime - 1;

end % function getPairedStageTrlStartEndIdx

% [EOF]
