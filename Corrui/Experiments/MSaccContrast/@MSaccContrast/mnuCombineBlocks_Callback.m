function mnuCombineBlocks_Callback(this, hObject, eventdata, handles)
% MSACCCONTRAST.MNURUNCOMBINEBLOCKS_CALLBACK callback of combining blocks
%
% Syntax:
%
% Input(s):
%   this        - MSaccContrast obj
%   hObject     - handle to mnuRunCombineBlocks (see GCBO)
%   eventdata   - reserved to be defined in a future version of MATLAB
%   handles     - guidata(hObject)
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

% Copyright 2016 Richard J. Cui. Created: Fri 06/17/2016 12:07:01.229 PM
% $Revision: 0.3 $  $Date: Tue 06/28/2016  1:05:30.649 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

handles = corrui_blocks2session( this, handles );
guidata( handles.internaltag_popup, handles);

end % function mnuRunCombineBlocks_Callback

% =========================================================================
% subroutines
% =========================================================================
function handles = corrui_blocks2session( this, handles )
curr_tag = CorrGui.get_current_tag( handles );

% newsession = CorrGui.Block2session( curr_tag, handles );
newsession = this.guiBlock2session( handles );

% update list
handles.([curr_tag '_List']){end+1} = newsession;
handles = corrui('update_session_lists', handles, newsession);

% update session description
handles = corrui('changeselectedsession', handles);

end % function

% [EOF]
