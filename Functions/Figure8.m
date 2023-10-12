function ct=Figure8(m,n,bl,noisetype,nl,KPmethods,T,ct)
% Plot Figure 8 for the paper
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
[X,m,n]=nameofimages(m,n,T);% Set up the images for training and testing 
[Ac,Ar] = BlurOperator(m,n,bl,0); % Calculate the blur operator for image of size m by n and with blur operator  by bl
for j=1:T
    [Btrue{j},X{j}] = GenerateImage(Ac,Ar,X{j});  % Generate the blurred versions of the images.
    [B{nl}{j}] = AddNoise(Btrue{j},cell2mat(noisetype),nl); %% Generate the noisy versions of the images.
end
% Now learn the truncation
Ttrain=floor(T/2); %Pick the size of the training data (upto 20)
fignameabc=strcat('Figure',num2str(ct))
figure
colors2= [1, 0,0; 1, 0,0; 0,0,1;0,0,1];
markers = {'+', 'p', '<', '>', '*','d'};
for k=1:4 % do a minimization dependent on the choice of KP method
    [kopt(nl,k),minfun(nl,k),method_timing(nl,k)]=FindKPparam_method(X,B{nl},Ac,Ar,Ttrain,cell2mat(KPmethods(k)),colors2(k,:),markers{k});
    leg{2*k-1}=cell2mat(KPmethods(k));leg{2*k}='';
    for j=1:T % Calculate the images using the estimate for k from fminbnd
        Xtrunc{nl}{j}{k}=TruncatedImage(Ac,Ar,B{nl}{j},kopt(nl,k));
        relerr(j,k,nl)=relative_error(X{j},Xtrunc{nl}{j}{k});% error in solution  k is the method nl is the noise level
    end
end
xlabel('index k');
ylabel('\Phi(k)');
axis tight,
legend(leg,'Location','Best','FontSize',16), 
set(gca,'TickLength', [0.0100 0.0100])
set(gca,'LineWidth',2); % This makes the width of the axis box wider
set(findobj('Type','line'),'MarkerSize',12) % This makes the width of the axis box wider
set(findobj('Type','line'),'LineWidth',2) %change the line width
set(findobj('Type','text'),'FontWeight','bold','FontSize',12)
set(findobj('Type','axes'),'FontWeight','bold','FontSize',12)
exportgraphics(gca,strcat(fignameabc,'.jpg'));
ct=ct+1;
end