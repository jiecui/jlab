function spkt = getSpktimes(this)
% NEUSPIKE.SPIKETIMES get spike times for all experiment
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

% Copyright 2014 Richard J. Cui. Created: 05/29/2013  4:46:22.343 PM
% $Revision: 0.2 $  $Date: Sat 03/29/2014 10:32:24.197 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

sname = this.sname;
vars = {'spiketimes'};
dat = this.db.Getsessvars(sname, vars);

if isfield(dat, 'spiketimes');
    spkt = dat.spiketimes;
else
    spkt = [];
    fprintf('Warning: no spiketimes in database of %s.\n', sname)
end

end % function spiketimes

% [EOF]
