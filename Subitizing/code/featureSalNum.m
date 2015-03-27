function feat = featureSalNum(salmap)

salmap = imresize(salmap,[256,256]);
salmap = im2double(salmap(:,:,1));
areaList = cell(3,1);
i = 1;
for thresh = 0.25:0.25:0.75
    bw = salmap > thresh;
    S = regionprops(bw,'Area');
    a = [S.Area];
    a = sqrt(a);
    areaList{i} = a;
    i = i+1;
end

%% separate normalization
feat1 = [];
for i = 1:numel(areaList)
    a = areaList{i};
    a = log(a/max(a))/log(0.5);
    tmp = hist(a,[0.5:1:3.5]);
    feat1 = [feat1 tmp];
end

%% overall normalization

feat2 = [];
mm = max(areaList{1});
for i = 1:numel(areaList)
    a = areaList{i};
    a = log(a/mm)/log(0.5);
    tmp = hist(a,[0.5:1:3.5]);
    feat2 = [feat2 tmp];
end

feat = [feat1 feat2];