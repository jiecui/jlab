function [beta, stats] = myrobustfit(x,y,degree)
% here, stats contains the fit confidence intervals, but I have to make
% sure the ci's are of the curve, not the samples. NOT TESTED!!
if nargin <3
    degree = 1;
end
% Construct Vandermonde matrix
V = ones(length(x),degree+1);
if (degree>0), V(:,end-1) = x; end
for j = degree-1:-1:1
    V(:,j) = x.*V(:,j+1);
end
[beta, other] = robustfit(V,y,'bisquare',[],0);

% Compute robust version of stuff polyfit places into structure
S.R = other.R;
S.df = other.dfe;
S.normr = sqrt(other.dfe) * other.s;
stats.beta = beta';
stats.structure = S;
if nargout == 2
    structure = stats.structure;
	beta = stats.beta;
    R = structure.R;
    df = structure.df;
    rmse = structure.normr / sqrt(df);
    Rinv = eye(size(R))/R;
    dxtxi = sqrt(sum(Rinv'.*Rinv'));
    stats.dbeta = dxtxi*stats.crit(degree)*rmse;
    stats.betaci=[beta-dbeta; beta+dbeta];
end