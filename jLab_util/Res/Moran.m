% Moran: Moran's I, a measure of global spatial autocorrelation.
%
%     Usage: [I,Ici] = Moran(crds,x,{iter},{ci_level})
%
%         crds =     [n x p] matrix of spatial coordinates in P dimensions.
%         x =        [n x 1] vector of corresponding values of the variable of interest.
%         iter =     optional number of bootstrap iterations [default = 0].
%         ci_level = optional level of confidence for confidence interval [default = 95].
%         -------------------------------------------------------------------------------
%         I =        value of Moran's I.
%         Ici =      [1 x 2] vector of confidence limits.
%

% RE Strauss, 3/25/05

function [I,Ici] = Moran(crds,x,iter,ci_level)
  if (nargin == 0) help Moran; return; end;
  
  if (nargin < 3) iter = []; end;
  if (nargin < 4) ci_level = []; end;
  
  if (isempty(iter)) iter = 0; end;
  if (isempty(ci_level)) ci_level = 0.95; end;
  
  if (ci_level > 1)
    ci_level = ci_level / 100;
  end;
  
  [n,p] = size(crds);
  if (length(x)~=n)
    error('  Moran: input matrices must have same number of observations.');
  end;
  
  if (iter)
    distrib = zeros(iter,1);
  end;
  
  w = eucl(crds);             % Euclidean spatial weight matrix
  xbar = mean(x); 
  s2 = var(x)*(n-1)/n;  
  denom = s2*sum(trilow(w));
  
  I = 0;
  for i = 1:(n-1)
    di = x(i)-xmean;
    for j = 2:n
      I = I + (w(i,j)*di*(x(j)-xmean))/denom;
    end;
  end;


  return;
  