function fit = LocfitRateEstimation(varargin)
% LOCFITRATEESTIMATION estimates rates of a point process with Locfit
%       approach.
%
% Syntax:
%   fit = LocfitRateEstimation(pt, ...)
%
% Input(s):
%   pt      - n x 1 point times
%   other   - other arguments follow locfit(). 'family' must be 'rate'
% 
% Output(s):
%   fit     - locfit() fit structure
%
% Example:
%   load lmem5312.mat;
%   fit = locfit(data(6).times{1},'xlim',[78.9 80.30],'family','rate','nn',0.6);
%   lfplot(fit);
%   title('Spike Firing Rate Estimation');
%   lfband(fit);
%
% See also locfit.

% Copyright 2012 Richard J. Cui. Created: 07/06/2012 11:16:09.480 AM
% $Revision: 0.1 $  $Date: 07/06/2012 11:16:09.480 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% point time
pt = varargin{1};   
pt = sort(pt(:));   % must be column vector

fit = locfit(pt, varargin{2:end});

end % function LocfitRateEstimation

% [EOF]
