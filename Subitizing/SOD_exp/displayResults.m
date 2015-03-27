function displayResults(imgDir,imgList,boxList)


for i = 1:numel(imgList)
    I = imread(fullfile(imgDir,imgList{i}));
    subplot(5,5,mod(i-1,25)+1)
    imshow(I);
    bbox = boxList{i};
    for k = 1:size(bbox,1)
        rectangle('Position',bbox(k,:),'edgecolor',[1 0 0]);
    end
    if mod(i-1,25)+1 == 25
        pause
    end
end
