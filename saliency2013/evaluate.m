function evaluate(data, model)


for dataIdx = 1:numel(data)
    saveDir = fullfile('result/EFP',data{dataIdx}.name);
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