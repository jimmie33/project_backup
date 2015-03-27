function visualizeTopN(modelName,range)

load(fullfile('result',modelName));
load imgIdx;
load testIdx;

score = [];
for i=1:numel(model.testScore)
    score = [score, model.testScore{i}];
end

pred = nan(size(score,1),1);
for i =1:size(pred,1)
    [~, idx] = max(score(i,:));
    pred(i) = idx-1;
end

testImg = imgIdx(testIdx);
count = 1;
for i=0:4
    testScore = model.testScore{i+1};
    [~,idx] = sort(testScore,'descend');
    idx(pred(idx)~=i)=[];
    for kk = range
        subplot(5,numel(range),count)
        imshow(imread(fullfile('overall',testImg(idx(kk)).name)));
        count = count+1;
    end
end