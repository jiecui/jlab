function [dirt, hw] = calDirect(angle, dist)
% CALDIRECT calculates the directionality of a polar histogram distribution
%
% Syntax:
%   [dirt, hw] = calDirect(angle, dist)
% 
% Input(s):
%   angle   - array of angles from -90 to 90 degree (we assume the
%             distribution is symetric)
%   dist    - normalized distribution at each angle, i.e., the sum of 'dist' is one
%
% Output(s):
%   dirt    - estimated direction (in degree)
%   hw      - half widow-width
%
% Example:
%
% See also CellOrtTuning.

% Copyright 2012 Richard J. Cui. Created: 09/19/2012  8:27:01.896 AM
% $Revision: 0.2 $  $Date: Fri 09/21/2012  4:16:32.378 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% check the inputs
% =========================================================================
% s = sum(dist);
% if s ~= 1
%     error('The distribution is not normalized')
% end % if

la = length(angle);
ld = length(dist);
if la ~= ld
    error('The length of Angle and Distribution must be the same')
end % if

% =========================================================================
% main
% =========================================================================
% sort angle & dist
[A, idx] = sort(angle);     % from -90 to 90 degree
D = dist(idx);
A = A(:);   % col vector
D = D(:); 

% % check the dirctionality in two ranges: -90 to 90 deg and 0 to 180 deg;
% % convert the directionality between -90 and 90 deg
% % (1) -90 to 90
% a_c1 = A' * D;              % center of angle
% hw1 = abs(A - a_c1)' * D;   % half window width
% 
% % (2) 0 to 180
% % circular shift the angles and distribution
% shiftsize = sum(A > -90 & A < 0);
% A2 = circshift(A, -shiftsize);
% A2(A2 < 0) = A2(A2 < 0) + 180;
% D2 = circshift(D, -shiftsize);
% a_c2 = A2' * D2;
% hw2 = abs(A2 - a_c2)' * D2;
% 
% % make decision, choose the smaller width
% if hw1 <= hw2
%     a_c = a_c1;
%     hwd = hw1;
% else
%     a_c = a_c2;
%     hwd = hw2;
% end % if

% alternative way
% ---------------
cp = round(length(A)/2);    % centeral position
[~, idx] = max(D);
shiftsize = cp - idx;
A2 = circshift(A, shiftsize);
if sign(shiftsize) == 1
    A2(1:shiftsize) = A2(1:shiftsize) - 180;
else
    A2(end+shiftsize+1:end) = A2(end+shiftsize+1:end) + 180;
end % if
D2 = circshift(D, shiftsize);

% if a_c < 180 && a_c > 90
%     a_c = a_c - 180;
% end % if

a_c = A2' * D2;
hwd = abs(A2 - a_c)' * D2;

% commit result
dirt = a_c;
hw = hwd;

end % function calDirect

% [EOF]
