function sess_name = getGMSSessName(data_fname)
% GFSMSACC.GETGMSSESSNAME (summary)
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

% Copyright 2016 Richard J. Cui. Created: Wed 05/25/2016  8:33:33.896 PM
% $Revision: 0.2 $  $Date: Thu 06/02/2016  8:02:30.023 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% construct session name for GMS experiment
%
% data_fname = [monkey]_[exp date]_[...]_[1904/2006]

dname = upper(data_fname);
% get dname parts
s = regexp(dname, '_', 'split');

% get monkey id
switch s{1}
    case 'DALI'
        m_id = 'D';
    case 'ERNST'
        m_id = 'E';
    case 'WALLY'
        m_id = 'W';
    otherwise
        error('GFSMSACC:import_files_dialog', 'Unknown monkey.')
end % switch

% get data id
switch s{end}
    case '1904'
        d_id = 'A';
    case '2006'
        d_id = 'B';
    otherwise
        error('GFSMSACC:import_files_dialog', 'Unknown data.')
end % switch

sess_name = [m_id, s{2}, d_id];

end % function getGMSSessName

% [EOF]
