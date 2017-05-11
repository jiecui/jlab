function stage1_data = stage1process(this, sname, options)
% GFSMSACC.STAGE1PROCESS processes for stage 1
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

% Copyright 2016 Richard J. Cui. Created: Wed 08/10/2016 11:12:00.764 AM
% $Revision: 0.1 $  $Date: Wed 08/10/2016 11:12:00.765 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

stage1_data_eye = this.analyze_eye_movements( sname, options );
stage1_data = stage1_data_eye;

end % function stage1process

% [EOF]
