function [optKP, minerr,varargout] = FindKPparamfminbnd_gcv(B, Ac,Ar,T,varargin)
%%
% For a set of T  noisy images  B find the optimal
% truncation parameter for the given blur operator A= Ar cross Ac  to
% minimize the error using fminbnd
%
% Inputs
%
% B : Blurred and Noisy Images Cell Array images 1:T
% Ac:  A= Ar cross Ac
% Ar:  A= Ar cross Ac
% T : Number of Images
% varargin{1}: color for plotting the curve - default is blue
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
cc='b';mm='h';
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

[optKP,minerr,fminoutput,fvals]=calcgcv(maxKP,CoefB, KPSVs,sortKP, sortKPind,m,n);
optKP=floor(optKP);
if nargout>2
    varargout{1}=fminoutput.iterations;
end
if nargout>3
    varargout{2}=fminoutput.funcCount;
end
semilogy(fvals(:,1), fvals(:,2), 'Color', cc,'Marker','x','LineStyle','none','MarkerSize',12);hold on
semilogy(optKP, minerr,'Marker',mm, 'Color', cc,'MarkerSize',12); 
end

function [optKP,mingcv,fminoutput,history]=calcgcv(maxKP,CoefB, KPSVs,sortKP, sortKPind,m,n)
history=[];
%optionsmin=optimset('OutputFcn', @myoutput,'Display','off','TolX',.01);
optionsmin=optimset('OutputFcn', @myoutput,'Display','off','TolX',.01);
%optionsmin=optimset('OutputFcn', @myoutput,'Display','off','PlotFcns',@optimplotfval,'TolX',.01);
[optKP,mingcv,exflag,fminoutput]=fminbnd(@gcvfun,1, maxKP,optionsmin);

    
    function stop = myoutput(x,optimvalues,state)
        stop = false;
        if isequal(state,'iter')
             %history = [history; [x,optimvalues.fval,optimvalues.iterations,optimvalues.funcCount]];
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
