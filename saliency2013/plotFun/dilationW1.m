configData;
plotSetting;

subplot(2,2,1)
load(fullfile('../result/EFP/paramAnalysis/record_d1'));
M = [];
name = [];
for i =1:numel(record)
    M = [M;record{i}.maxauc];
end
M = M(:,[1 2 5 4 3 7 6]);
x = 1:2:11;
for i = 1:numel(data)
    name{i} = data{i}.printName;
    plot(x',M(:,i),plotDrawStyle{i}.lineStyle,'color',plotDrawStyle{i}.color,'linewidth',2)
    hold on
end

ymin = min(M(:))-0.01;
ymax = max(M(:))+0.01;
axis([1,11,min(M(:))-0.01,max(M(:))+0.01])
h=xlabel('\omega');
set(h,'fontsize',13)
set(gca,'XTick',1:2:11)
grid on
subplot(2,2,2)


load(fullfile('../result/EFP/paramAnalysis/record_d2'));
M = [];
for i =1:numel(record)
    M = [M;record{i}.maxauc];
end
M = M(:,[1 2 5 4 3 7 6]);
x = 1:2:11;
for i = 1:numel(data)
    plot(x',M(:,i),plotDrawStyle{i}.lineStyle,'color',plotDrawStyle{i}.color,'linewidth',2)
    hold on
end

axis([1,11,ymin,ymax])
h = xlabel('\kappa');
set(h,'fontsize',13)
set(gca,'XTick',1:2:11)
grid on
legend(name)