function setylimpercent(ax1,ax2,avg)
%  function setylimpercent(ax1,ax2,avg)
% sets the ylim of ax2 to the percent deviation from avg of the limits of
% ax1 -- uses devmn()
set(ax2, 'ylim', devmn(get(ax1,'ylim'),avg) );
