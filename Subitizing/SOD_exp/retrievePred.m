modelName = {'AllCat_CNNFT_pca100_aug'};

load(fullfile('../SBTDATA/imgIdx.mat'));
load(fullfile('../SBTDATA/testIdx.mat'));

testList = {imgIdx(testIdx).name};

for modelIdx = 1:numel(modelName)
    load(fullfile('../SBTDATA/result',modelName{modelIdx}));
    %% calculate prediction
    testpred = [];
    predScore = [model.testScore{1} model.testScore{2} model.testScore{3} model.testScore{4} model.testScore{5}];
    for ii = 1:size(predScore,1)
        [mma,idx] = max(predScore(ii,:));
        if true
            testpred(end+1) = idx-1;
        end
    end
    
    for catIdx = 0:4
        pred = [];
        load(fullfile('img',['imgList_' num2str(catIdx)]));
        for fileIdx = 1:numel(imgList)
            testIdx = find(strcmp(testList,imgList{fileIdx}));
            pred(end+1) = testpred(testIdx);
        end
        save(fullfile('img',['pred_' modelName{modelIdx} '_' num2str(catIdx)]),'pred');
    end
end