% MDS:  Nonmetric multidimensional scaling of a square symmetric distance matrix
%       in a specified number of dimensions, p.
%
%     Usage: [crd,stress,mapdist] = 
%                     mds(dist,{labels},{p},{restarts},{normflag},{noplot})
%
%       dist =     [n x n] square symmetric distance matrix.
%       labels =   optional [n x 1] vector of integer point labels.
%       p =        optional number of dimensions into which points are to be mapped
%                    [default = 2].
%       restarts = optional number of restarts, after finding a new minimum stress,
%                    needed to end search [default=0].
%       normflag = optional boolean flag indicating that stress is to be normalized 
%                    to a range [0-1] if true (=1), or unnormalized
%                    sum-of-squared deviations if false (=0) [default = 0].
%       noplot =   optional boolean flag indicating, if true (=1), that the first 
%                    two coordinate axes are not to be plotted [default = 0].
%       ---------------------------------------------------------------------------
%       crd =      [n x p] matrix of map coordinates.
%       stress =   final stress.
%       mapdist =  [n x n] square symmetric distance of mapped euclidean distances.
%

% Krzanowski and Marriott (1994), pp. 108-114.

% RE Strauss, 9/20/97
%   8/20/99 - changed plot colors and other miscellaneous changes for Matlab v5.
%   1/4/00 -  changed usage of sqplot().
%   2/22/00 - open new figure window for plot.
%   3/15/02 - change fmins() to fminsearch(); use default fminsearch options.
%   11/1/02 - changed 'plotflag' to 'noplot'.
%   2/26/05 - set fminsearch options;
%             if mean coordinate is negative, flip signs.

function [crd,stress,mapdist] = mds(dist,labels,p,restarts,normflag,noplot)
  if (nargin < 2) labels = []; end;
  if (nargin < 3) p = []; end;
  if (nargin < 4) restarts = []; end;
  if (nargin < 5) normflag = []; end;
  if (nargin < 6) noplot = []; end;

  make_mapdist = 1;
  if (nargout < 3) make_mapdist = 0; end;

  n = size(dist,1);

  if (isempty(labels))   labels = [];  end;
  if (isempty(p))        p = 2;        end;
  if (isempty(restarts)) restarts = 0; end;
  if (isempty(normflag)) normflag = 0; end;
  if (isempty(noplot))   noplot = 0;   end;

  no_norm = 1;
  if (normflag) no_norm = 0; end;

  if (make_mapdist)
    distsave = dist;
  end;
  
  options = optimset('fminsearch');   % FMINSEARCH options
  maxfunevals = min([3000,300*n]);
  maxiter = min([3000,300*n]);
  tolerance = 1e-3;
  options = optimset(options,'MaxFunEvals',maxfunevals,'MaxIter',maxiter);
  options = optimset(options,'TolFun',tolerance','TolX',tolerance);

  % Get initial configuration from principal coordinates analysis
  [evects,evals] = pcoa(dist);
  if (length(evals)<p)                % Increase dimensions if necessary
    evects = [evects, zeros(n,p-length(evals))];
  end;
  init_pts = reshape(evects(:,1:p),n*p,1);  % Initial configuration

  % Repeat optimization until have 'restart' attempts with no better solution
  iter = restarts + 1;
  best_stress = 10e10;
  best_crd = init_pts;

  while (iter > 0)
    init_stress = mdsfunc(init_pts,dist,no_norm);

    if (init_stress > tolerance)
      crd = fminsearch('mdsfunc',init_pts,options,dist,no_norm); % Refine the configuration
    else
      crd = init_pts;
    end;

    stress = mdsfunc(crd,dist,no_norm);              % Calculate stress
    if (stress < best_stress)                        % If new best stress,
      if ((best_stress-stress) > 0.001*best_stress)
        iter = restarts;                             %   restart if much better
      else
        iter = iter-1;                               %   else decrement repeats
      end;
      best_stress = stress;                          %   new stress
      best_crd = crd;                                %     along with crds
    else
      init_pts = crd + (2*rand-1)*std(crd);          % Else jiggle points
      iter = iter-1;                                 %   and decrement repeats
    end;
  end;

  stress = best_stress;
  crd = best_crd;

  crd = reshape(crd,n,p);
  crd = crd - ones(n,1)*mean(crd);    % Zero-center the axes
  
  meancrd = mean(mean(crd));          % If mean coordinate is negative, flip signs
  if (meancrd < 0)
    crd = -crd;
  end;

  if (~noplot)
    if (p>1)                          % Plot first two dimensions
      x = crd(:,1);
      y = crd(:,2);
      figure;
      plot(x,y,'k.');
      hold on;
      axis('square');

      sqplot(x,y,10);

      if (isempty(labels))
        for i=1:n
          text(crd(i,1),crd(i,2),[' ',int2str(i)]);
        end;
      else
        if (~ischar(labels))
          labels = tostr(labels);
        end;
        for i=1:n
          text(crd(i,1),crd(i,2),[' ',labels(i,:)]);
        end;
      end;
      hold off;
    end;
  end;

  if (make_mapdist)                   % Mapped euclidean distances
    mapdist = eucl(crd);
    f = mean(trilow(distsave))/mean(trilow(mapdist));
    mapdist = mapdist * f;            % Rescale to same mean as original dists
  end;

  return;
  