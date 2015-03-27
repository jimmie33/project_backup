K = 5;

load imgIdx;
load testIdx;

testImgs = imgIdx(testIdx);
trainImgs = imgIdx(~testIdx);

load feature/CNN/CNNFT_aug_pca100
% trainFeat = bsxfun(@times,trainFeat,1./trainStd);
% testFeat = bsxfun(@times,testFeat,1./trainStd);

% random select some test Images

pred = nan(numel(testImgs),1);
h = nan(1,5);
h_prior = nan(1,5);
for kk = 1:5
    h_prior(kk) = sum([trainImgs.label]==kk-1);
end
for i = 1:numel(testImgs)
    
    % compute the K nearest neighbor
    tFeat = testFeat(i,:);
    score = bsxfun(@minus,trainFeat,tFeat);
    score = sum(score.^2,2);
    [~,rIdx] = sort(score,'ascend');
    R = [trainImgs(rIdx(1:K)).label];
    for kk = 1:5
        h(kk) = sum(R==kk-1);
    end
    [~,predId] = max(h);
    pred(i) = predId-1;
end

confusionmat([testImgs.label],pred)