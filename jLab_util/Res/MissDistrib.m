% MissDistrib:  Assesses the distribution of number of missing values per row or 
%               column of a data matrix against an expected uniform marginal 
%               distribution.  Returns the relative difference between observed 
%               and expected values for rows, columns, and total (relative to their
%               maximum possible values when all missing values are concentrated
%               within a single row or column).  Because the total relative difference
%               assumes independence of rows and columns, a contingency MAD statistic
%               (comparable to a 2-way contingency chi-squared statistic) is also
%               returned.  If the matrix contains fewer than 2 missing values, 
%               NaN's are returned for all measures of nonuniformity.
%                 Also returns scaled standard deviations of numbers of missing 
%               values per row and per column.
%                 Optionally estimates null distributions and returns adjusted index
%               values and right-tailed probability values for the observed values.
%               Indices are adjusted so that 0 = random expected, 1 = max when all 
%               missing values concentrated within a single row/col, and negative values
%               indicated more uniform than expected due to chance.
%               
%   Usage:  [indices,rand_indices,adj_indices,signif] = MissDistrib(X,{iter})
%
%       X =       [n x p] data matrix containing missing values.
%       iter =    optional number of iterations for randomization [default = 0].
%       ------------------------------------------------------------------------------
%       indices =      [1 x 6] vector of mean-squared differences between observed and 
%                        expected marginal totals.
%                          1) relative difference for matrix;
%                          2) relative difference for rows;
%                          3) relative difference for columns;
%                          4) contingency MAD statistic.
%                          5) scaled stdev of numbers of missing values per row.
%                          6) scaled stdev of numbers of missing values per column.
%       rand_indices = corresponding vector of randomized values of indices.
%       adj_indices  = corresponding vector of randomization-adjusted index values.
%       signif =       corresponding vector of right-tailed significance values for 
%                        observed index values.
%                   

% RE Strauss, 8/24/01
%   10/30/02 - allow for all missing values to be in same row or column.
%   4/14/05 -  add randomization adjustments and statistics.
%   4/17/05 -  changed name from 'MissRandMiss'.

function [indices,rand_indices,adj_indices,signif] = MissDistrib(X,iter)
  if (nargin < 2) iter = []; end;
  
  if (isempty(iter)) iter = 0; end;

  [r,c] = size(X);
  indices = [];
  rand_indices = [];
  adj_indices = [];
  signif = [];
  
  X = ~isfinite(X);                         % Convert to binary matrix
  nmiss = sum(sum(X));                      % Number of missing values
  if (sum(sum(X))>1)                        % If any missing data,
    indices = MissDistribF(X);              %   get index values
    if (iter)                                   % Randomize
      distrib = zeros(iter,6);
      distrib(1,:) = indices;
      X = zeros(size(X));
      for it = 2:iter
        Y = randmiss(X,nmiss);
        Y = ~isfinite(Y);
        distrib(it,:) = MissDistribF(Y);
      end;
      rand_indices = mean(distrib);
      adj_indices = (indices-rand_indices)./(1-rand_indices);
      signif = randprob(indices,sort(distrib));
    end;
  else
    indices = [NaN NaN NaN NaN NaN NaN];
  end;
  
  return;
  
% -----------------------------------------------------------------------------

% MissDistribF:   Calculates measures of nonrandomness for missing data within a 
%                 data matrix.  Relative difference is the sum of absolute deviations
%                 of row or column totals from an expected uniform distribution,
%                 relative to the maximum possible when all missing values are
%                 concentrated within a single row or column.
%
%     Usage: [indices,counts] = MissDistribF(X)
%

% RE Strauss, 8/24/01

function indices = MissDistribF(X)
  [r,c] = size(X);

  colobs = -sort(-sum(X));                  % Marginal totals
  rowobs = -sort(-sum(X'));
  N = sum(colobs);

  rowexp = (1/r)*ones(1,r);                 % Expected uniform row values
  rowexp = -sort(-prbcount(rowexp,N,[],1,1));
  rowdev = sum(abs(rowobs-rowexp));
  maxrowexp = [N zeros(1,r-1)];
  maxrowdev = sum(abs(rowobs-maxrowexp));
  if (maxrowdev==0)
    maxrowdev = 2*sum(maxrowexp);
  end;
  rowstat = rowdev/maxrowdev;
  
  rowstd = sqrt(var(rowobs)) / sqrt(var(maxrowexp));  % Scaled std of row values
  
  colexp = (1/c)*ones(1,c);                 % Expected uniform col values
  colexp = -sort(-prbcount(colexp,N,[],1,1));
  coldev = sum(abs(colobs-colexp));
  maxcolexp = [N zeros(1,c-1)];
  maxcoldev = sum(abs(colobs-maxcolexp));
  if (maxcoldev==0)
    maxcoldev = 2*sum(maxcolexp);
  end;
  colstat = coldev/maxcoldev;
  
  colstd = sqrt(var(colobs)) / sqrt(var(maxcolexp));  % Scaled std of col values
  
  totstat = (rowdev+coldev)/(maxrowdev+maxcoldev);
  
  cellexp = rowexp'*colexp/N;
  contstat = sum(sum(abs(X-cellexp)))/(r*c);
  
  indices = [rowstat colstat totstat contstat rowstd colstd];
  
  return;

