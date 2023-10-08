function ct=Figure7(X,ct)
%% 
% Plot Figure 7 for the paper A selection of images 
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
x0=200;y0=200; width=800;height=380;
figure,set(gcf,'position',[x0,y0,width,height]);
t=tiledlayout(2,4,TileSpacing = 'none')%,'Padding = 'compact');
for j=5:5:40
    nexttile,imshow( (X{j}),[])
end
fignameabc=strcat('Figure',num2str(ct))
exportgraphics(t,strcat(fignameabc,'.jpg'));
ct=ct+1;
end