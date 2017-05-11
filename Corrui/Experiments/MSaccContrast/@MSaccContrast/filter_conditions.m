function out = filter_conditions( this, conditions, filter, enum, sname)
% MSACCCONTRAST.FILTER_CONDITIONS (summary)
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
% $Revision: 0.3 $  $Date: Wed 08/31/2016 12:44:44.371 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% FILTER LIST
filter_names = { 'AllRecordings', 'AllTrials'};

if ( nargin == 2 )
    command = conditions;
    switch (command)
        case 'get_condition_names'
            out = filter_names;
    end
    return
end

% Filter the conditions
out = true(size(conditions));
for k = 1:length(filter)
    switch(filter(k))
        case 1 % All
            out_k = conditions >= 0;
            
        case 2 % AllTrials
            out_k = conditions > 0;
            
        otherwise
            error('MSaccContrast:filter_conditions', 'Unknown trial category')
    end
    out = out & out_k;
end % for

end % function filter_conditions

% [EOF]
