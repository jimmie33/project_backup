function [P R N] = evaluate(res)

load testImgIdx

P = zeros(1,numel(res));
R = zeros(1,numel(res));
N = zeros(1,numel(res));

for i = 1:numel(res)
    gt_num = zeros(1,numel(testImgIdx));
    pred_num = zeros(1,numel(testImgIdx));
    TP = zeros(1,numel(testImgIdx));
    for j = 1:numel(testImgIdx)
        gt_num(j) = size(testImgIdx(j).anno,1);
        pred_num(j) = size(res{i}{j},2);
        bboxes = getGTHitBoxes(res{i}{j},testImgIdx(j).anno, 0.5);
        TP(j) = size(bboxes,2);
    end
    P(i) = sum(TP)/max(sum(pred_num),0.1);
    R(i) = sum(TP)/max(sum(gt_num),0.1);
    N(i) = sum(pred_num)/numel(testImgIdx);
end