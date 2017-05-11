% FindCompleteData:  Given a list of variables, finds the observations having complete 
%             data (or vice versa).
%
%     Usage: obs = FindCompleteData(X,{indices},{getvars})
%
%         X =       [n x p] data matrix.
%         indices = optional vector of indices of variables [default = 1:p].
%         getvars = optional boolean flag indicating, if true, that the list of 
%                     indices represents observations rather than variables 
%                     [default = 0].
%         ---------------------------------------------------------------------
%         obs =     column vector of corresponding observations (or variables, 
%                     if 'getvars' is true).
%

% RE Strauss, 12/18/00
%   6/22/04 - rewritten from 'complobs'.

function obs = FindCompleteData(X,indices,getvars)
  if (nargin < 2) indices = []; end;
  if (nargin < 3) getvars = []; end;

  if (isempty(getvars)) getvars = 0; end;

  indices = indices(:);
  [n,p] = size(X);
  
  if (getvars)      % Find complete variables, given observations
    if (isempty(indices))
      indices = 1:n;
    end;
    if (max(indices) > n)
      error('  FindCompleteData: maximum index greater than matrix size.');
    end;
    X = X(indices,:);
    obs = find(isfinite(sum(X)));    % Complete observations
    
  else              % Find complete observations, given variables
    if (isempty(indices))
      indices = 1:p;
    end;
    if (max(indices) > p)
      error('  FindCompleteData: maximum index greater than matrix size.');
    end;
    X = X(:,indices);
    obs = find(isfinite(rowsum(X)));    % Complete observations
  end;

  return;