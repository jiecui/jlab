% PlsRegr: Partial least squares regression using the NIPALS algorithm.
%
%     Usage: [b,Xload,Yload,W,inner,Xscores,Yscores,Xpred,Ypred,Xres,Yres] = ...
%               PlsRegr(X,Y,{lvMax})
%
%         X =       [n x p] matrix of prediction variables.
%         Y =       [n x m] matrix of response variables.
%         lvMax =   optional maximum number of latent variables to estimate. 
%         ---------------------------------------------------------------------------------
%         b =       [lv x m] matrix of regression coefficients (B) of Y scores on X scores.
%         Xload =   [p x lv] matrix of X model-effect loadings on latent variables.
%         Yload =   [m x lv] matrix of Y loadings on latent variables.
%         W =       [p x lv] matrix of model effect weights, specifying directions of latent
%                            variables in terms of X.
%         inner =   [1 x lv] vector of inner regression coeffs between Y scores and X scores.
%         Xscores = [n x lv] matrix of X scores on latent variables (T).
%         Yscores = [n x lv] matrix of Y scores on latent variables (U).
%         Xpred =   [n x lv] matrix of predicted X scores.
%         Ypred =   [n x lv] matrix of predicted Y scores.
%         Xres =    [n x lv] matrix of residual X scores.
%         Yres =    [n x lv] matrix of residual Y scores.

% RE Strauss, 6/18/04

function [b,Xload,Yload,W,inner,Xscores,Yscores,Xpred,Ypred,Xres,Yres] = ...
           PlsRegr(X,Y,lvMax)
  if (nargin < 3) lvMax = []; end;         

  [n,p] = size(X);
  [ny,m] = size(Y);

  if (n ~= ny)
    error('  PlsRegr: X and y must have same number of observations')
  end;
  
  Xmean = mean(X);                % Save means & stds and standardize data matrices
  Xstd = std(X);
  Ymean = mean(Y); 
  Ystd = std(Y);
  X = zscores(X);
  Y = zscores(Y);

  if (isempty(lvMax))             % Number of latent variables
    lv = min([lvMax,p]); 
  else 
    lv = p; 
  end;

  rankX = rank(X);
  if (rankX < lv)
    disp(['  PlsRegr: ',int2str(rankX),' latent variables estimated due to low rank of X']);
    lv = rankX;
  end

lv_p_m = [lv p m]  

  b =       zeros(lv,p);          % Allocate output variables
  Xload =   zeros(p,lv);
  Yload =   ones(m,lv);
  W =       zeros(p,lv);
  Xscores = zeros(n,lv);
  Yscores = zeros(n,lv);
  inner =   zeros(1,lv);

  for ilv = 1:lv,                 % Estimate parameters for each latent variable, returning residuals
    [Xload(:,ilv),Yload(:,ilv),W(:,ilv),Xscores(:,ilv),Yscores(:,ilv),inner(ilv),X,Y] = ...
      PlsNipals(X,Y);
ilv
Xload
Yload
    if (p>2)
      if (vectcorr(Xload(:,ilv),ones(p,1))<0)  % Reverse vector directions if necessary
        Xload(:,ilv) = -Xload(:,ilv);
        Xscores(:,ilv) = -Xscores(:,ilv);
      end;
    end;
    if (m>2)
      if (vectcorr(Yload(:,ilv),ones(m,1))<0)
        Yload(:,ilv) = -Yload(:,ilv);
        Yscores(:,ilv) = -Yscores(:,ilv);
      end;
    end;
  end;
  
  b = PlsRegrCoeff(Xload,Yload,W,inner);   % Regression coefficients
  
%   [Ypred,t,Xres] = mvfullpredict(X,W,P,inner,lv,q,b0,xmean)
  [Ypred,t,Xres] = mvfullpredict(X,W,Xload,inner,lv,Yload);
  
  Xpred = [];
  Yres = [];
  
  inner = inner';

  return;
  
% ------------------------------------------------------------------------------------

% PlsNipals: Nonlinear iterative partial least squares (NIPALS) algorithm.  Estimates
%            first latent variable for X,Y data.
%
%     Usage: [Xload,Yload,W,Xscores,Yscores,inner,Xres,Yres] = PlsNipals(X,Y)
%
%         X =       [n x p] matrix of prediction variables.
%         Y =       [n x m] matrix of response variables.
%         ------------------------------------------------------------------
%         Xload =   [p x lv] matrix of X loadings on latent variables.
%         Yload =   [m x lv] matrix of Y loadings on latent variables.
%         W =       [p x lv] matrix of loading weights.
%         Xscores = [n x lv] matrix of X scores on latent variables.
%         Yscores = [n x lv] matrix of Y scores on latent variables.
%         inner =   [1 x lv] vector of inner relationships (X/Y scores).
%         Xres =    [n x lv] matrix of residual X scores.
%         Yres =    [n x lv] matrix of residual Y scores.
%         

% RE Strauss, 6/21/04

function [Xload,Yload,W,Xscores,Yscores,inner,Xres,Yres] = PlsNipals(X,Y)
  maxit = 100;                              % Max number of iterations
  convcrit = 1e3*eps;                       % Convergence criterion

  [n,p] = size(X);
  [ny,m] = size(Y);

  Xload =       zeros(p,1);                 % Allocate output vectors for current latent variable
  W =           zeros(p,1);
  Xscores =     ones(n,1);  
  Xscores_old = zeros(n,1); 

  if (m == 1)
    Yload = 1;
    Yscores = Y;
  else
    [Yvarmax,Yvarmaxcol]=max(var(Y));       % Column in Y with the highest variance
    Yscores = Y(:,Yvarmaxcol);              % Y scores initial values
  end;

  itnum = 1;
  while (((sum(abs(Xscores_old-Xscores))) > convcrit) & (itnum < maxit))
    itnum = itnum + 1;
    Xscores_old = Xscores;
%     W  = (Yscores'*X)';                     % Same as w = X'*Yscores, but faster
    W = X' * Yscores;
    W  =  W / sqrt(W'*W);                   % Scale to unit length
    Xscores  = X*W;
    if (m > 1)                              % If have more than one column in Y,
      Yload = (Xscores'*Y)';                  % Loadings
      Yload  =  Yload / sqrt((Yload'*Yload)); % Scale to unit length
      Yscores  = Y*Yload;                     % New weighting scores 
    end;
  end;

  Xload = ((Xscores'*X) / (Xscores'*Xscores))';     % X loadings
  Xloadnorm = sqrt(Xload'*Xload);           % Scaling factor
  W = W*Xloadnorm;                          % Rescale X weights
  Xscores = Xscores*Xloadnorm;              % Rescale scores
  Xload = Xload / Xloadnorm;                % Rescale loadings
  inner = (Yscores'*Xscores) / (Xscores'*Xscores);  % Inner product (relation between X and Y scores)
  Xres = X - (Xscores*Xload');              % Residuals from latent variable
  Yres = Y - inner*Xscores*Yload';
  
  return;
  
% ------------------------------------------------------------------------------------

% PlsRegrCoeff: Regression coefficients for PLS regression
%
%     Usage: b = PlsRegrCoeff(Xload,Yload,W,inner)
%
%         Xload =   [p x lv] matrix of X loadings on latent variables.
%         Yload =   [m x lv] matrix of Y loadings on latent variables.
%         W =       [p x lv] matrix of loading weights.
%         inner =   [1 x lv] vector of inner relationships (X/Y scores).
%         --------------------------------------------------------------
%         b =       [lv x m] matrix of regression coefficients.
%

% RE Strauss, 6/21/04

function [b,bcumsum] = PlsRegrCoeff(Xload,Yload,W,inner)
  [m,lv] = size(Yload);
  if (m==1)
    b = W*inv(Xload'*W)*diag(inner)*diag(Yload);
    bcumsum = cumsum(b',1);
  else
    b = W*inv(Xload'*W)*diag(inner)*Yload'; 
  end;
  
  return;
  
% ------------------------------------------------------------------------------------

  function [ypred,t,Xres] = mvfullpredict(X,W,P,inner,lv,q,b0,xmean)
%MVFULLPREDICT -- predict y-values from PLS loading weights
%
%  Usage:
%    [ypred,t,Xres] = mvfullpredict(X,W,P,inner,lv,q,b0,xmean)
%
%  Inputs:
%    X       predictor variables
%    W       PLS loading weights
%    P       PLS X loadings
%    inner   vector containing the inner (X/y scores) relationships
%    lv      number of latent variables to use
%    q       PLS y loadings (NOT SUPPORTED YET!)
%    b0      mean y from calibration data (optional)
%    xmean   mean x from calibration data (optional)
%	     
%  Outputs:  
%    ypred   predicted response values
%    t       PLS scores
%    Xres    X residuals
%
%  Description:
%    Predict response values from multivariate model using loading
%    weights. Centering of input data is done if 'xmean' is provided.
%
[m,n] = size(X);
[p,q] = size(W);

if (p ~= n),
  error('X and W must have same length (rows in W = columns in X)!')
end

if lv > p,
  error(['Max number of latent variables: ' num2str(p)])
end

if (~exist('b0') | isempty(b0)),
  b0 = 0;
end

if exist('xmean'), % center x-data?
  X = mvcenter(X,xmean);
end

t = zeros(m,lv);
ypred = ones(m,1)*b0;
Xres = X;

for i=1:lv,
  % calculate scores
  t(:,i) = Xres*W(:,i);

  % compute residuals
  Xres = Xres - t(:,i)*P(:,i)';

  % do predictions
  ypred = ypred + inner(i)*t(:,i);
end

%end of mvfullpredict
