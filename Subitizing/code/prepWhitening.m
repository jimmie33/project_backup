function [feat, m, invcov] = prepWhitening(feat)

m = mean(feat);
feat = bsxfun(@minus,feat,m);

if size(feat,1)<size(feat,2)
    error('number of instance is smaller than feature dimenstion!');
end
[~,D,V] = svd(feat);

D = diag(D);
D = abs(D) + mean(D)*0.01;
D = 1./D;
D = diag(D);

feat = feat*V*D;
