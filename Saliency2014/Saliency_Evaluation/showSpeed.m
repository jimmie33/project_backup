clear

show = true;
datasets = configData();
models = configModel();
plotSetting;

if show
    close all
end

speed = zeros(1,numel(models));
for idxModel = 1:numel(models)
    speed(idxModel) = models{idxModel}.speed;
end

bar(speed)
ylabel('FPS')
modelsCell = cell2mat(models);
name = {modelsCell.printName};
% name = [name(1:end-1) 'Ours'];
set(gca,'xTick' , 1:length(name));
set(gca,'xTickLabel', {});
set(gca,'XTickLabel',name);
axis([0,11,0,120])
text([1:10]',speed',num2str(speed','%d'),... 
'HorizontalAlignment','center',... 
'VerticalAlignment','bottom')
