function [num_tsteps, num_fpoints] = getChronuxSpecgramSize(N, movingwin, params)
% LOCALFIELDPOTENTIAL.GETCHRONUXSPECGRAMSIZE helper function to decide the dimension of the spectrogram
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

% Copyright 2015 Richard J. Cui. Created: Sun 03/01/2015  3:27:23.509 PM
% $Revision: 0.1 $  $Date: Sun 03/01/2015  3:27:23.619 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

% number of frequency points
pad     = params.pad;
fpass   = params.fpass;
Fs      = params.Fs;
Nwin    = round(movingwin(1) * Fs);    % number of samples in window
Nstep   = round(movingwin(2) * Fs);    % number of samples to step through
nfft = max(2^(nextpow2(Nwin) + pad), Nwin);
f = getfgrid(Fs, nfft, fpass); 
num_fpoints =length(f);

% number of time points
winstart = 1:Nstep:N-Nwin+1;
num_tsteps = length(winstart); 

end % function getChronuxSpecgramSize

% [EOF]
