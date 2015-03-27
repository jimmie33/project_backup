function getRawPatternGIST(outputDir,imgList,sz,dscr)

addpath GIST

fd = 512;% uint8
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end

param.imageSize = sz;
param.orientationsPerScale = [8 8 8 8]; % number of orientations per scale (from HF to LF)
param.numberBlocks = 4;
param.fc_prefilt = 4;

% initialize
img = rand(128,128);
[~, param] = featureGIST(img,param);


feat = nan(numel(imgList),fd);
filelist = {imgList.name};
parfor i = 1:numel(filelist)
    I = imread(fullfile('overall',filelist{i}));
    I = imresize(I,sz);
    f = featureGIST(I,param); 
    feat(i,:) = f(:)';
end

save(fullfile(outputDir,dscr),'feat','-v7.3');
