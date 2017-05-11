function Y = denswt(X,wname,level,sorh,thres)
% DENSWT denoises the signal using stationary (translate-invariant) wavelet
%       decomposition.
%
% Syntax:
%   Y = denswt(X,wname)
%   Y = denswt(X,wname,level)
%   Y = denswt(X,wname,level,sorh)
%   Y = denswt(X,wname,level,sorh,thres)
%
% Input(s):
%   X       - vector or m_by_n matrix, where m is the signal length and n 
%             is the number of signals
%   wname   - wavelet name (see wavenames.m for the detail)
%   level   - number of level for decomposition (optional)
%             default = floor(log2(m))
%   sorh    - soft ('s') or hard ('h') threshold (default = 'h')
%   thres   - 1 x level vector, threshold values for each level. the length
%             of thres must be the same as 'level'.
%
% Output(s):
%   Y       - denoised signal
% 
% Example:
%
% See also swt, ddencmp, wthresh, wextend, iswt.

% Copyright 2010-2016 Richard J. Cui. Created: 04/27/2010  3:55:27.164 PM
% $Revision: 0.4 $  $Date: Wed 08/03/2016 12:53:29.385 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% head for processing multiple signals
% =========================================================================
[m,n] = size(X);    % m - signal length, n - number of signals
if (n > 1) && (m > 1)
    Y = zeros(size(X));
    for i = 1:n  % loop over columns
        if nargin < 3
            Y(:,i) = denswt(X(:,i),wname);
        elseif nargin < 4
            Y(:,i) = denswt(X(:,i),wname,level);
        elseif nargin < 5
            Y(:,i) = denswt(X(:,i),wname,level,sorh);
        else
            Y(:,i) = denswt(X(:,i),wname,level,sorh,thres);
        end % if
    end
    return
end
if m == 1
    X = X(:);   % convert row to column
end

% =========================================================================
% main body for processing a single signal
% =========================================================================
m = size(X,1);

% determine the number of decomposition level
% if nargin < 3
if ~exist('level','var')
    level = floor(log2(m));
end % if

if ~exist('sorh','var')
    sorh = 'h';
end % if

% signal extention if necessary
L = ceil(m/2^level)*2^level-m;  % the length of extension
if true(mod(L,2))  % if L is not an even number
    X0 = X(1:end-1);
    L0 = (L+1)/2;
else
    X0 = X;
    L0 = L/2;
end %if

x = wextend('1d','symw',X0,L0,'b');% the extended signal
% de-noising
if (~exist('thres','var'))
    dx = denoise(x,level,wname,sorh);
else
    dx = denoise(x,level,wname,sorh,thres);
end % if

% recover to orignal signal
dx = dx(:);
Y = dx((L0+1):(L0+m));

end % function denswt

% =====================
% subroutines
% =====================
function dx = denoise(x,level,wname,sorh,thres)

% [swa,swd] = swt(x,level,wname);
% [thr,sorh] = ddencmp('den','wv',x);
% dswd = wthresh(swd,sorh,thr);
% dx = iswt(swa,dswd,wname);

% cf. sw1dtoo.m case 'decompose'
% decompose
% ---------
wDEC = swt(x,level,wname);
swd = wDEC(1:level,:);
swa = wDEC(level+1,:);

% thresholding
% ------------------
if ~exist('thres','var')
    maxTHR = zeros(1,level);
    for k = 1:level
        maxTHR(k) = max(abs(wDEC(k,:)));
    end % for
    meth = 'sqtwolog';
    alfa = 'one';
    option = 'sw1ddenoLVL';
    valTHR = wthrmngr(option,meth,wDEC,alfa);
    valTHR = min(valTHR,maxTHR);
else
    valTHR = thres;
end % if
% dswd = wthresh(swd,sorh,valTHR);
% sorh = 's';
% sorh = 'h';
dswd = threslevel(swd,sorh,valTHR);

% reconstruct de-noised signal
% ----------------------------
dwDEC = [dswd;swa];
dx = iswt(dwDEC,wname);

end % denoise

function y = threslevel(x,sorh,thrs)

y = zeros(size(x));
n = size(x,1);  % number of levels
for k = 1:n
    x_k = x(k,:);
    thrs_k = thrs(k);
    y(k,:) = wthresh(x_k,sorh,thrs_k);
end % for

end % threslevel


% [EOF]
