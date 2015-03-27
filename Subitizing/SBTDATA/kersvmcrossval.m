function bestC = kersvmcrossval(kernel,label,C,nfold)

AUCscore = nan(size(C));

for i = 1:numel(C)
    [auc accuracy] = crossval(kernel,label,C(i),nfold);
    AUCscore(i) = auc;
    fprintf('C: %f, AUC: %f, Acc.: %f\n', C(i), AUCscore(i), accuracy);
end

[~,idx] = max(AUCscore);
bestC = C(idx);

function [auc, accuracy] = crossval(kernel,label,C,nfold)

featfold = cell(nfold,1);
labelfold = cell(nfold,1);
posfeat = find(label == 1); posfeat = posfeat(randperm(numel(posfeat)));
negfeat = find(label == 0); negfeat = negfeat(randperm(numel(negfeat)));
for i = 1:nfold
    posstart = round((i-1)*numel(posfeat)/nfold + 1);
    posend = round(i*numel(posfeat)/nfold);
    negstart = round((i-1)*numel(negfeat)/nfold + 1);
    negend = round(i*numel(negfeat)/nfold);
    featfold{i} = [posfeat(posstart:posend)';negfeat(negstart:negend)'];
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
    
    trainkernel = kernel(trainfeat,trainfeat);
    testkernel = kernel(testfeat,trainfeat);
    
    w0 = 2*sum(label == 1)/numel(label);
    w1 = 2*sum(label == 0)/numel(label);
    
    model = kersvmtrain(trainkernel,trainlabel',C);
    [testscore,testacc] = kersvmtest(model,testkernel,testlabel');
    accuracy = accuracy + testacc(1);
    aa = calcOverallAP(testlabel,testscore);
%     [~,~,~,aa] = perfcurve(testlabel,testscore,1);
    auc = auc + aa;
end
accuracy = accuracy/nfold;
auc = auc/nfold;

