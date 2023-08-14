function [S, txx, fxx] = TftbTFRrsp(this, lfp)
% LOCALFIELDPOTENTIAL.TFTBTFRRSP estimates T-F representation with reassigned spectrogram
%
% Syntax:
%   [S, txx, fxx] = TftbTFRrsp(this, lfp)
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

% get the window
Nh  = this.TftbWinSize;
wn  = this.TftbWinName;
w   = tftb_window(Nh, wn);

% estimate the spectrogram
T   = this.TftbTimeInstants;
Nf  = this.TftbNumFreqBins;
n_trl = size(lfp, 2);   % number of trials
fpass = this.TftbFPassIdx;
fb_idx = fpass(1);
fe_idx = fpass(2);
nfpassbins = fe_idx - fb_idx + 1;
rs = zeros(nfpassbins, numel(T), n_trl);
for k = 1:n_trl
    lfp_k = lfp(:, k);
    [~, rs_k] = tfrrsp(lfp_k, T, Nf, w);
    rs(:, :, k) = rs_k(fb_idx:fe_idx, :);
end % for

% output
txx = T(:);
f = linspace(0, 1, Nf);
fxx = f(fb_idx:fe_idx); fxx = fxx(:);
S = permute(rs, [2, 1, 3]);

end % function TftbTFRrsp

% =========================================================================
% subroutines
% =========================================================================


% [EOF]
