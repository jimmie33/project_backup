function [rects] = getBestCombo(filename,N,toShow)

I = imread(fullfile('img',[filename '.jpg']));
salmap = imread(fullfile('salmap',[filename '.png']));

salmap = im2double(imresize(salmap,[size(I,1), size(I,2)]));
salbw = salmap >0.45*(mean(salmap(salmap>0.5))+mean(salmap(salmap<0.5)));%graythresh(salmap);
load(fullfile('edgeBoxProp',filename))

S = regionprops(salbw,'BoundingBox');
S_bb = reshape([S.BoundingBox],4,[])';
S_bb_area = S_bb(:,3).*S_bb(:,4);
[~,S_bb_idx] = sort(S_bb_area,'descend');
S_bb = S_bb(S_bb_idx,:);
S_bb(:,3:4) = S_bb(:,3:4) + S_bb(:,1:2)-1;


if ~isempty(S_bb)
    iou = getIOU(boxes,S_bb(1,:));
    [iou,iouIdx] = sort(iou,'descend');
    tmpboxes = boxes(iouIdx(iou>0.5 & iouIdx > 50),:);
end
boxes = [round(boxes(1:50,:));round(tmpboxes)];

salsum = [];
salmean = [];
bwsum= [];
bwmean = [];
for i = 1:size(boxes,1)
    salpatch = salmap(boxes(i,2):boxes(i,4),boxes(i,1):boxes(i,3));
    bwpatch = salbw(boxes(i,2):boxes(i,4),boxes(i,1):boxes(i,3));
    salsum(i) = sum(salpatch(:));
    salmean(i) = mean(salpatch(:));
    bwsum(i) = sum(bwpatch(:));
    bwmean(i) = mean(bwpatch(:));
end
salsum = salsum/sum(salmap(:));
bwsum = bwsum/sum(salbw(:));

rects = [];
if N == 1
    score = 0.3*salsum'+1*salmean'+2*bwsum'+2*bwmean'+0*boxes(:,end);
    [~,idx] = sort(score,'descend');
    rects = boxes(idx(1:30),:);
elseif N==2
    score = zeros(size(boxes,1));%0.3*salsum'+1*salmean'+2*bwsum'+2*bwmean'+0*boxes(:,end);
    
    for ii = 1:size(score,1)
        for jj = 1:ii-1
            s1 = 0.3*salsum(ii)+0.3*salmean(ii)+2*bwsum(ii)+1*bwmean(ii);
            s2 = 0.3*salsum(jj)+0.3*salmean(jj)+2*bwsum(jj)+1*bwmean(jj);
            score(ii,jj) = min(s1,s2)^2*...
                (1-max(getINCL(boxes(ii,:),boxes(jj,:)),getINCL(boxes(jj,:),boxes(ii,:))))^2;
        end
    end
    
    [~,idx] = sort(score(:),'descend');
    [rr,cc]=ind2sub(size(score),idx(1));
    rects = boxes([rr cc],:);
end

%% visualize
if toShow
    imshow(I);
    for i = 1:size(rects,1)
        bb = rects(i,:); bb(3:4) = bb(3:4)-bb(1:2)+1;
        rectangle('Position',bb(1:4),'linewidth',2,'edgecolor',[1 0 0]);
    end
end