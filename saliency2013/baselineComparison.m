function record = baselineComparison()

configData;
model = {...
    struct('name','BMS_exp_split_rgb','ext','.png','color',1,'wt',0),...
    struct('name','BMS_exp_split_rgbWT','ext','.png','color',1,'wt',1),...
    struct('name','BMS_exp_split_lab','ext','.png','color',2,'wt',0),...
    struct('name','BMS_exp_split_labWT','ext','.png','color',2,'wt',1),...
    struct('name','BMS_exp_split_luv','ext','.png','color',4,'wt',0),...
    struct('name','BMS_exp_split_luvWT','ext','.png','color',4,'wt',1),...
    struct('name','BMS_exp_split_rgblabWT','ext','.png','color',3,'wt',1),...
    struct('name','BMS_exp_split_rgblabluvWT','ext','.png','color',7,'wt',1),...
    };


step = 8;
d1 = 7;
d2 = 9;
record = cell(1,numel(model));
for i = 1:numel(model)
    record{i}.info = sprintf('ID: %s, step: %d, d1: %d, d2: %d',model{i}.name,step,d1,d2);
    fprintf('%s\n',record{i}.info);
    fprintf('computing saliency maps ...\n');
    
%     cd ./model/BMS_exp
%     for dataIdx = 1:numel(data)
%         srcDir = fullfile('../../data',data{dataIdx}.name,'src/');
%         outDir = fullfile('../../salmapsExp',data{dataIdx}.name,['output_' model{i}.name '/']);
%         if ~exist(outDir,'dir')
%             mkdir(outDir)
%         end
%         cmd = sprintf('./BMS %s %s %d %d %d 9 1 0 %d %d', srcDir, outDir, ...
%             step, d1, d2, model{i}.color, model{i}.wt);
%         system(cmd);
%      end
%      cd ../../
end

evaluate(data,model);

bestIdx = 0;
bestAUCsum = 0;
for i = 1:numel(model)
    maxauc = zeros(1,numel(data));
    auc = [];
    for dataIdx = 1:numel(data)
        load(fullfile('result/EFP/',data{dataIdx}.name,model{i}.name));
        maxauc(dataIdx) = max(auc);
    end
    record{i}.maxauc = maxauc;
    if bestAUCsum < sum(maxauc)
        bestAUCsum = sum(maxauc);
        bestIdx = i;
    end
end

fprintf('best configuration: %s\n', record{bestIdx}.info);
for i = 1:numel(data)
    fprintf('%s: %f\n', record{bestIdx}.maxauc(i));
end