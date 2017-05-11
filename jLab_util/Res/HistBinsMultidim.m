% HistBins: Sort multidimensional data into bins suitable for plotting.  Does not
%         produce a histogram plot.
%
%     Usage: [midpoints,freqs,nbins] = HistBins(X,{nbins})
%
%         X = [n x p] data matrix for n observations and p dimensions.
%         nbins = optional vector (length p) of number of bins per dimension 
%                   [default = Sturge's value for all dimensions].
%         -----------------------------------------------------------------------------
%         midpoints = [k x p] matrix of interval midpoints for k bins and p dimensions,
%                       padded with NaN's when necessary.
%         freqs =     [k1 x k2 x ... kp] matrix of counts per bin.
%         nbins =     vector (length p) of number of bins per dimension.
%

% RE Strauss, 9/8/04 - modified from histmulti5() by Hans Olsson, Hans.Olsson@dna.lth.se

function [n,x,nbins]=histmulti5(y,bins)

% Handling of arguments.
if (nargin<1)
  help histmulti
  return
end;
if (nargin<2)
  bins=10*ones(1,size(y,2));
end;
if (length(bins)==1)
  bins=bins*ones(1,size(y,2));
end;
if (size(bins,2)~=size(y,2))
  error('Wrong number of bins in histmul5');
end;

% Transform elements into bin numbers.
if (size(bins,1)==1)
  % All bins have equal size.
  nbins=bins;
  mincol=min(y);
  maxcol=max(y);
  % Construct bin-width:
  binwidth=(maxcol-mincol)./bins;
  x=nan*zeros(max(bins),size(nbins,2));
  prodold=1;
  for col=1:size(bins,2)
    % Construct the bins:
    x(1:nbins(col),col)=(mincol(col)+(0:nbins(col)-1)*binwidth(col))';
    % Transform data into bins in this dimension.
    add=floor((y(:,col)-mincol(col))/binwidth(col));
    % Ensure that it is valid bin, we subtract in order to simplify
    % the next line.
    add=min(add,nbins(col)-1);
    % Make one bin-number:
    if (col==1) S=add; else S=S+add*prodold; end;
    prodold=prodold*nbins(col);
  end;
else
  global binorder;
  x=bins;
  nbins=sum(~isnan(bins));
  % Index used by tobinh:
  I=1:size(y,1);
  prodold=1;
  for col=1:size(bins,2);
    x0=x(1,col);
    dx=diff(x(1:nbins(col)));
    if (abs(dx-dx(1))<=dx(1)*eps)
      % Same size in this bin, make it faster:
      % We must here handle data outside all bins:
      add=floor((y(:,col)-x0)/dx(1));
      Ind=find((add<0)|(add>=nbins(col)));
      add(Ind)=nan*ones(size(Ind));
      binorder=add;
    else
      % Initialize binorder
      binorder=nan*ones(size(y,1),1);
      % run tobinh which stores the bin in the global variable binorder
      tobinh(y(:,col),I,x(:,col),1:nbins(col),nbins(col));
    end;
    % Make one bin-number
    if (col==1), S=binorder; else,S=S+binorder*prodold; end;
    prodold=prodold*nbins(col);
  end;
  S=S(~isnan(S));
end;

% Transform bin numbers into histograms.
S=S+1;
% Compute one-dimensional histogram for integers S in the range
% 1..prod(nbins)
% This is the core of the routine and for large datasets this should
% be optimized.

% We have a special mex-file, but if that routine is not available
% we use a one-liner with sparse.
global DO_HAVEHELP
global HAVE_WARNED
if (isempty(DO_HAVEHELP)|(DO_HAVEHELP<3))
  DO_HAVEHELP=exist('hist5hel');
  if ((DO_HAVEHELP<3)&(isempty(HAVE_WARNED))&(exist('hist5hel.c')))
    warning(['Please compile ',which('hist5hel.c'),', and: clear mex']);
    HAVE_WARNED=1;
  end;
end;
if (DO_HAVEHELP>=3)
  n=hist5hel(S,prod(nbins));
else
 n=full(sparse(S,1,1,prod(nbins),1));
end;


% Finally make the output into the right form, do nothing if one
% dimension because reshape requires two dimensions.
if (length(nbins)>1)
  n=reshape(n,nbins);
end;



function tobinh(y,I,x,binnr,nbins)
% Helper to place elements into bins.
% Place the y in different bins.
% The result is in the global variable binorder.
%
% We use binary search for the bins.
% Number of operations should be length(x)*log(nbins)*nbins
global binorder;
if (isempty(y)|(nbins==0))
  % Do nothing.
elseif (nbins==1)
  if (binnr==1)
    sel=y>=x(1);
    I=I(sel);
  end;
  binorder(I)=(binnr-1)*ones(size(I));
else
  i=fix(nbins/2);
  middle=x(binnr(i+1));
  sel=y<middle;
  tobinh(y(sel),I(sel),x,binnr(1:i),i);
  sel=y>=middle;
  tobinh(y(sel),I(sel),x,binnr(i+1:nbins),nbins-i);
end;
