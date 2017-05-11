% MinEffectTest: Given the observed F-statistic value and corresponding degrees of freedom
%                from a linear model, performs a minimum-effect hypothesis test based on
%                Murphy & Myors (1998).
%
%     Usage: [p_me,p_c,F_crit,power] = MinEffectTest(F,nu1,nu2,{PV},{alpha},{noplot})
%
%         F =       observed F-statistic value from statistical test.
%         nu1,nu2 = degrees of freedom corresponding to F.
%         PV =      optional desired minimum-effect, as proportion of total variance
%                     [default = 0.01].
%         alpha =   optional alpha-level of test [default = 0.05].
%         noplot =  optional boolean flag indicating, if true, that the plot of
%                     null and sampling distributions is to be suppressed.
%         --------------------------------------------------------------------------
%         p_me =    significance level for minimum-effect test of null hypothesis.
%         p_c =     significance level for conventional nil hypothesis.
%         F_crit =  critical minimum-effect F value for the given value of alpha.
%         power =   estimate of post-hoc power.
%

% Murphy, K.R. and B. Myors. 1998. Statistical Power Analysis.  Lawrence Erlbaum Assoc.,
%   Mahwah NJ, 120 p.

% RE Strauss, 10/19/04

function [p_me,p_c,Fcrit,power] = MinEffectTest(F,v1,v2,PV,alpha,noplot)
  if (nargin < 1) help MinEffectTest; return; end;
  
  if (nargin < 4) PV = []; end;
  if (nargin < 5) alpha = []; end;
  if (nargin < 6) noplot = []; end;
  
  if (isempty(PV))     PV = 0.01; end;
  if (isempty(alpha))  alpha = 0.05; end;
  if (isempty(noplot)) noplot = 0; end;
  
  if (PV > 1)    PV = PV/100; end;
  if (alpha > 1) alpha = alpha/100; end;
  
  npts = 200;                           % Number of points to sample pdf

  PVF = (v1*F)/(v1*F+v2);                % Convert F to percent variance
  lambda_samp = v2*PVF/(1-PVF);                % Noncentrality parameter of sampling distribution
  lambda_null = v2*PV/(1-PV);                % Noncentrality parameter of null distribution
  
  Fcrit = ncfinv(1-alpha,v1,v2,lambda_null);  % Get critical value and power
  p_me = 1-ncfcdf(F,v1,v2,lambda_null);       % Min-effect significance level
  p_c = 1-fcdf(F,v1,v2);                      % Conventional significance level
  power = 1-ncfcdf(Fcrit,v1,v2,lambda_samp);  % Post-hoc power

  if (~noplot)                          % Plot null and sampling distributions
    f = linspace(0,50,npts);              % Get distributions
    Fsamp = ncfpdf(f,v1,v2,lambda_samp);
    i = npts;                             % Truncate X-axis at upper end
    while (Fsamp(i)<0.008)
      i = i-1;
    end;
    fmax = f(i);
    f = linspace(0,fmax,npts);
    Fnull = ncfpdf(f,v1,v2,lambda_null);
    Fsamp = ncfpdf(f,v1,v2,lambda_samp);
    maxfreq = max([Fnull,Fsamp]);
    
    s_alpha = '\alpha';
    
    figure;
    plot(f,Fnull,'k');
    hold on;
    plot(f,Fsamp,'k',[Fcrit,Fcrit],[0,ncfpdf(Fcrit,v1,v2,lambda_samp)],'k');
    hold off;
    axis([0 fmax 0 1.1*maxfreq]);
    putxlab('F');
    putylab('Frequency');
    puttext(0.55,0.86,sprintf('F =%5.2f, df = %d,%d',F,v1,v2));
    puttext(0.55,0.78,['\alpha',sprintf(' = %5.3f',alpha)]);
    puttext(0.55,0.70,sprintf('F_{crit} = %4.2f',Fcrit));
    puttext(0.55,0.62,sprintf('p = %5.3f',p_me));
    puttext(0.55,0.54,sprintf('power = %4.2f',power));
    s = num2str(PV*100);
    puttitle([s,'% minimum-effect test']);
  end;

  return;
  