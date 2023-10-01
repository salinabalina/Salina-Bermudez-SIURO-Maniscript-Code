function Xtrunc=TruncatedImage(Ac,Ar,B,kind)
[Uc,Sc,Vc]=svd(Ac);
[Ur,Sr,Vr]=svd(Ar);
Sc=diag(Sc); %extract into diagonal matrix
Sr=diag(Sr); %extract into diagonal matrix
KPSVs=Sc*Sr'; %KP singular values page 50 HNO book
[m,n]=size(KPSVs);
[sortKP, sortKPind]=sort(KPSVs(:),'descend'); % index into sorted values of the KPs
CoefB=(Uc'*B*Ur);
KPSVpinv=zeros(size(KPSVs(:)));
indKP=floor(kind);
KPSVpinv(sortKPind(1:indKP))=1./sortKP(1:indKP);
KPSVpinv=reshape(KPSVpinv,m,n);
Xtrunc=Vc*(CoefB.*KPSVpinv)*Vr';
end
