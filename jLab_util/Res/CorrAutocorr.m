% CorrAutocorr: Determines effect of lag-1 autocorrelations on the correlation
%   (and its significance) between two variables.
%
%     Usage:  function CorrAutocorr(x,y)
%

function CorrAutocorr(x,y)
  N = length(x);
  [r0,pr0] = corr(x,y);
  rx0 = autocorr(x,1);
  ry0 = autocorr(y,1);
  
  xx = x;
  yy = y;
  
  iter = 50;
  r =  [r0;  zeros(iter-1,1)];
  pr = [pr0; zeros(iter-1,1)];
  rx = [rx0; zeros(iter-1,1)];
  ry = [ry0; zeros(iter-1,1)];
  
  
  for it = 2:iter       % Reverse two random observations
    i = ceil(rand(1,2)*N);
    [xx(i(1)),xx(i(2))] = switchem(xx(i(1)),xx(i(2)));
    [yy(i(1)),yy(i(2))] = switchem(yy(i(1)),yy(i(2)));
    [r(it),pr(it)] = corr(xx,yy,[],1000);
    rx(it) = autocorr(xx,1);
    ry(it) = autocorr(yy,1);
  end;
  
r_pr_rx_ry = [r pr rx ry]  
  
%   [rx,rr,prr] = sortmat(rx,r,pr);
  figure;
  plot(r);
  putxlab('Iteration');
  putylab('Correlation');
  
  figure;
  plot(pr);
  putxlab('Iteration');
  putylab('Significance level');

  figure;
  plot(rx);
  putxlab('Iteration');
  putylab('Autocorrelation of X');

  figure;
  plot(ry);
  putxlab('Iteration');
  putylab('Autocorrelation of Y');

  return;
  