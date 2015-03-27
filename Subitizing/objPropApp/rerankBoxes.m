D = dir('BING_result/BBoxes/*.txt');
filelist = {D.name};

resPath = 'precomputed/edge_boxes_70/mat';
outputPath = 'reranked/edge_boxes_70';

for i = 1:numel(filelist)
    [~,filename,~] = fileparts(filelist{i});
    salmap = imread(fullfile('test_salmap',[filename '.png']));
    I = imread(fullfile('../DATA/PASCAL/VOCdevkit_test/VOC2007/JPEGImages',...
        [filename '.jpg']));
    salmap = imresize(salmap,[size(I,1) size(I,2)]);
    load(fullfile(resPath,filename(1:4),filename));
    prop = boxes;
    salscore = zeros(size(boxes,1),1);
    ss = sum(salmap(:));
    for kk = 1:size(boxes,1)
        bb = boxes(kk,:);
        salpatch = salmap(bb(2):bb(4),bb(1):bb(3));
        salscore(kk) = sum(salpatch(:));
    end
    
    [~, idx] = sort(salscore/ss+scores,'descend');
    boxes = boxes(idx,:);
    if ~exist(fullfile(outputPath,filename(1:4)),'dir')
        mkdir(fullfile(outputPath,filename(1:4)));
    end
    save(fullfile(outputPath,filename(1:4),filename),'boxes');
end