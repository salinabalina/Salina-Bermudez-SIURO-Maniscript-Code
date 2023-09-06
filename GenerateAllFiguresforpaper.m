% Set up to examine one image with symmetric blur
% record keeping 
% Figure 1 for blurred and noisy images with nl=3 for SNR=40
% Figure 2 for same images reconstructed with truncation guess
clearvars, close all
fprintf('Starting up learning project...\n')
directory = pwd;
if isempty(strfind(directory,'renaut'))
    image_directory = '/Users/rosie/Documents/Current/texfiles/ResearchStudents/summerREU/RESEARCHSPRING2023Final/new images';
    functions_directory = '/Users/rosie/Documents/Current/texfiles/ResearchStudents/summerREU/RESEARCHSPRING2023Final/Functions';
else
   image_directory = '/Users/renaut/Documents/Current/texfiles/ResearchStudents/summerREU/RESEARCHSPRING2023Final/new images';
   functions_directory = '/Users/renaut/Documents/Current/texfiles/ResearchStudents/summerREU/RESEARCHSPRING2023Final/Functions';
end
fprintf('  Current directory:    %s \n', directory)
fprintf('  Setting path to images: %s \n', image_directory)
addpath(genpath(image_directory))
fprintf('  Setting path to functions: %s \n', functions_directory)
addpath(genpath(functions_directory))
fprintf('done.\n\n')
clearvars directory functions_directory image_directory 
%% Turn off the toeplitz warning
warning('off','MATLAB:toeplitz:DiagonalConflict')
warning('off','MATLAB:Axes:NegativeDataInLogAxis')
x0=200;y0=200; width=800;height=400;
%% establish baseline markers and colors
markers = {'+', 'p', '<', '>', '*','d'};colors=hsv(10);
%%
m=512;n=512;bl=3;
noiseoptions={'gaussian','poisson','salt & pepper'}; %Noise types
labelim=['a','b','c'];
Ytest = 'peppers512x512.tif';
Xtest= double(im2gray(imread(Ytest))); %figure, imshow(X, [])
[mX,nX]=size(Xtest);
if mX>nX, X=transpose(Xtest); [mX,nX]=size(Xtest);end
if mX>m
    dm=floor((mX-m)/2)+1;
    X=X(dm:dm+m-1,:);
end
if nX>n
    dn=floor((nX-n)/2)+1;
    Xtest=Xtest(:, dn:dn+n-1);
end
[mX,nX]=size(Xtest);
%%
% Generate the true blurrred image and the operator
% Generate  the assymetric image needed later
% Need the plots of the psf for the paper
ct=2; 
[Ac,Ar] = BlurOperator(m,n,2);
[BtrueAsym,Xtest] = GenerateImage(Ac,Ar, Xtest);
colorbar off; 
figname=strcat('Figure',num2str(ct));fignameabc=strcat(figname,labelim(2))
print(fignameabc,'-depsc');print(fignameabc,'-djpeg')
% Now generate the symmetric image for the later plots 
[Ac,Ar] = BlurOperator(m,n,bl);
[Btruetest,Xtest] = GenerateImage(Ac,Ar, Xtest);
colorbar off; 
figname=strcat('Figure',num2str(ct));fignameabc=strcat(figname,labelim(1))
print(fignameabc,'-depsc');print(fignameabc,'-djpeg')
ct=1; % Figure 1 the true image
figname=strcat('Figure',num2str(ct))
imshow(Xtest)
print(figname,'-depsc')
print(figname,'-djpeg')
ct=2;
%%
% Now generate the information on the images for the other plots
[Uc,Sc,Vc]=svd(Ac);
[Ur,Sr,Vr]=svd(Ar);
Sc=diag(Sc); %extract into diagonal matrix
Sr=diag(Sr); %extract into diagonal matrix
KPSVs=Sc*Sr'; %KP singular values page 50 HNO book
[m,n]=size(KPSVs);
[sortKP, sortKPind]=sort(KPSVs(:),'descend');% index into sorted values of the KPs
NN=length(sortKP);
s=sortKP;
incrementind=100;
indtoplot=1:incrementind:NN; %can try with incrementind=1 but probably too dense
ssam=s(indtoplot);
k=[1000,4000,6500]; %SNR 10 25 40
kopt=[6149 6338 ;6284 6277 ;6143 6355 ] %optimal k copied from report for SNR 40 for Error and GCV
kopt=[6222 6338 ;6188 6277 ;6280 6355 ] %optimal k copied from report for SNR 40 for Error and GCV

%% Generate the images in the order of the report from Figure 3
ct=3 % We need the true image with symmetric (a) and assymetric blur (b)
figname=strcat('Figure',num2str(ct));
fignameabc=strcat(figname,labelim(1))
imshow(Btruetest)
print(fignameabc,'-depsc')
print(fignameabc,'-djpeg')
fignameabc=strcat('Figure3',labelim(2))
imshow(BtrueAsym)
print(fignameabc,'-depsc')
print(fignameabc,'-djpeg')
%% Generate the noise contaminated images for SNR 10 and 40
for nl=1:2:3
    for nt=1:3
        [Btest{nt}{nl}] = AddNoise(Btruetest,cell2mat(noiseoptions(nt)),nl);
        Xnaivetest{nt}{nl} = (Ac\ Btest{nt}{nl} )/Ar';
        Image_SNR_Big(nt,nl) = snr(Btruetest,Btest{nt}{nl});
        Xtrunctest{nt}{nl}=TruncatedImage(Ac,Ar,Btest{nt}{nl} ,k(nl));
        Xopterrtrunctest{nt}{nl}=TruncatedImage(Ac,Ar,Btest{nt}{nl} ,kopt(nt,1));
        Xoptgcvtrunctest{nt}{nl}=TruncatedImage(Ac,Ar,Btest{nt}{nl} ,kopt(nt,2));
        CoefB{nt}{nl}=abs(Uc'*Btest{nt}{nl}*Ur);
        sortCoefB{nt}{nl}=CoefB{nt}{nl}(sortKPind);
        beta{nt}{nl}=sortCoefB{nt}{nl};eta{nt}{nl}=beta{nt}{nl}./s;
        betasam{nt}{nl}=sortCoefB{nt}{nl}(indtoplot);
        etasam{nt}{nl}=eta{nt}{nl}(indtoplot);
    end
end
%% Now we want to plot figure 4 SNR 10
for nl=1
    ct=ct+1;
    figname=strcat('Figure',num2str(ct));
    for nt=1:3
        fignameabc=strcat(figname,labelim(nt))
        figure
        imshow( (Btest{nt}{nl}))
        print(fignameabc,'-depsc')
        print(fignameabc,'-djpeg')
    end
end
%% Now we want to plot figure 5 SNR 40
for nl=3
    ct=ct+1;
    figname=strcat('Figure',num2str(ct));
    for nt=1:3
        fignameabc=strcat(figname,labelim(nt))
        figure
        imshow( (Btest{nt}{nl}))
        print(fignameabc,'-depsc')
        print(fignameabc,'-djpeg')
    end
end
%% Now we need figure 6 which in (a) is the naive solution and in (b) is the Picard plot
ct=ct+1;nt=2;nl=3;
figname=strcat('Figure',num2str(ct));
fignameabc=strcat(figname,labelim(1))
imshow( Xnaivetest{nt}{nl} )
print(fignameabc,'-depsc')
print(fignameabc,'-djpeg')
fignameabc=strcat(figname,labelim(2))
figure
semilogy(indtoplot,ssam,'.-',indtoplot,betasam{nt}{nl},'x',indtoplot,etasam{nt}{nl},'o')
xlim([1 10000])
legend('\sigma_i','|u_i^Tb|','|u_i^Tb|/\sigma_i'),xlabel('i')
figprops
print(fignameabc,'-depsc')
print(fignameabc,'-djpeg')
%% Now we want to plot figure 7 SNR 40 truncation with k=6500
for nl=3
    ct=ct+1;
    figname=strcat('Figure',num2str(ct));
    for nt=1:3
        fignameabc=strcat(figname,labelim(nt))
        figure
        imshow( (Xtrunctest{nt}{nl}))
        print(fignameabc,'-depsc')
        print(fignameabc,'-djpeg')
        errorresfig7(nt)=relative_error(Xtest,Xtrunctest{nt}{nl});%norm(Xtrunctest{nt}{nl}-Xtest,'fro')/norm(Xtest,'fro');
    end
end
%% Now we want to plot figure 11 SNR 40 truncation with k from minimal error
ct=11;
for nl=3
    figname=strcat('Figure',num2str(ct));
    for nt=1:3
        fignameabc=strcat(figname,labelim(nt))
        figure
        imshow( (Xopterrtrunctest{nt}{nl}))
        print(fignameabc,'-depsc')
        print(fignameabc,'-djpeg')
        errorresfig11(nt)=relative_error(Xtest,Xopterrtrunctest{nt}{nl});%norm(Xopterrtrunctest{nt}{nl}-Xtest,'fro')/norm(Xtest,'fro');
    end
end
%% Now we want to plot figure 12 SNR 40 truncation with k from minimal gcv
ct=12;
for nl=3
    figname=strcat('Figure',num2str(ct));
    for nt=1:3
        fignameabc=strcat(figname,labelim(nt))
        figure
        imshow( (Xoptgcvtrunctest{nt}{nl}))
        print(fignameabc,'-depsc')
        print(fignameabc,'-djpeg')
        errorresfig12(nt)=relative_error(Xtest,Xoptgcvtrunctest{nt}{nl});%norm(Xoptgcvtrunctest{nt}{nl}-Xtest,'fro')/norm(Xtest,'fro');
    end
end
%% Now we want to plot figure 13 SNR 40 truncation with k from minimal gcv
Ytrain = 'house.tiff';ct=13;
Xtrain= double(im2gray(imread(Ytrain))); %figure, imshow(X, [])
[mX,nX]=size(Xtrain);
if mX>nX, Xtrain=transpose(Xtrain); [mX,nX]=size(Xtrain);end
if mX>m
    dm=floor((mX-m)/2)+1;
    Xtrain=Xtrain(dm:dm+m-1,:);
end
if nX>n
    dn=floor((nX-n)/2)+1;
    Xtrain=Xtrain(:, dn:dn+n-1);
end
[Btruetrain,Xtrain] = GenerateImage(Ac,Ar, Xtrain);
for nl=3
    figname=strcat('Figure',num2str(ct));
    for nt=1:3
        [Btrain{nt}{nl}] = AddNoise(Btruetrain,cell2mat(noiseoptions(nt)),nl);
        Xtrainopterrtrunc{nt}{nl}=TruncatedImage(Ac,Ar,Btrain{nt}{nl} ,kopt(nt,1));
        Xtrainoptgcvtrunc{nt}{nl}=TruncatedImage(Ac,Ar,Btrain{nt}{nl} ,kopt(nt,2));
        fignameabc=strcat(figname,labelim(nt))
        figure
        imshow( (Xtrainoptgcvtrunc{nt}{nl}))
        print(fignameabc,'-depsc')
        print(fignameabc,'-djpeg')
        errorresfig13(nt)=relative_error(Xtrain,Xtrainoptgcvtrunc{nt}{nl});%norm(Xtrainoptgcvtrunc{nt}{nl}-Xtrain,'fro')/norm(Xtrain,'fro');
    end
end
err=[errorresfig7; errorresfig11; errorresfig12;errorresfig13]
%% Now generate Figure 8- requires a full run with size 128, noise Gauss, noiselevel  - so SNR 40, symmetric blur
rng(1), clearvars Y  X B Xtrunc Btrue
%% The arrays that define what we want
KPmethods={'mre','fminmre','gcv','fmingcv','ncp','fminncp'};% For the methods
nl=[1,2,3];             % to pick noise levels 
%%  Run this to get the Figure 8
n=128;m=128;bl=3;noisetype=noiseoptions(1);rangenl=3;pickkp=KPmethods([1,2,3,4]);
Ttrain=20; %Pick the size of the training data (upto 20)
T=40;%Ttrain=floor(T/2);
%% 
% Read in T images into X{j}, j=1:T. 
% First identify the names of the images  from the Matlab repository
nameofimages;
for j=1:T
    X{j}= double(im2gray(imread(Y{j}))); %figure, imshow(X{j}, [])
    [mX(j),nX(j)]=size(X{j});if mX(j)>nX(j), X{j}=transpose(X{j}); [mX(j),nX(j)]=size(X{j});end
end
%% 
% Verify that the images are all no larger than the chosen m and n. They will 
% be reduced in size if too large in GenerateImage
m=min([mX,m]);n=min([nX,n]);
%% 
% Now put the images in the middle of the used image if possible
for j=1:T
    if mX(j)>m, dm(j)=floor((mX(j)-m)/2)+1;X{j}=X{j}(dm(j):dm(j)+m-1,:);end
    if nX(j)>n,   dn(j)=floor((nX(j)-n)/2)+1;  X{j}=X{j}(:, dn(j):dn(j)+n-1);   end
    [mX(j),nX(j)]=size(X{j});
end
m=min([mX,m]);n=min([nX,n]);
%% 
% Calculate the blur operator for image of size m by n and with blur operator  by bl
[Ac,Ar] = BlurOperator(m,n,bl);
%% 
% Generate the blurred versions of the images. 
for j=1:T, [Btrue{j},X{j}] = GenerateImage(Ac,Ar,X{j}); end
%%
% Beginning of the loop over the noise levels with choices for noise level
% Run the code T times to get noisy images (Btrue and B) and calculate the Image_SNR  before estimating the parameters
for nn=rangenl
    for j=1:T %
        [B{nn}{j}] = AddNoise(Btrue{j},cell2mat(noisetype),nl(nn));
        Image_SNR(nn,j) = snr(Btrue{j},B{nn}{j});
    end
end
%%
% Work out the best truncation parameter for the comparison plot with n=128
ct=8;kp=length(pickkp);
for nn=rangenl
    for k=1:kp % do a minimization dependent on the choice of KP method
        %if k>2, yyaxis right, end; % use right axis for the GCV
        [kopt(nn,k),minfun(nn,k),method_timing(nn,k)]=FindKPparam_method(X,B{nn},Ac,Ar,Ttrain,cell2mat(pickkp(k)),colors(k,:),markers{k});
        leg{2*k-1}=pickkp{k};leg{2*k}='';
        for j=1:T % Calculate the images using the estimate for k from fminbnd
            Xtrunc{nn}{j}{k}=TruncatedImage(Ac,Ar,B{nn}{j},kopt(nn,k));
            relerr(j,k,nn)=relative_error(X{j},Xtrunc{nn}{j}{k});% error in solution  k is the method nn is the noise level
        end
        Results_Errs_train(:,k)=relerr(1:Ttrain,k,nn); %not needed to check that it looks ok
        Results_Errs_test(:,k)=relerr(Ttrain+1:T,k,nn);
    end
    figprops,legend(leg,'Location','Best'),axis tight, 
    figname=strcat('Figure',num2str(ct))
    print(figname,'-depsc')
    print(figname,'-djpeg')
end
%% need to generate the box plots large case symmetric blur
m=512; n=m;bl=3;boxkp={'MRE','GCV'};snrvals=[10 25 40];       % equivalent SNR
pickkp=KPmethods([2,4]);rangenl=[1,2,3]; 
%%
for nt=1:3
    rng(1)
    noisetype=noiseoptions(nt); % Pick the type of noise
    if bl==3
        fignameTest=strcat('Figure',num2str(10));
        fignameTrain=strcat('Figure',num2str(9));
    else
        fignameTest=strcat('Figure',num2str(15));
        fignameTrain=strcat('Figure',num2str(14));
    end
    fignameabcTest=strcat(fignameTest,labelim(nt))
    fignameabcTrain=strcat(fignameTrain,labelim(nt))
    % Read in T images into X{j}, j=1:T. First identify the names of the images  
    nameofimages;
    for j=1:T
        X{j}= double(im2gray(imread(Y{j}))); %figure, imshow(X{j}, [])
        [mX(j),nX(j)]=size(X{j});
        if mX(j)>nX(j), X{j}=transpose(X{j}); [mX(j),nX(j)]=size(X{j});end
    end
    m=min([mX,m]);n=min([nX,n]);
    for j=1:T
        if mX(j)>m, dm(j)=floor((mX(j)-m)/2)+1;X{j}=X{j}(dm(j):dm(j)+m-1,:);end
        if nX(j)>n,  dn(j)=floor((nX(j)-n)/2)+1;X{j}=X{j}(:, dn(j):dn(j)+n-1);end
        [mX(j),nX(j)]=size(X{j});
    end
    m=min([mX,m]);n=min([nX,n]);
    [Ac,Ar] = BlurOperator(m,n,bl);
    for j=1:T %
        [Btrue{j},X{j}] = GenerateImage(Ac,Ar,X{j});
    end
    for nn=rangenl
        for j=1:T %
            [B{nn}{j}] = AddNoise(Btrue{j},cell2mat(noisetype),nl(nn));
            Image_SNR(nn,j) = snr(Btrue{j},B{nn}{j});
        end
    end
    % now work out the best truncation parameter
    ct=1;kp=length(pickkp);
    for nn=rangenl
        Table_names(1)="SNR";Table_names(2)="";Table_names(3)="";Table_names(4)="";
        figure,
        for k=1:kp % do a minimization dependent on the choice of KP method
            [kopt(nn,k),minfun(nn,k),method_timing(nn,k)]=FindKPparam_method(X,B{nn},Ac,Ar,Ttrain,cell2mat(pickkp(k)),colors(k,:),markers{k});
            leg{2*k-1}=pickkp{k};leg{2*k}='';
            for j=1:T % Calculate the images using the estimate for k from fminbnd
                Xtrunc{nn}{j}{k}=TruncatedImage(Ac,Ar,B{nn}{j},kopt(nn,k));
                relerr(j,k,nn)=relative_error(X{j},Xtrunc{nn}{j}{k});% error in solution  k is the method nn is the noise level
            end
            Results_Errs_train(:,ct)=relerr(1:Ttrain,k,nn);
            Results_Errs_test(:,ct)=relerr(Ttrain+1:T,k,nn);
              box_labels(ct)=strcat(string(boxkp{k}),num2str(snrvals(nn)));
            Table_names(2)=strcat(Table_names(2), string(strcat(' k_',pickkp{k})));
            Table_names(3)=strcat(Table_names(3), string(strcat(' t_',pickkp{k})));
            Table_names(4)=strcat(Table_names(4), string(strcat(' E_',pickkp{k})));
            ct=ct+1;
        end
    end
    % We need to group the test and train results and we have to allow different lengths
    Results_Errs=Generate_data_to_boxplot({Results_Errs_train, Results_Errs_test});% grouped relative errors
    meanTesterror=mean(relerr(Ttrain+1:T,:,:));%index 2 is the method index 3  is the noise level so both methods and all noise  TRAIN
    meanTrainerror=mean(relerr(1:Ttrain,:,:));%index 2 is the method index 3  is the noise level so both methods and all noise TEST
    meanTrainerror=permute(meanTrainerror, [3,2,1]);% Same but we permute to the order row is noise, column is method, third is error
    meanTesterror=permute(meanTesterror, [3,2,1]);% Same but we permute to the order row is noise, column is method, third is error
    % Master Box and Whisker plot and table of values
    figure,set(gcf,'position',[x0,y0,width,height])
    boxplot(Results_Errs_test,'Labels',box_labels,'Orientation','horizontal'),
    xlims=xlim;figprops;

    print(fignameabcTest,'-depsc')
    print(fignameabcTest,'-djpeg')
    figure,set(gcf,'position',[x0,y0,width,height])
    boxplot(Results_Errs_train,'Labels',box_labels,'Orientation','horizontal'),
    xlim(xlims);figprops;
    print(fignameabcTrain,'-depsc')
    print(fignameabcTrain,'-djpeg')

    SummaryResults=table(snrvals(rangenl)', kopt(rangenl,:), method_timing(rangenl,:),meanTesterror(rangenl,:),'VariableNames',Table_names)
    SummaryResults.Properties.Description='The optimal kopt,  cost to find kopt for each noise level with the obtained testing error';
    filetosave=cell2mat(strcat('SummaryResults',int2str(m),noisetype,int2str(bl)))
    save(filetosave,'SummaryResults','Results_Errs_test','Results_Errs_train','box_labels','fignameabcTest','fignameabcTrain')
end
