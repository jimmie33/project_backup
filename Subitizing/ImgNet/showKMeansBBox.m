function showKMeansBBox(feat_pp,pivot_center,topN)
load trainValImgIdx


% testIdx = ~testIdx;


idx = randperm(numel(valImgIdx));
feat_pp = feat_pp(idx,:);
valImgIdx = valImgIdx(idx);
pp_idx_tab = getIdxTab(size(pivot_center,2));
cmap = colormap(lines(10));
for i = 1:12:numel(valImgIdx)
    for j = 0:11
        im = imread(valImgIdx(i+j).path(59:end));
        subplot(3,4,floor(j/4)*4+mod(j,4)+1), imshow(im);
        tmpfeat = feat_pp(i+j,:);
        tmpfeat = (reshape(tmpfeat, [], 2));
%         tmpfeat = exp(tmpfeat);
%         tmpfeat = bsxfun(@times,tmpfeat,1./sum(tmpfeat,2));
        [~, pp_idx] = sort(tmpfeat(:,2),'descend');
        hold on;
        if valImgIdx(i+j).nObj > 1
            for k = 1:min(valImgIdx(i+j).nObj-1,2)+1
                dd = find(pp_idx_tab == pp_idx(k));
                dd = dd(1);
                [ii jj] = ind2sub(size(pp_idx_tab),dd);
                pp = pivot_center(:,[ii jj]);
                pp = pp+(rand(size(pp))*0.05);
                pp(1,:) = pp(1,:)*size(im,2);
                pp(2,:) = pp(2,:)*size(im,1);
                plot(pp(1,:),pp(2,:),'-+',...
                    'LineWidth',2,'Markersize',10,'MarkerEdgeColor',cmap(k,:),...
                    'color', cmap(k,:));
            end
        end
        bbox = valImgIdx(i+j).anno;
        bbox(:,[3 4]) = bbox(:,[3 4]) - bbox(:,[1 2])+1;
        for k = 1:valImgIdx(i+j).nObj
            rectangle('Position',bbox(k,:),'linewidth',2);
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