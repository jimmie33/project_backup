function imgIdx = updateFileIdx(imgIdx)

D = dir('masterImage/*g');

filelist = {D.name};
oldfilelist = {imgIdx.imgName};
ID = numel(imgIdx);
for i = 1:numel(filelist)
    if any(strcmp(oldfilelist,filelist{i}))
        continue;
    end
    ID = ID + 1;
    imgIdx(ID).imgName = filelist{i};
    imgIdx(ID).ID = ID;
    imgIdx(ID).prelabel = nan;
    imgIdx(ID).nBBox = nan;
    imgIdx(ID).BBox = [];
    imgIdx(ID).remove = false;
    imgIdx(ID).commet = 'batch2';
    imgIdx(ID).date = date;
    if strcmp(filelist{i}(1:3),'SUN')
        imgIdx(ID).dataSet = 'SUN';
    elseif strcmp(filelist{i}(1:4),'COCO')
        imgIdx(ID).dataSet = 'COCO';
    elseif strcmp(filelist{i}(1:6),'ImgNet')
        imgIdx(ID).dataSet = 'ImgNet';
    elseif strcmp(filelist{i}(1:7),'VOCTEST')
        imgIdx(ID).dataSet = 'VOCTEST';
    elseif strcmp(filelist{i}(1:3),'VOC')
        imgIdx(ID).dataSet = 'VOC';
    end
end