function getRawPatternHOG(outputDir,imgList,sz,dscr)

fd = sz(1)*sz(2)*31/64;% uint8
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end

feat = nan(numel(imgList),fd);

filelist = {imgList.name};
parfor i = 1:numel(filelist)
    I = imread(fullfile('overall',filelist{i}));
    f = featureHOG(I,sz); 
    feat(i,:) = f(:)';
end
save(fullfile(outputDir,dscr),'feat','-v7.3');
