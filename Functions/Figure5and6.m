function [re,ct]=Figure5and6(Xtest,Btest,Ac,Ar,kopterror,ct,labelim)
%%
% Plot Figures 5 and 6 for the paper
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
[Uc,Sc,Vc]=svd(Ac);
[Ur,Sr,Vr]=svd(Ar);
Sc=diag(Sc); %extract into diagonal matrix
Sr=diag(Sr); %extract into diagonal matrix
KPSVs=Sc*Sr'; %KP singular values page 50 HNO book
[sortKP, sortKPind]=sort(KPSVs(:),'descend');% index into sorted values of the KPs
NN=length(sortKP);
s=sortKP;
incrementind=100;
indtoplot=1:incrementind:NN; %can try with incrementind=1 but probably too dense
ssam=s(indtoplot);
nl=3;
figname=strcat('Figure',num2str(ct));
leg{1}='\sigma_k';leg{2}='|u_k^Tb|';leg{3}='|u_k^Tb|/\sigma_k';leg{4}='k=6500';
for nt=1:3
    CoefB{nt}{nl}=abs(Uc'*Btest{nt}{nl}*Ur);
    sortCoefB{nt}{nl}=CoefB{nt}{nl}(sortKPind);
    beta{nt}{nl}=sortCoefB{nt}{nl};eta{nt}{nl}=beta{nt}{nl}./s;
    betasam{nt}{nl}=sortCoefB{nt}{nl}(indtoplot);
    etasam{nt}{nl}=eta{nt}{nl}(indtoplot);
    fignameabc=strcat(figname,labelim(nt))
    figure
    semilogy(indtoplot,ssam,'.-',indtoplot,betasam{nt}{nl},'x',indtoplot,etasam{nt}{nl},'o')
    xlim([1 10000])
    xline(6500,'LineWidth',3)
    xline(kopterror(nt,nl),'LineWidth',6,'Color','b')
    leg{5}=strcat('k=',int2str(kopterror(nt,nl)));
    legend(leg,'Location','southwest','FontSize',14),
    xlabel('k')
    set(gca,'TickLength', [0.0100 0.0100])
    set(gca,'LineWidth',2); % This makes the width of the axis box wider
    set(findobj('Type','line'),'MarkerSize',12) % This makes the width of the axis box wider
    set(findobj('Type','line'),'LineWidth',2) %change the line width
    set(findobj('Type','text'),'FontWeight','bold','FontSize',12)
    set(findobj('Type','axes'),'FontWeight','bold','FontSize',12)
    exportgraphics(gca,strcat(fignameabc,'.jpg'));
end
fignameabc=strcat(figname,labelim(4))
Xnaivetest=(Ac\ Btest{2}{3} )/Ar';
figure
imshow( Xnaivetest)% bad image for Figure 5
exportgraphics(gca,strcat(fignameabc,'.jpg'));
% Figure 6
ct=ct+1;
figname=strcat('Figure',num2str(ct));
for nt=1:3
    Xtrunc{nt}=TruncatedImage(Ac,Ar,Btest{nt}{nl} ,6500); %For Figure 6
    re(1,nt)=relative_error(Xtest,Xtrunc{nt});
    Xtruncopt{nt}=TruncatedImage(Ac,Ar,Btest{nt}{nl} ,kopterror(nt,nl)); %For caption in Figure 6
    re(2,nt)=relative_error(Xtest,Xtruncopt{nt});
end
for nt=1:3
    fignameabc=strcat(figname,labelim(nt))
    figure,imshow( Xtrunc{nt}) ;
    exportgraphics(gca,strcat(fignameabc,'.jpg'));
end
ct=ct+1;
end


