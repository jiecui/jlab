% Mountford: Calculates the Mountford distance measure of dissimilarity between two 
%            species assemblages (sites), based on presence/absence data.  The distance
%            M is the positive root of the equation:
%
%                   exp(a*M) + exp(b*M) = 1 + exp((a+b-j)*M)
%
%            where where j is the number of species occurring in both assemblages, 
%            and a and b are the number of species in each separate assemblage.
%            M lies in the range 0 to log(2), so the distance is divided by log(2) so that 
%            it is normalized to the conventional range 0 to 1.
%              If either a or b is equal to j, one of the communities could be a subset of 
%            the other, and the distance is 0, meaning that non-identical objects may be 
%            regarded as identical and the index is non-metric.
%
%
%     Syntax:  M = mountford(occur)
%
%           occur = [N x S] binary occurrence matrix for N species 
%                       across S sites.
%           ---------------------------------------------------------------------
%           M =     [S x S] symmetric matrix of distances among columns.
%

% Mountford, M.D. 1962. An index of similarity and its application to classification 
%   problems. In: P.W.Murphy (ed.), Progress in Soil Zoology, 43–50. Butterworths.

% RE Strauss, 4/8/05

function M = mountford(occur)
  if (nargin < 1) help mountford; return; end;

  occur = (occur>0);                % Convert to binary matrix
  [N,S] = size(occur);
  M = zeros(S,S);
  m = linspace(0,log(2),10000);
  sumoccur = sum(occur)

  for i = 1:S-1
    a = sumoccur(i);
    for j = (i+1):S
      b = sumoccur(j);
      joint = sum(occur(:,i) & occur(:,j));
      delta = abs((exp(a*m) + exp(b*m))-(1 + exp((a+b-joint)*m))); 
% close all;
% plot(m,delta);
% pause;
      d = length(delta); 
      while (delta(d)-delta(d-1)>0)
        d = d-1;
        if (d <= 1)
          d = 1;
          break;
        end;
      end;
      M(i,j) = m(d)
    end;
  end;
  M = M + M';
  
  return;