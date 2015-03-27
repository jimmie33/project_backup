function evaluateJudd(folder,centerBias)

configData;

blobMap = [];
if centerBias
    blobx = repmat(abs([1:600]-300)',[1,600]);
    bloby = repmat(abs([1:600]-300),[600,1]);
    blobMap = (blobx.^2+bloby.^2).^0.5;
    blobMap = blobMap./(max(blobMap(:)));
    blobMap = 1-blobMap;
end

%%
model = {...
    struct('name','BMS_exp_split_labWT','ext','.png'),...
    };
for dataIdx = 1:numel(data)
    saveDir = fullfile(folder,data{dataIdx}.name);
    if ~exist(saveDir,'dir')
        mkdir(saveDir)
    end
    load(fullfile('GT',[data{dataIdx}.name, '_GT.mat']))
    sigma = data{dataIdx}.sigma;
    for modelIdx = 1:numel(model)
        if exist(fullfile(saveDir,[model{modelIdx}.name,'.mat']),'file')
            continue
        end
        salmapDir = fullfile('salmapsExp',data{dataIdx}.name,['output_', model{modelIdx}.name]);
        ext = model{modelIdx}.ext;
        auc = zeros(1,numel(sigma));
        terase = '';
        for i = 1:numel(auc)
            auc(i) = mean(computeMeanAUCJudd(fixMaps,salmapDir,ext,sigma(i),blobMap));
            tt = [num2str(i),': ',num2str(auc(i))];
            fprintf('%s',[terase,tt]);
            terase = repmat(sprintf('\b'),1,length(tt));
        end
        [maxauc idx] = max(auc);
        fprintf('%s',terase);
        fprintf('%s: %f\n; sigma: %f\n',data{dataIdx}.name, maxauc, sigma(idx));
        save(fullfile(saveDir,model{modelIdx}.name),'sigma','auc','-v7.3');
    end
end

%%
model = {...
    struct('name','AIM','ext','.png'),...
    struct('name','AWS','ext','.png'),...
    struct('name','BMS','ext','.png'),...
    struct('name','CAS','ext','.png'),...
    struct('name','GBVS','ext','.png'),...
    struct('name','HFT','ext','.png'),...
    struct('name','Itti2','ext','.png'),...
    struct('name','Judd','ext','.png'),...
    struct('name','JuddOrig','ext','.png'),...
    struct('name','LG','ext','.png'),...
    struct('name','MQDCT','ext','.png'),...
    struct('name','SigSal','ext','.png'),...
    };
for dataIdx = 1:numel(data)
    saveDir = fullfile(folder,data{dataIdx}.name);
    if ~exist(saveDir,'dir')
        mkdir(saveDir)
    end
    load(fullfile('GT',[data{dataIdx}.name, '_GT.mat']))
    sigma = data{dataIdx}.sigma;
    for modelIdx = 1:numel(model)
        if exist(fullfile(saveDir,[model{modelIdx}.name,'.mat']),'file')
            continue
        end
        salmapDir = fullfile('salmaps',data{dataIdx}.name,['output_', model{modelIdx}.name]);
        ext = model{modelIdx}.ext;
        auc = zeros(1,numel(sigma));
        terase = '';
        for i = 1:numel(auc)
            auc(i) = mean(computeMeanAUCJudd(fixMaps,salmapDir,ext,sigma(i),blobMap));
            tt = [num2str(i),': ',num2str(auc(i))];
            fprintf('%s',[terase,tt]);
            terase = repmat(sprintf('\b'),1,length(tt));
        end
        [maxauc idx] = max(auc);
        fprintf('%s',terase);
        fprintf('%s: %f\n; sigma: %f\n',data{dataIdx}.name, maxauc, sigma(idx));
        save(fullfile(saveDir,model{modelIdx}.name),'sigma','auc','-v7.3');
    end
end

