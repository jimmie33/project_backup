res = {...
    'recall_BING_5',...
    'recall_EB50_5',...
    };
model_name = {'EB','EB+SBT','MCG','MCG+SBT'};
plotStyle = {...
    struct('color',[1 0 0],'linestyle','-'),...
    struct('color',[0 0 1],'linestyle','-'),...
    struct('color',[0 1 0],'linestyle','-'),...
    };
load CNNFT_fc8_aug_pred
% figure
for i = 1:numel(res)
    load([res{i},'_scored']);
    [X,Y,R,nP] = evaluateID(pred==-1,0.5,-1,rec,nInst,nProposal);
    plot(X,Y,'-','color',plotStyle{i}.color,'lineWidth',1.4), hold on
    [X,Y,R,nP] = evaluateID(pred~=0&pred~=4,0.5,-1,rec,nInst,nProposal);
    plot(X,Y,'--','color',plotStyle{i}.color,'lineWidth',1.4)
    
    load([res{i},'_scored']);
%     [X,Y] = evaluateScoreThresh(score,rec,nProposal,nInst);
    plot(X,Y,'-.','color',plotStyle{i}.color,'lineWidth',2);
%     name{i} = sprintf('%s [%.2f]',model_name{i},ap);
end
legend(model_name,'location','SouthEast');
xlabel('Avg. Number of Proposals per Image'),ylabel('Recall')
axis([100 1000,0.45,0.74]), 
set(gca,'xtick',[100:200:1000])
grid on