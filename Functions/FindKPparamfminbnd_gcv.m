function [optKP, minerr] = FindKPparamfminbnd_gcv(B, Ac,Ar,T,varargin)
cc='b';mm='h';
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

maxsv=sortKP(1);
tolstart=1e-8;
maxKP=[];
while isempty(maxKP)
maxKP=find(sortKP/maxsv<tolstart,1);
tolstart=tolstart*10;
end
