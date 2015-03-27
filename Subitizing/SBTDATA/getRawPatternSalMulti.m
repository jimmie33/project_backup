function getRawPatternSalMulti(srcDir,outputDir,imgList,dscr)

fd = 320;% uint8
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end

feat = nan(numel(imgList),fd);
filelist = {imgList.name};
parfor i = 1:numel(filelist)
    [p,name,~]=fileparts(filelist{i});
    S = imread(fullfile(srcDir,[name '.png']));
    f = featureSalMulti(S); 
    feat(i,:) = f(:)';
end
save(fullfile(outputDir,dscr),'feat','-v7.3');
