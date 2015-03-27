configData;

M = zeros(numel(data),2);
xname = [];
for i = 1:numel(data)    
    xname{i}= data{i}.printName;
    load(fullfile('../result/EFP',data{i}.name,['BMS_exp_labWT']))
    M(i,1)=max(auc);
    load(fullfile('../result/EFP',data{i}.name,['BMS_exp_split_labWT']))
    M(i,2)=max(auc);    
end

bar(M);
axis([0 8 min(M(:))-0.01 max(M(:))+0.01])
    
set(gca,'XTickLabel',xname)
aa=get(gca,'XTickLabel');
bb=get(gca,'XTick');

set(gca,'XTickLabel',{});
th=text(bb,min(M(:))*ones(1,7)-0.02,aa,'HorizontalAlignment','left','rotation',-50);
set(th , 'fontsize', 12)
grid on
