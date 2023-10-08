function ct=Figure1(m,n,ct,labelim)
%%
% Plot Figure 1 for the paper
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
[Acb,Arb,PSFb] = BlurOperator(m,n,1,0);
figure, imagesc(PSFb(129+104:384-104,129+104:384-104));axis image,axis off,%233:280
figname=strcat('Figure',num2str(ct));fignameabc=strcat(figname,labelim(1))
exportgraphics(gca,strcat(fignameabc,'.jpg'));
[Ac,Ar,PSFa] = BlurOperator(m,n,2,0);
figure, imagesc(PSFa(129+104:384-104,129+104:384-104));axis image,axis off,%233:280
figname=strcat('Figure',num2str(ct));fignameabc=strcat(figname,labelim(2))
exportgraphics(gca,strcat(fignameabc,'.jpg'));
ct=ct+1;
end