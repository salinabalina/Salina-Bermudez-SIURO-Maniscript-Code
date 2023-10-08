function [optKP, minerr,varargout] = FindKPparamfminbnd(X,B, Ac,Ar,T,varargin)
%%
% For a set of T true and their noisy images B find the optimal
% truncation parameter for the given blur operator A= Ar cross Ac  to
% minimize the error using fminbnd
%
% Inputs
%
% X : True Images Cell Array images 1:T
% B : Blurred and Noisy Images Cell Array images 1:T
% Ac:  A= Ar cross Ac
% Ar:  A= Ar cross Ac
% T : Number of Images
% varargin{1}: color for plotting the curve - default is black
% varargin{2}: symbol for plotting optimal index - default is hexagon
%
% Outputs
%
% optKP : the optimal index for the set of images
% minerr:  the obtained optimal value of the error
% varargout{1}:  iterations in fminbnd
% varargout{2}: function evaluations
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
cc='k';mm='h';
if ~isempty(varargin{1})
    cc=cell2mat(varargin{1}(1));
    if ~isempty(varargin{1}{2})
        mm=cell2mat(varargin{1}(2));
    end
end
% Find the SVD
[Uc,Sc,Vc]=svd(Ac);
[Ur,Sr,Vr]=svd(Ar);
Sc=diag(Sc); %extract into diagonal matrix
Sr=diag(Sr); %extract into diagonal matrix
KPSVs=Sc*Sr'; %KP singular values page 50 HNO book
[sortKP, sortKPind]=sort(KPSVs(:),'descend');% index into sorted values of the KPs
[m,n]=size(KPSVs);
maxsv=sortKP(1);
tolstart=1e-8;
maxKP=[];
while isempty(maxKP)
maxKP=find(sortKP/maxsv<tolstart,1);
tolstart=tolstart*10;
end
for j=1:T
    CoefX{j}=Vc'*X{j}*Vr;
    CoefB{j}=(Uc'*B{j}*Ur);
end
[optKP,minerr,fminoutput,fvals]=calcerror(maxKP,CoefX,CoefB, KPSVs,sortKP, sortKPind,m,n,T);
optKP=floor(optKP);
if nargout>2
    varargout{1}=fminoutput.iterations;
end
if nargout>3
    varargout{2}=fminoutput.funcCount;
end
semilogy(fvals(:,1), fvals(:,2), 'Color', cc,'Marker','x','LineStyle','none','MarkerSize',12), hold on
semilogy(optKP, minerr,'Marker',mm, 'Color', cc,'MarkerSize',12)
end

function [optKP,minerr,fminoutput,history]=calcerror(maxKP,CoefX,CoefB, KPSVs,sortKP, sortKPind,m,n,R)
history=[];
errorvec = @(KPSVpinv,j) norm(CoefX{j}-CoefB{j}.*KPSVpinv,'fro')/norm(CoefX{j},'fro');
optionsmin=optimset('OutputFcn', @myoutput,'Display','off','TolX',.01);
[optKP,minerr,exflag,fminoutput]=fminbnd(@error,1, maxKP,optionsmin);

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
