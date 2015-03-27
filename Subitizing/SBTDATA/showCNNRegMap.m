function showCNNRegMap(feat,sz)
load imgIdx
load testIdx

feat = feat(testIdx,:);

filename = {imgIdx.name};
filename = filename(testIdx);

idx = randperm(numel(filename));

feat = feat(idx,:);
filename = filename(idx);

figure
for i = 1:10:numel(filename)
    for j = 0:9
        im = imread(fullfile('overall',filename{i+j}));
        subplot(4,5,floor(j/5)*10+mod(j,5)+1), imshow(im);
        tmpfeat = feat(i+j,:);
        tmpfeat = (reshape(tmpfeat, sz)); 
        map = tmpfeat';
        map = imresize(map,[size(im,1) size(im,2)]);
        subplot(4,5,j*10+6)
        imagesc(map), axis equal
    end
    pause
end