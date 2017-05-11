% function fit_pretimes(usacc_props)
%%
theta = {};
figure
for i=1:8
    
    times = usacc_props{i}{1}(find(usacc_props{i}{1}(:,12)==1),15);
    times = times(find(times<2000 & times>0));
    
%     for j=1:1000
%         bs_times = bootstrap(times);
%         bs_theta(i,j,:) = fminsearch('MLE', [ 200,50,100],optimset('MaxFunEvals',500),'exgausspdf',bs_times);
         theta1 = fminsearch('MLE', [ 200,50,100],optimset('MaxFunEvals',500),'exgausspdf',times);
%         [i,j]
%     end
%     theta1 = mean(bs_theta);
    mu(i) = theta1(1);
    s(i) = theta1(2);
    exp(i) = theta1(3);
    theta{i} = theta1;
end

%%
% for i=1:8
%     bs_mu_avg(i) = mean(bs_theta(i,:,1));
%     bs_sigma_avg(i) = mean(bs_theta(i,:,2));
%     bs_tau_avg(i) = mean(bs_theta(i,:,3));
%     bs_mu_std(i) = std(bs_theta(i,:,1));
%     bs_sigma_std(i) = std(bs_theta(i,:,2));
%     bs_tau_std(i) = std(bs_theta(i,:,3));
% end

%%
for i=1:8
    times = usacc_props{i}{1}(find(usacc_props{i}{1}(:,12)==1),15);
    times = times(find(times<2000 & times>0));
    step = 10;
    edges = 0:step:2000;
    h = histc(times,edges);
%     h = ht/sum(ht)/step;
    
    subplot(2,4,i);
    plot(edges,h);
    hold
    plot(edges,exgausspdf(edges,theta{i})*sum(h)*step,'r-');
    
%     [x2(i),pchi(i)] = chi2( times, 'exgausscdf', theta{i},[10:20:90]);
    
%     [k(i) pks(i)  ksstat(i) cv(i)] = kstest(times,[times exgausscdf(times,theta{i})],1-1e-15,0);
    
    
%     [X2gof(i),dfgof(i),prgof(i),X2cell{i}] = goodfit(h',exgausspdf(edges,theta{i})*sum(h)*step);
    
%     [prob(i) t(i)] = goodfitp(h',exgausspdf(edges,theta{i})*sum(h)*step);
    
%     [stathat(i),pr(i),power(i)] = kstest1d((0:1:2000),hist(times,(0:1:2000)),exgausspdf(0:1:2000,theta{i}));
end

