clear
close all
datasets = configData();
models = configModel();
plotSetting;

blobx = repmat(abs([1:600]-300)',[1,600]);
bloby = repmat(abs([1:600]-300),[600,1]);
blobMap = (blobx.^2+bloby.^2).^0.5;
blobMap = blobMap./(max(blobMap(:)));
blobMap = 1-blobMap;

% blobMap = exp(-(blobx.^2+bloby.^2).^2/50000000);
% blobMap = blobMap - min(blobMap(:));
% blobMap = blobMap/max(blobMap(:));

for idxData = 1:numel(datasets)
    figure
    hold on
    dataName = datasets{idxData}.name;
    if ~exist(fullfile('Results',dataName),'dir')
        mkdir(fullfile('Results',dataName))
    end
    for idxModel = 1:numel(models)
        modelName = models{idxModel}.name;
        resultFullPath = fullfile('Results',dataName,[modelName,'.mat']);
        if ~exist(resultFullPath,'file')
            eval(['[recall,precision,~,~]=getPR_',dataName,'(fullfile(''Salmaps'',dataName,[''output_'',modelName]),models{idxModel}.ext);']);
            save(resultFullPath,'recall','precision','-v7.3');
        end
        load(resultFullPath)
        plot(mean(recall),mean(precision),'color',plotDrawStyle{idxModel}.color,...
            'lineStyle',plotDrawStyle{idxModel}.lineStyle,'lineWidth',2);
    end
    %% blob baseline
    modelName = 'blobBaseline';
    eval(['[recall,precision,~,~]=getPR_',dataName,'(fullfile(''Salmaps'',dataName,[''output_'',''BMS_WS'']),''.png'',blobMap*1);']);
    plot(mean(recall),mean(precision),'color',plotDrawStyle{numel(models)+1}.color,...
        'lineStyle',plotDrawStyle{numel(models)}.lineStyle,'lineWidth',2);
    %%
    grid on
    modelsCell = cell2mat(models);
    title(dataName)
    xlabel('Recall')
    ylabel('Precision')
    name = {modelsCell.name};
    legend([name,'GuassianBlob'],'Location','SouthWest','Interpreter', 'none')
end