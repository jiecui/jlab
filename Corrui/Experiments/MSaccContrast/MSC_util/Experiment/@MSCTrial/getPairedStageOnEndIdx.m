function [s1st_on_idx, s1st_end_idx, s2nd_on_idx, s2nd_end_idx ] = getPairedStageOnEndIdx(this, pair_type)
% GETPAIREDSTAGEONENDIDX gets the start/end time index of paired stages
%
% Syntax:
%   on_idx = get2ndStageOnIdx(this, condidx, cycleidx, pairtype)
% 
% Input(s):
%
% Output(s):
%
% Note:
%   Paired stages means start and end is 'grattime' ms from the start of
%   the 2nd stage
% 
% Example:
%
% See also .

% Copyright 2013-2014 Richard J. Cui. Created: 04/25/2013  4:37:20.200 PM
% $Revision: 0.2 $  $Date: Tue 04/29/2014  5:22:51.059 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

num_cond = this.NumberCondition;
num_cyc  = this.NumberCycle;

N = num_cond * num_cyc;
s1st_on_idx = zeros(N, 1);
s1st_end_idx = zeros(N, 1);
s2nd_on_idx = zeros(N, 1);
s2nd_end_idx = zeros(N, 1);

for p = 1:num_cond
    for q = 1:num_cyc
        k = (p - 1) * num_cyc + q;
        [on_k, end_k, s2nd_on_k] = this.getPairedStageTrlStartEndIdx(p, q, pair_type);
        if ~(isempty(on_k) || isempty(end_k) || isempty(s2nd_on_k))
            s1st_on_idx(k) = on_k;
            s1st_end_idx(k) = s2nd_on_k - 1;
            s2nd_on_idx(k) = s2nd_on_k;
            s2nd_end_idx(k) = end_k;
        end % if
    end % for
end % for


end % function get2ndStageOnIdx

% [EOF]
