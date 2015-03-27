function showKMeansBBox(feat,feat_pp,center,pivot_center,topN)
load imgIdx
load testIdx

% testIdx = ~testIdx;

feat = feat(testIdx,:);
feat_pp = feat_pp(testIdx,:);
label = [imgIdx.label];
label = label(testIdx);

filename = {imgIdx.name};
filename = filename(testIdx);

idx = randperm(numel(filename));

feat = feat(idx,:);
feat_pp = feat_pp(idx,:);
filename = filename(idx);
label = label(idx);
pp_idx_tab = getIdxTab(size(pivot_center,2));
cmap = colormap(lines(10));
for i = 1:12:numel(filename)
    for j = 0:11
        im = imread(fullfile('overall',filename{i+j}));
        subplot(3,4,floor(j/4)*4+mod(j,4)+1), imshow(im);
        tmpfeat = feat(i+j,:);
        tmpfeat = (reshape(tmpfeat, [], 2));
        tmpfeat = exp(tmpfeat);
        tmpfeat = bsxfun(@times,tmpfeat,1./sum(tmpfeat,2));
        [score, iidx] = sort(tmpfeat(:,2),'descend');
        N = label(i+j);
        bboxes = center(:,iidx);
        bboxes_ = bboxes;
        bb_scores_ = score;
        bboxes = bsxfun(@times,bboxes,[size(im,2);size(im,1);size(im,2);size(im,1)]);
        bboxes([3 4],:) = bboxes([3 4],:)-bboxes([1 2],:)+1;
        for k = 1:label(i+j)
            rectangle('position',bboxes(:,k),'edgecolor',[1 0 0], 'linewidth', 2);
        end
        tmpfeat = feat_pp(i+j,:);
        tmpfeat = (reshape(tmpfeat, [], 2));
        tmpfeat = exp(tmpfeat);
        tmpfeat = bsxfun(@times,tmpfeat,1./sum(tmpfeat,2));
        pp_score_tab_ = zeros(size(pp_idx_tab));
        for k = 1:size(tmpfeat,1)
            pp_score_tab_(pp_idx_tab == k) = tmpfeat(k,2);
        end
        
        %opt_bboxes = getOptBBoxes(bboxes_,bb_scores_,pivot_center,pp_score_tab_,label(i+j));
        
        [~, pp_idx] = sort(tmpfeat(:,2),'descend');
        
        hold on;
        if N > 1
            for k = 1:N-1
                dd = find(pp_idx_tab == pp_idx(k));
                dd = dd(1);
                [ii jj] = ind2sub(size(pp_idx_tab),dd);
                pp = pivot_center(:,[ii jj]);
                pp(1,:) = pp(1,:)*size(im,2);
                pp(2,:) = pp(2,:)*size(im,1);
                plot(pp(1,:)+rand(1,2)*5,pp(2,:)+rand(1,2)*5,'-+',...
                    'LineWidth',2,'Markersize',10,'MarkerEdgeColor',cmap(k,:),...
                    'color',cmap(k,:));
            end
        end
        hold off
    end
    pause
end

function idx_tab = getIdxTab(N)

idx_tab = zeros(N);
count = 1;
for i = 1:N
    for j = 1:N
        if j>=i
            idx_tab(i,j) = count;
            count = count+1;
        else
            idx_tab(i,j) = idx_tab(j,i);
        end
    end
end