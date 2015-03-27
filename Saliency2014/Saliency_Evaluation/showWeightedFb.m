clear

show = true;
datasets = configData();
models = configModel();
plotSetting;

if show
%     close all
end

for idxData = 1:numel(datasets)
    if show
%         figure
        hold on
    end
    
    dataName = datasets{idxData}.name;
    data_ext = datasets{idxData}.gt_ext;
    if ~exist(fullfile('Results',dataName),'dir')
        mkdir(fullfile('Results',dataName))
    end
    fprintf('\n%s\n',dataName);
    
    overallWFb = nan(1,numel(models));
    for idxModel = 1:numel(models)
        modelName = models{idxModel}.name;
        resultFullPath = fullfile('Results',dataName,[modelName,'.mat']);
        load(resultFullPath)
        overallWFb(idxModel) = mean(weightedFb);
        fprintf('%s: %f %f %f %f %f\n',modelName, auc, mean(adtFb), mean(AE), min(mean(aAE)), mean(weightedFb));
    end
    %% for our method
%     modelName = models{end}.name;
%     resultFullPath = fullfile('Results',dataName,[modelName,'.mat']);
%     load(resultFullPath)
%     overallWFb(end) = mean(weightedFb);
%     fprintf('%s: %f %f %f %f %f\n',modelName, auc, mean(adtFb), mean(AE), min(mean(aAE)), mean(weightedFb));
    
    if show
        subplot(2,4,idxData+4)
        modelsCell = cell2mat(models);

        bar(overallWFb)
        axis([0,length(models)+1,0,max(overallWFb)+0.1]);
        ylabel('Weighted-F_\beta')
        name = {modelsCell.printName};
%         name = [name(1:end-1) 'Ours'];
        set(gca,'xTick' , 1:length(name));
        set(gca,'xTickLabel', {});
        set(gca,'XTickLabel',name);
        grid on
        title(datasets{idxData}.printName)
    end
end