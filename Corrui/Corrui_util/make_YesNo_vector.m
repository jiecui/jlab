function YesNo =  make_YesNo_vector(starts, ends, length_of_YesNo)
% MAKE_YESNO_VECTOR
% 
% Syntax:
%   result_dat = Main_Sequence(current_tag, sname, S)
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also be2yn.

% Copyright 2014-2016 Richard J. Cui. Created: Mon 02/11/2013  3:33:32.808 PM
% $Revision: 1.1 $  $Date: Wed 09/14/2016  3:48:14.951 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

YesNo = false(length_of_YesNo, 1);

for i=1:length(starts)
    YesNo(starts(i):ends(i)) = 1;
end

end