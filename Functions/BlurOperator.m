function [Ac,Ar,varargout] = BlurOperator(varargin)
%%
% Generate the matrices for blurring an image used in the paper
% Inputs
%
% varargin{1} : m default is 64
% varargin{2} : n default is 64
% varargin{3} : bl: default is 1 the blurring operator to choose 1 or 2
% varargin{4} : 0 or (1) showimages -default is to look at the PSF
%
% Outputs
%
% Ac:  A= Ar cross Ac
% Ar:  A= Ar cross Ac
% varargout{1} : PSF for plotting
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
if nargin<1 m=64;  else m=varargin{1};end
if nargin<2 n=64;   else n=varargin{2};end
if nargin<3 bl=1;    else bl=varargin{3};end
if nargin<4 showimages=1; else showimages=varargin{4};end
if isempty(m) m=64;end
if isempty(n)  n=64;end
if isempty(bl) bl=1; end
% The blurring operators
dx=1/(m-1);
c=dx*(0:m-1);
dx=1/(n-1);
r=dx*(0:n-1);
sigmac=.01;
switch bl
    case 2 % asymmetric
        sigmar=.02; % for the results in the paper asymmetric blur
    case 1 % symmetric
        sigmar=sigmac;% for the results in the paper symmetric blur
    otherwise
        error('bl is 1 or 2 only ')
end
c=exp(-(c.^2)/(2*sigmac^2));
c(c<1e-4)=0;
r=exp(-(r.^2)/(2*sigmar^2));
r(r<1e-4)=0;
c=c/(2*sum(c)-c(1));
r=r/(2*sum(r)-r(1));
Ac = toeplitz(c(1:m));
Ar=toeplitz(r(1:n));
X=zeros(m,n);
X(floor(m/2),floor(n/2))=1;
PSF=Ac*X*Ar';
if nargout>2
    varargout{1}=PSF;
end
if showimages
    figure, imagesc(PSF);axis image,axis off,colorbar
end
end
