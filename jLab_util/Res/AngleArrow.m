% AngleArrow: Given a set of point coordinates specifying vectors originating from the
%             origin, and a set of pairs of vectors, draws circular-arc arrows between
%             among vectors.  Opens a new figure window.  Turns axes off.
%
%     Usage:  AngleArrow(vectorheads,{vectorpairs},{reldist},{clockwise})
%         
%         vectorheads = [n x 2] matrix of coordinates of vector heads, assuming that
%                         vectors originate from coordinate origin.
%         vectorpairs = optional [k x 2] matrix of vector indices for k vector pairs, 
%                         indicating pairs between which angles are to be drawn
%                         [default = all possible pairs].
%         reldist =     optional relative distance of angle arrows from origin, relative to
%                         longest vector [default = 0.2].
%         clockwise =   optional boolean flag indicating, if true, that angle arrows
%                         are to be clockwise [default = 0 = counterclockwise].
%

% RE Strauss, 10/24/04

function AngleArrow(vectorheads,vectorpairs,reldist,clockwise)
  if (nargin < 1) help AngleArrow; return; end;

  if (nargin < 2) vectorpairs = []; end;
  if (nargin < 3) reldist = []; end;
  if (nargin < 4) clockwise = []; end;
  
  if (isempty(reldist))   reldist = 0.2; end;
  if (isempty(clockwise)) clockwise = 0; end;
  
  nvectors = size(vectorheads,1);
  
  if (isempty(vectorpairs))
    vectorpairs = zeros(nvectors*(nvectors-1)/2,2);
    npairs = 0;
    for i = 1:(nvectors-1)
      for j = 2:nvectors
        npairs = npairs+1;
        vectorpairs(npairs,:) = [i j];
      end;
    end;
  end;
  
  npairs = size(vectorpairs,1);
  origin = [0,0];
  xaxis = [1,0];
  
  maxvectlen = max(eucl(origin,vectorheads));
  rad = reldist * maxvectlen;       % Radius for angle arrow
  
  figure;
  plot([0;vectorheads(:,1)],[0;vectorheads(:,2)],'w.');
  putbnds([0,;vectorheads(:,1)],[0;vectorheads(:,2)]);
  axis equal;
  for iv = 1:nvectors               % Draw vectors
    putarrow([0,0],vectorheads(iv,:),[],0.1);
  end;
  axis off;
  hold on;
  for ip = 1:npairs
    [v1,v2] = extrcols(vectorpairs(ip,:));
    t = AngleRotation(origin,xaxis,vectorheads([v1,v2],:),1);
    npts = ceil(100*(t(2)-t(1))/(2*pi));
    theta = linspace(t(1),t(2),npts)';
    [x,y] = polarcrd(rad,theta,1);
    plot(x,y,'k');
    if (~clockwise)
      putarrow([x(end-1),y(end-1)],[x(end),y(end)],[],6);
    else
      putarrow([x(2),y(2)],[x(1),y(1)],[],6);
    end;
  end;
  hold off;
  
  return;
  