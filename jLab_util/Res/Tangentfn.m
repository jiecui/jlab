% TANGENTFN: 2D tangent-angle function of a quadratic-spline smoothing of an open or 
%           closed polygon, as a function of length along the boundary 
%           (arc-length).  Tangent angle of the start point is defined to be zero.  
%           Plots the fitted outline and the tangent-angle function.
%
%     Usage: [theta,perim,indx] = tangentfn(crds,{start},{noplot},{nsp})
%
%           crds =    [n x 2] matrix of point coordinates.
%           start =   optional index (subscript) of starting point, for closed boundaries. 
%                       [default = first point in 'crds'].
%           noplot =  optional boolean flag indicating, if true, that plot of 
%                       the radius function is not to be produced [default = 0].
%           nsp =     optional number of fitted points to be returned [default=256].
%           ------------------------------------------------------------------------------
%           theta =   [nsp x 1] vector of tangent-angles.
%           perim =   correspoinding vector of perimeter distances (arc-lengths) of 
%                       tangent-angles from starting point.
%           indx =    [n x 1] vector of indices of 'theta' most closely corresponding to 
%                       each point in 'crds'.
%

% RE Strauss, 3/26/00
%   9/12/01 - added initial figure window.
%   2/4/05 -  allow for open boundaries;
%             plot original points on tangent-angle function.

function [theta,perim,indx] = tangentfn(crds,start,noplot,nsp)
  if (nargin < 2) start = []; end;
  if (nargin < 3) noplot = []; end;
  if (nargin < 4) nsp = []; end;

  if (isempty(start))  start = 1; end;
  if (isempty(noplot)) noplot = 0; end;
  if (isempty(nsp))    nsp = 256; end;
  
  get_perim = 0;
  if (nargout>1 | ~noplot)
    get_perim = 1;
  end;

  [n,p] = size(crds);
  if (p~=2)
    error('  TANGENTFN: 2-dimensional input coordinates only.');
  end;

  if (~isscalar(start))
    error('  TANGENTFN: starting index must be a scalar.');
  elseif (start<1 | start>n)
    error('  TANGENTFN: starting index out of range.');
  end;

  [scrds,indx] = quadspln(crds,start,0,nsp);     % Quadratic splining of crds
  
  d1 = scrds(2,:)-scrds(1,:);
  dn = scrds(end,:)-scrds(end-1,:);
  ascrds = [scrds(1,:)-d1; scrds; scrds(end,:)+dn]; % Extend fitting
  
  P = ascrds(1:nsp,:);                    % Points forming angles
  Q = P + ones(nsp,1)*([1 0]);
  R = ascrds(3:nsp+2,:);

  theta = angl(Q,P,R,1);                  % Tangent-angles
  dt = [theta(2:nsp) - theta(1:nsp-1)];

  i = find(dt > pi);
  if (~isempty(i))
    dt(i) = dt(i) - 2*pi;
  end;
  i = find(dt < -pi);
  if (~isempty(i))
    dt(i) = dt(i) + 2*pi;
  end;
  theta = [0; cumsum(dt)];

  if (get_perim)                          % Distance along perimeter
    perim = zeros(nsp,1);
    for i = 2:nsp
      perim(i) = perim(i-1) + eucl(scrds(i-1,:),scrds(i,:));  % Accum perimeter length
    end;
  end;

  if (~noplot)
    figure;
    plot(crds(:,1),crds(:,2),'ko');
    hold on;
    plot(crds(start,1),crds(start,2),'k*');
    plot(scrds(:,1),scrds(:,2),'k');
    hold off;
    putbnd([crds; scrds]);

    figure;
    plot(perim,theta,'k',perim(indx),theta(indx),'kx');
    putbnd(perim,theta);
    putxlab('Distance along boundary');
    putylab('Tangent-angle');
  end;

  return;


