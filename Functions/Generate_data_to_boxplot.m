function padded_res=Generate_data_to_boxplot(x)
[Tsizes, Testruns]=cellfun(@size,x);
maxNumEl=max(Tsizes); 
for tt=1:Testruns(1)
padded_res(:,2*tt-1) = {padarray(x{1}(:,tt),[maxNumEl-numel(x{1}(:,tt)),0],NaN,'post')};
padded_res(:,2*tt) = {padarray(x{2}(:,tt),[maxNumEl-numel(x{2}(:,tt)),0],NaN,'post')};
end
padded_res= cell2mat(padded_res); 
