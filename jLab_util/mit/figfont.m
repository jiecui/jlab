function figfont(curfig, newfont)
%   script to change a figure's font properties
% based on gcf and gca
curaxes = get(curfig,'CurrentAxes');

% change everything at the top level
set(curaxes,'FontName',newfont);
%set(curaxes,'FontSize',newsize);
%set(curaxes,'FontWeight',newweight);

% now change children
xtlab = get(curaxes,'XLabel');
ytlab = get(curaxes,'YLabel');
titl = get(curaxes,'Title');

set(xtlab,'FontName', newfont);
set(ytlab,'FontName', newfont);
set(titl,'FontName', newfont);


%set(xtlab,'FontSize', newsize);
%set(ytlab,'FontSize', newsize);
%set(titl,'FontSize', newsize);

%set(xtlab,'FontWeight',newweight);
%set(ytlab,'FontWeight',newweight);
%set(titl,'FontWeight',newweight);

% change legend
legend(curaxes)