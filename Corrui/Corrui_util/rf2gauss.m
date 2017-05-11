function gaussmatrix=rf2gauss(width, stdd)
% RF2GAUSS makes a 2D gaussian blob on a matrix with size = width  and
% standard deviation = stdd 
%
% Syntax:
%   gaussmatrix = rf2gauss(width, stdd)
%

% Adapted from (c) December 20, 2001, Tom Pologruto and Steve Macknik, All
% Rights Reserved macknik@neuralcorrelate.com
% 
% Copyright 2010 Richard J. Cui. Created: 02/23/2010  9:57:02.817 AM
% $Revision: 0.2 $  $Date: Sat 05/08/2010 11:43 28 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

x = linspace(-width/2,width/2, width);   
y = linspace(-width/2,width/2, width);   
[x,y] = meshgrid(x,y);


gaussmatrix = exp(-(x.^2 + y.^2)/(stdd^2));
% normalization (add up to one)
checksum=sum(sum(gaussmatrix));
gaussmatrix = gaussmatrix/checksum;

end 

% [EOF]