function [S, txx, fxx] = HilbertHuangSpectrum(this, lfp)
% LOCALFIELDPOTENTIAL.HILBERTHUANGSPECTRUM estimates T-F representation with HHS
%
% Syntax:
%   [S, txx, fxx] = HilbertHuangSpectrum(this, lfp)
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%   need TFTB boolbox
% 
% See also .

% Copyright 2015 Richard J. Cui. Created: Fri 03/13/2015  3:46:00.071 PM
% $Revision: 0.1 $  $Date: Fri 03/13/2015  3:46:00.079 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

% get the Gaussian filter
t_sigma     = this.HhsFilterTimeSigma;
t_size      = this.HhsFilterTimeSize;
f_sigma     = this.HhsFilterFreqSigma;
f_size      = this.HhsFilterFreqSize;

mu = [0 0];
Sigma = [f_sigma 0; 0 t_sigma];
Y = -round(f_size/2):round(f_size/2); 
X = -round(t_size/2):round(t_size/2);
[Y1,X1] = meshgrid(Y,X);
H = mvnpdf([Y1(:) X1(:)], mu, Sigma);
H = reshape(H,length(Y),length(X));
H = H / sum(sum(H));    % normalize to 1

% estimate the spectrogram
[N, n_trl] = size(lfp);
Nf  = this.HhsNumFreqBins;
fpass = this.HhsFPassIdx;
fb_idx = fpass(1);
fe_idx = fpass(2);
nfpassbins = fe_idx - fb_idx + 1;
l = 1;  % to compensate the parameter l in hhspectrum.m
im = zeros(nfpassbins, N - 2 * l, n_trl);
wh = waitbar(0, 'Estimate HHS for one unit of LFPs ...');
% parfor k = 1:n_trl
for k = 1:n_trl
    waitbar((k - 1) / n_trl, wh)
    
    lfp_k = lfp(:, k);
    
    imf_k = emd(lfp_k);
    [A_k, f_k] = hhspectrum(imf_k(1:end-1, :));
    im_k = toimage(A_k, f_k, Nf);
    im_k = imfilter(im_k, H);
    
    im(:, :, k) = im_k(fb_idx:fe_idx, :);
end % for
waitbar(1, wh)
close(wh)

% output
S = permute(im, [2, 1, 3]);

imf = emd(lfp(:, 1));
[A, f] = hhspectrum(imf(1:end-1, :));
[~, tt, ff] = toimage(A, f, Nf);
txx = tt';
fxx = ff(fb_idx:fe_idx)';

end % function HilbertHuangSpectrum

% =========================================================================
% subroutines
% =========================================================================


% [EOF]
