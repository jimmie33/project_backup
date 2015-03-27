function [feat, m, V, D] = prepPCA(feat, num)
% m: sample mean
% V: eigen vectors
% D: eigen values

m = mean(feat);
feat = bsxfun(@minus,feat,m);
% C = cov(feat);
% [V, D] = eig(C);
% 
% D = diag(D);
% [D, idx] = sort(D,'descend');
% D = D(1:num);
% V = V(:,idx(1:num));
[U,S,V] = svd(feat);
V = V(:,1:num);
D = diag(S).^2;
D = (1:num);
feat = feat*V;




