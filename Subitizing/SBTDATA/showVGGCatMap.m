function showVGGCatMap(feat,center)
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
        subIdx = floor((j)/5)*10+mod(j,5)+1;
        subplot(4,5,subIdx), imshow(im);
        tmpfeat = feat(i+j,:);
        tmpfeat = reshape(tmpfeat,7,7,size(center,2)+2);
        tmpfeat = exp(tmpfeat);
        tmpfeat = bsxfun(@times, tmpfeat, 1./sum(tmpfeat,3));
        tmpfeat = tmpfeat(:,:,1:end-1);
        [~,maxidx] = max(tmpfeat,[],3);
        maxidx = maxidx';
        subplot(4,5,subIdx+5);
        idxmap = uint8(imresize(maxidx,[size(im,1) size(im,2)],'nearest'));
        idxmap = imresize(idxmap,[size(im,1) size(im,2)],'nearest');
        imshow(idxmap,cmap);
        axis equal;
        cidx = unique(maxidx(maxidx~=1))-1;
        bboxes = center(:,cidx);
        bboxes = bsxfun(@times,bboxes,[size(im,2);size(im,1);size(im,2);size(im,1)]);
        bboxes([3 4],:) = bboxes([3 4],:)-bboxes([1 2],:)+1;
        subplot(4,5,subIdx)
        for k = 1:size(bboxes,2)
            rectangle('position',bboxes(:,k),'edgecolor',cmap(cidx(k)+2,:), 'linewidth', 2);
        end
    end
    pause
end