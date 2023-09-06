function [optKP, minerr] = FindKPparamfminbnd_gcv(B, Ac,Ar,T,varargin)
% For given set of images B and true images X
% For Ac, Ar, operator, find the best choice to truncate for the full KP
% Find the SVD
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
Sc=diag(Sc); %extract into diagonal matrix
Sr=diag(Sr); %extract into diagonal matrix
KPSVs=Sc*Sr'; %KP singular values page 50 HNO book
[m,n]=size(KPSVs);
[sortKP, sortKPind]=sort(KPSVs(:),'descend');% index into sorted values of the KPs
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

[optKP,minerr,fvals]=calcgcv(maxKP,CoefB, KPSVs,sortKP, sortKPind,m,n);
optKP=floor(optKP);
semilogy(fvals(:,1), fvals(:,2), 'Color', cc,'Marker','x','LineStyle','none','MarkerSize',12);hold on
semilogy(optKP, minerr,'Marker',mm, 'Color', cc,'MarkerSize',12); 
end

function [optKP,mingcv,history]=calcgcv(maxKP,CoefB, KPSVs,sortKP, sortKPind,m,n)
history=[];
optionsmin=optimset('OutputFcn', @myoutput,'Display','off','TolX',.01);
%optionsmin=optimset('OutputFcn', @myoutput,'Display','off','PlotFcns',@optimplotfval,'TolX',.01);
[optKP,mingcv]=fminbnd(@gcvfun,1, maxKP,optionsmin);
    
    function stop = myoutput(x,optimvalues,state)
        stop = false;
        if isequal(state,'iter')
            history = [history; [x,optimvalues.fval]];
        end
    end

    function fval=gcvfun(KP)
        KPSVpinv=ones(size(KPSVs(:)));
        kind=floor(KP);
        KPSVpinv(sortKPind(1:kind))=0;
        Residual=(KPSVpinv).^2;
        Residual=reshape(Residual,m,n).*CoefB;
        fval=sum(Residual(:))/(m*n-kind)^2;
    end

end
