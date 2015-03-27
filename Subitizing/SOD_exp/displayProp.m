function displayProp(imgDir,cate,boxDir,N)

modelName = 'pred_AllCat_CNN_SalCNN_Sal_pca250';
load(fullfile(imgDir,['imgList_' num2str(cate)]));

for i = 1:numel(imgList)
    I = imread(fullfile(imgDir,num2str(cate),imgList{i}));
    subplot(5,5,mod(i-1,25)+1)
    imshow(I);
    [~,name,~] = fileparts(imgList{i});
    load(fullfile(boxDir,num2str(cate),name));
    load(fullfile('img',[modelName '_' num2str(cate)]));
    text(0,-20,num2str(pred(i)));
    for k = 1:min(N,size(boxes,1))
        aa = boxes(k,1:4);
        aa(3:4) = aa(3:4)-aa(1:2)+1;
        rectangle('Position',aa,'edgecolor',[1 0 0]);
    end
    if mod(i-1,25)+1 == 25
        pause
    end
end