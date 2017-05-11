% AnovaNRand: Implementation of a 2-way or 3-way ANOVA for which significance levels 
%     (p-values) are estimated by random permutation rather than by comparison to 
%     theoretical F-distributions.  Based on the Matlab Statistics Toolbox function ANOVAN.
%
%     Usage: [p,table,stats,terms] = AnovaNRand(x,groups,iter,{'model'},{random},...
%                                           {varnames},{'display'}) 
%
%         x =         [N x 1] vector of data values.
%         groups =    [N x k] matrix of group-identification variables for k factors (k<=3), 
%                       or a cell array of k matrices for k factors (see ANOVAN documentation.)
%         iter =      number of randomization iterations.
%         model =     optional model specification (see ANOVAN doc):
%                       'linear' to use only main effects of all factors [default];
%                       'interaction' for main effects plus two-factor interactions;
%                       'full' to include interactions of all levels;
%                       an integer representing the maximum interaction order; or
%                       a matrix of term definitions as accepted by the X2FX function,
%                         with all entries 0 or 1 (no higher powers).
%         random =    optional vector of indices indicating which grouping variables
%                       are random effects default = [] = all are fixed].
%         varnames =  optional grouping variables names in a character matrix or a cell array 
%                       of strings, one per grouping variable [default names = 'X1', X2', ...].
%         display =   optional string variable, either 'on' [default] to display an anova
%                       table or 'off' to suppress the display.
%         -------------------------------------------------------------------------------------
%         p =         column vector of randomized p-values, one per term.
%         table =     cell array containing the anova table.
%         stats =     structure containing anova statistics.
%         terms =     matrix describing the main and interaction terms used in the model.
%

% Anderson, MJ & CJF ter Braak. 2003. Permutation tests for multi-factorial analysis
%   of variance.  Journal of Statistical Computation and Simulation 73:85-113.

% RE Strauss, 9/22/04

function [p,table,stats,terms] = AnovaNRand(x,groups,iter,model,random,varnames,display) 
  if (nargin < 1) help AnovaNRand; end;
  if (nargin < 2) groups = []; end;
  if (nargin < 3) iter = []; end;
  if (nargin < 4) model = []; end;
  if (nargin < 5) random = []; end;
  if (nargin < 6) varnames = []; end;
  if (nargin < 7) display = []; end;
  
  if (isempty(groups) | isempty(iter))
    error('  AnovaNRand: insufficient number of arguments passed.');
  end;
  
  if (isempty(model))   model = 'linear'; end;
  if (isempty(display)) display = 'on'; end;
  
  x = x(:);
  N = length(x);
  
  if (iscell(groups))                 % groups = cell array
    nfactors = max(size(groups));     % factors = columnwise matrix of factors
    factors = zeros(N,nfactors);
    for i = 1:nfactors
      g = groups{i};
      factors(:,i) = g(:);
    end;
  else
    factors = groups;
    nfactors = size(factors,2);
    g = cell(size(groups,2),1);
    for i = 1:size(groups,2)
      g(i) = {groups(:,i)};
    end;
    groups = g;
  end;

  % ANOVA for original data
  [phat,table,stats,terms] = anovan(x,groups,'model',model,'random',random,...
                               'varnames',varnames,'display',display);
                               
  i = 2;                                    % Isolate F values from table
  while (~isempty(table{i,6}))
    Fhat(i-1) = table{i,6};
    i = i+1;
  end;

  nF = length(Fhat);
  Fnull = zeros(iter,nF);
  Fnull(1,:) = Fhat;
  F = Fhat;
  
  maxlevels = 0;                            % Max levels/factor
  levels = [];
  nlevels = zeros(1,nfactors);
  for i = 1:nfactors
    u = uniquef(factors(:,i));
    nlevels(i) = length(u);
    [levels,u] = padrows(levels,u);
    levels = [levels,u];
    maxlevels = max([maxlevels,length(u)]);
  end; 
  
  grandmean = mean(x);                      % Residual adjustments for terms in model
  
  twoway = false;
  threeway = false;
  nt = rowsum(terms);
  if (any(nt==2)) twoway = true; end;
  if (any(nt==3)) threeway = true; end;
  if (any(nt>3))
    error('  AnovaNRand: max N-way interactions allowed is 3-way.');
  end;
  
  terms_main = NaN*ones(maxlevels,nfactors);% Terms for main effects
  for i = 1:nfactors                        
    M = means(x,factors(:,i));
    terms_main(1:length(M),i) = M - grandmean;
  end;
terms_main  
  
  if (twoway)                               % Terms for pairwise interactions
    terms_twoway = NaN*ones(nfactors,nfactors,maxlevels,maxlevels);
    for f1 = 1:(nfactors-1)
      for f2 = (f1+1):nfactors
        for lv1 = 1:nlevels(f1)
          for lv2 = 1:nlevels(f2)
            i = find(factors(:,f1)==levels(lv1,f1) & factors(:,f2)==levels(lv2,f2));
            if (~isempty(i))
              terms_twoway(f1,f2,lv1,lv2) = mean(x(i)) - grandmean;
            end;
          end;
        end;
      end;
    end;
  end;
  
  if (threeway)                             % Terms for 3-way interactions
    terms_threeway = NaN*ones(nfactors,nfactors,nfactors,maxlevels,maxlevels,maxlevels);
    for f1 = 1:(nfactors-2)
      for f2 = (f1+1):(nfactors-1)
        for f3 = (f2+1):nfactors
          for lv1 = 1:nlevels(f1)
            for lv2 = 1:nlevels(f2)
              for lv3 = 1:nlevels(f3)
                i = find(factors(:,f1)==levels(lv1,f1) & factors(:,f2)==levels(lv2,f2) ...
                       & factors(:,f3)==levels(lv3,f3));
                if (~isempty(i))
                  terms_threeway(f1,f2,f3,lv1,lv2,lv3) = mean(x(i)) - grandmean;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  
  adj = grandmean*ones(N,nF);         % Adjustments to be subtracted for permutation of residuals
  for inF = 1:nF                      % For each term in model
    t = terms(inF,:);                   % Get factor combination
    nt = sum(t);
    for obs = 1:N                       % Cycle thru observations
      switch (nt)
        case 1,                           % Main effect: 
          f1 = find(t>0);
          for f = 1:nfactors                % Subtract other main effects
            if (f~=f1)
              adj(obs,inF) = adj(obs,inF) + terms_main(factors(obs,f1),f1);
            end;
          end;
        case 2,                           % Two-way interaction
        
        case 3,                           % Three-way interaction
        
      end;
    end;
  end;
  
x_adj = [x adj]
return;
  

  fh = @anovan;                       % File handle
  for it = 2:iter                     % Build null F-distribs via random permutations
    i = randperm(N);
    [p,table] = feval(fh,x(i),groups,'model',model,'random',random,'display','off');
    for i = 1:nF
      F(i) = table{i+1,6};
    end;
    Fnull(it,:) = F;
  end;
  
  Fnull = sort(Fnull);                % Sort null distributions

  p = randprob(Fhat,Fnull,0)';          % Find randomized p-values
  i = find(~isfinite(Fhat));
  p(i) = zeros(length(i),1);

  return;
  
  
