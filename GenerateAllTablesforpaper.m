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
%% need to generate the data for the tables
% We need cases m=256, m=512, bl=2 and bl=3;
nl=[1,2,3];  
snrvals=[10 25 40];       % equivalent SNR
KPmethods={'mre','fminmre','gcv','fmingcv','ncp','fminncp'};% For the methods
noiseoptions={'gaussian','poisson','salt & pepper'}; 
pickkp=KPmethods([2,4]);rangenl=[1,2,3];
tablect=0;
tabsym{2}='assym'; tabsym{3}='sym';
Ttrain=20; %Pick the size of the training data (upto 20)
T=40;%Ttrain=floor(T/2);
for bl=[3,2]
    switch bl
        case 3
            mchoice=[256,512];
        case 2
            mchoice=512;
    end
    for m=mchoice
        n=m;
        tablect=tablect+1;
        tablename=strcat('Table',num2str(tablect));
        %%
        for nt=1:3
            rng(1)
            noisetype=noiseoptions(nt); % Pick the type of noise
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
                for k=1:kp % do a minimization dependent on the choice of KP method
                    [kopt(nn,k),minfun(nn,k),method_timing(nn,k)]=FindKPparam_method(X,B{nn},Ac,Ar,Ttrain,cell2mat(pickkp(k)),colors(k,:),markers{k});
                    for j=1:T % Calculate the images using the estimate for k from fminbnd
                        Xtrunc{nn}{j}{k}=TruncatedImage(Ac,Ar,B{nn}{j},kopt(nn,k));
                        relerr(j,k,nn)=relative_error(X{j},Xtrunc{nn}{j}{k});% error in solution  k is the method nn is the noise level
                    end
                    Results_Errs_train(:,ct)=relerr(1:Ttrain,k,nn);
                    Results_Errs_test(:,ct)=relerr(Ttrain+1:T,k,nn);
                    Table_names(2)=strcat(Table_names(2), string(strcat(' k_',pickkp{k})));
                    Table_names(3)=strcat(Table_names(3), string(strcat(' t_',pickkp{k})));
                    Table_names(4)=strcat(Table_names(4), string(strcat(' E_',pickkp{k})));
                    ct=ct+1;
                end
            end
            % We need to group the test and train results and we have to allow different lengths
            Results_Errs=Generate_data_to_boxplot({Results_Errs_train, Results_Errs_test});% grouped relative errors
            meanTesterror=mean(relerr(Ttrain+1:T,:,:));%index 2 is the method index 3  is the noise level so both methods and all noise  TRAIN
            meanTesterror=permute(meanTesterror, [3,2,1]);% Same but we permute to the order row is noise, column is method, third is error
            %meanTrainerror=mean(relerr(1:Ttrain,:,:));%index 2 is the method index 3  is the noise level so both methods and all noise TEST
            %meanTrainerror=permute(meanTrainerror, [3,2,1]);% Same but we permute to the order row is noise, column is method, third is error
            SummaryTestResults=table(snrvals(rangenl)', kopt(rangenl,:), method_timing(rangenl,:),meanTesterror(rangenl,:),'VariableNames',Table_names);
            SummaryTestResults.Properties.Description='The optimal kopt,  cost to find kopt for each noise level with the obtained testing error';
            %filetosave=cell2mat(strcat('SummaryTestResults',int2str(m),noisetype,int2str(bl)))
            %save(filetosave,'SummaryTestResults','Results_Errs_test','Results_Errs_train')
            SummaryTestResultsall{nt}=SummaryTestResults;
            Alldata{nt}=SummaryTestResultsall{nt}.Variables;
        end
        sizetable=size(SummaryTestResultsall);
        Alldataarray=zeros(3*sizetable(1), sizetable(2));
        Alldataarray=[Alldata{1};Alldata{2}; Alldata{3}];
       % tablename=strcat(tabsym{bl},num2str(m))
        maketableforpaper(Alldataarray,strcat(tablename,'.tex'),tablename,tablename,'%0.2g');
    end
end
