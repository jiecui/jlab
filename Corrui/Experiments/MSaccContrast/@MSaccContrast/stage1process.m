function stage1_data = stage1process(this, sname, options)
% MSACCCONTRAST.STAGE1PROCESS porcesses for stage 1 
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

% Copyright 2014-2016 Richard J. Cui. Created: Wed 03/19/2014  5:29:37.047 PM
% $Revision: 0.2 $  $Date: Tue 08/02/2016  4:04:54.663 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

stage1_data_eye = this.analyze_eye_movements( sname, options );
stage1_data_spike = this.detect_spike_events(sname, options);
stage1_data = mergestructs(stage1_data_eye, stage1_data_spike);

end % function stage0process

% [EOF]
