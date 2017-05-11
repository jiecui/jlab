% MakeFactorLevels : Creates a matrix of group-identification variables (by column)
%         specifying a balanced design, given the numbers of levels for each factor.
%         The sample size must be exactly divisible by each of the numbers of levels.
%
%     Usage: [G,N] = MakeFactorLevels(levels,{N})
%
%         levels =  vector (length k) of number of levels for each of k factors.
%         N =       optional sample size (number of observations)
%                     [default = 2*prod(levels)].
%         ----------------------------------------------------------------------
%         G =       [N x k] matrix of level identifiers.
%         N =       sample size generated.
%

% RE Strauss, 9/29/04

function [G,N] = MakeFactorLevels(levels,N)
  if (nargin < 1) help MakeFactorLevels; return; end;
  if (nargin < 2) N = []; end;

  k = length(levels);
  minN = 2*prod(levels);
  if (isempty(N))
    N = minN;
  end;
  
  if (N < minN)
    N = minN;
    disp(sprintf('  MakeFactorLevels warning: N too small, adjusted to %d.',N));
  end;
  if (sum(mod(N,levels)) > 0)
    error('  MakeFactorLevels: sample size must be divisible by numbers of levels.');
  end;
  
  G = zeros(N,k);
  seqlen = N;
  repeats = 1;
  for ik = 1:k
    seqlen = seqlen / levels(ik);
    g = [];
    for i = 1:repeats
      for j = 1:levels(ik)
        g = [g; j*ones(seqlen,1)];
      end;
    end;
    repeats = repeats*levels(ik);
    G(:,ik) = g;
  end;
  
  return;
  
  