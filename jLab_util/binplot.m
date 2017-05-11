function binplot(dat,varargin)
if nargin > 1
    area(dat,varargin);
else
    area(dat);
end
set(gca,'YLim',[0 1.5]);
