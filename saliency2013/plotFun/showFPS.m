addpath('../')
configModel;
fps = [];
xname = [];
for i = 1:numel(model)
    fps = [fps;model{i}.fps];
    xname{i}=model{i}.printName;
end

bar(fps);

ymin = 0;
ymax = max(fps(:))+3;
axis([0 13 ymin ymax])
grid on

ylabel('FPS')
set(gca,'XTickLabel',xname);
aa=get(gca,'XTickLabel');
bb=get(gca,'XTick');
cc=get(gca,'YTick');
set(gca,'XTickLabel',{});
th=text(bb,zeros(1,length(model))-0.9,aa,'HorizontalAlignment','left','rotation',-50);