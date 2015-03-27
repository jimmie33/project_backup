addpath('../')
configData;
configModel;

for i = 1:numel(data)
    subplot(2,4,i);
    aucCache = zeros(numel(model),2);
    xname = {};
    for j = 1:numel(model)
        load(fullfile('../result/EFP_Judd/noCB',data{i}.name,model{j}.name));
        aucCache(j,1) = max(auc);
        load(fullfile('../result/EFP_Judd/withCB',data{i}.name,model{j}.name));
        aucCache(j,2) = max(auc);
        xname{j} = model{j}.printName;
    end
    bar(aucCache)
    title(data{i}.printName)
    ymin = min(aucCache(:))-0.05;
    ymax = max(aucCache(:))+0.03;
    axis([0 13 ymin ymax])
    grid on
    
    set(gca,'XTickLabel',xname);
    aa=get(gca,'XTickLabel');
    bb=get(gca,'XTick');
    cc=get(gca,'YTick');
    set(gca,'XTickLabel',{});
    th=text(bb,(min(aucCache(:))-0.05)*ones(1,length(bb))-0.03*(ymax-ymin),aa,'HorizontalAlignment','left','rotation',-50);
%     set(th , 'fontsize' , 10);
end