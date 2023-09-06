function [kopt,minfun,timing]=FindKPparam_method(X,B,Ac,Ar,T,pickkp, varargin)
if nargin<7
    varargin=[];
end
tic
switch pickkp
    case 'ncp'
        [kopt,minfun]= FindKPparam_ncp(B, Ac,Ar,T,varargin);
   case 'fminncp'
        [kopt,minfun]= FindKPparamfminbnd_ncp(B, Ac,Ar,T,varargin);
    case 'mre'
        [kopt,minfun]= FindKPparam(X,B, Ac,Ar,T,varargin);
    case 'fminmre'
        [kopt,minfun]=FindKPparamfminbnd(X,B, Ac,Ar,T,varargin);
    case 'gcv'
        [kopt,minfun]= FindKPparam_gcv(B,Ac,Ar,T,varargin);
    case 'fmingcv'
        [kopt,minfun]= FindKPparamfminbnd_gcv(B,Ac,Ar,T,varargin);
end
timing=toc;
