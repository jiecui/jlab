function hdat=ploterr(dat,err,specdat,specerr,widthdat,widtherr)


plot1 = plot([dat dat+err dat-err]);
set(plot1(1),'Color',specdat(1),'LineStyle',specdat(2));
if ~exist('widthdat')
    widthdat = 3;
end
set(plot1(1),'linewidth',widthdat);

set(plot1(2),'Color',specerr(1),'LineStyle',specerr(2));
set(plot1(3),'Color',specerr(1),'LineStyle',specerr(2))
if ~exist('widtherr')
    widtherr = 1;
end
set(plot1(2),'linewidth',widtherr);
set(plot1(3),'linewidth',widtherr);
hdat=plot1(1);