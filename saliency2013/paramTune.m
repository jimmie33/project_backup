function record = paramTune()

configData;
model = {...
    struct('name','BMS_exp_split_labWT','ext','.png','color',2,'wt',1),...
    };
i = 1;
bestIdx = 0;
bestAUCsum = 0;
auc = [];
for step = [24 16 8]
    for d1 = 7%7
        for d2 = 9%9
        for dim = [200 300 400]
            d1 = max(round(7*dim/400),1);
            d2 = max(round(9*dim/400),1);
            blur = 9*dim/400;
            record{i}.info = sprintf('step: %d, d1: %d, d2: %d, dim: %d',step,d1,d2,dim);
            fprintf('%s\n',record{i}.info);
            fprintf('computing saliency maps ...\n');
            cd ./model/BMS_exp
            for dataIdx = 1:numel(data)
                srcDir = fullfile('../../data',data{dataIdx}.name,'src/');
                outDir = fullfile('../../salmapsExp/paramAnalysis',data{dataIdx}.name,'output_BMS_exp_split_labWT/');
                if ~exist(outDir,'dir')
                    mkdir(outDir)
                end
                cmd = sprintf('./BMS %s %s %d %d %d %f 1 0 2 1 %d', srcDir, outDir, step, d1, d2, blur, dim);
                system(cmd);
            end
            cd ../../
            fprintf('evaluating saliency maps ...\n')
            evaluate_(data, model);
            maxauc = zeros(1,numel(data));
            for dataIdx = 1:numel(data)
                load(fullfile('result/EFP/paramAnalysis',data{dataIdx}.name,'BMS_exp_split_labWT'));
                maxauc(dataIdx) = max(auc);
            end
            record{i}.maxauc = maxauc;
            if bestAUCsum < sum(maxauc)
                bestAUCsum = sum(maxauc);
                bestIdx = i;
            end
            save('result/EFP/paramAnalysis/record_step_dim','record');
            i = i+1;
        end
        end
    end
end
fprintf('best configuration: %s\n', record{bestIdx}.info);
end

%%
function evaluate_(data, model)

for dataIdx = 1:numel(data)
    saveDir = fullfile('result/EFP/paramAnalysis',data{dataIdx}.name);
    if ~exist(saveDir,'dir')
        mkdir(saveDir)
    end
    load(fullfile('GT',[data{dataIdx}.name, '_GT.mat']))
    sigma = data{dataIdx}.sigma;
    for modelIdx = 1:numel(model)
        if exist(fullfile(saveDir,[model{modelIdx}.name,'.mat']),'file')
            %continue
        end
        salmapDir = fullfile('salmapsExp/paramAnalysis',data{dataIdx}.name,['output_', model{modelIdx}.name]);
        ext = model{modelIdx}.ext;
        auc = zeros(1,numel(sigma));
        terase = '';
        for i = 1:numel(auc)
            auc(i) = mean(computeMeanAUC(fixMaps,overallFixMap,salmapDir,ext,sigma(i)));
            tt = [num2str(i),': ',num2str(auc(i))];
	    fprintf('%s',[terase,tt]);
	    terase = repmat(sprintf('\b'),1,length(tt));
        end
        fprintf('%s',terase);
        fprintf('%s: %f\n',data{dataIdx}.name, max(auc));
        save(fullfile(saveDir,model{modelIdx}.name),'sigma','auc','-v7.3');
    end
end
end