function sess_name = UserSessName2SessName(this, user_sn)
% EXPERIMENT.USERSESSNAME2SESSNAME converts user session name to session name
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

% Copyright 2016 Richard J. Cui. Created: Tue 07/05/2016  3:57:32.048 PM
% $Revision: 0.1 $  $Date: Tue 07/05/2016  3:57:32.076 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

sess_name = strcat(this.prefix, user_sn);

end % function UserSessName2SessName

% [EOF]
