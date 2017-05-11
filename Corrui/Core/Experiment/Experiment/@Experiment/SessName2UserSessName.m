function user_sn = SessName2UserSessName(this, sess_name)
% SESSNAME2USERSESSNAME converts session name to user session name
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

% Copyright 2016 Richard J. Cui. Created: Tue 07/05/2016  4:01:44.948 PM
% $Revision: 0.1 $  $Date: Tue 07/05/2016  4:01:44.949 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

p = regexp(sess_name, this.prefix);
if p(1) ~= 1    % Prefix must be at the beggining 
    error('Experiment:SessName2UserSessName', 'Invalid user session name')
else
    user_sn = sess_name(length(this.prefix)+1:end);
end % if

end % function SessName2UserSessName

% [EOF]
