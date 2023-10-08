function [re] = relative_error(Xtrue, Xrestore)
%%
% Calculate the relative error for  a restored image Xrestore compared to Xtrue
%
% Inputs
%  Xtrue
%  Xrestore  
%
% Outputs
% re : the realative error
%
% Update October 8, 2023. 
% Copyright: Salina Bermudez and Rosemary Renaut
%
%%
re = norm(Xtrue - Xrestore,'fro')/norm(Xtrue,'fro');
end

