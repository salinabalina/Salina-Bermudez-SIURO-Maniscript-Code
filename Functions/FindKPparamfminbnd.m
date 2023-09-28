function [optKP, minerr] = FindKPparamfminbnd(X,B, Ac,Ar,R,varargin)
cc='k';mm='h';
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
[sortKP, sortKPind]=sort(KPSVs(:),'descend');
[m,n]=size(KPSVs);
maxsv=sortKP(1);
tolstart=1e-8;
maxKP=[];
while isempty(maxKP)
maxKP=find(sortKP/maxsv<tolstart,1);
tolstart=tolstart*10;
end
for j=1:R
    CoefX{j}=Vc'*X{j}*Vr;
    CoefB{j}=(Uc'*B{j}*Ur);
end
[optKP,minerr,fvals]=calcerror(maxKP,CoefX,CoefB, KPSVs,sortKP, sortKPind,m,n,R);
optKP=floor(optKP);
semilogy(fvals(:,1), fvals(:,2), 'Color', cc,'Marker','x','LineStyle','none','MarkerSize',12), hold on
semilogy(optKP, minerr,'Marker',mm, 'Color', cc,'MarkerSize',12)
end

function [optKP,minerr,history]=calcerror(maxKP,CoefX,CoefB, KPSVs,sortKP, sortKPind,m,n,R)
history=[];
errorvec = @(KPSVpinv,j) norm(CoefX{j}-CoefB{j}.*KPSVpinv,'fro')/norm(CoefX{j},'fro');
optionsmin=optimset('OutputFcn', @myoutput,'Display','off','TolX',.01);
[optKP,minerr]=fminbnd(@error,1, maxKP,optionsmin);

    function stop = myoutput(x,optimvalues,state)
        stop = false;
        if isequal(state,'iter')
            history = [history; [x,optimvalues.fval]];
        end
    end

    function fval=error(KP)
        KPSVpinv=zeros(size(KPSVs(:)));
        indKP=floor(KP);
        KPSVpinv(sortKPind(1:indKP))=1./sortKP(1:indKP);
        KPSVpinv=reshape(KPSVpinv,m,n);
        for j=1:R
            error(j)=errorvec(KPSVpinv,j);
        end
        fval=mean(error');
    end

end
