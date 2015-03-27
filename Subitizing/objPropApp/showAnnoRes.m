function showAnnoRes(filename,nProp)

load(fullfile('bboxAnnotation/',filename));
prop = dlmread(fullfile('BING_result/BBoxes',[filename,'.txt']));
prop = prop(2:end,2:end);
I = imread(fullfile('../DATA/PASCAL/VOCdevkit_test/VOC2007/JPEGImages/',...
    [filename,'.jpg']));
imshow(I);

for i=1:size(bbox,1)
    bb = bbox(i,:);
    bb(3:4) = bb(3:4)-bb(1:2)+1;
    rectangle('Position',bb,'edgecolor',[0 1 0]);
    iou = getIOU(prop,bbox(i,:));
    pp = prop(iou>0.5,:);
    for j = 1:size(pp,1)
        bb = pp(j,:);
        bb(3:4) = bb(3:4)-bb(1:2);
        rectangle('Position',bb,'edgecolor',[1 0 0]);
    end
end

% for i=1:min(nProp,size(prop,1))
%     bb = prop(i,:);
%     bb(3:4) = bb(3:4)-bb(1:2);
%     rectangle('Position',bb,'edgecolor',[1 0 0]);
% end

function iou = getIOU(res,gt)

xmin = max(res(:,1),gt(1));
ymin = max(res(:,2),gt(2));
xmax = min(res(:,3),gt(3));
ymax = min(res(:,4),gt(4));

I = max((xmax-xmin+1),0).*max((ymax-ymin+1),0);
U = (res(:,3)-res(:,1)+1).*(res(:,4)-res(:,2)+1)+(gt(3)-gt(1)+1)*(gt(4)-gt(2)+1);
iou = I./(U-I);