addpath('../')
configData;
configModel;
plotSetting;

for i = 1:numel(data)
    subplot(2,4,i);
    aucCache = [];
    if i == 1
        xlabel('\sigma')
        ylabel('sAUC')
    end
    
    for j = 1:numel(model)
        load(fullfile('../result/EFP',data{i}.name,model{j}.name));
        aucCache=[aucCache;auc];
        plot(sigma,auc,plotDrawStyle{j}.lineStyle,'color',plotDrawStyle{j}.color,'linewidth',2);
        hold on
    end
    axis([0 0.12 min(aucCache(:))-0.02 max(aucCache(:))+0.02])
    title(data{i}.name)
    grid on
end