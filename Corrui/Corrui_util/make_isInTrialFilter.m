function isInTrialFilter = make_isInTrialFilter(TrialCond, enum, name, current_exp, filter_num)
% MAKE_ISINTRIALFILTER get trial condition filters
%
% Syntax:
%   isInTrialFilter = make_isInTrialFilter(TrialCond,enum,name,current_exp,filter_num)
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Mon 08/22/2016  1:23:52.278 PM
% $ Revision: 0.2 $  $ Date: Wed 09/14/2016  3:48:14.951 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

if nargin == 5 % Construct isInTrialFilter
    isInTrialFilter = false(size(TrialCond));
    for ifilter = 1:length(filter_num)
        isInTrialFilter( CorrGui.filter_conditions(current_exp, TrialCond, filter_num(ifilter), enum, name)) = 1;
    end
elseif nargin == 3
    starts = TrialCond;
    stops = enum;
    length_YesNo = name;
    
    isInTrialFilter =  make_YesNo_vector(starts,stops,length_YesNo);
end

end