
function [gabor,x,y] = make_gabor(trial,graph)

xmax = trial.gabor_window_size;
xmin = -xmax;
ymax = xmax;
ymin = xmin;

[x,y] = meshgrid(xmin:xmax,ymin:ymax);


% *** To lengthen the period, increase pixelsPerPeriod.
pixelsPerPeriod = trial.sinPeriod ; % How many pixels will each period/cycle occupy?
spatialFrequency = 1 / pixelsPerPeriod; % How many periods/cycles are there in a pixel?
radiansPerPixel = spatialFrequency * (2 * pi); % = (periods per pixel) * (2 pi radians per period)

a=radiansPerPixel;


% Converts meshgrid into a sinusoidal matrix only for the x direction where the
% period of the sinusoid is equal to "pixelsPerPeriod" pixels.
sinMatrix = sin(a*x - a*pi);




% Creates a circular Gaussian mask centered at the origin, where the number
% of pixels covered by one standard deviation in the X/Y is approximately
% Xgauss/Ygauss
gaussMatrix = exp(-.5*((x/trial.Xgauss) .^ 2 + (y/trial.Ygauss) .^ 2));



% Since each entry of sinMatrix varies between minus one and one and each entry of
% circularGaussianMaskMatrix vary between zero and one, each entry of
% gabor varies between minus one and one.

gabor = sinMatrix .* gaussMatrix;

% This is to get rid of stuff outside of circle so we can only see two
% lobes
gabor(abs(gabor) < .09 & x.^2 + y.^2 > (trial.gaborSize/1.4)^2) = 0;








