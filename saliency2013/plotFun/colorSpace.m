colorspace = {'rgb','luv','lab'};
configData;

for i = 1:numel(data)
    subplot(2,4,i)
    M = zeros(numel(colorspace),2);
    for j = 1:numel(colorspace)
        load(fullfile('../result/EFP',data{i}.name,['BMS_exp_split_' colorspace{j}]))
        M(j,1)=max(auc);
        load(fullfile('../result/EFP',data{i}.name,['BMS_exp_split_' colorspace{j} 'WT']))
        M(j,2)=max(auc);
    end
    
    bar(M);
    axis([0 4 min(M(:))-0.01 max(M(:))+0.01])
    
    set(gca,'XTickLabel',{'RGB' 'LUV' 'Lab'})
    aa=get(gca,'XTickLabel');
    bb=get(gca,'XTick');

    set(gca,'XTickLabel',{});
    th=text(bb,min(M(:))*ones(1,3)-0.01-0.1*( max(M(:))-min(M(:))),aa,'HorizontalAlignment','left','rotation',-50);

    grid on
    title(data{i}.printName)
    
end