function [salmap cate] = getSBTSalmap(cropConf,feat,model)

predscore = applyModel(model,{double(feat)});
[~,cate] = max(mean(predscore(1:9,:))); 
score=predscore(:,cate);
idx = find(score>0);
salmap = zeros(size(cropConf{1}.msk));

for i = 1:numel(idx)
    salmap = salmap + cropConf{idx(i)}.msk;%*sqrt(sum(cropConf{idx(i)}.msk(:)));
end

countMap = zeros(size(cropConf{1}.msk));
for i = 1:numel(cropConf)
    countMap = countMap + cropConf{i}.msk;
end

salmap = salmap./countMap;
salmap = -salmap;
cate = cate-1;