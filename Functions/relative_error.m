function [re] = relative_error(X, Xnaive)
re = norm(X - Xnaive,'fro')/norm(X,'fro');
