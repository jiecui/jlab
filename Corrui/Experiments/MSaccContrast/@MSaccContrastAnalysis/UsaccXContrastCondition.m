function [uxc12_onset, uxc12_offset, uxc23_onset, uxc23_offset] = UsaccXContrastCondition(NumberCondition, NumberCycle, grattime, ...
    usacc_props, CondInCycle, trialMatrix, enum)
% USACCXCONTRASTCONDITION Microsaccade onset times and end times when the cell is in response to step-contrast change
% 
% Description:
%   This funciton obtains times of usacc onset and offset correlated to
%   contrast conditoions. There are two contrast conditions: from stage 1
%   to stage 2 (i.e. contrast 1) and from stage 2 to stage 3 (i.e. contrast
%   2).
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
%   uxc12_onset             - usacc onset cell array = 1 x NumberCondition; from
%                             stage 1 to stage 2 and from stage 2 to stage 3
%
% Example:
%
% See also .

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

uxc12_onset     = {};
uxc12_offset    = {};
uxc23_onset     = {};
uxc23_offset    = {};
for k = 1:NumberCondition
    uxc12_onset_c   = [];
    uxc12_offset_c  = [];
    uxc23_onset_c   = [];
    uxc23_offset_c  = [];
    for c = 1:NumberCycle
        [us_onset12_ck, us_offset12_ck, us_onset23_ck, us_offset23_ck, start12_c, ~, start23_c]...
            = MSaccContrast.get_1trial_ustime(c, k, trialMatrix, NumberCondition, ...
            CondInCycle, grattime, enum, usacc_props);
        
        if isempty(us_onset12_ck)
            us_onset12_idx = [];
        else
            us_onset12_idx = (us_onset12_ck - start12_c + 1) + (c - 1) * trial_length;
        end % if
        
        if isempty(us_offset12_ck)
            us_offset12_idx = [];
        else
            us_offset12_idx = (us_offset12_ck - start12_c + 1) + (c - 1) * trial_length;
        end % if
        
        if isempty(us_onset23_ck)
            us_onset23_idx = [];
        else
            us_onset23_idx = (us_onset23_ck - start23_c + 1) + (c - 1) * trial_length;
        end % if
        
        if isempty(us_offset23_ck)
            us_offset23_idx = [];
        else
            us_offset23_idx = (us_offset23_ck - start23_c + 1) + (c - 1) * trial_length;
        end % if
        
        uxc12_onset_c = cat(1, uxc12_onset_c, us_onset12_idx);
        uxc12_offset_c = cat(1, uxc12_offset_c, us_offset12_idx);
        uxc23_onset_c = cat(1, uxc23_onset_c, us_onset23_idx);
        uxc23_offset_c = cat(1, uxc23_offset_c, us_offset23_idx);
    end % for
    
    uxc12_onset     = cat(2, uxc12_onset, {uxc12_onset_c});
    uxc12_offset    = cat(2, uxc12_offset, {uxc12_offset_c});
    uxc23_onset     = cat(2, uxc23_onset, {uxc23_onset_c});
    uxc23_offset     = cat(2, uxc23_offset, {uxc23_offset_c});
end % for

end % function FiringXContrastCondition

% [EOF]
