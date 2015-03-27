function [res] = runThreshSalNMS(thresh)

load testImgIdx
load feature/CNN/CNNFT_VGG16_Salmap_3000
salfeat = feat;
param = getParam();

for j = 1:numel(testImgIdx)
    bboxscore = testImgIdx(j).sortbboxscore(1:min(100,numel(testImgIdx(j).sortbboxscore)));
    bboxes = testImgIdx(j).sortbbox(:,1:1:min(100,numel(testImgIdx(j).sortbboxscore)));
    
    tmpfeat = salfeat(j,:);
    tmpfeat = reshape(tmpfeat,7,7,3);
    salmap = 1-tmpfeat(:,:,1)';
    [bboxes bboxscore] = initData(bboxscore,bboxes,salmap,param);
    bboxes = bsxfun(@times,bboxes,testImgIdx(j).imsz([2 1 2 1])');
    [bboxes idx] = getBBoxesThreshNMS(bboxes, param.nmsthresh);
    bboxscore = bboxscore(idx);
    for i = 1:numel(thresh)
        res{i}{j} = bboxes(:,bboxscore>thresh(i));
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
tmp = max(tmp,0.01);
bboxscore = bboxscore.*tmp;
[bboxscore,idx] = sort(bboxscore,'descend');
bboxes = origbboxes(:,idx);
