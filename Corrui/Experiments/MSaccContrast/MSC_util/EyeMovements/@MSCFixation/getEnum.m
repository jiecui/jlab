function [props_enum, props_size] = getEnum()
% MSCFIXATION.GETENUM MSCUsacc specified enum
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

[enum, n_old] = getEnum@EyeFixation;

props_new = {'ntrial', 'condition', 'cycle', 'start_in_stage', 'end_in_stage'};
n_new = numel(props_new);
for k = 1:n_new
    enum.(props_new{k}) = n_old + k;
end % for

props_enum = enum;
props_size = numel(fieldnames(enum));

end % function getEnum

% [EOF]
