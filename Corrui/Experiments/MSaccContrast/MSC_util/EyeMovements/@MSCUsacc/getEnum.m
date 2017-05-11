function [props_enum, props_size] = getEnum()
% MSCUSACC.GETENUM MSCUsacc specified enum
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Thu 08/04/2016  3:41:35.368 PM
% $Revision: 0.1 $  $Date: Thu 08/04/2016  3:41:35.399 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% eyeusaccenum.start_index        = 1;    % index of MS start timestamps
% eyeusaccenum.end_index          = 2;
% eyeusaccenum.duration           = 3;
% eyeusaccenum.magnitude          = 4;
% eyeusaccenum.magnitude2         = 5;
% eyeusaccenum.pkvel              = 6;
% eyeusaccenum.mnvel              = 7;
% eyeusaccenum.direction          = 8;
% eyeusaccenum.ntrial             = 9;
% eyeusaccenum.condition          = 10;
% eyeusaccenum.pre_time           = 11;   % time from beginning of previous event to this usacc
% eyeusaccenum.pre_event          = 12;   % code of events: 1 = usacc, 2 = sacc, 3 = blink, 4 = trial start, 5 = trial end
% eyeusaccenum.post_time          = 13;
% eyeusaccenum.post_event         = 14;
% eyeusaccenum.pre_time_end       = 15;
% eyeusaccenum.post_time_end      = 16;
% eyeusaccenum.pre_event_index    = 17;   % event index, not index of timestamps
% eyeusaccenum.post_event_index   = 18;
% eyeusaccenum.swj_pair           = 19;   % 1: the first usacc in the pair; 2: the 2nd, in analyze_eye_movements.m
% eyeusaccenum.cycle              = 20;   % MS-contrast exp specific
% eyeusaccenum.start_in_stage     = 21;   % MS-contrast
% eyeusaccenum.end_in_stage       = 22;   % MS-contrast

[enum, n_old] = getEnum@EyeUsacc;

props_new = {'ntrial', 'condition', 'cycle', 'start_in_stage', 'end_in_stage'};
n_new = numel(props_new);
for k = 1:n_new
    enum.(props_new{k}) = n_old + k;
end % for

props_enum = enum;
props_size = numel(fieldnames(enum));

end % function getEnum

% [EOF]
