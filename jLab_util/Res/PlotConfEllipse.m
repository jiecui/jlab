% PlotConfEllipse: Given bivariate data for a single group, plots a confidence
%         ellipse about the centroid, about the data, or about both.  Plots
%         on the current plot ('hold' set to 'on' and not reset to 'off').
%         Extends the current axis bounds if necessary.
%
%     Usage: PlotConfEllipse(X,{plotwhich},{'label'},{ci_level})
%
%         X =         [N x 2] data matrix.  If more than two variables are passed,
%                       only the first two are used.
%         plotwhich = optional boolean vector indicating which elements are to be 
%                     plotted (default = [1 1 0 0]):
%                       1 = centroid;
%                       2 = centroid ellipse;
%                       3 = data;
%                       4 = data ellipse.
%         label =     optional character-string label to print to right of ellipse.
%         ci_level =  confidence level for ellipses [default = 0.95].
%

% RE Strauss, 9/19/04

function PlotConfEllipse(X,plotwhich,label,ci_level)
  if (nargin < 1) help PlotConfEllipse; return; end;
  
  if (nargin < 2) plotwhich = []; end;
  if (nargin < 3) label = []; end;
  if (nargin < 4) ci_level = []; end;

  if (isempty(plotwhich)) plotwhich = [1 1 0 0]; end;
  if (isempty(ci_level))  ci_level = 0.95; end;
  
  if (ci_level > 1)
    ci_level = ci_level / 100;
  end;
  
  if (~isempty(label))
    if (~ischar(label))
      label = num2str(label);
    end;
  end;
  
  plotwhich = plotwhich(:)';        % Pad 'plotwhich' vector if necessary
  if (length(plotwhich)<4)
    plotwhich = [plotwhich zeros(1,4-length(plotwhich))];
  end;
  
  if (isvect(X))
    error('  PlotConfEllipse: data matrix must have at least two variables.');
  end;
  X = X(:,1:2);                      % Reduce to 2 vars
  [n,p] = size(X);
  
  plot_centroid_ellipse = 0;
  plot_data_ellipse = 0;
  plot_centroid = 0;
  plot_data = 0;
  if (plotwhich(1)) plot_centroid = 1; end;
  if (plotwhich(2)) plot_centroid_ellipse = 1; end;
  if (plotwhich(3)) plot_data = 1; end;
  if (plotwhich(4)) plot_data_ellipse = 1; end;
  
  npts = 100;                             % Number of plotted points per ellipse
  p = 2;                                  % Dimensions
  mxy = mean(X);                          % Centroid

  theta = linspace(0,2*pi,npts)';
  F = finv(ci_level,p,n-p)*p*(n-1)/(n-p); % Confidence bound
  [pc,eigval] = eigen(cov(X));            % Get eigenvalues
  
  hold on;
  v = axis;
  if (~isequal(v,[0 1 0 1]))              % Current axis bounds
    rx = v(2)-v(1);
    ry = v(4)-v(3);
    d = 0.045;
    v = [v(1)+d*rx, v(3)+d*ry; v(2)-d*rx, v(4)-d*ry];             
  else
    v = [];
  end;

  if (plot_centroid)
    plot(mxy(1),mxy(2),'kx');             % Plot centroid
  end;
  if (plot_centroid_ellipse)              % Plot conf ellipse about centroid
    ab = diag(sqrt(F*eigval/(n-1)));
    exy = [cos(theta),sin(theta)]*ab*pc' + ones(npts,1)*mxy;
    xx = exy(:,1);
    yy = exy(:,2);
    plot(xx,yy,'k');
    v = [v; min(exy); max(exy)];            % Extend axis ranges
    [xlabel,i] = max(xx);
    ylabel = yy(i);
  end;
    
  if (plot_data)
    plot(X(:,1),X(:,2),'ko');
    v = [v; min(X); max(X)];
  end;
  if (plot_data_ellipse)                  % Plot conf ellipse about data
    ab = diag(sqrt(F*eigval));
    exy = [cos(theta),sin(theta)]*ab*pc' + ones(npts,1)*mxy;
    xx = exy(:,1);
    yy = exy(:,2);
    plot(exy(:,1),exy(:,2),'k');
    v = [v; min(exy); max(exy)]; % Extend axis ranges
    [xlabel,i] = max(xx);
    ylabel = yy(i);
  end;
  
  box on;
  putbnd(v);
  
  if (~isempty(label))
    v = axis;
    xlabel = xlabel + 0.01*(v(2)-v(1));
    text(xlabel,ylabel,label);
  end;
  
  return;

