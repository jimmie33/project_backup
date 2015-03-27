function getTightSalmap_Img(outputSal, outputOrig,imgList)

dilate_p = 16;
if ~exist(outputSal,'dir')
    mkdir(outputSal)
end

if ~exist(outputOrig,'dir')
    mkdir(outputOrig)
end

filelist = {imgList.name};
parfor i = 1:numel(filelist)
    I = imread(fullfile('overall',filelist{i}));
    salmap = imread(fullfile('feature/salmap/SO',[filelist{i}(1:end-4) '_wCtr_Optimized.png']));
    salmap = imresize(salmap,[size(I,1) size(I,2)]);
    salmap = im2double(salmap);
    bwmap = salmap > graythresh(salmap);
    [X Y] = meshgrid(1:size(I,2),1:size(I,1));
    X = X(bwmap(:)); Y = Y(bwmap(:));
    xmin = max(min(X)-dilate_p,1);
    xmax = min(max(X)+dilate_p,size(I,2));
    ymin = max(min(Y)-dilate_p,1);
    ymax = min(max(Y)+dilate_p,size(I,1));
    I = I(ymin:ymax,xmin:xmax,:);
    salmap = salmap(ymin:ymax,xmin:xmax);
    imwrite(salmap,fullfile(outputSal,[filelist{i}(1:end-4) '.png']));
    imwrite(I,fullfile(outputOrig,filelist{i}));
end