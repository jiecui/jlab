% PlotPCAxes: Given a data matrix X for 2 or 3 variables, plots the data and principal 
%             components.  Returns the values in the original coordinate space of the
%             endpoints of the PC line segments.
%
%     Usage: endpoints = PlotPCAxes(X,{seglengths},{'linetype'},{noplot})
%
%         X = [n x p] data matrix.
%         seglengths = optional vector (length 1-3) of lengths of PC axes to be plotted,
%                        in standard deviations of scores from the centroid
%                        (default = 2 for each component).
%         linetype =   optional line type and color for principal components
%                        [default = 'k'].
%         noplot =     optional boolean flag indicating, if true, that no plot is
%                        to be produced [default = 0].
%         ------------------------------------------------------------------------------
%         endpoints =  [p x 2 x p] matrix of endpoints of plots [components x endpoint
%                        x coordinates].
%

% RE Strauss, 11/19/04

function endpoints = PlotPCAxes(X,seglengths,linetype,noplot)
  if (nargin < 1) help PlotPCAxes; return; end;
  
  if (nargin < 2) seglengths = []; end;
  if (nargin < 3) linetype = []; end;
  if (nargin < 4) noplot = []; end;
  
  [N,P] = size(X);
  P = min([P,3]);
  
  if (isempty(seglengths)) seglengths = 2*ones(1,P); end;
  if (isempty(linetype))   linetype = 'k'; end;
  if (isempty(noplot))     noplot = 0; end;  
  
  Xmean = mean(X);                      % Centroid of in X space
  [w,evals] = eigen(cov(X));            % Eigenvectors
  z = X*w;                              % Scores
  
  zmean = mean(z);                      % Centroid of scores
  zstd = std(z);                        % Standard deviations of scores
  zlow =  zmean - seglengths.*zstd; 
  zhigh = zmean + seglengths.*zstd;
  
  if (P==2)                             % Endpoints in PC space
    z = [zlow(1),0; zhigh(1),0; ...
         0,zlow(2); 0,zhigh(2)];  
  else
    z = [zlow(1),0,0; zhigh(1),0,0; ...
         0,zlow(2),0; 0,zhigh(2),0; ...
         0,0,zlow(3); 0,0,zhigh(3)];
  end;
 
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
    if (P==2)                           % 2D plot
      [x,y] = extrcols(Xendpoints);
      scatter(X);
      axis equal;
      hold on;
      plot(x(1:2),y(1:2),linetype);
      plot(x(3:4),y(3:4),linetype);
      hold off;
    else                                % 3D plot
      [x,y,z] = extrcols(Xendpoints);
      figure;
      plot3(X(:,1),X(:,2),X(:,3),'ko');
      axis equal;
      hold on;
      plot3(x(1:2),y(1:2),z(1:2),linetype);
      plot3(x(3:4),y(3:4),z(3:4),linetype);
      plot3(x(5:6),y(5:6),z(5:6),linetype);
      hold off;
      box on;
    end;
  end;

  return;
  