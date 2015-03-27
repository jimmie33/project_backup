% %% do sift feature
% imgCat = {'0' '1' '2' '3' '4'};
% fd = 128*64/2;% uint8
% srcDir = '../DATA/SBT/TRAIN';
% for imgCatIdx = 1:numel(imgCat)
%     D=dir(fullfile(srcDir,imgCat{imgCatIdx},'*g'));
%     imgList = {D.name};
%     feat = nan(numel(imgList),fd);
%     for i = 1:numel(imgList)
%         I = imread(fullfile(srcDir,imgCat{imgCatIdx},imgList{i}));
%         f = featureSIFT(I); 
%         feat(i,:) = f(:)';
%     end
%     save(fullfile('../trainSample/SIFT',[imgCat{imgCatIdx} '_SIFT']),'feat','-v7.3');
% end
%% do Geo feature
% addpath('GeoFeat')
% imgCat = {'c0' 'c1' 'c2' 'c3' 'c4'};
% fd = 3*1024;%
% for imgCatIdx = 1:numel(imgCat)
%     load(fullfile('../DATA/',imgCat{imgCatIdx}));
%     feat = nan(numel(imgList),fd);
%     for i = 1:numel(imgList)
%         I = imread(fullfile('../DATA',strrep(imgList{i},'\','/')));
%         f = featureGeo(I); 
%         feat(i,:) = f(:)';
%     end
%     save(fullfile('../trainSample',[imgCat{imgCatIdx} '_Geo']),'feat','-v7.3');
% end
%% do hog feature
imgCat = {'0' '1' '2' '3' '4'};
fd = 16*16*31;% uint8
srcDir = '../DATA/SBT/TRAIN';
for imgCatIdx = 1:numel(imgCat)
    D=dir(fullfile(srcDir,imgCat{imgCatIdx},'*g'));
    imgList = {D.name};
    feat = nan(numel(imgList),fd);
    feat_flip = nan(numel(imgList),fd);
    perm = vl_hog('permutation') ;
    parfor i = 1:numel(imgList)
        I = imread(fullfile(srcDir,imgCat{imgCatIdx},imgList{i}));
        f = featureHOG(I,[128 128]); 
        feat(i,:) = f(:)';
        flipped = f(:,end:-1:1,perm) ;
        feat_flip(i,:) = flipped(:)';
    end
    feat = [feat;feat_flip];
    save(fullfile('../trainSample/HOG',[imgCat{imgCatIdx} '_HOG_flip']),'feat','-v7.3');
end