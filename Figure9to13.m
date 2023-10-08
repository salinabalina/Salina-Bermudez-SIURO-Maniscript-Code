function [errorresfig11,errorresfig12,errorresfig13,ct]=Figure9to13(X,m,n,bl,T,noiseoptions,rangenl,KPmethods,snrvals,jindex,colors,markers,ct,labelim)
%%
% Plot Figures 9, 10, 11,  12 and 13 for the paper
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
fignameTrain=strcat('Figure',num2str(ct));
ct=ct+1;
fignameTest=strcat('Figure',num2str(ct));
pickkp=KPmethods([2,4]);
Ttrain=floor(T/2);
boxkp={'MRE','GCV'};
x0=200;y0=200; width=800;height=400;
[Ac,Ar] = BlurOperator(m,n,bl);
for j=1:T %
    [Btrue{j},X{j}] = GenerateImage(Ac,Ar,X{j});
end
for nt=1:3
    noisetype=noiseoptions(nt); % Pick the type of noise
    fignameabcTest=strcat(fignameTest,labelim(nt));
    fignameabcTrain=strcat(fignameTrain,labelim(nt));
    fignameabcTestlog=strcat(fignameTest,labelim(nt+3)) ;   %log box plots if wanted
    fignameabcTrainlog=strcat(fignameTrain,labelim(nt+3)) ;%log box plots if wanted
    for nl=rangenl
        for j=1:T %
            [B{nl}{j}] = AddNoise(Btrue{j},cell2mat(noisetype),nl);
        end
    end
    % now work out the best truncation parameter
    colct=1;kp=length(pickkp);
    for nl=rangenl
        Table_names(1)="SNR";Table_names(2)="";Table_names(3)="";Table_names(4)="";
        figure,
        for k=1:kp % do a minimization dependent on the choice of KP method
            [kopt(nl,k),minfun(nl,k),method_timing(nl,k)]=FindKPparam_method(X,B{nl},Ac,Ar,Ttrain,cell2mat(pickkp(k)),colors(k,:),markers{k});
            leg{2*k-1}=pickkp{k};leg{2*k}='';
            for j=1:T % Calculate the images using the estimate for k from fminbnd
                Xtrunc{nl}{j}{k}=TruncatedImage(Ac,Ar,B{nl}{j},kopt(nl,k));
                relerr(j,k,nl)=relative_error(X{j},Xtrunc{nl}{j}{k});% error in solution  k is the method nl is the noise level
                if k==1 && j==jindex(1)
                    Xopterrtrunctest{nt}{nl}= Xtrunc{nl}{j}{k};
                end
                if k==2 && j==jindex(1)
                    Xoptgcvtrunctest{nt}{nl}= Xtrunc{nl}{j}{k};
                end
                if k==2 && j==jindex(2)
                    Xhouse{nt}{nl}=Xtrunc{nl}{j}{k};
                    Xtesthouse=X{j};
                end
            end
            Results_Errs_train(:,colct)=relerr(1:Ttrain,k,nl);
            Results_Errs_test(:,colct)=relerr(Ttrain+1:T,k,nl);
            box_labels(colct)=strcat(string(boxkp{k}),num2str(snrvals(nl)));
            Table_names(2)=strcat(Table_names(2), string(strcat(' k_',pickkp{k})));
            Table_names(3)=strcat(Table_names(3), string(strcat(' t_',pickkp{k})));
            Table_names(4)=strcat(Table_names(4), string(strcat(' E_',pickkp{k})));
            colct=colct+1;
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
    xlims=xlim;
    set(gca,'TickLength', [0.0100 0.0100])
    set(gca,'LineWidth',2);  
    set(findobj('Type','line'),'MarkerSize',12)  
    set(findobj('Type','line'),'LineWidth',2)  
    set(findobj('Type','text'),'FontWeight','bold','FontSize',12)
    set(findobj('Type','axes'),'FontWeight','bold','FontSize',12)
    exportgraphics(gca,strcat(fignameabcTest,'.jpg'));

    figure,set(gcf,'position',[x0,y0,width,height])
    boxplot(Results_Errs_train,'Labels',box_labels,'Orientation','horizontal'),
    xlim(xlims);
    set(gca,'TickLength', [0.0100 0.0100])
    set(gca,'LineWidth',2);  
    set(findobj('Type','line'),'MarkerSize',12)  
    set(findobj('Type','line'),'LineWidth',2)  
    set(findobj('Type','text'),'FontWeight','bold','FontSize',12)
    set(findobj('Type','axes'),'FontWeight','bold','FontSize',12)
    exportgraphics(gca,strcat(fignameabcTrain,'.jpg'));

    % log10
    figure,set(gcf,'position',[x0,y0,width,height])
    boxplot(log10(Results_Errs_test),'Labels',box_labels,'Orientation','horizontal'),
    xlims=xlim;
    set(gca,'TickLength', [0.0100 0.0100])
    set(gca,'LineWidth',2);   
    set(findobj('Type','line'),'MarkerSize',12)  
    set(findobj('Type','line'),'LineWidth',2)  
    set(findobj('Type','text'),'FontWeight','bold','FontSize',12)
    set(findobj('Type','axes'),'FontWeight','bold','FontSize',12)
    exportgraphics(gca,strcat(fignameabcTestlog,'.jpg'));

    figure,set(gcf,'position',[x0,y0,width,height])
    boxplot(log10(Results_Errs_train),'Labels',box_labels,'Orientation','horizontal'),
    xlim(xlims);
    set(gca,'TickLength', [0.0100 0.0100])
    set(gca,'LineWidth',2);  
    set(findobj('Type','line'),'MarkerSize',12)  
    set(findobj('Type','line'),'LineWidth',2)  
    set(findobj('Type','text'),'FontWeight','bold','FontSize',12)
    set(findobj('Type','axes'),'FontWeight','bold','FontSize',12)
    exportgraphics(gca,strcat(fignameabcTrainlog,'.jpg'));
    % log10

    SummaryResults=table(snrvals(rangenl)', kopt(rangenl,:), method_timing(rangenl,:),meanTesterror(rangenl,:),'VariableNames',Table_names)
    SummaryResults.Properties.Description='The optimal kopt,  cost to find kopt for each noise level with the obtained testing error';
    filetosave=cell2mat(strcat('SummaryResults',int2str(m),noisetype,int2str(bl)))
    %save(filetosave,'SummaryResults','Results_Errs_test','Results_Errs_train','box_labels','fignameabcTest','fignameabcTrain')
end
%% Now we want to plot figure 11 SNR 40 truncation with k from minimal error
ct=ct+1;
j=jindex(1); Xtest=X{j};%for peppers
for nl=3
    figname=strcat('Figure',num2str(ct));
    for nt=1:3
        fignameabc=strcat(figname,labelim(nt))
        figure
        imshow( (Xopterrtrunctest{nt}{nl}))
        exportgraphics(gca,strcat(fignameabc,'.jpg'));
        errorresfig11(nt)=relative_error(Xtest,Xopterrtrunctest{nt}{nl});%norm(Xopterrtrunctest{nt}{nl}-Xtest,'fro')/norm(Xtest,'fro');
    end
end
%% Now we want to plot figure 12 SNR 40 truncation with k from minimal gcv
ct=ct+1;
for nl=3
    figname=strcat('Figure',num2str(ct));
    for nt=1:3
        fignameabc=strcat(figname,labelim(nt))
        figure
        imshow( (Xoptgcvtrunctest{nt}{nl}))
        exportgraphics(gca,strcat(fignameabc,'.jpg'));
        errorresfig12(nt)=relative_error(Xtest,Xoptgcvtrunctest{nt}{nl});%norm(Xoptgcvtrunctest{nt}{nl}-Xtest,'fro')/norm(Xtest,'fro');
    end
end
ct=ct+1;
for nl=3
    figname=strcat('Figure',num2str(ct));
    for nt=1:3
        fignameabc=strcat(figname,labelim(nt))
        figure
        imshow( (Xhouse{nt}{nl}))
        exportgraphics(gca,strcat(fignameabc,'.jpg'));
        errorresfig13(nt)=relative_error(Xtesthouse,Xhouse{nt}{nl});%norm(Xoptgcvtrunctest{nt}{nl}-Xtest,'fro')/norm(Xtest,'fro');
    end
end
ct=ct+1;
end
