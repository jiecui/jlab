function values = getSessionInfo(sess_name, max_num_chunks)
% MSACCCONTRAST.GETSESSIONINFO gets information of session to import
%
% Syntax:
%   values = getSessionInfo(sess_name)
% 
% Input(s):
%   sess_name       - name of the session (cell type)
% 
% Output(s):
%   values          - structure of session info
% 
% Example:
%
% See also CorruiGui.Import.

% Copyright 2014 Richard J. Cui. Created: Fri 03/14/2014  3:40:55.984 PM
% $Revision: 0.1 $  $Date: Fri 03/14/2014  5:01:28.867 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

[tune_range, chunk_range] = cell_contrast_exp_info( sess_name, max_num_chunks );

% range of chunks
opt.Tune_range  = {tune_range 'Tuning chunk range' [1 max_num_chunks]};
opt.Chunk_range = {chunk_range 'Chunk range' [1 max_num_chunks]};
% opt.Excluded_chunk_range = {exlcuded_range 'Excluded_chunk_range' []};
opt.Which_reading_method = {'{Jie}|Other'};

if iscell(sess_name) && length(sess_name) == 1
    sname = sess_name{1};
end % if
dlg_title = sprintf('Options for reading MSC RF file %s...', sname);
values = StructDlg(opt, dlg_title);

end % function getSessionInfo

% [EOF]
