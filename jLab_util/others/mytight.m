function mytight(ax, margin_percent, doX)
% function mytight(ax, margin_percent)
% Adjust the axes to the contents
% ax			: axes to adjust
% margin_percent: magin between the content and the axis, in percent of the content size	
% doX			: 1 if the X axis should be adjusted as well
axis tight
yl = get(ax,'ylim');
set(ax,'ylim',[yl(1)-abs(margin_percent/100*yl(1)) yl(2)+abs(margin_percent/100*yl(2))]); 

if ( exist('doX') && doX == 1 )
	xl = get(ax,'xlim');
	set(ax,'xlim',[xl(1)-abs(margin_percent/100*xl(1)) xl(2)+abs(margin_percent/100*xl(2))]); 
end