addpath('../');
configData;
configModel;


for i=1:numel(data)
    resdir = fullfile('../result/EFP/',data{i}.name);
    load(fullfile('../GT/',[data{i}.name '_GT']))
    score = nan(numel(fixMaps),numel(model));
    for j = 1:numel(model)
        load(fullfile(resdir,model{j}.name));
        [~, idx] = max(auc);
        sigma = sigma(idx);
        if j ~= numel(model)
            salmapDir = fullfile('../salmaps',data{i}.name,['output_' model{j}.name]);
        else
            salmapDir = fullfile('../salmapsExp',data{i}.name,['output_' model{j}.name]);
        end
        auc = computeMeanAUC(fixMaps,overallFixMap,salmapDir,'.png',sigma);
        score(:,j) = auc(:);
    end
    save(data{i}.name,'score');
end