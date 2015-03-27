function getRawPatternSalMulti(srcDir,srcDir2,outputDir,imgList,flip,dscr)

fd = 640;% uint8
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end
for imgCatIdx = 0:4
    feat = nan(numel(imgList),fd);
    if flip
        feat_flip = nan(numel(imgList),fd);
    end
    filelist = imgList.(['c' num2str(imgCatIdx)]);
    parfor i = 1:numel(filelist)
        [p,name,~]=fileparts(filelist{i});
        S = imread(fullfile(srcDir,p,[name '.png']));
        I = imread(fullfile(srcDir2,p,[name '.jpg']));
        f = featureSalMulti(S,I); 
        feat(i,:) = f(:)';
        if flip
            flipped = featureSalMulti(S(:,end:-1:1,:),I(:,end:-1:1,:)) ;
            feat_flip(i,:) = flipped(:)';
        end
    end
    if flip
        feat = [feat;feat_flip];
    end
    save(fullfile(outputDir,[num2str(imgCatIdx) '_' dscr]),'feat','-v7.3');
end