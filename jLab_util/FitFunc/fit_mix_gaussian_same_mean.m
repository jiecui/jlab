function [u,sig,t,iter] = fit_mix_gaussian_same_mean( X,M, DOPLOT )
% FIT_MIX_GAUSSIAN_SAME_MEAN - fit parameters for a mixed-gaussian distribution with same mean using EM algorithm
% 
% Note: modified from fit_mix_gaussian.m for RF2 analysis
%
% format:   [u,sig,t,iter] = fit_mix_gaussian( X,M )
%
% input:    X   - input samples, Nx1 vector
%           M   - number of gaussians which are assumed to compose the distribution
%           DOPLOT   - FLAG for optional ploting
%
% output:   u   - fitted mean for each gaussian
%           sig - fitted standard deviation for each gaussian
%           t   - probability of each gaussian in the complete distribution
%           iter- number of iterations done by the function
%

% Copyright 2013 Richard J. Cui. Created: Sat 05/18/2013  8:37:47.793 AM
% $Revision: 0.1 $  $Date: Sat 05/18/2013  8:37:47.793 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com


% run with default values
if ~nargin
    M   = round(rand*5)+1;
    sig = rand(1,M)*3;
    u   = randn * 8 * ones(1, M);
    prob= rand(1,M);
    [u,sig,t,iter] = fit_mix_gaussian_same_mean( build_mix_gaussian( u,sig,prob,2000*M ),M );
    return
end

if ( ~exist( 'DOPLOT' , 'var' ) )
    DOPLOT = 0;
end

% initialize and initial guesses
N           = length( X );                      % number of samples
Z           = ones(N,M) * 1/M;                  % indicators vector
% P           = zeros(N,M);                       % probabilities vector for each sample and each model
t           = ones(1,M) * 1/M;                  % distribution of the gaussian models in the samples
% t           = ones(1, M) * diag([0.4 0.6]);
% u           = linspace(min(X),max(X),M);        % mean vector
u           = mean(X) * ones(1, M);             % use average as the initial guess, same mean
sig2        = ones(1,M) * var(X) / sqrt(M);     % variance vector
C           = 1/sqrt(2*pi);                     % just a constant
Ic          = ones(N,1);                        % - enable a row replication by the * operator
Ir          = ones(1,M);                        % - enable a column replication by the * operator
% Q           = zeros(N,M);                       % user variable to determine when we have converged to a steady solution
thresh      = 1e-3;
step        = N;
last_step   = inf;
iter        = 0;
min_iter    = 10;

% main convergence loop, assume gaussians are 1D
while ((( abs((step/last_step)-1) > thresh) && (step>(N*eps)) ) || (iter<min_iter) ) 
    
    % E step
    % ========
    Q   = Z;
    P   = C ./ (Ic*sqrt(sig2)) .* exp( -((X*Ir - Ic*u).^2)./(2*Ic*sig2) );
    for m = 1:M
        Z(:,m)  = (P(:,m)*t(m))./(P*t(:));
    end
        
    % estimate convergence step size and update iteration number
    prog_text   = sprintf(repmat( '\b',1,(iter>0)*12+ceil(log10(iter+1)) ));
    iter        = iter + 1;
    last_step   = step * (1 + eps) + eps;
    step        = sum(sum(abs(Q-Z)));
    fprintf( '%s%d iterations\n',prog_text,iter );

    % M step
    % ========
    Zm              = sum(Z);               % sum each column
    % Zm(find(Zm==0)) = eps;                  % avoid devision by zero
    Zm(Zm==0) = eps;                        % avoid devision by zero
    u               = (X')*Z ./ Zm;
    sig2            = sum(((X*Ir - Ic*u).^2).*Z) ./ Zm;
    t               = Zm/N;
end

% plot the fitted distribution
% =============================
sig     = sqrt( sig2 );
if ( DOPLOT )
    plot_mix_gaussian( u,sig,t, X);
end
