function [newsession, dtype] = guiMergeData( this , handles )
% GFSMSACC.GUIMERGEDATA GUI for merge two data types
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

% Copyright 2016 Richard J. Cui. Created: Mon 06/20/2016 10:17:47.652 PM
% $Revision: 0.2 $  $Date: Fri 06/24/2016 10:34:42.239 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

%-- get the data type
dtype = CorrGui.getSessListString( handles );

if isempty(dtype)
    cprintf('Keywords', 'Please select data type...\n')
    newsession = [];
    return
end % if

if ischar(dtype)
    dtype = {dtype};
end

%-- get the session name

if numel(dtype) == 2
    type_name1 = dtype{1}(1:end-1);  % get rid of the 'A' or 'B'
    type_name2 = dtype{2}(1:end-1);  % get rid of the 'A' or 'B'
    if strcmp(type_name1, type_name2)
        new_sess_name = type_name1;
    else
        cprintf('Errors', 'The selected data types are invalid to merge.\n')
        newsession = [];
        return
    end % if
else
    new_sess_name = dtype{1}(1:end-1);  % get rid of the 'A' or 'B'
end % if

% S.New_session_name = 'CombinedSession';
S.newusersession = {this.SessName2UserSessName(new_sess_name), 'New session name'};
S = StructDlg( S, 'Merge data types', handles.rawPlotOptions,  CorrGui.get_default_dlg_pos() );
if isempty(S)
    newsession = [];
    return
else
    newsession = this.UserSessName2SessName(S.newusersession);
end

end % function guiBlock2session

% [EOF]
