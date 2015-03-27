function testImgIdx = prepareTestData()
% prepare data, store predictions
% name, size, gt, sbtscore, sorted bbox and scores

load imgList
load feature/CNN/CNNFT_VGG16_SBT_40000
sbt_feat = feat;
load feature/CNN/CNNFT_VGG16_BBox_1000
bb_feat = feat;
load center100

img_root = '../DATA/PASCAL/VOCdevkit_test/VOC2007/JPEGImages/';

for i = 1:numel(imgList)
    I = imread(fullfile(img_root,imgList{i}));
    testImgIdx(i).name = imgList{i};
    testImgIdx(i).imsz = [size(I,1) size(I,2)];
    load(fullfile('../objPropApp/bboxAnnotation',[testImgIdx(i).name(1:end-4) '.mat']));
    testImgIdx(i).anno = bbox;
    
    testImgIdx(i).sbtscore = sbt_feat(i,:);
    [bbox score] = getBBoxScore(center,bb_feat(i,:));
    testImgIdx(i).sortbbox = bbox;
    testImgIdx(i).sortbboxscore = score;
end

function [bbox score] = getBBoxScore(center,bb_feat)

bb_feat = reshape(bb_feat,[],2);
[score idx] = sort(bb_feat(:,2),'descend');
bbox = center(:,idx);