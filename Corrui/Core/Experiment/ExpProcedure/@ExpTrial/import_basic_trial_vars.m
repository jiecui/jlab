function import_basic_trial_vars(this)
% IMPORT_BASIC_TRIAL_VARS (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/31/2014 12:02:50.932 PM
% $Revision: 0.1 $  $Date: 03/31/2014 12:02:50.932 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

vars = {'enum', 'samplerate'};
dat = this.db.Getsessvars(this.sname, vars);

if isfield(dat, 'enum')
    this.enum               = dat. enum;
end

if isfield(dat, 'samplerate')
    this.samplerate         = dat.samplerate;
end

end % function import_basic_trial_vars

% [EOF]
