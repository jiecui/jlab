%  LoessFit:  Nonparametric curve fitting using locally weighted regression.  Produces,
%             by default, six plots with varying values of alpha, in addition to the
%             plot for a given value of alpha.
%             See: Cleveland, W.S. 1993. Visualizing Data. Hobart Press, Summit NJ, 360 p.
%
%     Usage: crds = LoessFit(x,y,{alpha},{lambda},{xfit},{robust},{noplot})
%
%         x,y =    vectors (length N) of coordinates of data points.
%         alpha =  optional smoothing factor, typically 0.2 to 1.0 [default = 0.5].
%         lambda = optional polynomial order 1 or 2 [default = 2, quadratic].
%         xfit =   optional vector (length M) of abscissa values to be fitted
%                    [default = linspace(min(x),max(x),100)].
%         robust = optional boolean flag; if true, bisquare to iteratively
%                    identify and downweight outliers in the fit [default = 1].
%         noplot = optional boolean flag indicating, if true, that the plots of data and
%                    fitted function are to be suppressed [default = 0].
%         ------------------------------------------------------------------------------
%         crds =   [N x 2] matrix of 'xfit' and fitted ordinate values corresponding
%                    to xfit.
%

% RE Strauss, 3/11/05, modified from Datatool LOESS function.

function crds = LoessFit(x,y,alpha,lambda,xfit,robust,noplot)
  if (nargin < 3) alpha = []; end;
  if (nargin < 4) lambda = []; end;
  if (nargin < 5) xfit = []; end;
  if (nargin < 6) robust = []; end;
  if (nargin < 7) noplot = []; end;
  
  default_alpha = 0.5;                      % Default parameter values
  default_lambda = 2;
  default_robust = 0;
  
  plot_alpha = [0.2:0.1:1.0];               % Alpha values for subplots
  plot_single_alpha = 0;

  if (isempty(xfit))   xfit = linspace(min(x),max(x),100); end;
  if (isempty(lambda)) lambda = default_lambda; end;
  if (isempty(noplot)) noplot = 0; end;
  
  if (isempty(alpha))
    alpha = default_alpha;
  else
    plot_single_alpha = 1;
  end;

  robustfit = 0;
  if (isempty(robust)) robustfit = default_robust; end;
  
  xfit = xfit(:);                           % Allocate coordinates as column vectors
  tol = 0.003;                              % Tolerance for robust fitting
  maxiter = 100;

  crds = loess(x,y,xfit,alpha,lambda,robustfit,tol,maxiter);
  
  if (~noplot)
    if (plot_single_alpha)
      scatter(x,y);
      hold on;
      plot(crds(:,1),crds(:,2),'k');
      hold off;
    end;
    
%     figure;
%     for iplot = 1:9
%       a = plot_alpha(iplot);
%       c = loess(x,y,xfit,a,lambda,robustfit,tol,maxiter);
%       subplot(3,3,iplot);
%       plot(x,y,'ko');
%       putbnds([x;c(:,1)],[y;c(:,2)]);
%       hold on;
%       plot(c(:,1),c(:,2),'k');
%       hold off;
%       title(['\alpha',sprintf(' = %4.2f',a)]);
%     end;
  end;
  
  return;

% ==================================================================================
% loess: Fits the loess model.
%
%     Usage: crds = loess(xfit,alpha,lambda,robustfit,tol,maxiter)
%

function crds = loess(x,y,xfit,alpha,lambda,robustfit,tol,maxiter)
  n = length(x);                            % Number of data points
  yfit = zeros(size(xfit));
  q = floor(alpha*n);
  q = max([q,1]);
  q = min([q,n]);                           % Used for weight function width
  
  for pt = 1:length(xfit)                   % Cycle thru fitted points
    deltax = abs(xfit(pt)-x);                 % Distances from current point to data
    deltaxsort = sort(deltax);                % Sorted small to large
    qthdeltax = deltaxsort(q);                % Width of weight function
    arg = min(deltax/(qthdeltax*max(alpha,1)),1);
    tricube = (1-abs(arg).^3).^3;             % Weight function for x distance
    index = tricube>0;                        % Find points with nonzero weights
    p = least2(x(index),y(index),lambda,tricube(index));  % Weighted fit parameters
    new_yfit = polyval(p,xfit(pt));           % Evaluate fit at current point
    
    if (robustfit)                            % Use bisquare for robust fitting
      test = 10*tol;
      niter = 1;
      while (test > tol)
        old_yfit = new_yfit;
        residual = y(index)-polyval(p,x(index));  % Fit errors at points of interest
        weight = bisquare(residual);              % Robust weights based on residuals
        newWeight = tricube(index).*weight;       % New overall weights
        p = least2(x(index),y(index),lambda,newWeight);  
        new_yfit = polyval(p,xfit(pt));           % Revised fit
        niter = niter+1;
        if (niter > maxiter)
          disp('  LoessFit: too many iterations.');
          break;
        end;
        test = max(0.5*abs(new_yfit-old_yfit)./(new_yfit+old_yfit));
      end;
    end;
    yfit(pt) = new_yfit;
  end;
  
  crds = [xfit,yfit];
  return;

% ==================================================================================

% least2: Estimates the coefficients of a polynomial p(x) of degree n that fits the 
%         data, p(x(i)) ~= y(i), in a weighted least-squares sense with weights w(i).
%
%     Usage: [p,S] = least2(x,y,n,w)
%
%     The structure S contains additional info.  Based on polyfit(). 
%

% The regression problem is formulated in matrix format as:
%
%    A'*W*y = A'*W*A*p
%
% where the vector p contains the coefficients to be found.  For a
% 2nd order polynomial, matrix A would be:
%
% A = [x.^2 x.^1 ones(size(x))];

% RE Strauss, 3/11/05, modified from Datatool function least2.

function [p,S] = least2(x,y,n,w)
  if (nargin==4)
    if (any(size(x) ~= size(w)))
      error('X and W vectors must be the same size.')
    else
      w = ones(size(x));    %		default weights are unity.
    end;
  end;
    
  if any(size(x) ~= size(y))
    error('  least2: X and Y vectors must be the same size.')
  end;
  
  x = x(:);
  y = y(:);
  w = w(:);

  zindex=find(w==0);  % Remove data for w=0 to reduce computations and storage
  x(zindex) = [];
  y(zindex) = [];
  w(zindex) = [];
  nw = length(w);

  W = spdiags(w,0,nw,nw); % Construct sparse matrices to avoid large weight matrix.

  A = vander(x);
  A(:,1:length(x)-n-1) = [];

  V = A'*W*A;
  Y = A'*W*y;

  [Q,R] = qr(V,0);  % Solve least squares problem. Use QR decomposition for computation.
    
  p = R\(Q'*Y);    % Same as p = V\Y;
  r = Y - V*p;     % residuals
  p = p';          % Polynomial coefficients are row vectors by convention.

  % S is a structure containing three elements: the Cholesky factor of the
  % Vandermonde matrix, the degrees of freedom and the norm of the residuals.

  S.R = R;
  S.df = length(y) - (n-1);
  S.normr = norm(r);

  return;

% ==================================================================================

% bisquare: Calculate robustness weights using bisquare technique.
%
%     Usage: weight = bisquare(residual)

% RE Strauss, modified from Datatool function bisquare().

function weight = bisquare(residual)
  s = median(abs(residual));      % Use median absolute deviation of residuals as scale factor
  u = min(abs(residual/(6*s)),1); % Make 0<= scaled residuals <=1
  weight = (1-u.^2).^2;           % Use bisquare function
  return;
  