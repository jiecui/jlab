function [fitParams, fitParamsInt, fithistogram] = fitdata( data, distribution, degbins )
% FITDATA
% 
% Syntax:
%   [fitParams, fitParamsInt, fithistogram] = fitdata( data, distribution, degbins )
% 
% Input(s):
% 
% Output(s):
% 
% See also .

% Last modified by Richard J. Cui. on: Tue 10/23/2012 10:10:14.593 AM
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

if ( ~exist( 'degbins', 'var' ) )
    [~, degbins] = hist(data);
end

%-- fitting options ---------------------------------------------------
switch(distribution)
    case 'Normal'
        [muhat, sigmahat, muci, sigmaci] = normfit(data, 0.05);
        y =  normpdf(degbins, muhat, sigmahat);
        fithistogram = y/sum(y)*length(data);
        fitParams = [muhat, sigmahat];
        fitParamsInt = [ muci, sigmaci];
        % disp( sprintf('Data Length%.2d mu = %6.2f - sigma = %6.2f', length(n), muhat, sigmahat ) )
        fprintf('Normal fit - Data Length: %.2d, mu = %6.2f, sigma = %6.2f\n', length(data), muhat, sigmahat)
        
    case 'Rayleigh'
        [phat, pci] = raylfit(data, 0.05);
        y =  raylpdf(degbins, phat);
        fithistogram  = y/sum(y)*length(data);
        fitParams = phat;
        fitParamsInt = pci;
        fprintf('Rayleigh fit - Data Length: %.2d\n', length(data))
        
    case 'Ex-gaussian'
        data = data(data<2000 & data>0);
        [phat fval ] = fminsearch('trish_MLE', [150,36,100],optimset('MaxFunEvals',500),'exgausspdf',data);
        y =  exgausspdf(degbins, phat);
        fithistogram  = y/sum(y)*length(data);
        fitParams = phat;
        fitParamsInt = fval;    % the value of the objective function fun at the solution x.
        fprintf('Ex-Gaussian fit - Data Length: %.2d, mu = %6.2f, sigma = %6.2f, tau = %6.2f\n', length(data), phat(1), phat(2), phat(3) )
        
    case 'Mix-2-Gaussian'
        [mu, s, t] = fit_mix_gaussian(data,2);
        y =  normpdf(degbins, mu(1), s(1))*t(1)+normpdf(degbins, mu(2), s(2))*t(2);
        fithistogram  = y/sum(y)*length(data);
        fitParams = [mu s t];
        fitParamsInt = [];
        fprintf('DATA %.2d mu1 = %6.2f - sigma1 = %6.2f mu2 = %6.2f - sigma2 = %6.2f [%6.2f/%6.2f]', length(data), mu(1),s(1),mu(2),s(2),t(1),t(2))
        
    case 'Mix-3-Gaussian'
        [mu, s, t] = fit_mix_gaussian(data,3,1);
        y =  normpdf(degbins, mu(1), s(1))*t(1)+normpdf(degbins, mu(2), s(2))*t(2)+normpdf(degbins, mu(3), s(3))*t(3);
        fithistogram  = y/sum(y)*length(data);
%         disp( sprintf('DATA %.2d mu1 = %6.2f - sigma1 = %6.2f mu2 = %6.2f - sigma2 = %6.2f mu3 = %6.2f - sigma3 = %6.2f', i, mu(1),s(1),mu(2),s(2),mu(3),s(3)))
end

end

% [EOF]