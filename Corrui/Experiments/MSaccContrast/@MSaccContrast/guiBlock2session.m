function newsession = guiBlock2session( this , handles )
% MSACCCONTRAST.GUIBLOCK2SESSION GUI for combining two data blocks
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

% Copyright 2016 Richard J. Cui. Created: Fri 06/17/2016  3:47:30.465 PM
% $Revision: 0.1 $  $Date: Fri 06/17/2016  3:47:30.497 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

%-- get the blocks
blocks = CorrGui.getSessListString( handles );

if isempty(blocks)
    fprintf('Please select data blocks...\n')
    newsession = [];
    
    return
end % if

if ischar(blocks)
    blocks = {blocks};
end

%-- get the session name
new_sess_name = blocks{1}(1:end-3);
% S.New_session_name = 'CombinedSession';
S.newsession = {new_sess_name, 'New session name'};
S = StructDlg( S, 'Combine blocks', handles.rawPlotOptions,  CorrGui.get_default_dlg_pos() );
if isempty(S)
    newsession = [];
    return
end

% combining
% ---------
news = S.newsession;
if ischar(news)
    news = {S.newsession};
end % if
opt.newsessions = news;
% perform block combination
newsession = this.blocks2session(blocks, opt);

end % function guiBlock2session

% [EOF]
