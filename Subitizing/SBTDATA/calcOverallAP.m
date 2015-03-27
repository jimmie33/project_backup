function ap = calcOverallAP(gt, score)
% gt should start at 1. e.g. 1,2,3,4,5 for [0 1 2 3 4]
if size(score,1) ~= numel(gt)
    error('score and gt not matched.')
end


for i = 1:max(gt)
    tmpScore = score(:,i);
    [tmpScore, idx] = sort(tmpScore,'descend');
    tmpGT = gt(idx);
    prec = nan(numel(gt),1);
    rec = nan(numel(gt),1);
    nInst = sum(tmpGT == i);
    for kk = 1:numel(gt)
        tp = sum(tmpGT(1:kk)==i);
        rec(kk) = tp/nInst;
        prec(kk) = tp/kk;
    end
    ap(i) = calcAP(rec,prec);
end