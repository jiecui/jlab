function rplot(save_data, bspike, rfactor, A_to_D_per_DVA)
% Just your basic plot from the nature neuroscience paper
%
% params:
%   save_data: samples x 8 data array
%   bspike: boolean whether to plot spikes
%   rfactor: how much to scale the r vector by
%   A_to_D_per_DVA: factor to divide raw x,y by; default 28.0

if nargin == 4
    dva_fac = A_to_D_per_DVA;
else
    dva_fac = 28.0;
end
% create lines for r-plot
figure;plot([save_data(:,1)/28 save_data(:,2)/28+7],1:.001:124.762);hold on;area( save_data(:,6)*5+15,15, 'edgecolor','r', 'FaceColor', 'r')
    