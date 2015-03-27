function getRawPatternSalRaw(srcDir,outputDir,imgList,sz,flip,dscr)

fd = sz(1)*sz(2);% uint8
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
        I = imread(fullfile(srcDir,p,[name '.png']));
        f = featureSalRaw(I,sz); 
        feat(i,:) = f(:)';
        if flip
            flipped = featureSalRaw(I(:,end:-1:1,:),sz) ;
            feat_flip(i,:) = flipped(:)';
        end
    end
    if flip
        feat = [feat;feat_flip];
    end
    save(fullfile(outputDir,[num2str(imgCatIdx) '_' dscr]),'feat','-v7.3');
end