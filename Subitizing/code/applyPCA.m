function feat = applyPCA(feat, m, V)
% m: sample mean
% V: eigen vectors

feat = bsxfun(@minus,feat,m);
feat = feat*V;