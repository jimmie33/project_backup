function [score] = getSelfSimilarity(model,feat)

if numel(feat)~= numel(model.featParam)
    error('model and feature do not match.');
end

overallFeat = [];
for i = 1:numel(feat)
    tmp = applyPCA(feat{i},model.featParam{i}.m,model.featParam{i}.V);
    if model.param.feature{i}.norm
        tmp = bsxfun(@times,tmp,1./model.featParam{i}.trainStd);
    end
    overallFeat = [overallFeat tmp];
end
score = overallFeat*overallFeat(1,:)'/norm(overallFeat(1,:));

