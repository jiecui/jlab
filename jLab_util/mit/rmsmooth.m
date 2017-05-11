function yout = rmsmooth(yin,N)

% RMSMOOTH.M: Smooths vector data.
%			YOUT=SMOOTH(YIN,N) smooths the data in YIN using a running mean
%			over 2*N+1 successive point, N points on each side of the
%			current point. At the ends of the series one-sided
%			means are used.

%			Olof Liungman, 1997
%			Dept. of Oceanography, Earth Sciences Centre
%			Göteborg University, Sweden
%			E-mail: olof.liungman@oce.gu.se
%MODIFIED BY MIKE MCCAMY
% revised by Richard J. Cui on Mon 07/09/2012  2:36:34.347 PM

if nargin<2, error('Not enough input arguments!'), end


[rows,cols] = size(yin);
if min(rows,cols)~=1, error('Y data must be a vector!'), end
if length(N)~=1, error('N must be a scalar!'), end

yin = (yin(:))';
L = length(yin);
yout = zeros(1,L);
temp = zeros(2*N+1,L-2*N);
temp(N+1,:) = yin(N+1:L-N);

for i = 1:N
    yout(i) = nanmean(yin(1:i+N));
    yout(L-i+1) = nanmean(yin(L-i-N:L));
    temp(i,:) = yin(i:L-2*N+i-1);
    temp(N+i+1,:) = yin(N+i+1:L-N+i);
end

yout(N+1:L-N) = nanmean(temp);

if size(yout)~=[rows,cols], yout = yout'; end
