function [res] = runFixNumSalNMS(num) 

load testImgIdx
% load getBaseline/baselines/testImgIdxLBI
load ../feature/CNN/CNNFT_VGG16_Exp3_3000
load ../testIdx
salfeat = feat(testIdx,:);
param = getParam();

for j = 1:numel(testImgIdx)
    bboxscore = testImgIdx(j).sortbboxscore;
    bboxes = testImgIdx(j).sortbbox;
    
    tmpfeat = salfeat(j,:);
    tmpfeat = reshape(tmpfeat,7,7,3);
    salmap = 1-tmpfeat(:,:,1)';
    [bboxes bboxscore] = initData(bboxscore,bboxes,salmap,param);
    bboxes = bsxfun(@times,bboxes,testImgIdx(j).imsz([2 1 2 1])');
    [bboxes idx] = getBBoxesThreshNMS(bboxes, param.nmsthresh);
    bboxscore = bboxscore(idx);
    for i = 1:numel(num)
        res{i}{j} = bboxes(:,1:min(num(i),size(bboxes,2)));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function param = getParam()
param.salthresh = 0.5;
param.nmsthresh = 0.4;

function [bboxes bboxscore] = initData(bboxscore,bboxes,salmap,param)

origbboxes = bboxes;
salmapS = salmap > param.salthresh;
salmapS = salmapS/sum(salmap(:));
bboxes = round(bsxfun(@times,bboxes,[7 7 7 7]'));
bboxes([1 2],:) = max(bboxes([1 2],:),1);
%for single obj
tmp = zeros(size(bboxscore));
for i = 1:numel(tmp)
    tmp(i) = sum(sum(salmapS(bboxes(2,i):bboxes(4,i),bboxes(1,i):bboxes(3,i))));
end
bboxscore = bboxscore.*tmp;
[bboxscore,idx] = sort(bboxscore,'descend');
bboxes = origbboxes(:,idx);
