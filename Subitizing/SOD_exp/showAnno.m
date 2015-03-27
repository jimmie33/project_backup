function showAnno(catName)

D = dir(fullfile('img',catName,'*.jpg'));
imgList = {D.name};
for i = 1:numel(imgList)
    I = imread(fullfile('img',catName,imgList{i}));
    subplot(5,5,mod(i-1,25)+1)
    imshow(I);
    load(fullfile('gt',catName,imgList{i}(1:end-4)));
    for k = 1:size(anno,1)
        bbox = anno(k,:);
        bbox(3:4) = bbox(3:4)-bbox(1:2)+1;
        rectangle('Position',bbox,'edgecolor',[1 0 0]);
    end
    if mod(i-1,25)+1 == 25
        pause
    end
end
