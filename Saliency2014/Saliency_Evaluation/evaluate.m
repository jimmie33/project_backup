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
    for idxModel = 1:numel(models)
        modelName = models{idxModel}.name;
        resultFullPath = fullfile('Results',dataName,[modelName,'.mat']);
        if ~exist(resultFullPath,'file')
            eval(['[recall,precision,FP,TP,Fb,auc,weightedFb,AE,adtPrecision,adtRecall,adtFb,aAE]',...
                '=getScores(fullfile(''Salmaps'',dataName,[''output_'',modelName]),models{idxModel}.ext,',...
                'fullfile(''GT'',dataName),data_ext);']);
            save(resultFullPath,'recall','precision','FP','TP','Fb','auc',...
                'weightedFb','AE','adtPrecision','adtRecall','adtFb','aAE','-v7.3');
        end
        load(resultFullPath)
        if show
            plot(mean(recall,1),mean(precision,1),'color',plotDrawStyle{idxModel}.color,...
            	'lineStyle',plotDrawStyle{idxModel}.lineStyle,'lineWidth',2);
        end
        fprintf('%s: %f %f %f %f %f\n',modelName, auc, mean(adtFb), mean(AE), min(mean(aAE)), mean(weightedFb));
    end
    if show
        grid on
        modelsCell = cell2mat(models);
        title(dataName)
        xlabel('Recall')
        ylabel('Precision')
        name = {modelsCell.name};
        legend(name,'Location','SouthWest','Interpreter', 'none')
    end
end



