function sess_str = setSessListString( handles )
% CORRGUI.SETSESSLISTSTRING set string for the display in session list box
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

% Copyright 2014 Richard J. Cui. Created: Tue 12/30/2014 12:47:53.903 PM
% $Revision: 0.1 $  $Date: Tue 12/30/2014 12:47:53.911 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

[curr_tag, curr_exp] = CorrGui.get_current_tag( handles );
prefix = curr_exp.prefix;
is_Avg = curr_exp.is_Avg;

if is_Avg == true
    headstr = [prefix, 'ag'];
else
    headstr = prefix;
end % if

% remove headstr
sess_list = handles.([curr_tag '_List']);
if ischar(sess_list)
    sess_str = rmheadstr(headstr, sess_list);
else
    num_sess = numel(sess_list);
    sess_str = cell(1, num_sess);
    for k = 1:num_sess
        ses_k = sess_list{k};        
        sess_str{k} = rmheadstr(headstr, ses_k);
    end % for
end % if

end % function setSessListString

% =========================================================================
% subroutines
% =========================================================================
function new_str = rmheadstr(hstr, old_str)

[si, ei] = regexp(old_str, hstr);
if si(1) ~= 1
    error('CorrGui:setSessListString', ...
        'The syntax of the session name %s is not correct.', old_str);
end % if

new_str = old_str(ei(1) + 1:end);

end % funciton
% [EOF]
