% Basic script :
% Illustrate all images in the paper  
% Provides for tables  1 to 3 in the paper
%
% % Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
clearvars, close all
startuptosetfoldernames %Make sure that images are in subfolder /Images and functions in /Functions
% Parameters used in setting up images  and finding optimal indices
noiseoptions={'gaussian','poisson','salt & pepper'}; % Noise types for the images
snrvals=[10 25 40];  % SNR used when a noise level is specified
KPmethods={'mre','fminmre','gcv','fmingcv'};% The methods that can be used 
% Parameters used for plotting and saving images
labelim=['a','b','c','d','e','f'];
colors=hsv(10);
markers = {'+', 'p', '<', '>', '*','d'};
% Some images that are illustrated use fixed values for kopt
kopt      = [6222 6338 ;6156 6273 ;6153 6434 ] ;    % optimal k copied from report for SNR 40 for Error and GCV
kopt_as= [3397 3507; 3377 3509;3389 3545]; % optimal k copied from report for SNR 40 for Error and GCV, assym
kopterror=[0 0 6208;0 0 6189; 0 0 6189]; % used for Figures 5 Picard plots and for calculating the errors in the captions of Figure 6
%% Set up the T images of size 512 by 512
m=512;n=512;T=40;
[X,m,n]=nameofimages(m,n,T);
%% Figures 1 to 7 all images use 512 by 512  
rng(1); % initlialized with fixed seed - 
figcnter=1; %counts through the images and is updated by each Figure function
jindex=[37,1]% 37 for peppers in test set and 1 for house in training set 
figcnter=Figure1(m,n,figcnter,labelim);
[Xtest,Btrue,Ac,Ar,figcnter]=Figure2(X{jindex(1)},m,n,figcnter,labelim);  
[Btest,figcnter]=Figure3and4(Btrue,noiseoptions,figcnter,labelim);
[re,figcnter]=Figure5and6(Xtest,Btest,Ac,Ar,kopterror,figcnter,labelim); %the relative error (re) for Figure 6 caption
figcnter=Figure7(X,figcnter);
%% Figure 8 Size 128, Gaussian and SNR 40 symmetric blur
rng(1);bl=1;nl=3;
figcnter=Figure8(128,128,bl,{'gaussian'},nl,KPmethods,T,figcnter);
%% Figures 9 to 13, Size 512  symmetric blur all noise levels and types
rng(1);nl=[1,2,3];
[errorresfig11,errorresfig12,errorresfig13,figcnter]=Figure9to13(X,m,n,bl,T,noiseoptions,nl,KPmethods,snrvals,jindex,colors,markers,figcnter,labelim);
%% Figure 14, Size 512  asymmetric blur all noise types, snr=40 nl=3
rng(1);bl=2;nl=3;
[errorresfig14,figcnter]=Figure14(X{jindex(1)},m,n,bl,noiseoptions,nl,kopt_as,figcnter,labelim);  %X{37} for peppers
%% Generate results for tables
% Table 1: symmetric blur. All noise types and  levels. Size 256 by 256.
nl=1:3;bl=1;T=40;rng(1)
Results1=GenerateTable(256,256,bl,T,noiseoptions,nl,KPmethods([2,4]),snrvals,'table1');
% Table 2: symmetric blur. All noise types and  levels. Size 512 by 512.
nl=1:3;bl=1;T=40;rng(1)
Results2=GenerateTable(512,512,bl,T,noiseoptions,nl,KPmethods([2,4]),snrvals,'table2');
% Table 3: asymmetric blur. All noise types and  levels. Size 512 by 512.
nl=1:3;bl=2;T=40;rng(1)
Results3=GenerateTable(512,512,bl,T,noiseoptions,nl,KPmethods([2,4]),snrvals,'table3');
