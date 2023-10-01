function padded_res=Generate_data_to_boxplot(x)
% We assume here that x is a cell which contains sets of training results
% and testing results. If Test and Train are not the same size we have to
% pad the arrays to be of the same length.
% We will also assume in the padded data that the results are in pairs
% (train, test) so we extract and reorder
[Tsizes, Testruns]=cellfun(@size,x);
maxNumEl=max(Tsizes); 
% Pad each vector with NaN values to equate lengths
for tt=1:Testruns(1)
padded_res(:,2*tt-1) = {padarray(x{1}(:,tt),[maxNumEl-numel(x{1}(:,tt)),0],NaN,'post')};
padded_res(:,2*tt) = {padarray(x{2}(:,tt),[maxNumEl-numel(x{2}(:,tt)),0],NaN,'post')};
end
% Convert cell array to matrix and run boxplot
padded_res= cell2mat(padded_res); 
