% TREEPLOT: Given only an ancestor function, plots a horizontal or vertical 
%             V-shaped tree.
%           Given an ancestor function plus branch lengths, plots a 
%             horizontal rectangular tree.
%
%     Usage: treeplot(anc,{brlen | vert},{labels},{prtnodes},{fontsize})
%
%           anc =      vector specifying ancestor function, with ancestor of 
%                        root specified as 0.
%           brlen =    optional corresponding vector of branch lengths.
%           vert =     optional boolean flag indicating that tree topology is 
%                        to be oriented vertically, with root at bottom; 
%                        default = tree oriented horizontally, with root 
%                        at left.
%           labels =   optional matrix of labels (rows) for terminal taxa 
%                        (ignored for vertically oriented trees).
%           prtnodes = optional boolean flag indicating that nodes are to 
%                        identified by labels.
%           fontsize = optional font size for labels [default = 10].
%

% RE Strauss, 6/24/98
%   8/20/99 - changed plot colors, and other miscellaneous items, for Matlab v5.
%   9/20/99 - update handling of null input arguments.

function treeplot(anc,brlen,labels,prtnodes,fontsize)
  if (nargin < 2) brlen = []; end;
  if (nargin < 3) labels = []; end;
  if (nargin < 4) prtnodes = []; end;
  if (nargin < 5) fontsize = []; end;

  if (isempty(brlen))             % Input arguments
    vert = 0;
  else
    size_brlen = size(brlen);
    if (size_brlen==[1,1])
      vert = brlen;
      brlen = [];
    else
      vert = 0;
    end;
  end;

  if (isempty(prtnodes))
    prtnodes = 0;
  end;
  if (isempty(fontsize))
    fontsize = 10;
  end;

  if (min(size(anc)) > 1)
    error('  TREEPLOT: ancestor function must be a vector.');
  end; 

  n_anc = length(anc);
  n_taxa = ceil(n_anc/2);
  n_nodes = n_anc - n_taxa;
  n_edges = n_anc - 1;

  x = zeros(n_anc,1);        % Plotting coords of taxa and nodes
  y = zeros(n_anc,1);
  cum = ones(n_anc,1);       % Cum taxa per node

  % Get list of ancestors, descendants, and node levels by recursion
  i = find(anc==0);
  if (isempty(i))
    error('  TREEPLOT: ancestor of root node must be specified as 0');
  end;

  [links,anc,curr_node,level] = treedivd([],anc,i,0);
  anc = links(:,1);          % Ancestral ends of links
  desc = links(:,2);         % Descendant ends of links
  level = links(:,3);        % Levels in tree
  level = max(level)-level;  % Put level zero at tips
  max_level = max(level);

  t = find(desc <= n_taxa);  % Get indices to taxa
  taxon = desc(t);           % Get taxa

  % <<< Topology only >>>

  if (isempty(brlen))
    x(taxon) = zeros(n_taxa,1); % Get coords of terminal taxa
    y(taxon) = [1:n_taxa]';    

    for lev = 0:max_level      % Get coords of nodes
      for e = 1:2:n_edges-1
        if (level([e:e+1]) == [lev lev]')  % Find pair of edges at level
          a = anc(e);
          d1 = desc(e);
          d2 = desc(e+1);
          cum(a) = cum(d1) + cum(d2);
          y(a) = meanwt([y(d1) y(d2)],[cum(d1) cum(d2)]);
          x(a) = max([x(d1) x(d2)])+1;
        end;
      end;
    end;
    x = -x;

    if (vert)
      xx = x;
      x = y;
      y = xx;
    end;

    clf;
    hold on;                    % Plot tree
      for lev = 0:max_level
        for i = 1:n_edges
          if (level(i) == lev)
            a = anc(i);
            d = desc(i);
            plot([x(a) x(d)],[y(a) y(d)],'k');
          end;
        end;
      end;

      if (vert)
        deltay = 0.05 * max_level;
        deltax = 0.01 * n_taxa;
      else
        deltay = 0;
        deltax = 0.02 * max_level;
      end;

      if (prtnodes)
        for t = 1:length(x)
          if (vert)
            if (t < 10)
              h = text(x(t)-deltax,y(t)+deltay,num2str(t));
            else
              h =text(x(t)-2*deltax,y(t)+deltay,num2str(t));
            end;
          else
            h =text(x(t)+deltax,y(t)+deltay,num2str(t));
          end;
          set(h,'fontsize',fontsize);
        end;
      else
        for t = 1:n_taxa          % Add taxon identifiers
          if (vert)
            if (t < 10)
              h = text(x(t)-deltax,y(t)+deltay,num2str(t));
            else
              h =text(x(t)-2*deltax,y(t)+deltay,num2str(t));
            end;
          else
            if (isempty(labels))
              h =text(x(t)+deltax,y(t)+deltay,num2str(t));
            else
              h =text(x(t)+deltax,y(t)+deltay,num2str(labels(t,:)));
            end;
          end;
          set(h,'fontsize',fontsize);
        end;
      end;

      if (vert & ~isempty(labels))
        disp('  TREEPLOT warning: taxon labels ignored for vertical tree');
      end;

      axis('off');
    hold off;
  end;

  % <<< Topology + branch lengths >>>

  if (~isempty(brlen))          
    if (min(size(brlen)) > 1)
      error('  TREEPLOT: branch lengths must be specified as a vector.');
    end; 

    y(taxon) = [1:n_taxa];     % Get y-coords of terminal taxa

    for lev = 0:max_level      % Get y-coords of nodes, from tips to root
      for e = 1:2:n_edges-1
        if (level([e:e+1]) == [lev lev]')  % Find pair of edges at level
          a = anc(e);
          d1 = desc(e);
          d2 = desc(e+1);
          y(a) = mean([y(d1) y(d2)]);
        end;
      end;
    end;

    for e = 1:2:n_edges-1     % Get x-coords of nodes, from root to tips
      a = anc(e);
      d1 = desc(e);
      d2 = desc(e+1);
      x(d1) = x(a) + brlen(d1);
      x(d2) = x(a) + brlen(d2);
    end;

    clf;
    hold on;                    % Plot tree
      for e = 1:n_anc-1
        a = anc(e);
        d = desc(e);
        plot([x(a) x(a)],[y(a) y(d)],'k');
        plot([x(a) x(d)],[y(d) y(d)],'k');
      end;

      xroot = x(n_anc) - 0.07*max(x);
      yroot = y(n_anc);
      plot([0 xroot],[yroot yroot],'k');  % Draw root

      deltax = 0.015 * max(x);
      deltay = 0;
      if (prtnodes)
        for t = 1:length(x)          % Add taxon and node identifiers
          if (isempty(labels))
            h =text(x(t)+deltax,y(t)+deltay,num2str(t));
          else
            h =text(x(t)+deltax,y(t)+deltay,num2str(labels(t,:)));
          end;
          set(h,'fontsize',fontsize);
        end;
      else
        for t = 1:n_taxa          % Add taxon identifiers
          if (isempty(labels))
            h = text(x(t)+deltax,y(t)+deltay,num2str(t));
          else
            h = text(x(t)+deltax,y(t)+deltay,num2str(labels(t,:)));
          end;
          set(h,'fontsize',fontsize);
        end;
      end;
      axis([xroot max(x)+0.1*max(x) min(y) max(y)]);
      axis('off');
    hold off;
  end;

  if (labels & ~vert)         % Extend plot to accommodate labels
    v = axis;
    v(2) = v(1) + 1.1*(v(2)-v(1));
    axis(v);
  end;

  return;
