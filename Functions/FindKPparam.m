function [optKP, minerr] = FindKPparam(X,B, Ac,Ar,T,varargin)
%%
% For a set of T true images and blurred noisy images find the optimal
% truncation parameter for the given blur operator A= Ar cross Ac  to
% minimize the error.
% This code calculates the error for all indices of the expansion
%
% Inputs
%
% X : True Images Cell Array images 1:T
% B : Blurred and Noisy Images Cell Array images 1:T
% Ac:  A= Ar cross Ac
% Ar:  A= Ar cross Ac
% T : Number of Images
% varargin{1}: color for plotting error curve default black
% varargin{2}: symbol for plotting optimal index - default diamond
%
% Outputs
%
% optKP : the optimal index for the set of images
% minerr: the obtained minimal error
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
cc='k';mm='d';
if ~isempty(varargin{1})
    cc=cell2mat(varargin{1}(1));
    if ~isempty(varargin{1}{2})
        mm=cell2mat(varargin{1}(2));
    end
end
[Uc,Sc,Vc]=svd(Ac);
[Ur,Sr,Vr]=svd(Ar);
Sc=diag(Sc); %extract into diagonal matrix
Sr=diag(Sr);  %extract into diagonal matrix
KPSVs=Sc*Sr'; %KP singular values page 50 HNO book
[sortKP, sortKPind]=sort(KPSVs(:),'descend'); % index into sorted values of the KPs
[m,n]=size(KPSVs);
for j=1:T
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
    for j=1:T
        error(indKP,j)=errorvec(KPSVpinv,j);
    end
end
meanerror=mean(error');
[minerr, optKP]=min(meanerror);
semilogy(1:indKP, meanerror, 'Color',cc);hold on
semilogy(optKP, minerr,'Marker',mm, 'Color', cc,'MarkerSize',12);
end
