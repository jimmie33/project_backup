clear

show = true;
datasets = configData();
models = configModel();
plotSetting;

if show
    close all
end

for idxData = 1:numel(datasets)
    if show
        figure
        hold on
    end
    
    dataName = datasets{idxData}.name;
    data_ext = datasets{idxData}.gt_ext;
    if ~exist(fullfile('Results',dataName),'dir')
        mkdir(fullfile('Results',dataName))
    end
    fprintf('\n%s\n',dataName);
    
    overallWFb = nan(1,numel(models));
    for idxModel = 1:numel(models)-1
        modelName = models{idxModel}.name;
        resultFullPath = fullfile('Results',dataName,[modelName,'.mat']);
        load(resultFullPath)
        overallWFb(idxModel) = mean(AE);
        fprintf('%s: %f %f %f %f %f\n',modelName, auc, mean(adtFb), mean(AE), min(mean(aAE)), mean(weightedFb));
    end
    %% for our method
    modelName = models{end}.name;
    resultFullPath = fullfile('Results',dataName,[modelName,'.mat']);
    load(resultFullPath)
    overallWFb(end) = mean(AE);
    fprintf('%s: %f %f %f %f %f\n',modelName, auc, mean(adtFb), mean(AE), min(mean(aAE)), mean(weightedFb));
    
    if show
        grid on
        modelsCell = cell2mat(models);
        title(datasets{idxData}.printName)
        bar(overallWFb)
        ylabel('Weighted F Metric')
        name = {modelsCell.name};
        name = [name(1:end-1) 'Ours']
        set(gca,'xTick' , 1:length(name));
        set(gca,'xTickLabel', {});
        set(gca,'XTickLabel',name);
    end
end