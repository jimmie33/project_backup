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
        subplot(2,4,idxData+4)
        hold on
    end
    
    dataName = datasets{idxData}.name;
    data_ext = datasets{idxData}.gt_ext;
    if ~exist(fullfile('Results',dataName),'dir')
        mkdir(fullfile('Results',dataName))
    end
    fprintf('\n%s\n',dataName);
    for idxModel = 1:numel(models)
        modelName = models{idxModel}.name;
        resultFullPath = fullfile('Results',dataName,[modelName,'.mat']);
        load(resultFullPath)
        if show
            plot(mean(recall,1),mean(precision,1),'color',plotDrawStyle{numel(models)+1-idxModel}.color,...
            	'lineStyle',plotDrawStyle{numel(models)+1-idxModel}.lineStyle,'lineWidth',2);
        end
        fprintf('%s: %f %f %f %f %f\n',modelName, auc, mean(adtFb), mean(AE), min(mean(aAE)), mean(weightedFb));
    end
    %% for our method
%     modelName = models{end}.name;
%     resultFullPath = fullfile('Results',dataName,[modelName,'.mat']);
%     load(resultFullPath)
%     if show
%         plot(mean(recall,1),mean(precision,1),'color',plotDrawStyle{1}.color,...
%         	'lineStyle',plotDrawStyle{1}.lineStyle,'lineWidth',3);
%     end
%     fprintf('%s: %f %f %f %f %f\n',modelName, auc, mean(adtFb), mean(AE), min(mean(aAE)), mean(weightedFb));
    
    if show
%         subplot(1,4,idxData)
        grid on
        modelsCell = cell2mat(models);
        title(datasets{idxData}.printName,'fontsize',18)
        xlabel('Recall','fontsize',18)
        ylabel('Precision','fontsize',18)
        name = {modelsCell.printName};
%         name = [name(1:end-1) 'Ours']
        if idxData == 4
            legend(name,'Location','SouthWest','Interpreter', 'none')
        end
        set(gca,'xTick',[0:0.2:1])
        set(gca,'yTick',[0:0.2:1])
        set(gca,'fontsize',18)
    end
end