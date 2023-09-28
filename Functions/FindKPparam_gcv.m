function [kopt, gcvval]=FindKPparamgcv(B,Ac,Ar,T,varargin)
cc='b';mm='d';
if ~isempty(varargin)
    if nargin >5
        cc=cell2mat(varargin{1}(1));
    end
    if nargin> 6  
        mm=cell2mat(varargin{1}(2));
    end
end
[Uc,Sc,Vc]=svd(Ac);
[Ur,Sr,Vr]=svd(Ar);
Sc=diag(Sc); 
Sr=diag(Sr); 
KPSVs=Sc*Sr'; 
[m,n]=size(KPSVs);
[sortKP, sortKPind]=sort(KPSVs(:),'descend');
CoefB=zeros(m,n);
for j=1:T
CoefB=CoefB+(Uc'*B{j}*Ur).^2;
end
for kind=1:m*n
KPSVpinv=ones(size(KPSVs(:)));
KPSVpinv(sortKPind(1:kind))=0;
Residual=(KPSVpinv).^2;
Residual=reshape(Residual,m,n).*CoefB;
gcvfun(kind)=sum(Residual(:))/(m*n-kind)^2;
end
[gcvval, kopt]=min(gcvfun(:));
semilogy(1:kind, gcvfun, 'Color',cc);hold on
semilogy(kopt, gcvval,'Marker',mm, 'Color', cc,'MarkerSize',12); 
end 
