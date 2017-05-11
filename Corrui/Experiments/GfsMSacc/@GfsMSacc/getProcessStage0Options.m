function opt = getProcessStage0Options( this )
% GFSMSACC.GETPROCESSSTAGE0OPTIONS options of process stage 0
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

% Copyright 2016 Richard J. Cui. Created: Sun 07/31/2016  4:01:19.809 PM
% $Revision: 0.1 $  $Date: Sun 07/31/2016  4:01:19.809 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

S.rm_mua_spk = { {'0', '{1}'}, 'Remove MUA spikes' };
S.Remove_MUA_spikes_options.threshold = {18, 'Threshold (STD)', [0 Inf]};

opt = S;

end % function getProcessStage0Options

% [EOF]
