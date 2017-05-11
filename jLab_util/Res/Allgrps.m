% Allgrps:  Returns a list of all possible groupings of N objects into k groups, 
%           labeled or unlabeled.  If group sample sizes are not specified, then 
%           all possible arrangements are considered.
%
%     Usage: grpid = allgrps(N,k,{sortmat})
%           
%             N =         number of objects.
%             k =         number of groups, or vector of numbers of groups.
%             sortmat =   boolean flag indicating that output matrix is to be 
%                           sorted into lexicological sequence [default=0].
%             ----------------------------------------------------------------------
%             grpid =     [m x N] matrix of group identifiers.
%

% RE Strauss, 8/29/99
%   10/3/99 -  added option of labeled groups.
%   10/27/99 - added option to sort output matrix.
%   6/19/04 -  removed option for vector k to be vector of sample sizes for 1 of 2 grps;
%              remove option for labeled groups.

function grpid = allgrps(N,k,sortmat)
  if (nargin < 3) sortmat = []; end;

  if (isempty(sortmat)) sortmat = 0; end;
  labeled = 0;

  k = k(:);
  lenk = length(k);

  grpid = [];
  for ik = 1:lenk
    sizes = allsizes(N,k(ik));
    nsizes = size(sizes,1);
    
    for i = 1:nsizes                        % Cycle thru sample-size combinations
      kk = sizes(i,:);                      % For current sample-size combination,
      g = allgrpf(1:N,kk,~labeled);         %   get list of object permutations
      
      gid = zeros(size(g));                 % Convert objects to group identifiers
      leng = size(g,1);
      lenkk = length(kk);

      for ig = 1:leng
        kkmax = 0;
        for ikk = 1:lenkk
          kkmin = kkmax+1;
          kkmax = kkmin+kk(ikk)-1;
          gid(ig,g(ig,kkmin:kkmax)) = ikk*ones(1,kk(ikk));
        end;
      end;
      for ig = 1:size(gid,1)                % Replace identifiers with increasing sequence
        u = uniquef(gid(ig,:))';
        gid(ig,:) = replace(gid(ig,:),u,1:length(u));
      end;
      grpid = [grpid; gid];                 % Concatenate to full list
    end;
  end;
  
  if (sortmat)                          % Sort into lexicological sequence
    grpid = sortrows(grpid);
  end;
  
  return;
  
% ---------------------------------------------------------------------------------

% Allgrpf:  Recursive function for listing all possible groupings of N objects 
%           into k groups.  See allgrps().
%
%     Usage: grps = allgrpf(N,k,unlabeled)
%
%             N =         vector of remaining object identifiers.
%             k =         vector of sample sizes per group.
%             unlabeled = boolean flag indicating that groups are unlabeled 
%                           (ie, groups of equal sample size are equivalent and 
%                           indistinguishable).
%             -----------------------------------------------------------------
%             grps =      [ngrp x N] matrix of partitions.
%

% RE Strauss, 8/29/99

function grps = allgrpf(N,k,unlabeled)
  lenk = length(k);

  if (lenk == 1)
    g = combvals(length(N),k);
    grps = zeros(size(g));
    for i = 1:size(g,1)
      grps(i,:) = N(g(i,:));
    end;
    return;
  end;

  grps = [];
  gp = combvals(length(N),k(1));
  for igp = 1:size(gp,1)
    n = N;
    Nout = n(gp(igp,:));
    n(gp(igp,:)) = [];

    g = allgrpf(n,k(2:lenk),unlabeled);
    grps = [grps; ones(size(g,1),1)*Nout g];
  end;

  if (unlabeled)
    ngrps = size(grps,1);
    if (ngrps > 1)
      k1 = k(1);
      k2 = k(2);
      if (k1 == k2)
        if (k1 == 1)
          i = find(grps(:,1) < grps(:,2));
          grps = grps(i,:);
        else
          i = max(find(grps(:,1)==grps(1,1)));
          i1 = [1:i]';
          i2 = [(i+1):ngrps]';
          gk1 = grps(i1,1:(k1+k2));
          gk2 = grps(i2,[(k1+1):(k1+k2) 1:k1]);
          keep = ~ismember(gk2,gk1,'rows');
          i = [i1; i+find(keep)];
          grps = grps(i,:);
        end;
      end;
    end;
  end;

  return;

