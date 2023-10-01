% A script to make plots look good for printing and display in class notes
% First do the plot of the data, and then run this, and then do titles and
% so forth
if exist('a') aold=a;end
if exist('h') ho=h;end

axis(axis);
h=gcf; %handles of the figure
a=gca; %axes handle
set(gca,'FontWeight','bold'); % This makes the text on the axis bold and 
% the x or y label bold and the title note that it seems to matter that
% we do titles etc after setting to bold
a.TickLength=[.01,.01];
set(a,'LineWidth',2); % This makes the width of the axis box wider
set(findobj('Type','line'),'MarkerSize',12) % This makes the width of the axis box wider
set(findobj('Type','line'),'LineWidth',2) %change the line width
set(findobj('Type','text'),'FontWeight','bold','FontSize',12)
set(findobj('Type','axes'),'FontWeight','bold','FontSize',12)
set(findobj('Type','title'),'FontWeight','bold')
if exist('aold') a=aold;end
if exist('ho') h=ho;end
hold off
