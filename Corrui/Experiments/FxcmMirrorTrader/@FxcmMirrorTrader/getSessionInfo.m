function values = getSessionInfo(curr_exp, sfile_name, varargin)
% FXCMMIRRORTRADER.GETSESSIONINFO gets information of session to import
%
% Syntax:
%   values = getSessionInfo(sess_name)
% 
% Input(s):
%   sfile_name      - name of the files of the sessions (cell type)
% 
% Output(s):
%   values          - structure of session info
% 
% Example:
%
% See also CorruiGui.Import.

% Copyright 2014-2015 Richard J. Cui. Created: Sat 11/08/2014 11:02:23.968 PM
% $Revision: 0.2 $  $Date: Mon 02/23/2015 10:18:55.968 PM $
%
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% inparse inputs
% --------------
% curr_exp = varargin{1};
if ischar(sfile_name)
    sf_name = upper( sfile_name );
elseif iscell(sfile_name)
    sf_name = upper( sfile_name{1} );
end % if

[~, sessf_name] = fileparts(sf_name);
switch sessf_name
    case 'EURJPY_BREAKOUT2'
        max_numpos = 5;     % max number of positions
        
    otherwise
        max_numpos = 4;
        
end % switch

% construct options for the dialog
% ---------------------------------
opt.file_kind = {'{History}|Performance', 'Kind of file'};
opt.max_numpos = { max_numpos, 'Max number of positions', [1 Inf] };
dlg_title = sprintf('Options for reading FMT %s file...', sfile_name{1});
values = StructDlg(opt,dlg_title);

end % function getSessionInfo

% [EOF]
