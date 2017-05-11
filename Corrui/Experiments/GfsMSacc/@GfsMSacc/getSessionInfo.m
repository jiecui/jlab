function values = getSessionInfo(varargin)
% GFSMSACC.GETSESSIONINFO gets information of session to import
%
% Syntax:
%   values = getSessionInfo(sess_name)
% 
% Input(s):
%   this            - varargin{1}, GfsMacc object
%   sess_name       - varargin{2} = name of the session (cell type)
% 
% Output(s):
%   values          - structure of session info
% 
% Example:
%
% See also CorruiGui.Import.

% Copyright 2016 Richard J. Cui. Created: Tue 05/24/2016 10:02:31.156 PM
% $Revision: 0.2 $  $Date: Thu 06/02/2016  8:02:30.023 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% inparse inputs
% --------------
this = varargin{1};

f_name = varargin{2};
if ischar(f_name)
    ff_name = upper( f_name );
elseif iscell(f_name)
    ff_name = upper( f_name{1} );
end % if

[~, d_name] = fileparts(ff_name);

sess_name = this.getGMSSessName(d_name);

% get channel info
% ----------------
gms_trl = GMSTrial(this, sess_name);
[area_code, electrode_num, grid_idx] = gms_trl.gms_exp_channle_info;
% if no channel info retrun empty
if isempty(area_code) == true && isempty(electrode_num) == true && isempty(grid_idx) == true
    values = [];
    return
end % if

% get session info
% -----------------
switch sess_name(1)
    case 'D'
        monkey_id = 'Dali';
    case 'E'
        monkey_id = 'Ernst';
    case 'W'
        monkey_id = 'Wally';
    otherwise
        error('GfsMSacc:getSessionInfo', 'Unknown monkey')
        
end % switch

sess_type = sess_name(end);

% construct options for the dialog
% ---------------------------------
opt.monkey_id   = { monkey_id, 'Monkey ID' };
opt.sess_type   = { sess_type, 'Session type' };
opt.area_code   = { area_code, 'Cortical area ID' };
opt.eled_num    = { electrode_num, 'Electrode number' };
opt.grid_idx    = { grid_idx, 'Grid index' };
dlg_title = sprintf('Options for reading %s %s file...', this.prefix, sess_name);
values = StructDlg(opt,dlg_title);

end % function getSessionInfo

% [EOF]
