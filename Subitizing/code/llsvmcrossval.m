function bestC = llsvmcrossval(trainFeat,label,C,nfold)

AUCscore = nan(size(C));
% trainFeat = sparse(trainFeat);

for i = 1:numel(C)
    [auc accuracy] = crossval(trainFeat,label,C(i),nfold);
    AUCscore(i) = auc;
    fprintf('C: %f, AUC: %f, Acc.: %f\n', C(i), AUCscore(i), accuracy);
end

[~,idx] = max(AUCscore);
bestC = C(idx);

%%
function [auc, accuracy] = crossval(feat,label,C,nfold)

featfold = cell(nfold,1);
labelfold = cell(nfold,1);

posfeat = feat(label == 1,:); posfeat = posfeat(randperm(size(posfeat,1)),:);
negfeat = feat(label == 0,:); negfeat = negfeat(randperm(size(negfeat,1)),:);
for i = 1:nfold
    posstart = round((i-1)*size(posfeat,1)/nfold + 1);
    posend = round(i*size(posfeat,1)/nfold);
    negstart = round((i-1)*size(negfeat,1)/nfold + 1);
    negend = round(i*size(negfeat,1)/nfold);
    featfold{i} = sparse([posfeat(posstart:posend,:);negfeat(negstart:negend,:)]);
    labelfold{i} = [ones(posend-posstart+1,1);zeros(negend-negstart+1,1)];
end

auc = 0;
accuracy = 0;

for i = 1:nfold
    trainfeat = [];
    trainlabel = [];
    testfeat = [];
    testlabel = [];
    for kk = 1:nfold
        if kk == i
            testfeat = featfold{kk};
            testlabel = labelfold{kk};
        else
            trainfeat = [trainfeat;featfold{kk}];
            trainlabel = [trainlabel;labelfold{kk}];
        end
    end
    
    w0 = 2*sum(label == 1)/numel(label);
    w1 = 2*sum(label == 0)/numel(label);
    
    model = train(trainlabel, trainfeat, sprintf('-c %f -B 1 -w0 %f -w1 %f -q', C,w0,w1));
    [~, acc, dec_values] = predict(testlabel, testfeat, model);
    accuracy = accuracy + acc(1);
    [~,~,~,aa] = perfcurve(testlabel,dec_values,model.Label(1));
    auc = auc + aa;
end
accuracy = accuracy/nfold;
auc = auc/nfold;


