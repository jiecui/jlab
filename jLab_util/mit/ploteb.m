function ploteb(xdata, ydata, xsd, ysd, symstyle, blinestyle, bcolor, connect, connstyle)

%PLOTEB  Error-Bar Plot (ahema project)
%	
%		ploteb(xdata, ydata, xsd, ysd, symstyle, barstyle, bcolor, connect, connstyle)
%
%		xdata, ydata: column-vectors with mean-data
%		xsd, ysd: 	column-vectors with standard 
%						deviations for error bars.	
%		symstyle:	string for symbols 
%						( + | o | * | . | x )	
%		blinestyle:	string for bars 
%						({-} | -- | : | -. | none )
%		bcolor:		color for bars
%		connect:		connect data points? ( 0 | 1 )
%		connstyle:	string for connection (e.g. 'r--')
%	
%	F.Bunjes  7/98
%	
%******************************************************

cla;
hold on
if connect
   plot(xdata,ydata,connstyle)
end

xxl=[xdata'+xsd'; xdata'-xsd'];
xyl=[ydata'; ydata'];
yxl=[xdata'; xdata'];
yyl=[ydata'+ysd'; ydata'-ysd'];
%Endstriche
yxe=[xsd'.*0.04+xdata'; xdata'-xsd'.*0.04];
yye1=[ydata'+ysd'; ydata'+ysd'];
yye2=[ydata'-ysd'; ydata'-ysd'];

xye=[ydata'+ysd'.*0.04; ydata'-ysd'.*0.04];
xxe1=[xdata'+xsd'; xdata'+xsd'];
xxe2=[xdata'-xsd'; xdata'-xsd'];

lx=line(xxl,xyl,'color',bcolor,'linestyle',blinestyle);
ly=line(yxl,yyl,'color',bcolor,'linestyle',blinestyle);

lxe=line([yxe yxe],[yye1 yye2],'color',bcolor);
lye=line([xxe1 xxe2],[xye xye],'color',bcolor);


plot(xdata,ydata,symstyle)

