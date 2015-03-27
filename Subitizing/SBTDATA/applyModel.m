function [score] = applyModel(model,feat)

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
score = [];
for i = 1:numel(model.svmModel)
    [~, ~, tmpscore] = predict(zeros(size(overallFeat,1),1), ...
        sparse(overallFeat), model.svmModel{i}, '-q');
    if model.svmModel{i}.Label(1) == 0;
        tmpscore = tmpscore*-1;
    end
    score = [score tmpscore];
end
