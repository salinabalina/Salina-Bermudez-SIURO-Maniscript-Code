function [kopt,minfun,timing,varargout]=FindKPparam_method(X,B,Ac,Ar,T,pickkp, varargin)
%%
% For a set of T true and their noisy images  find the optimal
% truncation parameter for the given blur operator A= Ar cross Ac  to
% minimize the chosen function.
%
% Inputs
%
% X : True Images Cell Array images 1:T
% B : Blurred and Noisy Images Cell Array images 1:T
% Ac:  A= Ar cross Ac 
% Ar:  A= Ar cross Ac
% T : Number of Images 
% pickkp : determine which method to use {'mre', 'fminmre',gcv',fmingcv'}
% varargin{1}: color for plotting the curve - default is picked in the method
% varargin{2}: symbol for plotting optimal index - default is picked in the method
%
% Outputs
%
% optKP : the optimal index for the set of images
% minfun:  the obtained optimal value
% timing : tic-toc timing of the method
% varargout{1}:  iterations in fminbnd
% varargout{2}: function evaluations
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
if nargin<7
    varargin=[];
end
k_it=0;totalfevals=0;
tic
switch pickkp
    case 'mre'
        [kopt,minfun]= FindKPparam(X,B, Ac,Ar,T,varargin);
    case 'fminmre'
        [kopt,minfun,k_it,totalfevals]=FindKPparamfminbnd(X,B, Ac,Ar,T,varargin);
    case 'gcv'
        [kopt,minfun]= FindKPparam_gcv(B,Ac,Ar,T,varargin);
    case 'fmingcv'
        [kopt,minfun,k_it,totalfevals]= FindKPparamfminbnd_gcv(B,Ac,Ar,T,varargin);
end
timing=toc;
if nargout>3
    varargout{1}=k_it;
end
if nargout>4
    varargout{2}=totalfevals;
end
