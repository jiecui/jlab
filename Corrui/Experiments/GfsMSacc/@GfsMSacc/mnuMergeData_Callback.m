function mnuMergeData_Callback(this, hObject, eventdata, handles)
% GFSMSACC.MNUMERGEDATA_CALLBACK callback of merging data
%
% Syntax:
%
% Input(s):
%   this        - GfsMsacc obj
%   hObject     - handle to the object issuing callback (see GCBO)
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

% Copyright 2016 Richard J. Cui. Created: Mon 06/20/2016 10:17:47.652 PM
% $Revision: 0.2 $  $Date: Fri 06/24/2016 10:34:42.239 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

handles = merging_data( this, handles );
guidata( handles.internaltag_popup, handles);

end % function mnuRunCombineBlocks_Callback

% =========================================================================
% subroutines
% =========================================================================
function handles = merging_data( this, handles )

curr_tag = CorrGui.get_current_tag( handles );

% combining
% ---------
[news, d_type] = this.guiMergeData( handles ); 
if ~isempty(news)
    if ischar(news)     % news = new session names
        news = {news};
    end % if
    opt.newsessions = news;
    
    % arrange data type
    dtype = cell(2, 1);
    switch numel(d_type)
        case 1
            dt = d_type{1};
            type = dt(end);
            switch type
                case 'A'
                    dtype{1} = dt;
                case 'B'
                    dtype{2} = dt;
                otherwise
                    error('GFSMSACC:MNUMERGEDATA_CALLBACK','Unknown data type.')
            end % switch
        case 2
            type1 = d_type{1}(end);
            type2 = d_type{2}(end);
            if strcmp(type1, 'A') && strcmp(type2, 'B')
                dtype = d_type;
            else
                cprintf('Error', 'Not properly selected data types.\n')
                return
            end % if
        otherwise
            cprintf('Error', 'Too many data types are selected.\n')
            return
    end % switch
    % --------------------
    % perform data merging
    % --------------------
    newsession = this.mergeData(dtype, opt);    % data saved within
    
    % update list
    if ~isempty(newsession)
        handles.([curr_tag '_List']){end+1} = newsession;
        handles = corrui('update_session_lists', handles, newsession);
    end % if
    
    % update session description
    handles = corrui('changeselectedsession', handles);

end % if

end % function

% [EOF]
