function [p, t] = lyngby_ts_ttest(d1, d2)

% lyngby_ts_ttest      - Two sample Student t test, equal variances.
%
%       function [p, t] = lyngby_ts_ttest(X1, X2)
%
%       Input:  X1   First set of samples 
%               X2   Second set of samples
%       
%       Output: p    p-values
%               t    Student test size
%
%       lyngby_ts_ttest gives the probability that Student's t
%       calculated on data X1 and X2, sampled from distributions
%       with the same variance, is higher than observed, i.e.
%       the "significance" level. This is used to test whether
%       two sample have significantly different means.
%       [P, T] = lyngby_ts_ttest(X1, X2) gives this probability P and
%       the value of Student's t in T. The smaller P is, the more
%       significant the difference between the means.
%       E.g. if P = 0.05 or 0.01, it is very likely that the
%       two sets are sampled from distributions with different
%       means.
%
%       This works if the samples are drawn from distributions with
%       the SAME VARIANCE. Otherwise, use lyngby_ts_uttest.
%
%       See also: lyngby_ts_uttest, lyngby_ts_pttest

% cvs : $Id: lyngby_ts_ttest.m,v 1.5 1998/03/23 10:20:48 fnielsen Exp $
%       $Revision: 1.5 $    

    [l1 c1] = size(d1) ;
    n1 = l1 * c1 ;
    x1 = reshape(d1, l1 * c1, 1) ;
    
    [l2 c2] = size(d2) ;
    n2 = l2 * c2 ;
    x2 = reshape(d2, l2 * c2, 1) ;
    
    a1 = mean(x1);
    v1 = std(x1).^2;
    a2 = mean(x2);
    v2 = std(x2).^2;
    
    df = n1 + n2 - 2 ;
    pvar = ((n1 - 1) * v1 + (n2 - 1) * v2) / df ;
    t = (a1 - a2) / sqrt( pvar * (1/n1 + 1/n2)) ;
    p = betainc( df / (df + t*t), 0.5*df, 0.5) ;
    







