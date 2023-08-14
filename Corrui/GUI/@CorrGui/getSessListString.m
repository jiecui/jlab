function sess_list = getSessListString( handles )
% CORRGUI.GETSESSLISTSTRING get true strings of sessions from the display
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

% Copyright 2014-2016 Richard J. Cui. Created: Tue 12/30/2014 12:48:15.726 PM
% $Revision: 0.2 $  $Date: Thu 06/16/2016  5:08:25.921 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

[~, curr_exp] = CorrGui.get_current_tag( handles );

prefix = curr_exp.prefix;
is_Avg = curr_exp.is_Avg;

if is_Avg == true
    headstr = [prefix, 'ag'];
else
    headstr = prefix;
end % if

sess_str = GetCurrentValue( handles.sessionlistbox );
if ischar(sess_str)
    sess_list = [headstr, sess_str];
else
    num_sess = numel(sess_str);
    % sess_list = cell(1, num_sess);
    sess_list = cell(num_sess, 1);
    for k = 1:num_sess
        ses_k = sess_str{k};
        sess_list{k} = [headstr, ses_k];
    end % for
    
end % if

end % function getSessListString

% [EOF]
