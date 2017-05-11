% PlotDFAxes: Given a data matrix X for 2 variables and for 3 or more groups, 
%             plots the data and discriminant functions.   Returns the values in the 
%             original coordinate space of the endpoints of the DF line segments.
%
%     Usage: endpoints = PlotDFAxes(X,grps,{seglengths},{'linetype'},{noplot})
%
%         X =          [n x p] data matrix.
%         grps =       [n x 1] group-membership vector.
%         seglengths = optional vector (length 1-3) of lengths of PC axes to be plotted,
%                        in standard deviations of scores from the centroid
%                        (default = 2 for each component).
%         linetype =   optional line type and color for principal components
%                        [default = 'b'].
%         noplot =     optional boolean flag indicating, if true, that no plot is
%                        to be produced [default = 0].
%         ------------------------------------------------------------------------------
%         endpoints =  [p x 2 x p] matrix of endpoints of plots [components x endpoint
%                        x coordinates].
%

% RE Strauss, 12/5/04 (modified from PlotPCAxes)

function endpoints = PlotDFAxes(X,grps,seglengths,linetype,noplot)
  if (nargin < 1) help PlotPCAxes; return; end;
  
  if (nargin < 3) seglengths = []; end;
  if (nargin < 4) linetype = []; end;
  if (nargin < 5) noplot = []; end;
  
  [N,P] = size(X);
  P = min([P,3]);
  
  if (isempty(seglengths)) seglengths = 2*ones(1,P); end;
  if (isempty(linetype))   linetype = 'b'; end;
  if (isempty(noplot))     noplot = 0; end;  
  
  [loadings,percvar,scores,fscores,CI_loadings,CI_percvar,w] = discrim(X,grps,[],2);
  w(:,1) = flipud(w(:,2));
  w(2,1) = -w(2,1);

  Xmean = mean(X);                      % Centroid of in X space
  z = X*w;                              % Scores
  
  zmean = mean(z);                      % Centroid of scores
  zstd = std(z);                        % Standard deviations of scores
  zlow =  zmean - seglengths.*zstd; 
  zhigh = zmean + seglengths.*zstd;
  
  z = [zlow(1),0; zhigh(1),0; ...     % Endpoints in DF space
       0,zlow(2); 0,zhigh(2)];  
 
  Xendpoints = z*inv(w);                % Corresponding endpoints in X space
  
  for ip = 1:2:(2*P)
    x = Xendpoints(ip:(ip+1),:);
    xmean = mean(x);
    x = x - ones(2,1)*xmean + ones(2,1)*Xmean;
    Xendpoints(ip:(ip+1),:) = x;
  end;
  
  endpoints = zeros(P,2,P);
  j = 0;
  for ip = 1:P
    for i = 1:2
      j = j+1;
      endpoints(ip,i,:) = Xendpoints(j,:);
    end;
  end;
  
  if (~noplot)
    [x,y] = extrcols(Xendpoints);
    plotgrps(X(:,1),X(:,2),grps);
    axis equal;
    hold on;
    plot(x(1:2),y(1:2),linetype);
    plot(x(3:4),y(3:4),linetype);
    hold off;
  end;

  return;
  