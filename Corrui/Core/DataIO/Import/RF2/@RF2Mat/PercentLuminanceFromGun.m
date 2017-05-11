function percent_lum = PercentLuminanceFromGun(~,gun_value,usergamma,gamma)
%						Percent_Luminance_From_Gun
%   Returns the percent luminance of the given gun value taking into
%   account the given usergamma, and the monitor's gamma values
% 
% adapted from percentluminancefromgun.m

% Copyright 2009-2010 Richard J. Cui. Created: 12/15/2009  6:36:09.109 PM
% $Revision: 0.2 $  $Date: 02/20/2010 10:43:01.870 AM $
% 
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
% 
% Email: jie@neurocorrleate.com

if(gamma/usergamma > 0.000)
    lum_fraction = (gun_value/255.0)^(gamma/usergamma);
    percent_lum = (lum_fraction * 100.0);
end

end%funciton

% [EOF]
