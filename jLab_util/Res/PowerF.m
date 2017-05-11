% PowerF: Given an observed or desired F-value, estimates power using the
%     method of Murphy & Myors (1998).  Optionally plots the null and sampling 
%     distributions of F.
%
%     Usage: [power,PV,lambda] = PowerF(F,v1,v2,{alpha},{doplot})
%
%         F =       specifed F-statistic value.
%         v1,v2 =   degrees of freedom.
%         alpha =   optional probability of Type I error [default = 0.05].
%         doplot =  optional boolean flag indicating, if true, that plots are to 
%                     be produced.
%         -----------------------------------------------------------------------------
%         power =   power estimate.
%         PV =      proportion of total variance accounted for in general linear model.
%         lambda =  noncentrality parameter for sampling distribution.
%     

% RE Strauss, 9/28/04

function [power,PV,lambda] = PowerF(F,v1,v2,alpha,doplot)
  if (nargin < 1) help PowerF; end;
  if (nargin < 4) alpha = []; end;
  if (nargin < 5) doplot = []; end;
  
  if (isempty(alpha))  alpha = 0.05; end;
  if (isempty(doplot)) doplot = 0; end;
  
  if (alpha > 1)
    alpha = alpha/100;
  end;
  
  PV = (v1*F)/(v1*F+v2);                % Convert F to percent variance
  lambda = v2*PV/(1-PV);                % Noncentrality parameter
  
  Fcrit = finv(1-alpha,v1,v2);          % Get critical value and power
  power = 1-ncfcdf(Fcrit,v1,v2,lambda);
  
  npts = 200;                           % Number of points to sample pdf
  if (doplot)
    f = linspace(0,50,npts);              % Get distributions
    Fsamp = ncfpdf(f,v1,v2,lambda);
    i = npts;                             % Truncate X-axis at upper end
    while (Fsamp(i)<0.008)
      i = i-1;
    end;
    fmax = f(i);
    f = linspace(0,fmax,npts);
    Fnull = fpdf(f,v1,v2);
    Fsamp = ncfpdf(f,v1,v2,lambda);
    maxfreq = max([Fnull,Fsamp]);
    
    figure;
    plot(f,Fnull,'k');
    hold on;
    plot(f,Fsamp,'k',[Fcrit,Fcrit],[0,ncfpdf(Fcrit,v1,v2,lambda)],'k');
    hold off;
    axis([0 fmax 0 1.1*maxfreq]);
    putxlab('F');
    putylab('Frequency');
    puttext(0.55,0.86,sprintf('F =%5.2f, df = %d,%d',F,v1,v2));
    puttext(0.55,0.78,sprintf('F_{crit} = %4.2f',Fcrit));
    puttext(0.55,0.70,sprintf('Power = %4.2f',power));
  end;
show  

  return;
  
  