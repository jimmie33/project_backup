function showNINCatMap(feat)
load imgIdx
load testIdx

feat = feat(testIdx,:);

filename = {imgIdx.name};
filename = filename(testIdx);

idx = randperm(numel(filename));

feat = feat(idx,:);
filename = filename(idx);

figure
for i = 1:5:numel(filename)
    for j = 0:4
        im = imread(fullfile('overall',filename{i+j}));
        subplot(5,6,j*6+1), imshow(im);
        tmpfeat = feat(i+j,:);
        tmpscore = mean(reshape(tmpfeat,[],5)); 
        [~,maxidx] = max(tmpscore);
        maxval = max(tmpfeat(:));
        tmpfeat = reshape(tmpfeat,[],5);
        for k = 1:5
            map = reshape(tmpfeat(:,k),6,6);
            mm = mean(map(:));
            map = imresize(map',[size(im,1) size(im,2)]);
            map = map/maxval;
            subplot(5,6,j*6+k+1),imshow(map);
            
            if k == maxidx
                text(-5,0,num2str(mm),'color',[1 0 0]);
            else
                text(-5,0,num2str(mm));
            end
        end
    end
    pause
end