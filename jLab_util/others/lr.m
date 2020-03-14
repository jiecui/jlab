function [b,stats,stats2,yfit,deltay,r] = lr(x,y,show)
%LR linear regression by least squares.
% Also given are the regression coefficients (with their standard deviations), R2, p ,F, and t values
% and 95% confidence band
% [B,STATS,STATS2,YFIT,DELTAY,R] = LR(X,Y,SHOW) 
% Inputs:
%  X: vector of independent variable
%  Y: vector of dependent variable (same size as X)
%  SHOW (optional): 0 does nothing (default), 1 plots data, fit, and 95% confidence band
% Outputs:
%  B: vector of regression coefficients in the linear model  Y = XB
%  STATS: R-square, F, and p values for the regression
%  STATS2: coefficients with their standard deviations, t-values, and p-values
%  YFIT: y fitted values
%  DELTAY: y values of 95% confidence band
%  R: vector of residuals
%
% Obs.: In the case you do not want to consider a point (e.g., if it is an outlier),
% just substitute that point by NaN that it will be ignored.
%
%Function REGRESS modified by Marcos Duarte mduarte@usp.br 10Jan2002.

if  nargin == 2,              
    show = 0;      
end 
if size(x,1)==1, x=x'; end
if size(y,1)==1, y=y'; end
x = [ones(length(x),1) x];

p=2;
n = length(y);
alpha = 0.05;

% Remove missing values, if any
wasnan = (isnan(y) | any(isnan(x),2));
if (any(wasnan))
   y(wasnan) = [];
   x(wasnan,:) = [];
   n = length(y);
end

% Find the least squares solution.
[Q, R]=qr(x,0);
b = R\(Q'*y);

% Find a confidence interval for each component of x
% Draper and Smith, equation 2.6.15, page 94
RI = R\eye(p);
xdiag=sqrt(sum((RI .* RI)',1))';
nu = n-p;                       % Residual degrees of freedom
yhat = x*b;                     % Predicted responses at each data point.
r = y-yhat;                     % Residuals.
if nu ~= 0
   rmse = norm(r)/sqrt(nu);     % Root mean square error.
else
   rmse = Inf;
end
s2 = rmse^2;                    % Estimator of error variance.
tval = tinv((1-alpha/2),nu);

% Calculate R-squared.
RSS = norm(yhat-mean(y))^2;  % Regression sum of squares.
TSS = norm(y-mean(y))^2;     % Total sum of squares.
r2 = RSS/TSS;                % R-square statistic.
F = (RSS/(p-1))/s2;          % F statistic for regression
prob = 1 - fcdf(F,p-1,nu);   % Significance probability for regression
stats = [r2 F prob];

% Coefficients with their standard deviations, t-values, and p-values (took from MREGRESS):
covariance = inv(x'*x) .* s2;
C = sqrt(diag(covariance, 0));
p_value = 2 * (1 - tcdf(abs(b./C), (n-2)));
stats2 = [ b, C, (b./C), p_value];

% Find the standard errors of the residuals.
% Get the diagonal elements of the "Hat" matrix.
% Calculate the variance estimate obtained by removing each case (i.e. sigmai)
% see Chatterjee and Hadi p. 380 equation 14.
T = x*RI;
hatdiag=sum((T .* T)',1)';
ok = ((1-hatdiag) > sqrt(eps));
hatdiag(~ok) = 1;
if nu < 1, 
  ser=rmse*ones(length(y),1);
elseif nu > 1
  denom = (nu-1) .* (1-hatdiag);
  sigmai = zeros(length(denom),1);
  sigmai(ok) = sqrt((nu*s2/(nu-1)) - (r(ok) .^2 ./ denom(ok)));
  ser = sqrt(1-hatdiag) .* sigmai;
  ser(~ok) = Inf;
elseif nu == 1
  ser = sqrt(1-hatdiag) .* rmse;
  ser(~ok) = Inf;
end

% Restore NaN so inputs and outputs conform
if (nargout>2 & any(wasnan))
   tmp = ones(size(wasnan));
   tmp(:) = NaN;
   tmp(~wasnan) = r;
   r = tmp;
end

% Plot (took from POLYTOOL):
[beta, S] = polyfit(x(:,2),y,1);
[yfit, deltay]=polyval(beta,x(:,2),S);
df = S.df;
normr = S.normr;

nobs = length(y);
ncoeffs = 2:(nobs-1);
dflist = nobs - ncoeffs;
crit = tinv(1 - alpha/2,dflist);

if S.normr==0
   dy = deltay;
else
   e = (deltay * sqrt(df) / normr).^2;
   e = sqrt(max(0, e-1));
   dy = normr/sqrt(df)*e;
end

deltay = dy * crit(1);

[minx, maxx] = plotlimits(x);
xfit = linspace(minx,maxx,length(x))';

if show
    figure
    hold on
    h1=plot(x(:,2),y,'b+');
    h2=plot(xfit,yfit,'k-');
    h3=plot(xfit,yfit-deltay,'r--',xfit,yfit+deltay,'r--');
    h4=plot(x(1,2),y(1),'w');
    hold off
    set(gca,'XLim',[minx maxx],'Box','on');
    legend([h1 h2 h3(1) h4],'Data',['Y=' num2str(b(1)) '+' num2str(b(2)) '*X'],['95% confidence band'],...
        ['R2=' num2str(round(stats(1)*100)/100) ' , F=' num2str(round(stats(2)*100)/100) ', p=' num2str(stats(3))],0)
    xlabel('X, independent variable')
    ylabel('Y, dependent variable')
end

function [minx, maxx] = plotlimits(x)
% PLOTLIMITS   Local function to control the X-axis limit values.
maxx = max(x(:,2));
minx = min(x(:,2));
xrange = maxx - minx;
maxx = maxx + 0.025 * xrange;
minx = minx - 0.025 * xrange;