function import_basic_spike_vars(this)
% IMPORT_BASIC_VARS (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/28/2014  9:21:36.344 PM
% $Revision: 0.1 $  $Date: 03/28/2014  9:21:36.346 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

vars = { 'enum',  'samplerate', 'spiketimes' };
dat = this.db.Getsessvars(this.sname, vars);

this.enum               = dat.enum;
this.samplerate         = dat.samplerate;
this.spiketimes         = dat.spiketimes;

end % function import_basic_vars

% [EOF]
