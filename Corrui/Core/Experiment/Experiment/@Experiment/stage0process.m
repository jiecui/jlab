function [imported_data, stage0_data] = stage0process(this, sname, options)
% EXPERIMENT.STAGE0PROCESS (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/17/2014 10:34:22.854 AM
% $Revision: 0.1 $  $Date: 03/17/2014 10:34:22.870 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

fprintf('Experiment %s has null stage0process for session %s.\n', ...
    this.name, sname)

imported_data = [];
stage0_data = [];

end % function stage0process

% [EOF]
