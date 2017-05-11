function [fxc12, fxc23] = FiringXContrastCondition(NumberCondition, NumberCycle, grattime, ...
    spiketimes, CondInCycle, trialMatrix, enum)
% FIRINGXCONTRASTCONDITION Spike times of cell response to step-contrast change
% 
% Description:
%   This function obtains spike times of cell response correlated to
%   contrast conditoions. There are two contrast conditions: from stage 1
%   to stage 2 (i.e. contrast 1) and from stage 2 to stage 3 (i.e. contrast
%   2)
%
% Syntax:
% 
% Input(s):
%   NumberCondition         - number of conditions in the experiment
%   NumberCycle             - numbef of cycles in the experiment
%   grattime                - presentation time of stimulus in one stage
%   spiketimes              - spike times of matrix
%   CondInCycle             - condition sequence in one cycle
%   trialMatrix             - trial info matrix
%   enum                    - infomation structure
%
% Output(s):
%   fxc12/23                - spike times cell array = 1 x NumberCondition; from
%                             stage 1 to stage 2 and from stage 2 to stage 3
%
% Example:
%
% See also do_SpikeTimeStepCont.

% Copyright 2012 Richard J. Cui. Created: 10/28/2012  2:08:43.722 PM
% $Revision: 0.1 $  $Date: 10/28/2012  2:08:43.722 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

trial_length = 2 * grattime;

fxc12 = {};
fxc23 = {};
for k = 1:NumberCondition
    fxc12_c = [];
    fxc23_c = [];
    for c = 1:NumberCycle
        [fxc12_ck, fxc23_ck, start12_k, ~, start23_k, ~] = MSaccContrast.get_1trial_spktime(c, k, ...
            trialMatrix,  NumberCondition, CondInCycle, grattime, enum, spiketimes);
        if ~isempty(fxc12_ck)
            fxc12_idx = (fxc12_ck - start12_k + 1) + (c - 1) * trial_length;
        else
            fxc12_idx = [];
        end % if
        
        if ~isempty(fxc23_ck)
            fxc23_idx = (fxc23_ck - start23_k + 1) + (c - 1) * trial_length;
        else
            fxc12_idx = [];
        end % if
        
        fxc12_c = cat(1, fxc12_c, fxc12_idx);
        fxc23_c = cat(1, fxc23_c, fxc23_idx);
    end % for
    fxc12 = cat(2, fxc12, {fxc12_c});
    fxc23 = cat(2, fxc23, {fxc23_c});
end % for

end % function FiringXContrastCondition

% [EOF]
