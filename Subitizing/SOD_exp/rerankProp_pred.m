function rerankProp_pred(propDir,outDir,salDir,predName)

for i = 0:4
    load(fullfile('img',['imgList_' num2str(i)]));
    load(fullfile('img',[predName '_' num2str(i)]));
    for fileIdx = 1:numel(imgList)
        [~,name,~] = fileparts(imgList{fileIdx});
        I = imread(fullfile('img',num2str(i),imgList{fileIdx}));
        salmap = imread(fullfile(salDir,num2str(i),[name '.png']));
        salmap = im2double(imresize(salmap,[size(I,1) size(I,2)]));
        p = pred(fileIdx);
        load(fullfile(propDir,num2str(i),name));
        
        boxes = rerank_sal(boxes,salmap,p);
%         if i == 2
%             [rects] = getBestCombo(['2/' name],2,false);
%             boxes = [rects;boxes];
%         end
        
        if ~exist(fullfile(outDir,num2str(i)),'dir')
            mkdir(fullfile(outDir,num2str(i)));
        end
        
        save(fullfile(outDir,num2str(i),name),'boxes','p');
    end
end

%%

function boxes = rerank_sal(boxes,salmap,cate)

if cate~=1
    return
end

topN = min(100,size(boxes,1));

score_sum = nan(size(boxes,1),1);
area = nan(size(boxes,1),1);
for i = 1:topN
    salpatch = salmap(round(boxes(i,2):boxes(i,4)),round(boxes(i,1):boxes(i,3)));
%     bwpatch = bwmap(round(boxes(i,2):boxes(i,4)),round(boxes(i,1):boxes(i,3)));
    score_sum(i) = sum(salpatch(:));
    area(i) = numel(salpatch);
%     score_bw_sum(i) = sum(bwpatch(:));
%     score_bw_mean(i) = mean(bwpatch(:));
end
score_sum = score_sum/sum(salmap(:));
[~,idx] = sort(area,'ascend');
iidx = find(score_sum(idx) > 0.9);
if isempty(iidx)
    return
end

bestBox = boxes(idx(iidx(1)),:);

boxTop = boxes(1:topN,:);
iou = getIOU(boxTop,bestBox);
[~,iid] = max(iou);
if iou(iid)>0.5
    [~,iid] = max(iou);
    cand = boxes(iid,:); boxes(iid,:)=[];
    boxes = [cand;boxes];
end



%% put the con. components first
% bwmap = salmap > graythresh(salmap);
% 
% boxTop = [boxes(1:topN,:),[1:topN]'];
% selectedIdx = [];
% for iCom = 1:numel(size(S_bb,1))
%     iou = getIOU(boxTop,S_bb(iCom,:));
%     [~,iid] = max(iou);
%     if iou(iid)>0.5
%         selectedIdx = boxTop(iid,end);
%         boxTop(iid,:) = [];
%     end
% end
% iid = 1:topN; iid(selectedIdx)=[];
% boxes(1:topN,:) = boxes([selectedIdx' iid],:);






%%






% 
% 
% bwmap = salmap > 0.5;%graythresh(salmap);
% score_sum = nan(size(boxes,1),1);
% score_mean = nan(size(boxes,1),1);
% for i = 1:size(boxes,1)
%     salpatch = salmap(round(boxes(i,2):boxes(i,4)),round(boxes(i,1):boxes(i,3)));
% %     bwpatch = bwmap(round(boxes(i,2):boxes(i,4)),round(boxes(i,1):boxes(i,3)));
%     score_sum(i) = sum(salpatch(:));
%     score_mean(i) = mean(salpatch(:));
% %     score_bw_sum(i) = sum(bwpatch(:));
% %     score_bw_mean(i) = mean(bwpatch(:));
% end
% % [~,idx] = sort(score,'descend');
% score_sum = score_sum/sum(salmap(:));
% % score_bw_sum = score_bw_sum/sum(bwmap(:));
% 
% if cate == 1
%     score = 1*score_sum + 0.5*score_mean+boxes(:,5);
%     [score,idx] = sort(score(1:50),'descend');
%     boxes(1:50,:) = boxes(idx,:);  
% %     tmpMap = zeros(size(salmap));
% %     for jj = 1:5
% %         tmpMap(round(boxes(jj,2):boxes(jj,4)),round(boxes(jj,1):boxes(jj,3)))=...
% %             tmpMap(round(boxes(jj,2):boxes(jj,4)),round(boxes(jj,1):boxes(jj,3)))+1;
% %     end
% %     idd = find(tmpMap > 2);
% %     if ~isempty(idd)
% %         [r, c] = ind2sub(size(salmap),idd);
% %         priorBox = [min(c) min(r) max(c) max(r)];
% %         iou = getIOU(boxes,priorBox);
% %         score = iou + boxes(:,end);
% %     end
% %     [score,idx] = sort(score,'descend');
% %     boxes = boxes(idx,:);
%     
% elseif cate == 2
% 
% end




