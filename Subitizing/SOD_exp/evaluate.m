function [P,R,F,TP,FP,nDet,nInst] = evaluate(name,iouThresh)

TP = [];
FP = [];
nDet = [];
nInst = [];

for i=0:4
    load(fullfile('img',['imgList_' num2str(i)]));
    load(fullfile('results',['rectList_' num2str(i) '_' name]));
    
    for imgIdx = 1:numel(imgList)
        [~,imgname,~] = fileparts(imgList{imgIdx});
        det = rectList{imgIdx};
        if i == 0
            TP(end+1,:) = 0;
            FP(end+1,:) = size(det,1);
            nDet(end+1) = size(det,1);
            nInst(end+1) = 0;
            continue;
        end
        load(fullfile('gt',num2str(i),imgname));
        
        det(:,3:4) = det(:,3:4)+det(:,1:2)-1;% transform to [xmin ymin xmax ymax]
        
        if isempty(det)
            TP(end+1,:) = zeros(1,numel(iouThresh));
            FP(end+1,:) = zeros(1,numel(iouThresh));
            nInst(end+1) = size(anno,1);
            continue;
        end
        
        %% Greedy matching
        matched_score = []; % first: gt, second, det
        tmpDet = det;
        for gtIdx = 1:size(anno,1)
            iou = getIOU(tmpDet,anno(gtIdx,:));
            if max(iou) == 0
                continue
            end
            if isempty(iou)
                keyboard
            end
            [~,idx] = max(iou);
            matched_score(end+1) = iou(idx);
            tmpDet(idx,:) = [];
            if isempty(tmpDet)
                break
            end
        end
        
        %% 
        TP(end+1,:) = sum(repmat(matched_score(:),[1 numel(iouThresh)])>repmat(iouThresh,[numel(matched_score),1]),1);
        FP(end+1,:) = size(det,1) - TP(end,:);
        nDet(end+1) = size(det,1);
        nInst(end+1) = size(anno,1);
    end
end

P = sum(TP,1)/sum(nDet);
R = sum(TP,1)/sum(nInst);
F = 2*P.*R./max((P+R),eps);


function iou = getIOU(res,gt)

xmin = max(res(:,1),gt(1));
ymin = max(res(:,2),gt(2));
xmax = min(res(:,3),gt(3));
ymax = min(res(:,4),gt(4));

I = max((xmax-xmin+1),0).*max((ymax-ymin+1),0);
U = (res(:,3)-res(:,1)+1).*(res(:,4)-res(:,2)+1)+(gt(3)-gt(1)+1)*(gt(4)-gt(2)+1);
iou = I./(U-I);
