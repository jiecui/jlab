function stage1_data = stage1process(this, sname, options)
% MSCLED.STAGE1PROCESS (summary)
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

% Copyright 2014 Richard J. Cui. Created: Tue 07/01/2014  9:46:19.122 PM
% $Revision: 0.1 $  $Date: Tue 07/01/2014  9:46:19.122 PM $
%
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

stage1_data_eye = this.analyze_eye_movements( sname, options );
stage1_data_spike = this.detect_spike_events(sname, options);
stage1_data = mergestructs(stage1_data_eye, stage1_data_spike);

end % function stage0process

% [EOF]
