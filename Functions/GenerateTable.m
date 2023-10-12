function SummaryTestResultsall=GenerateTable(m,n,bl,T,noiseoptions,rangenl,pickkp,snrvals,tablename)
%%
% For a set of T  find the optimal index for truncation 
%
% Inputs
%
% m: desired image size used by rows 
% n:  desired image size used by columns
% bl: blurring 1 or 2 for symmetric or asymmetric
% T : Number of Images in total
% noiseoptions : select from {'gaussian','poisson','salt & pepper'};  can be all three
% rangenl : noise levels for the table, supported for 1:3
% pickkp : methods {'mre','fminmre','gcv','fmingcv'};  use fminmre and fmingcv
% snrvals : chose images with given SNR - [10, 25, 40]
% tablename : string to be generated for the table as tablename.tex
%
% Outputs : Tables of results for each noise type are in SummaryTestResultsall
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
kp=length(pickkp);
Ttrain=floor(T/2);
[X,m,n]=nameofimages(m,n,T);
[Ac,Ar] = BlurOperator(m,n,bl);
for j=1:T %
    [Btrue{j},X{j}] = GenerateImage(Ac,Ar,X{j});
end
for nt=1:3
    noisetype=noiseoptions(nt); % Pick the type of noise
    for nl=rangenl
        for j=1:T %
            [B{nl}{j}] = AddNoise(Btrue{j},cell2mat(noisetype),nl);
        end
    end
    % now work out the best truncation parameter
    colct=1;
    for nl=rangenl
        Table_names(1)="SNR";Table_names(2)="";Table_names(3)="";Table_names(4)="";
        Table_names(5)="";Table_names(6)="";
        for k=1:kp % do a minimization dependent on the choice of KP method
            [kopt(nl,k),minfun(nl,k),method_timing(nl,k),method_k(nl,k),method_eval(nl,k)]=FindKPparam_method(X,B{nl},Ac,Ar,Ttrain,cell2mat(pickkp(k)));
            for j=1:T % Calculate the images using the estimate for k from fminbnd
                Xtrunc{nl}{j}{k}=TruncatedImage(Ac,Ar,B{nl}{j},kopt(nl,k));
                relerr(j,k,nl)=relative_error(X{j},Xtrunc{nl}{j}{k});% error in solution  k is the method nl is the noise level
            end
            Results_Errs_train(:,colct)=relerr(1:Ttrain,k,nl);
            Results_Errs_test(:,colct)=relerr(Ttrain+1:T,k,nl);
            Table_names(2)=strcat(Table_names(2), string(strcat(' k_',pickkp{k})));
            Table_names(3)=strcat(Table_names(3), string(strcat(' t_',pickkp{k})));
            Table_names(4)=strcat(Table_names(4), string(strcat(' it_',pickkp{k})));
            Table_names(5)=strcat(Table_names(5), string(strcat(' fev_',pickkp{k})));
            Table_names(6)=strcat(Table_names(6), string(strcat(' E_',pickkp{k})));
            colct=colct+1;
        end
    end
    % We need to group the test and train results and we have to allow different lengths
    meanTesterror=mean(relerr(Ttrain+1:T,:,:));%index 2 is the method index 3  is the noise level so both methods and all noise  TRAIN
    meanTrainerror=mean(relerr(1:Ttrain,:,:));%index 2 is the method index 3  is the noise level so both methods and all noise TEST
    meanTrainerror=permute(meanTrainerror, [3,2,1]);% Same but we permute to the order row is noise, column is method, third is error
    meanTesterror=permute(meanTesterror, [3,2,1]);% Same but we permute to the order row is noise, column is method, third is error

    SummaryTestResults=table(snrvals(rangenl)', kopt(rangenl,:), method_timing(rangenl,:),method_k(rangenl,:),method_eval(rangenl,:),meanTesterror(rangenl,:),'VariableNames',Table_names);
    SummaryTestResults.Properties.Description='The optimal kopt,  cost to find kopt for each noise level with the obtained testing error';
    SummaryTestResultsall{nt}=SummaryTestResults;
    Alldata{nt}=SummaryTestResultsall{nt}.Variables;

end
sizetable=size(SummaryTestResultsall);
Alldataarray=zeros(3*sizetable(1), sizetable(2));
Alldataarray=[Alldata{1};Alldata{2}; Alldata{3}];
maketableforpaper(Alldataarray,strcat(tablename,'.tex'),tablename,tablename,'%0.3g');
end
