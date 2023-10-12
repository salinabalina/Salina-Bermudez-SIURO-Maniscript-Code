function [Btest,ct]=Figure3and4(Btrue,noiseoptions,ct,labelim)
%%
% Plot Figures 3 and 4 for the paper
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
for nl=[1,3]
    for nt=1:3
        [Btest{nt}{nl}] = AddNoise(Btrue,cell2mat(noiseoptions(nt)),nl);
    end
end
%% Now we want to plot figure 3 SNR 10
for nl=1
    figname=strcat('Figure',num2str(ct));
    for nt=1:3
        fignameabc=strcat(figname,labelim(nt))
        figure
        imshow( (Btest{nt}{nl}))
        exportgraphics(gca,strcat(fignameabc,'.jpg'));
    end
end
%% Now we want to plot figure 4 SNR 40
ct=ct+1;
for nl=3
    figname=strcat('Figure',num2str(ct));
    for nt=1:3
        fignameabc=strcat(figname,labelim(nt))
        figure
        imshow( (Btest{nt}{nl}))
        exportgraphics(gca,strcat(fignameabc,'.jpg'));
    end
end
ct=ct+1;
end