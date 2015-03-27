function rerankProp_gt(propDir,outDir,salDir)

for i = 0:4
    load(fullfile('img',['imgList_' num2str(i)]));
    for fileIdx = 1:numel(imgList)
        [~,name,~] = fileparts(imgList{fileIdx});
        I = imread(fullfile('img',num2str(i),imgList{fileIdx}));
        salmap = imread(fullfile(salDir,num2str(i),[name '.png']));
        salmap = im2double(imresize(salmap,[size(I,1) size(I,2)]));
        
        load(fullfile(propDir,num2str(i),name));
        
        boxes = rerank_sal(boxes,salmap,i);
%         if i == 2
%             [rects] = getBestCombo(['2/' name],2,false);
%             boxes = [rects;boxes];
%         end
        
        if ~exist(fullfile(outDir,num2str(i)),'dir')
            mkdir(fullfile(outDir,num2str(i)));
        end
        save(fullfile(outDir,num2str(i),name),'boxes');
    end
end

%%

function boxes = rerank_sal(boxes,salmap,cate)

topN = min(100,size(boxes,1));
%% put the con. components first
bwmap = salmap > graythresh(salmap);

S = regionprops(bwmap,'BoundingBox');
S_bb = reshape([S.BoundingBox],4,[])';
S_bb_area = S_bb(:,3).*S_bb(:,4);
[~,S_bb_idx] = sort(S_bb_area,'descend');
S_bb = S_bb(S_bb_idx,:);
S_bb(:,3:4) = S_bb(:,3:4) + S_bb(:,1:2)-1;

boxTop = [boxes(1:topN,:),[1:topN]'];
selectedIdx = [];
for iCom = 1:numel(size(S_bb,1))
    iou = getIOU(boxTop,S_bb(iCom,:));
    [~,iid] = max(iou);
    if iou(iid)>0.5
        selectedIdx = boxTop(iid,end);
        boxTop(iid,:) = [];
    end
end
iid = 1:topN; iid(selectedIdx)=[];
boxes(1:topN,:) = boxes([selectedIdx' iid],:);

% 
% 
% for i = 1:size(boxes,1)
%     salpatch = salmap(round(boxes(i,2):boxes(i,4)),round(boxes(i,1):boxes(i,3)));
%     bwpatch = bwmap(round(boxes(i,2):boxes(i,4)),round(boxes(i,1):boxes(i,3)));
%     score_sum(i) = sum(salpatch(:));
%     score_mean(i) = mean(salpatch(:));
%     score_bw_sum(i) = sum(bwpatch(:));
%     score_bw_mean(i) = mean(bwpatch(:));
% end
% % [~,idx] = sort(score,'descend');
% score_sum = score_sum/sum(salmap(:));
% score_bw_sum = score_bw_sum/sum(bwmap(:));
% 
% if cate == 1
%     score = 1*score_sum' + 0.5*score_mean'+0*score_bw_sum'+0*score_bw_mean'+0*boxes(:,end);
%     [score,idx] = sort(score(1:40),'descend');
%     boxes(1:40,:) = boxes(idx,:);  
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
% %     score = 1*score_sum' + 0.5*score_mean'+boxes(:,end);
% %     [~,idx] = sort(score,'descend');
% %     boxes = boxes(idx,:);
% 
%     S = regionprops(bwmap,'BoundingBox');
%     S_bb = reshape([S.BoundingBox],4,[])';
%     S_bb_area = S_bb(:,3).*S_bb(:,4);
%     [~,S_bb_idx] = sort(S_bb_area,'descend');
%     S_bb = S_bb(S_bb_idx,:);
%     S_bb(:,3:4) = S_bb(:,3:4) + S_bb(:,1:2)-1;
% %     
% %     tmpScore = [];
% %     for bIdx=1:min(3,size(S_bb_idx,1))
% %         tmpScore (:,end+1) = getIOU(boxes,S_bb(bIdx,:));
% %     end
% %     score = max(tmpScore,[],2) + boxes(:,end);
% %     [score,idx] = sort(score,'descend');
% %     boxes = boxes(idx,:);
% 
%     %% clustering
%     nCluster = size(S_bb,1);
%     score = score_sum' + 0.5*score_mean'+boxes(:,end);
% %     [~,idx] = sort(score,'descend');
%     tmpboxes = [boxes score [1:size(boxes,1)]'];
%     clster = [];
%     for clIdx = 1:nCluster
% %         [~, iiidx] = max(tmpboxes(:,end-1));%max by score
%         seed = S_bb(clIdx,:);%tmpboxes(iiidx,:);
%         iou = getIOU(tmpboxes,seed);
%         clster(clIdx).boxIdx = tmpboxes(iou>0.7,end);%store index
%         clster(clIdx).len = numel(clster(clIdx).boxIdx);
%         tmpboxes(iou>0.7,:) = [];
%         if isempty(tmpboxes)
%             break
%         end
%     end
%     if ~isempty(tmpboxes)
%         clster(end+1).boxIdx = tmpboxes(:,end);
%         clster(end).len = numel(clster(end).boxIdx);
%     end
%     %% assemble
%     maxlen = max([clster.len]);
%     tmpM = zeros(numel(clster),maxlen);
%     for kkk = 1:size(tmpM,1)
%         tmpM(kkk,1:numel(clster(kkk).boxIdx)) = clster(kkk).boxIdx';
%     end
%     tmpM = tmpM(:); tmpM(tmpM==0) = [];
%     boxes = boxes(tmpM,:);
% end




