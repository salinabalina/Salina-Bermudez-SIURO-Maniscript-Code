function [Xtrue,Btruesym,Ac,Ar,ct]=Figure2(X,m,n,ct,labelim)
%%
% Plot Figure 2 for the paper
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
[mX,nX]=size(X);
if mX~= m ||  nX~= n  
    disp('For Figure 2 we want image of size 512 by 512'); 
    return;
end
[Ac,Ar] = BlurOperator(m,n,1,0);
[Btruesym,Xtrue] = GenerateImage(Ac,Ar, X);
[Ac2,Ar2] = BlurOperator(m,n,2,0);
[BtrueAsym,~] = GenerateImage(Ac2,Ar2, X);
figname=strcat('Figure',num2str(ct),labelim(1))
figure, imshow(Xtrue,[])
exportgraphics(gca,strcat(figname,'.jpg'));
figname=strcat('Figure',num2str(ct));
fignameabc=strcat(figname,labelim(2))
figure, imshow(Btruesym)
exportgraphics(gca,strcat(fignameabc,'.jpg'));
fignameabc=strcat('Figure',num2str(ct),labelim(3))
figure, imshow(BtrueAsym)
exportgraphics(gca,strcat(fignameabc,'.jpg'));
ct=ct+1;
end