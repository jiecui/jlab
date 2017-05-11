function plot_raster(raster, zero_line)

figure
hold on
for n = 1 : size(raster,1)
    plot(n*raster(n,:),'Marker','.','MarkerSize',1,'LineStyle','none','Color',[0 0 0])
end
set(gca, 'YLim',[0 size(raster,1)])
if( exist('zero_line') )
    line([zero_line zero_line], [0 size(raster,1)])
end
