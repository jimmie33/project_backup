function createBatch(name, imgIdx)

if ~exist(name,'dir')
    mkdir(name);
    mkdir(name,'img')
end

save(fullfile(name,'imgList'),'imgIdx');

% only output imgName and ID
struct2csv(rmfield(imgIdx,{'nBBox','BBox','remove','commet','date','dataSet'})...
    ,fullfile(name,'imgList.csv'));

% copy images
for i = 1:numel(imgIdx)
    copyfile(fullfile('masterImage',imgIdx(i).imgName),fullfile(name,'img',imgIdx(i).imgName));
end