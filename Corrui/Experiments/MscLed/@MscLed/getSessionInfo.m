function values = getSessionInfo(sess_name, max_num_chunks, filetype)
% MSCLED.GETSESSIONINFO gets information of session to import
%
% Syntax:
%   values = getSessionInfo(sess_name, max_num_chunks)
% 
% Input(s):
%   sess_name       - name of the session (cell type)
%   max_num_chunks  - maximum number chunks can be handled
% 
% Output(s):
%   values          - structure of session info
% 
% Example:
%
% See also CorruiGui.Import.

% Copyright 2014 Richard J. Cui. Created: Tue 07/01/2014 11:21:30.731 AM
% $Revision: 0.1 $  $Date: Tue 07/01/2014 11:21:30.731 AM $
%
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

[tune_range, chunk_range, cond_range, hor_ver_deg] = ...
    cell_mscled_exp_info( sess_name, max_num_chunks );

% construct options for the dialog
opt.Tune_range  = {tune_range, 'Tuning chunk range', [1 max_num_chunks]};
opt.Chunk_range = {chunk_range, 'Chunk range', [1 max_num_chunks]};
opt.Cond_range  = {cond_range, 'Condition ragne', [1 10]};
opt.Hor_ver_deg = {hor_ver_deg, 'Screen hor/ver in dva', [0 100]};
% opt.Which_reading_method = {'{Jie}|Other'};

if iscell(sess_name) && length(sess_name) == 1
    sname = sess_name{1};
end % if
dlg_title = sprintf('Options for reading MLD RF file %s...', sname);
values = StructDlg(opt, dlg_title);

end % function getSessionInfo

% [EOF]
