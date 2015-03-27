function [im cLabel stateLabel toCont] = getGT_Rec(imgIdx,param,doTF)

[I cmap] = imread(imgIdx.path(59:end));
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
bbox = imgIdx.anno;
cLabel = zeros(size(param.center,2),1);
toCont = 0;
stateLabel = zeros(size(param.center,2),1);

if param.randomCrop
    if isempty(bbox)
        newsz = round((0.5+rand(1, 2)*0.5).*sz);%0.5-1 original width or height
        upleft = round(rand(1,2).*(sz-newsz));
        roi = [upleft, newsz+upleft-1];
        roi([1,2]) = max(roi([1,2]),1);
        roi([3,4]) = min([roi([3,4]);sz]); 
        I = I(roi(1):roi(3), roi(2):roi(4),:);
    else
        if size(bbox,1) == 1
            bboxid = randi([1 size(bbox,1)],1);
            selbbox = round(bbox(bboxid,:));
        else % for more than two object, make sure the crop includes at least two
            bboxid = randsample(size(bbox,1),2);
            selbbox = round(bbox(bboxid,:));
            selbbox = [min(selbbox(:,1:2)) max(selbbox(:,3:4))];
        end
        selbbox(1:2) = max(selbbox(1:2),1);
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
        bbox = bsxfun(@plus, bbox, -roi([2 1 2 1])) + 1;
        bbox(:,[1 2]) = max(bbox(:, [1 2]),1);
        bbox(:,3) = min(bbox(:,3),size(I,2));
        bbox(:,4) = min(bbox(:,4),size(I,1));
    end
end
if ~isempty(bbox)
    bbox = bsxfun(@times, bbox, 1./sz([2 1 2 1]));
    [~,idx] = min(vl_alldist(bbox',param.center),[],2);
    cLabel(idx) = 1;
    toCont = 1;
    if doTF
        [cLabel stateLabel toCont] = getTFGT(cLabel);
    end
end

im = double(imresize(I,param.imageSize));
im = im(:,:,[3 2 1]);
im = im - repmat(reshape(param.imageMean,1,1,[]),[param.imageSize 1]);


function iou = getIOU(res,gt)

xmin = max(res(:,1),gt(1));
ymin = max(res(:,2),gt(2));
xmax = min(res(:,3),gt(3));
ymax = min(res(:,4),gt(4));

I = max((xmax-xmin+1),0).*max((ymax-ymin+1),0);
U = (res(:,3)-res(:,1)+1).*(res(:,4)-res(:,2)+1);
iou = I./U;


function [cLabel stateLabel toCont] = getTFGT(cLabel)
stateLabel = zeros(size(cLabel));

% decide the num of the predicted
nPred = randi(sum(cLabel));

% decide toCont
if nPred >= sum(cLabel)
    toCont = 0;
else
    toCont = 1;
end

% decide which is predicted
gtIdx = find(cLabel == 1);
emptyIdx = find(cLabel == 0);

tmpIdx = randperm(numel(gtIdx));
predIdx = gtIdx(tmpIdx(1:nPred));
stateLabel(predIdx) = 1;
cLabel(predIdx) = 0;

% decide if to add noise in stateLabel
if rand(1) > 0.9
    nNoise = randi(2);
    tmpIdx = randperm(numel(emptyIdx));
    stateLabel(emptyIdx(tmpIdx(1:nNoise))) = 1;
end






