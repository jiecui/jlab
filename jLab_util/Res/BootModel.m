% BootModel: Tests for statistical differences in model coefficients among groups, based
%            on parameter estimates from a model fitted independently to each group.
%            Uses a parametric bootstrap approach, assuming that the model parameters
%            are distributed following a multivariate normal distribution. Bootstraps the
%            parameter space.
%              Does pairwise manovas for all possible pairs of groups, with sequential 
%            Bonferroni corrections for significance.
%
%   Usage: [F_tot,pr_tot,F_pair,pr_pair,signif_pair] = ...
%                                BootModel(params,stderrs,corrs,N,{iter},{noplot},{alpha})
%
%         params =  [k x p] matrix of parameter values for k groups and p parameters.
%         stderrs = [k x p] matrix of correponding standard errors.
%         corrs =   [p x p x k] matrix of corresponding parameter correlation matrices,
%                     for p>2, or a [k x 1] vector of correlations for p=2.
%         N =       [k x 1] vector of sample sizes.  If N is a scalar, it is expanded
%                     into a [k x 1] vector.
%         iter =    optional number of bootstrap iterations [default = 1000].
%         noplot =  optional boolean flag indicating that a plot of confidence intervals
%                     is not to be produced [default = 0 (produce plot) for p=2 and
%                     1 (no plot) for p>2].
%         alpha =   optional value of alpha for significance decisions [default = 0.05].
%         ---------------------------------------------------------------------------------
%         F_tot =       median F-statistic value for pooled manova.
%         pr_tot =      probability of F_tot under the null hypothesis.
%         F_pair =      [k x k] matrix of median pairwise F-statistics.
%         pr_pair =     corresponding [k x k] matrix of probabilities of pairwise F-statistics.
%         signif_pair = corresponding [k x k] matrix of significance decisions based on
%                         sequential Bonferroni adjustments.
%

% RE Strauss, 10/13/04

function [F_tot,pr_tot,F_pair,pr_pair,signif_pair] = ...
                                       BootModel(params,stderrs,corrs,N,iter,noplot,alpha)
  if (nargin < 1) help BootModel; return; end;
  if (nargin < 4) error('  BootModel: too few input parameters.'); end;
  
  if (nargin < 5) iter = []; end;
  if (nargin < 6) noplot = []; end;
  if (nargin < 7) alpha = []; end;
  
  [k,p] = size(params);
  nparampairs = p*(p-1)/2;
  ngrppairs = k*(k-1)/2;
  
  if (isempty(iter))   iter = 1000; end;
  if (isempty(alpha))  alpha = 0.05; end;
  if (isempty(noplot))
    if (p==2)
      noplot = 0; 
    else
      noplot = 1;
    end;
  end;

  if (alpha > 1)
    alpha = alpha / 100;
  end;
  
  if (~isequal(size(params),size(stderrs)))
    error('  BootModel: incompatible parameter and standard-error matrices.');
  end;
  
  N = N(:);
  if (length(N)==1)
    N = N*ones(k,1);
  elseif (length(N)~=k)
    error('  BootModel: invalid sample-size vector.');
  end;
  
  if (ndims(corrs)==2)                 % Convert 2D corrs matrix to 3D
    corrs = corrs(:);
    if (length(corrs)~=k)
      error('  BootModel: invalid parameter-correlation matrix.');
    end;
    c = ones(p,p,k);
    for ik = 1:size(corrs,1)
      c(1,2,ik) = corrs(ik);
      c(2,1,ik) = corrs(ik);
    end;
    corrs = c;
  end;
  
  Fsamp_tot =  0;
  Fnull_tot =  zeros(iter,1);
  Fsamp_pair = zeros(1,ngrppairs);
  Fnull_pair = zeros(iter,ngrppairs);
  
  g = makegrps(1:k,N);
  X = zeros(sum(N),p);
  exact = 1;
  notexact = 0;
  
  e = 0;                      % Use exact sampling to generate observed F-hat values
  for ik = 1:k              
    b = e+1;
    e = b+N(ik)-1;
    X(b:e,:) = randmvn(N(ik),params(ik,:),stderrs(ik,:).^2,corrs(:,:,ik),exact);
  end;
  [lambda,Fsamp_tot] = manova(X,g);
  
  c = 0;
  for ik1 = 1:(k-1)
    for ik2 = (ik1+1):k
      i = find(g==ik1 | g==ik2);
      c = c+1;
      [lambda,Fsamp_pair(c)] = manova(X(i,:),g(i));
    end;
  end;
  
  for it = 1:iter             % Use sampling with variation to generate observed F-hat values
    e = 0;
    for ik = 1:k                % Generate multivar-normal sets of param values per grp
      b = e+1;
      e = b+N(ik)-1;
      X(b:e,:) = randmvn(N(ik),params(ik,:),stderrs(ik,:).^2,corrs(:,:,ik),notexact);
    end;
    gperm = g(randperm(length(g)));
    [lambda,Fnull_tot(it)] = manova(X,gperm);
    c = 0;
    for ik1 = 1:(k-1)
      for ik2 = (ik1+1):k
        i = find(g==ik1 | g==ik2);
        c = c+1;
        gperm = g(i);
        gperm = gperm(randperm(length(gperm)));
        [lambda,Fnull_pair(it,c)] = manova(X(i,:),gperm);
      end;
    end;
  end;
  
  Fnull_tot = sort(Fnull_tot);
  pr_tot = bootprob(Fsamp_tot,Fnull_tot);     % Probability of overall F-statistic
  
  Fnull_pair = sort(Fnull_pair);
  pr_pair = bootprob(Fsamp_pair,Fnull_pair);  % Probabilities of pairwise F-statistics
  
  F_tot = Fsamp_tot;
  F_pair = Fsamp_pair;
  
  F_pair = trisqmat(F_pair);                  % Convert to square symmetric matrices
  pr_pair = trisqmat(pr_pair);
  signif_pair = seqbonf(pr_pair,alpha);
  
  if (~noplot)
    figure;
    for ik = 1:k
      X = randmvn(1000,params(ik,:),stderrs(ik,:).^2,corrs(:,:,ik),exact);
      PlotConfEllipse(X,[1 0 0 1],ik);
    end;
  end;
  
  return;
  