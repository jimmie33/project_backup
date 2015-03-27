K = 5;

load imgIdx;
load testIdx;

testImgs = imgIdx(testIdx);
trainImgs = imgIdx(~testIdx);

load feature/CNN/CNNFT_aug_pca100
trainFeat = bsxfun(@times,trainFeat,1./trainStd);
testFeat = bsxfun(@times,testFeat,1./trainStd);

% random select some test Images

sampleIdx = randsample(numel(testImgs),K);

for i = 1:numel(sampleIdx)
    tIdx = sampleIdx(i);
    subplot(numel(sampleIdx),K+1,(i-1)*(K+1)+1)
    imshow(imread(fullfile('overall',testImgs(tIdx).name)));
    
    % compute the K nearest neighbor
    tFeat = testFeat(tIdx,:);
    score = trainFeat*tFeat';
    [~,rIdx] = sort(score,'descend');
    for j = 1:K
        subplot(numel(sampleIdx),K+1,(i-1)*(K+1)+1+j);
        imshow(imread(fullfile('overall',trainImgs(rIdx(j)).name)));
    end
end

