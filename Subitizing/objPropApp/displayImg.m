function displayImg(imgList,sz)

if nargin == 1
    sz = [5 5];
end
idx = randperm(numel(imgList));

batchsz = sz(1)*sz(2);

figure
for i = 1:batchsz:numel(idx)
    count = 1;
    idend = min(i+batchsz-1,numel(idx));
    for j = i:idend
        subplot(sz(1),sz(2),count)
        imshow(imread(fullfile('../DATA/PASCAL/VOCdevkit_test/VOC2007/JPEGImages/',...
            [imgList{idx(j)}(1:end-4) '.jpg'])));
        count = count+1;
    end
    pause;
end