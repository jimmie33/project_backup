function showVGGSbtMap(feat)
load imgIdx
load testIdx

feat = feat(testIdx,:);

filename = {imgIdx.name};
filename = filename(testIdx);

idx = randperm(numel(filename));

feat = feat(idx,:);
filename = filename(idx);
cmap = rand(256,3);
for i = 1:10:numel(filename)
    for j = 0:9
        im = imread(fullfile('overall',filename{i+j}));
        if (size(im,3)==1)
            im = repmat(im, [1 1 3]);
        end
        subIdx = floor((j)/5)*15+mod(j,5)+1;
        subplot(6,5,subIdx), imshow(im);
        tmpfeat = feat(i+j,:);
        tmpfeat = reshape(tmpfeat,7,7,3);
        subplot(6,5,subIdx+10);
        imagesc(imresize(tmpfeat(:,:,3)',[size(im,1) size(im,2)],'nearest'))
        caxis([0 1])
        axis equal;
        subplot(6,5,subIdx+5);
        imagesc(1-imresize(tmpfeat(:,:,1)',[size(im,1) size(im,2)],'nearest'))
        caxis([0 1])
        axis equal;
%         [~,maxidx] = max(tmpfeat,[],3);
%         maxidx = maxidx';
%         idxmap = uint8(imresize(maxidx,[size(im,1) size(im,2)],'nearest'));
%         idxmap = imresize(idxmap,[size(im,1) size(im,2)],'nearest');
%         imshow(idxmap,cmap);
        
    end
    pause
end