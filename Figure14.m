function [errorresfig14,ct]=Figure14(X,m,n,bl,noiseoptions,rangenl,kopt,ct,labelim)
%%
% Plot Figure 14 for paper. Peppers with asymmetric blur. SNR=40 and
% optimal k by mre and gcv
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
[mX,nX]=size(X);
if mX~= m ||  nX~= n  
    disp('For Figure 14 we want image of size 512 by 512'); 
    return;
end
[Ac,Ar] = BlurOperator(m,n,bl,0);
[Btrue,X] = GenerateImage(Ac,Ar, X);
for nl=rangenl
    figname=strcat('Figure',num2str(ct));
    for nt=1:3
        [Btest{nt}{nl}] = AddNoise(Btrue,cell2mat(noiseoptions(nt)),nl);
        Xtest_asyoptgcvtrunc{nt}{nl}=TruncatedImage(Ac,Ar,Btest{nt}{nl} ,kopt(nt,2));
        fignameabc=strcat(figname,labelim(nt))
        figure
        imshow( (Xtest_asyoptgcvtrunc{nt}{nl}))
        exportgraphics(gca,strcat(fignameabc,'.jpg'));
        errorresfig14(nt)=relative_error(X,Xtest_asyoptgcvtrunc{nt}{nl});%norm(Xtrainoptgcvtrunc{nt}{nl}-Xtrain,'fro')/norm(Xtrain,'fro');
    end
end
ct=ct+1;
end