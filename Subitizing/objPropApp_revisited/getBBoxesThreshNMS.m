function [bboxes,idx] = getBBoxesThreshNMS(bboxes,nmsthresh)
if isempty(bboxes)
    return
end
tmp = bboxes(:,1);
idx = 1;
for i = 2:size(bboxes,2)
    if max(getIOU(tmp',bboxes(:,i)')) < nmsthresh
        tmp = [tmp bboxes(:,i)];
        idx = [idx i];
    end
end
bboxes = tmp;