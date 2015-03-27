function [TP,nP,nGT] = getRecall(gt,prop,thresh,nProp)
% nP: number of existing proposals
% nProp: a vector

% gtPath = 'bboxAnnotation';
% resPath = 'precomputed/BING/mat';
% 
% load(fullfile(gtPath,filename));
% gt = bbox;
% % prop = dlmread(fullfile(resPath,[filename,'.txt']));
% load(fullfile(resPath,filename(1:4),filename));
% prop = boxes;
% 
nGT = size(gt,1);

% prop = prop(2:max(nProp)+1,2:end);

TP = zeros(size(prop,1),size(gt,1));

for i=1:size(gt,1)
    iou = getIOU(prop,gt(i,:));
    TP(:,i) = iou>thresh;
end

if size(TP,1)<max(nProp)
    tmp = zeros(max(nProp),size(gt,1));
    tmp(1:size(TP,1),:) = TP;
    TP = tmp;
end
TP = cumsum(TP,1);
TP(TP>1) = 1;
TP = sum(TP,2);
TP = TP(nProp);
nP = nProp;
nP(nP>size(prop,1))=size(prop,1);






