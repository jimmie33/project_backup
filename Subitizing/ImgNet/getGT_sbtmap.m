function [im sbtmap nlabel] = getGT_sbtmap(imgIdx,mapsz,param,doNeg)

incthresh = 0.3;

bbox = imgIdx.anno;
% [I cmap] = imread(imgIdx.path(80:end));
[I cmap] = imread(imgIdx.path);
if size(cmap,2) > 0
    newim = cell(1, size(cmap,2));
    for j=1:size(cmap,2)
        ch = cmap(:,j);
        newim{j} = ch(I+1);
    end
    I = cat(3, newim{:});
end
if size(I,3) == 1
    I = repmat(I,[1 1 3]);
end

sz = size(I);
sz = sz([1 2]);
sbtmap = zeros(mapsz);

if doNeg % generate background sample
    if ~isempty(bbox)
        % get the roi
        roi = round([min(bbox(:,2)) min(bbox(:,1)) max(bbox(:,4)) max(bbox(:,3))]);
        roi([1,2]) = max(roi([1,2]),1);
        roi([3,4]) = min([roi([3,4]);sz([1 2])]); 
        % generate proposal
        prop(1,:) = [1 1  sz(1) roi(2)];
        prop(2,:) = [1 1 roi(1) sz(2)];
        prop(3,:) = [1 roi(4) sz(1) sz(2)];
        prop(4,:) = [roi(3) 1 sz(1) sz(2)];
        [~,iidx] = max((prop(:,3)-prop(:,1)+1).*(prop(:,4)-prop(:,2)+1));
        roi = prop(iidx,:);
        I = I(roi(1):roi(3), roi(2):roi(4),:);
        bbox = [];
    end
elseif param.randomCrop
    if isempty(bbox)
        newsz = round((0.5+rand(1, 2)*0.5).*sz);%0.5-1 original width or height
        upleft = round(rand(1,2).*(sz-newsz));
        roi = [upleft, newsz+upleft-1];
        roi([1,2]) = max(roi([1,2]),1);
        roi([3,4]) = min([roi([3,4]);sz]); 
        I = I(roi(1):roi(3), roi(2):roi(4),:);
        if rand(1) > 0.5 %flip
            I = flipdim(I,2);
        end
    else
        bboxid = randi([1 size(bbox,1)],1);
        selbbox = round(bbox(bboxid,:));
        if selbbox(4) > sz(1)
            keyboard
        end
        roi = zeros(1,4);
        roi(1) = randi([1 selbbox(2)],1);
        roi(2) = randi([1 selbbox(1)],1);
        roi(3) = randi([selbbox(4) sz(1)],1);
        roi(4) = randi([selbbox(3) sz(2)],1);
        iou = getIOU(round(bbox), roi([2 1 4 3]));
        bbox = bbox(iou>0.7,:);
        
        I = I(roi(1):roi(3), roi(2):roi(4),:);
        sz = size(I);
        sz = sz([1 2]);
        bbox = round(bsxfun(@plus, bbox, -roi([2 1 2 1])) + 1);
        bbox(:,[1 2]) = max(bbox(:, [1 2]),1);
        bbox(:,3) = min(bbox(:,3),size(I,2));
        bbox(:,4) = min(bbox(:,4),size(I,1));
        
        if rand(1) > 0.5 %flip
            I = flipdim(I,2);
            bbox(:,[3 1]) = sz(2) - bbox(:,[1 3]) + 1;
        end
    end
end
if ~isempty(bbox)
   tmpMap = zeros([mapsz size(bbox,1)]);
   bbox(:,[1 2]) = max(bbox(:, [1 2]),1);
   bbox(:,3) = min(bbox(:,3),size(I,2));
   bbox(:,4) = min(bbox(:,4),size(I,1));
   for i = 1:size(bbox,1)
       tmp = zeros(sz);
       bb = round(bbox(i,:));
       inc = getINC(bbox([1:size(bbox,1)]~=i,:),bb);
       
       if max(inc) < incthresh % singular object
           tmp(bb(2):bb(4),bb(1):bb(3)) = 1;
           flag = 1;
       else % overlap object
           tmp(bb(2):bb(4),bb(1):bb(3)) = 2;
           flag = 2;
       end
       tmp = imresize(tmp,mapsz,'nearest');
       if max(tmp(:)) == 0
           r = max(round(bb(2)*mapsz(1)/sz(1)),1);
           c = max(round(bb(1)*mapsz(2)/sz(2)),1);
           tmp(r,c) = flag;
       end
       tmpMap(:,:,i) = tmp;
   end
   sbtmap = max(tmpMap,[],3);
end

im = double(imresize(I,param.imageSize));
if size(im,3) == 1
    im = repmat(im,[1 1 3]);
else
    im = im(:,:,[3 2 1]);
end
im = im - repmat(reshape(param.imageMean,1,1,[]),[param.imageSize 1]);

switch size(bbox,1)
    case 0
        nlabel = 0;
    case 1
        nlabel = 1;
    case 2
        nlabel = 2;
    case 3
        nlabel = 3;
    otherwise
        nlabel = 4;
end



function iou = getIOU(res,gt)

xmin = max(res(:,1),gt(1));
ymin = max(res(:,2),gt(2));
xmax = min(res(:,3),gt(3));
ymax = min(res(:,4),gt(4));

I = max((xmax-xmin+1),0).*max((ymax-ymin+1),0);
U = (res(:,3)-res(:,1)+1).*(res(:,4)-res(:,2)+1);
iou = I./U;

function inc = getINC(res,gt)

if isempty(res)
    inc = 0;
    return
end
xmin = max(res(:,1),gt(1));
ymin = max(res(:,2),gt(2));
xmax = min(res(:,3),gt(3));
ymax = min(res(:,4),gt(4));

I = max((xmax-xmin+1),0).*max((ymax-ymin+1),0);
U1 = (res(:,3)-res(:,1)+1).*(res(:,4)-res(:,2)+1);
U2 = (gt(3)-gt(1)+1)*(gt(4)-gt(2)+1);
inc1 = I./U1;
inc2 = I./U2;
inc = max(inc1,inc2);