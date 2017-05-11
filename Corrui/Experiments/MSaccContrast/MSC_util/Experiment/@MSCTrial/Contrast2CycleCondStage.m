function [cond_idx, stage_idx, cyc_idx] = Contrast2CycleCondStage(this, cont_level)
% MSCTrial.CONTRAST2CYCLECONDSTAGE locates the position of stage which has the specified contrast lelve
%
% Syntax:
%   [cond_idx, stage_idx, cyc_idx] = Contrast2CycleCondStage(this, cont_level)
% 
% Input(s):
%   this        - MSCTrial object
%   cont_level  - contrast level = 0%, 10%, ..., 100%
% 
% Output(s):
%   cond_idx    - condition index/number: 1,2,...,121
%   stage_idx   - 1, 2, 3 three stages
%   cyc_idx     - repeat number
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 04/26/2013 10:42:48.399 PM
% $Revision: 0.1 $  $Date: 04/26/2013 10:42:48.399 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

ncond = this.NumberCondition;
ncycle = this.NumberCycle;
nstage = 3;

% fill a 3-d arrary: cycle x cond x stage
C = zeros(ncond, nstage);

for k = 1:ncond
    [cont1, cont2] = this.Condnum2Cont(k);
    C(k, :) = [0, cont1, cont2];     % stage1 = 0%
end % for

T = repmat(C, [1, 1, ncycle]);
ind = find(T == cont_level);
[cond_idx, stage_idx, cyc_idx] = ind2sub(size(T), ind);

end % function Contrast2CycleCondStage

% [EOF]
