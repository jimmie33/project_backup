addpath('libsvm/');

param = getParamKernel();

load imgIdx;
load testIdx;
label = [imgIdx.label];
trainLabel = label(~testIdx);
testLabel = label(testIdx);

for i=1:numel(param)
    if exist(fullfile('result',[param{i}.name '.mat']),'file')
        continue;
    end
    model = [];
    model.param = param{i};
    
    kerFile = fullfile('feature',[param{i}.kernel.name, '_kernel.mat']);
    if (~exist(kerFile,'file'))
        error('kernel file does not exist.');
    end
    load(kerFile);
    
    %% get the training testing split
    
    trainKernel = feat_kernel(~testIdx,~testIdx);
    testKernel = feat_kernel(testIdx,~testIdx);
    
    
    %% cross validation
    fprintf('Cross validation...\n')
    label_set = param{i}.label_set;
    C = [1,10];
    
    
    for label_idx = 1:numel(label_set)
        tmpLabel = nan(size(trainLabel));
        % define task label
        for lIdx = 1:numel(label_set)
            for k = 1:numel(label_set{lIdx})
                if label_idx == lIdx
                    tmpLabel(trainLabel == label_set{lIdx}(k)) = 1;
                else
                    tmpLabel(trainLabel == label_set{lIdx}(k)) = 0;
                end
            end
        end
        if any(isnan(tmpLabel))
            error('not supporting partial set yet')
        end
        tmpKernel = trainKernel;
        
        bestC = kersvmcrossval(tmpKernel,tmpLabel,C,5);
        model.svmModel{label_idx} = kersvmtrain(tmpKernel,tmpLabel,bestC);
        fprintf('best C: %f\n',bestC);
        % test
        % define test task label
        tmpLabel = nan(size(testLabel));
        for lIdx = 1:numel(label_set)
            for k = 1:numel(label_set{lIdx})
                if label_idx == lIdx
                    tmpLabel(testLabel == label_set{lIdx}(k)) = 1;
                else
                    tmpLabel(testLabel == label_set{lIdx}(k)) = 0;
                end
            end
        end
        if any(isnan(tmpLabel))
            error('not supporting partial set yet')
        end
        tmpKernel = testKernel;

        model.testScore{label_idx} = (model.svmModel{label_idx}.Label(1)-0.5)*2*...
            kersvmtest(model.svmModel{label_idx},tmpKernel,tmpLabel);
        model.testGT{label_idx} = tmpLabel;
        
        [~,~,~,aa] = perfcurve(model.testGT{label_idx},model.testScore{label_idx},1);
        fprintf('category: ')
        for k = 1:numel(label_set{label_idx})
            fprintf('%d ', label_set{label_idx}(k))
        end
        fprintf('\nAUC: %f\n',aa);
    end
    
    save(fullfile('result',param{i}.name),'model','-v7.3');
end

%% show metric
for i=1:numel(param)
    load(fullfile('result',param{i}.name));
    label_set = param{i}.label_set;
    fprintf('-----------\n%s\n',param{i}.name)
%     for label_idx = 1:numel(label_set)
%         [~,~,~,aa] = perfcurve(model.testGT{label_idx},model.testScore{label_idx},1);
%         fprintf('category: ')
%         for k = 1:numel(label_set{label_idx})
%             fprintf('%d ', label_set{label_idx}(k))
%         end
%         confusionmat(model.testGT{label_idx}>0, model.testScore{label_idx}>0)
%         fprintf('--------\nAUC: %f\n',aa);
%     end
    
    % show confusion matrix
    score = [];
    for label_idx = 1:numel(label_set)
        score = [score,model.testScore{label_idx}(:)];
    end
    [~,idx] = max(score,[],2);
    pred = idx;
    gt = nan(size(testLabel));
    for label_idx = 1:numel(label_set)
        for k = 1:numel(label_set{label_idx})
            gt(testLabel == label_set{label_idx}(k)) = label_idx;
        end
    end 
    gt(isnan(gt))=[];
    confmat = confusionmat(gt,pred)
    ap = calcOverallAP(gt,score);
    fscore = calcFscore(confmat);
    fprintf('AP:\n')
    fprintf('%f\n',ap);
    fprintf('mean AP: %f\n\n',mean(ap));
%     fprintf('F-measure:\n');
%     fprintf('%f\n',fscore');
%     fprintf('mean F: %f\n\n',mean(fscore));
end