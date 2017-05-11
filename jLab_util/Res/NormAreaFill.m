% NormAreaFill: Draw figure of a normal distribution with specified mean and
%               standard deviation, and fill in the area between two specified limits
%               (which may include -Inf and Inf for tail areas).
%
%     Usage: NormAreaFill(xc,{m},{s},{bound})
%
%         xc =    vector of lower and upper limits defining region of distribution 
%                   to be filled.  Limits may include either  -Inf and Inf as value.
%         m,s =   optional mean and standard deviation of normal distribution
%                   [defaults = 0,1].
%         bound = optional lower and upper boundaries for plot, in standard
%                   deviation units.  If one value is given, it is assumed to be
%                   the upper bound and the lower is -bound [default = -3.5,3.5].
%

% RE Strauss, 4/6/03
%   3/1/05 - permit either tail area to be filled in, as well as central areas.

function NormAreaFill(xc,m,s,bound)
  if (~nargin) help normareafill; return; end;
  
  if (nargin < 2) m = []; end;
  if (nargin < 3) s = []; end;
  if (nargin < 4) bound = []; end;
  
  if (isempty(m)) m = 0; end;
  if (isempty(s)) s = 1; end;
  if (isempty(bound)) bound = 3.5; end;
  
  if (isscalar(bound))
    bound = sort([-bound,bound]);
  end;
  bound = m+s*bound;
  
  xc = sort(xc(:)');
  if (length(xc)~=2)
    error('  NormAreaFill: invalid fill limits.');
  end;
  
  x3 = [];
  y3 = [];
  
  if (xc(1)==-Inf)                        % Left tail area
    x1 = linspace(bound(1),xc(2));
    x2 = linspace(xc(2),bound(2));
    y1 = normpdf(x1,m,s);
    y2 = normpdf(x2,m,s);
    plot(x1,y1,'k',x2,y2,'k');
    hold on;
    xx = [bound(1),xc(2),fliplr(x1)];
    yy = [0,0,fliplr(y1)];
    fill(xx,yy,'k');
    hold off;

  elseif (xc(2)==Inf)                     % Right tail area
    x1 = linspace(bound(1),xc(1));
    x2 = linspace(xc(1),bound(2));
    y1 = normpdf(x1,m,s);
    y2 = normpdf(x2,m,s);
    plot(x1,y1,'k',x2,y2,'k');
    hold on;
    xx = [bound(2),xc(1),x2];
    yy = [0,0,y2];
    fill(xx,yy,'k');
    hold off;

  else                                    % Central area
    x1 = linspace(bound(1),xc(1));
    x2 = linspace(xc(1),xc(2));
    x3 = linspace(xc(2),bound(2));
    y1 = normpdf(x1,m,s);
    y2 = normpdf(x2,m,s);
    y3 = normpdf(x3,m,s);
    plot(x1,y1,'k',x2,y2,'k',x3,y3,'k');
    hold on;
    xx = [xc(2),xc(1),x2];
    yy = [0,0,y2];
    fill(xx,yy,'k');
    hold off;

  end;
  
  xtick = xc(isfinite(xc));
  if (~isin(m,xtick))
    xtick = sort([m,xtick]);
  end;
  
  putbnd([x1,x2,x3],[y1,y2,y3]);
  v = axis;
  putybnd(0,v(4));
  set(gca,'XTick',xtick);
  set(gca,'XTickLabel',xtick);

  return;
  