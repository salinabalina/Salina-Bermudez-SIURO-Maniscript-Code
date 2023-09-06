function [B,X] = GenerateImage(Ac,Ar, varargin)
% GenerateImage given X and operators KP form
%   Note all images are scaled to max of Btrue since Btrue scaled to max 1
% varargin{5} X : array of size m by n which is the image to blur, or
%                this references an image file and not an array
m=size(Ac,1);
n=size(Ar,1);
if nargin >= 3 % read in an image
    if ischar(varargin{1})
        X = imread(varargin{1});
        X = double(im2gray(X));
        X = double(im2gray(X)+1)/max(X(:));
    else
        X = varargin{1};
    end
    [mX,nX]=size(X);
    if m<mX % try to take from center of image
        dm=floor((mX-m)/2);
        X=X(dm+1:dm+m,:);
    end
    if n<nX 
         dn=floor((nX-n)/2);
        X=X(:,dn+1:n+dn);
    end
end
if nargin<3 ||  isempty(X)%standard image of circles and squares
    X = zeros(m,n);
    I = round(m/5):round(3*m/5);
    J = round(n/5):round(3*n/5);
    X(I,J) = 0.5;
    for i=1:m
        for j=1:n
            if (i-round(3*m/5))^2+(j-round(5*n/8))^2 < round(max(m,n)/5)^2
                X(i,j) = 1;
            end
        end
    end
end
X=X/max(X(:));
B=Ac*X*Ar' ;
X=X/max(B(:));
B=B/max(B(:));
end