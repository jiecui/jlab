
function gabor = make_gabor2(trial)


xmax = trial.gabor_fudge_factor*floor(trial.gaborSize);
xmin = -xmax;
ymax = xmax;
ymin = xmin;

[x,y] = meshgrid(xmin:xmax,ymin:ymax);


% *** To rotate the grating, set tiltInDegrees to a new value.
tiltInDegrees = 0; % The tilt of the grating in degrees.
tiltInRadians = tiltInDegrees * pi / 180; % The tilt of the grating in radians.

% *** To lengthen the period of the grating, increase pixelsPerPeriod.
pixelsPerPeriod = 10*trial.sinPeriod ; % How many pixels will each period/cycle occupy?
spatialFrequency = 1 / pixelsPerPeriod; % How many periods/cycles are there in a pixel?
radiansPerPixel = spatialFrequency * (2 * pi); % = (periods per pixel) * (2 pi radians per period)

% *** To enlarge the gaussian mask, increase periodsCoveredByOneStandardDeviation.
% The parameter "periodsCoveredByOneStandardDeviation" is approximately
% equal to
% the number of periods/cycles covered by one standard deviation of the radius of
% the gaussian mask.



a=cos(tiltInRadians)*radiansPerPixel;
b=sin(tiltInRadians)*radiansPerPixel;

% Converts meshgrid into a sinusoidal grating, where elements
% along a line with angle theta have the same value and where the
% period of the sinusoid is equal to "pixelsPerPeriod" pixels.
% Note that each entry of gratingMatrix varies between minus one and
% one; -1 <= gratingMatrix(x0, y0)  <= 1
gratingMatrix = sin(radiansPerPixel*x);




% Creates a circular Gaussian mask centered at the origin, where the number
% of pixels covered by one standard deviation of the radius is
% approximately equal to "gaussianSpaceConstant."
% For more information on circular and elliptical Gaussian distributions, please see
% http://mathworld.wolfram.com/GaussianFunction.html
% Note that since each entry of circularGaussianMaskMatrix is "e"
% raised to a negative exponent, each entry of
% circularGaussianMaskMatrix is one over "e" raised to a positive
% exponent, which is always between zero and one;
% 0 < circularGaussianMaskMatrix(x0, y0) <= 1
circularGaussianMaskMatrix = exp(-.5*((x/trial.Xgauss) .^ 2 +...
    (y/trial.Ygauss) .^ 2));

% Since each entry of gratingMatrix varies between minus one and one and each entry of
% circularGaussianMaskMatrix vary between zero and one, each entry of
% imageMatrix varies between minus one and one.
% -1 <= imageMatrix(x0, y0) <= 1
imageMatrix = gratingMatrix .* circularGaussianMaskMatrix;

gabor = imageMatrix;




