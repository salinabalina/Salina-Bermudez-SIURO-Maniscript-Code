function [optKP, gcvval]=FindKPparamgcv(B,Ac,Ar,T,varargin)
%%
% For a set of T true images  find the optimal
% truncation parameter for the given blur operator A= Ar cross Ac  to
% minimize the gcv function.
% This code calculates the gcv for all indices of the expansion
%
% Inputs
%
% B : Blurred and Noisy Images Cell Array images 1:T
% Ac:  A= Ar cross Ac
% Ar:  A= Ar cross Ac
% T : Number of Images
% varargin{1}: color for plotting gcv curve default blue
% varargin{2}: symbol for plotting optimal index - default diamond
%
% Outputs
%
% optKP : the optimal index for the set of images
% gcvval the obtained minimal gcv
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
cc='b';mm='d';
if ~isempty(varargin{1})
    cc=cell2mat(varargin{1}(1));
    if ~isempty(varargin{1}{2})
        mm=cell2mat(varargin{1}(2));
    end
end
[Uc,Sc,Vc]=svd(Ac);
[Ur,Sr,Vr]=svd(Ar);
Sc=diag(Sc); %extract into diagonal matrix
Sr=diag(Sr); %extract into diagonal matrix
KPSVs=Sc*Sr'; %KP singular values page 50 HNO book
[m,n]=size(KPSVs);
[sortKP, sortKPind]=sort(KPSVs(:),'descend'); % index into sorted values of the KPs
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
[gcvval, optKP]=min(gcvfun(:));
semilogy(1:kind, gcvfun, 'Color',cc);hold on
semilogy(optKP, gcvval,'Marker',mm, 'Color', cc,'MarkerSize',12);
end
