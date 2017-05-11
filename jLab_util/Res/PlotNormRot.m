% PlotNormRot: Plots a normal distribution, rotated by a desired angle that depends
%     on the specified endpoints of the base of the distribution.  If the angle
%     is not 90, 180 or 270 degrees, then axis units must be set to equal intervals
%     to maintain the proper shape of the distribution.
%
%     Usage: PlotNormRot(base1,base2,{nobase},{height},{'linespecs'})
%
%         base1 =       [1 x 2] vector of coordinates for left base of distribution.
%         base2 =       [1 x 2] vector of coordinates for right base of distribution.
%         nobase =      optional boolean flag indicating, if true, that the base
%                         of the distribution is not to be plotted 
%                         [default = 0 = plot base].
%         height =      optional multiplicative scaling factor for height of 
%                         distribution [default = 1].
%         'linespecs' = optional line type/color for plot statement [default = 'k'].
%

% RE Strauss, 11/6/04

function PlotNormRot(base1,base2,nobase,height,linespecs)
  if (nargin < 3) nobase = []; end;
  if (nargin < 4) height = []; end;
  if (nargin < 5) linespecs = []; end;
  
  if (isempty(nobase))    nobase = 0; end;
  if (isempty(height))    height = 1; end;
  if (isempty(linespecs)) linespecs = 'k'; end;

  baselen = eucl(base1,base2);
  x = linspace(-3,3)';
  y = normpdf(x);
  
  x = linspace(0,baselen)';
  y = y * baselen * height;
  
  xbase = x([1,end]);
  ybase = [0,0]';
  
  theta = angledev(base1-[1,0],base1,base2);
  newpts = rotate([x,y; xbase,ybase],theta,[0,0]);
  [x,y] = extrcols(newpts);
  x = x + base1(1);
  y = y + base1(2);

  hold on;
  plot(x(1:end-2),y(1:end-2),linespecs);
  if (~nobase)
    plot(x(end-1:end),y(end-1:end),linespecs);
  end;

  return;
  