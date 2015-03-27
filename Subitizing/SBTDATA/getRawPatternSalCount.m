function getRawPatternSalCount(outputDir,imgList,thresh,dscr)

fd = 4;% uint8
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end

feat = nan(numel(imgList),fd);
filelist = {imgList.name};
parfor i = 1:numel(filelist)
    I = imread(fullfile('feature/salmap/SO',[filelist{i}(1:end-4) '_wCtr_Optimized.png']));
    f = featureSalCount(I,thresh); 
    feat(i,:) = f(:)';
end

save(fullfile(outputDir,dscr),'feat','-v7.3');