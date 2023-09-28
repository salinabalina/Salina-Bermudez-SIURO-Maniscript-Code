if exist('a') aold=a;end
if exist('h') ho=h;end

axis(axis);
h=gcf; 
a=gca; 
set(gca,'FontWeight','bold');
a.TickLength=[.01,.01];
set(a,'LineWidth',2);
set(findobj('Type','line'),'MarkerSize',12)
set(findobj('Type','line'),'LineWidth',2)
set(findobj('Type','text'),'FontWeight','bold','FontSize',12)
set(findobj('Type','axes'),'FontWeight','bold','FontSize',12)
set(findobj('Type','title'),'FontWeight','bold')
if exist('aold') a=aold;end
if exist('ho') h=ho;end
hold off
