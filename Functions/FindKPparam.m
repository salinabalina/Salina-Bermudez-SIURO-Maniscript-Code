function [optKP, minerr] = FindKPparam(X,B, Ac,Ar,R,varargin)
% For given set of images B and true images X
% For Ac, Ar, operator, find the best choice to truncate for the full KP
% Find the SVD
cc='k';mm='d';
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
Sc=diag(Sc); %extract into diagonal matrix
Sr=diag(Sr); %extract into diagonal matrix
KPSVs=Sc*Sr'; %KP singular values page 50 HNO book
[sortKP, sortKPind]=sort(KPSVs(:),'descend'); % index into sorted values of the KPs
[m,n]=size(KPSVs);
for j=1:R
    CoefX{j}=Vc'*X{j}*Vr;
    CoefB{j}=(Uc'*B{j}*Ur);
end
errorvec = @(KPSVpinv,j) norm(CoefX{j}-CoefB{j}.*KPSVpinv,'fro')/norm(CoefX{j},'fro');
maxKP=[];maxsv=sortKP(1);tolstart=1e-8;
while isempty(maxKP)
maxKP=find(sortKP/maxsv<tolstart,1);
tolstart=tolstart*10;
end
for indKP=1:maxKP % should be index of sorted KP
    KPSVpinv=zeros(size(KPSVs(:)));
    KPSVpinv(sortKPind(1:indKP))=1./sortKP(1:indKP);
    KPSVpinv=reshape(KPSVpinv,m,n);
    for j=1:R
        error(indKP,j)=errorvec(KPSVpinv,j);
    end
end
meanerror=mean(error');
[minerr, optKP]=min(meanerror);
semilogy(1:indKP, meanerror, 'Color',cc);hold on
semilogy(optKP, minerr,'Marker',mm, 'Color', cc,'MarkerSize',12); 
end
