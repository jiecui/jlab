% RegressLikelihood: Given estimates of beta0 and beta1 and a set of data,
%           calculates the log-likelihood function.
%
%     Usage: logL = RegressLikelihood(x,y,b0,b1)
%
%         x,y =   [n x 1] vectors.
%         b0,b1 = parameter estimates.
%         -------------------------------------------
%         logL =  log-likelihood function value at b0,b1.
%

% RE Strauss, 9/1/04

function logL = RegressLikelihood(x,y,b0,b1)
  n = length(x);
  pred = b0 + b1*x;
  s2 = sum((y-pred).^2)/n;
  logL = -(n/2)*log(2*pi*s2) - (1/2*s2)*sum((y-pred).^2);
  return;
  