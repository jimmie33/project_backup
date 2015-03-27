function [res] = runFixNum(num)

load testImgIdx
% load getBaseline/baselines/testImgIdxLBI

for i = 1:numel(num)
    tmpres = {};
    for j = 1:numel(testImgIdx)
        score = testImgIdx(j).sortbboxscore;
        bboxes = testImgIdx(j).sortbbox;
        bboxes = bboxes(:,1:min(num(i),size(bboxes,2)));
        bboxes = bsxfun(@times,bboxes,testImgIdx(j).imsz([2 1 2 1])');
        tmpres{j} = bboxes;
    end
    res{i} = tmpres;
end