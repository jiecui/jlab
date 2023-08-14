function out = filter_conditions( this, trial_conditions, filter, enum, sname)
% EXPERIMENT.FILTER_CONDITIONS (summary)
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012-2016 Richard J. Cui. Created: 10/22/2012 11:16:52.781 AM
% $Revision: 0.2 $  $Date: Sat 08/06/2016  9:44:12.990 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% List of trial categories
filter_names = { 'All' };

if nargin == 2
    command = trial_conditions;
    switch (command)
        case 'get_condition_names'
            out = filter_names;
    end
    return
end

% Filter the conditions
switch(filter)
    case 1 % All
        out = find(trial_conditions >= 0);
    otherwise
        error('EXPERIMENT:filter_conditions', 'Unknown trial category')
end

end % function filter_conditions

% [EOF]
