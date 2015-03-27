function [feat param] = featureGIST(I,param)

[feat, param] = LMgist(I, '', param);
feat = double(feat);