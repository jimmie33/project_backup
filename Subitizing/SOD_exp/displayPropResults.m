function displayPropResults(imgDir,cate,boxDir,thresh,topN)

modelName = 'pred_AllCat_CNN_SalCNN_Sal_pca250';
load(fullfile(imgDir,['imgList_' num2str(cate)]));

for i = 1:numel(imgList)
    I = imread(fullfile(imgDir,num2str(cate),imgList{i}));
    subplot(5,5,mod(i-1,25)+1)
    imshow(I);
    [~,name,~] = fileparts(imgList{i});
    load(fullfile(boxDir,num2str(cate),name));
    if ~isempty(boxes)
        boxes = boxes(1:topN,:);
    end
    load(fullfile('gt',num2str(cate),name));
    load(fullfile('img',[modelName '_' num2str(cate)]));
    text(0,-20,num2str(pred(i)));
    for k = 1:size(anno,1)
        iou = getIOU(boxes,anno(k,:));
        [iou iouIdx] = max(iou);
        aa = anno(k,:);
        aa(3:4) = aa(3:4) - aa(1:2) +1;
        if iou < thresh
            rectangle('Position',aa,'edgecolor',[1 0 0]);
        else
            rectangle('Position',aa,'edgecolor',[0 1 0]);
            bb = boxes(iouIdx,1:4);
            bb(3:4) = bb(3:4) - bb(1:2) +1;
            rectangle('Position',bb,'edgecolor',[0 0 1]);
        end
    end
    if mod(i-1,25)+1 == 25
        pause
    end
end