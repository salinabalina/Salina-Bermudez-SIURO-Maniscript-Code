function [Ac,Ar] = BlurOperator(varargin)
% determine a blurring operator to use for all images
% varargin{1} m
% varargin{2} n
% varargin{3} bl: the blurring operator to choose
if nargin<1 m=64;   else m=varargin{1};end
if nargin<2 n=64;   else n=varargin{2};end
if nargin<3 bl=1;   else bl=varargin{3};end
if nargin<4 showimages=1; else showimages=varargin{4};end
if isempty(m) m=64;end
if isempty(n) n=64;end
if isempty(bl) bl=1; end
% The blurring operators
c = zeros(max(n,m),1);
r = zeros(max(n,m),1);
switch bl
    case 1 %use the original blur operators
        c(1:5) = [5:-1:1]/15;
        r(1:10) = [5:-.5:.5]/15;
    case 4 %use symmetric
        c(1:5) = [5:-1:1]/15;
        r=c;
    case 2 % add a new blur operator
%         p=floor(5*(m/64));
%         c(1:p) = [p:-1:1];
%         r(1:2*p) = [p:-.5:.5];
            sigmac=.01;sigmar=.02;
            dx=1/(m-1);
            c=dx*(0:m-1);
            r=c;
    case 3 % add a new blur operator symmetric
%         p=floor(10*(m/64));
%         c(1:p) = [p:-1:1];
%         r=c;
            sigmac=.01;sigmar=sigmac;
            dx=1/(m-1);
            c=dx*(0:m-1);
            r=c;
    otherwise
        error('bl is 1 or 2 or 3 or 4')
end
c=exp(-(c.^2)/(2*sigmac^2));
c(c<1e-4)=0;
r=exp(-(r.^2)/(2*sigmar^2));
r(r<1e-4)=0;
c=c/(2*sum(c)-c(1));
r=r/(2*sum(r)-r(1));
Ac = toeplitz(c(1:m)); %square size m by m
%Ar = toeplitz(c(1:n),r(1:n));% size n by n
Ar=toeplitz(r(1:n));
X=zeros(m,n);
X(floor(m/2),floor(n/2))=1;
PSF=Ac*X*Ar';
if showimages
figure, imagesc(PSF);axis image,axis off,colorbar
end
end