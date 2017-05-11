% SORENSEN: Sorensen's (Bray-Curtis) measure of dissimilarity between two assemblages 
%           (sites), based on relative abundances (proportions) of individuals of 
%           composite species.
%
%     Syntax: [dist,abund] = sorensen(abund)
%
%           abund = [N x S] matrix of abundance (counts or proportions of 
%                     individuals) for N taxa across S localities.
%           ---------------------------------------------------------------
%           dist =  [S x S] symmetric matrix of distances among columns.
%

% RE Strauss, 4/8/05, modified from renkonen()

function dist = sorensen(abund)
  [n,s] = size(abund);
  dist = zeros(s,s);
  
  sumabund = sum(abund);

  for i = 1:(s-1)                   % All possible pairs of sites (columns)
    for j = (i+1):s
      dist(i,j) = sum(abs(abund(:,i)-abund(:,j))) / (sumabund(i)+sumabund(j));
      dist(j,i) = dist(i,j);
    end;
  end;

  return;
