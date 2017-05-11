function varargout = rho_polar(col6, col8, expname)
% function rho_polar(hrudat,expname), plots microsaccades in polar format
% [H,n] = rho_polar(hrudat,expname), n is number of microscaccades in bins
ud68 = [col6 col8];
dud8 = diff(ud68(:,2));
rho = ud68(dud8==-1,1);
thta = deg2rad(ud68(dud8==-1,2));
% thta = ud68(dud8==-1,2);

% since y is reversed in matlab-land, need to do some reflection across
% x-axis
thta = 2*pi - thta;
[n,x]=hist(thta,[0:pi/180:2*pi]);
n(end+1) = n(1);
x(end+1) = x(1);
% histrho = zeros(length(rho)*2,1);
% histthta = zeros(length(thta)*2,1);
% histrho(2:2:end)=rho;
% histthta(2:2:end)=thta;
% zero out max bin...
% [m,i]=max(n);
% n(i)=0;
if nargout == 0
    figure;mmpolar(x,n,'RLimit',[0,max(n)+max(5,.1*max(n))],'Style','compass')
else
    H = mmpolar(x,n,'RLimit',[0,max(n)+max(5,.1*max(n))],'Style','compass');
    %mmrose(thta,50);
    varargout= {H n};
end
title(expname);