function [current_tag, curr_exp] = get_current_tag( handles )
% CORRGUI.GET_CURRENT_TAG gets current tag and experiment object
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: Tue 12/30/2014  9:52:37.966 PM
% $Revision: 0.1 $  $Date: Tue 12/30/2014  9:52:38.017 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

current_tag_value	= get(handles.internaltag_popup,'Value');
getaggregated = get(handles.chkShowAggregated, 'value');
if ( current_tag_value > length( handles.Enums.Internal_Tag_List ) )
    current_tag_value = 1;
    set(handles.internaltag_popup,'Value',1);
end
current_tag	= handles.Enums.Internal_Tag_List{current_tag_value};
curr_exp    = handles.Enums.Experiment_List{current_tag_value};
if ( getaggregated )
    current_tag = [current_tag '_Avg'];
    curr_exp    = handles.Enums.Experiment_List_Avg{current_tag_value};
end % if

end % function get_current_tag

% [EOF]
