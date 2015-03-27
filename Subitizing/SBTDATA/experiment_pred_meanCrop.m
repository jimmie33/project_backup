load imgIdx
load testIdx

testImg = imgIdx(testIdx);

pp = [];
for i = 1:numel(testImg)
    i
    load(fullfile('feature/CropCNN',testImg(i).name(1:end-4)));
    predscore = applyModel(model,{double(feat)});
    [~,idx]=max(mean(predscore(1:9,:)));
    pp(end+1)=idx-1;
end