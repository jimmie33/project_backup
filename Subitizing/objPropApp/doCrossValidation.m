addpath('../SBTDATA/liblinear-1.93/matlab');

param = getParam();

load GTVOCTRAIN
testIdx = zeros(numel(label),1)==1;
trainLabel = label;
testLabel = [];

for i=1:numel(param)
    if exist(fullfile('result',[param{i}.name '.mat']),'file')
        continue;
    end
    model = [];
    model.param = param{i};
    %% pca
    fprintf('PCA...\n')
    feature = param{i}.feature;
    for featIdx = 1:numel(feature)
        pcaD = feature{featIdx}.pca;
        featName = [feature{featIdx}.name '_pca' num2str(pcaD)];
        if exist(fullfile('feature',[featName '.mat']),'file')
            continue;
        end
            
        load(fullfile('feature',feature{featIdx}.name));
        feat = double(feat);
    
        % train test split
        trainFeat = feat(~testIdx,:);
        testFeat = feat(testIdx,:);
    
        % PCA
        [trainFeat,m,V,~] = prepPCA(trainFeat,pcaD);
        testFeat = applyPCA(testFeat,m,V);
        trainStd = std(trainFeat);

        save(fullfile('feature',featName),'trainFeat','testFeat','m','V','trainStd','-v7.3');
    end
    
    %% concatenate train test feature
    fprintf('Prepare feature...\n')
    saveName = fullfile('cache',[param{i}.name '_feat']);
    if exist([saveName '.mat'],'file')
        load(saveName)
    else
        tmpTrain = [];
        tmpTest = [];
        featParam = [];
        for featIdx = 1:numel(param{i}.feature)
            pcaD = feature{featIdx}.pca;
            featName = [feature{featIdx}.name '_pca' num2str(pcaD)];
            load(fullfile('feature',featName))
            % normalize
            if feature{featIdx}.norm
                trainFeat = bsxfun(@times,trainFeat,1./trainStd);
                testFeat = bsxfun(@times,testFeat,1./trainStd);
            end
            tmpTrain = [tmpTrain trainFeat];
            tmpTest = [tmpTest testFeat];
            featParam{featIdx}.m = m;
            featParam{featIdx}.V = V;
            featParam{featIdx}.trainStd = trainStd;
        end
        trainFeat = tmpTrain;
        testFeat = tmpTest;
        save(saveName,'trainFeat','testFeat','featParam','-v7.3');
    end
    
    model.featParam = featParam;
    
    %% cross validation
    fprintf('Cross validation...\n')
    label_set = param{i}.label_set;
    C = [0.01,0.1,1,10];
    
    
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
        tmpFeat = trainFeat(~isnan(tmpLabel),:);
        tmpLabel(isnan(tmpLabel))=[];
        
        bestC = llsvmcrossval(trainFeat,tmpLabel,C,5);
        model.svmModel{label_idx} = llsvmtrain(tmpFeat,tmpLabel,bestC);
        % test
        % define test task label
%         tmpLabel = nan(size(testLabel));
%         for lIdx = 1:numel(label_set)
%             for k = 1:numel(label_set{lIdx})
%                 if label_idx == lIdx
%                     tmpLabel(testLabel == label_set{lIdx}(k)) = 1;
%                 else
%                     tmpLabel(testLabel == label_set{lIdx}(k)) = 0;
%                 end
%             end
%         end
%         tmpFeat = testFeat(~isnan(tmpLabel),:);
%         tmpLabel = tmpLabel(~isnan(tmpLabel));
%         model.testScore{label_idx} = llsvmtest(model.svmModel{label_idx},tmpFeat,tmpLabel);
%         model.testGT{label_idx} = tmpLabel;
%         
%         [~,~,~,aa] = perfcurve(model.testGT{label_idx},model.testScore{label_idx},1);
%         fprintf('category: ')
%         for k = 1:numel(label_set{label_idx})
%             fprintf('%d ', label_set{label_idx}(k))
%         end
%         fprintf('\nAUC: %f\n',aa);
    end
    
    save(fullfile('result',param{i}.name),'model','-v7.3');
end

%% show metric
% for i=1:numel(param)
%     load(fullfile('result',param{i}.name));
%     label_set = param{i}.label_set;
%     fprintf('\n%s\n',param{i}.name)
%     for label_idx = 1:numel(label_set)
%         [~,~,~,aa] = perfcurve(model.testGT{label_idx},model.testScore{label_idx},1);
%         fprintf('category: ')
%         for k = 1:numel(label_set{label_idx})
%             fprintf('%d ', label_set{label_idx}(k))
%         end
%         confusionmat(model.testGT{label_idx}>0, model.testScore{label_idx}>0)
%         fprintf('--------\nAUC: %f\n',aa);
%     end
%     
%     % show confusion matrix
%     score = [];
%     for label_idx = 1:numel(label_set)
%         score = [score,model.testScore{label_idx}(:)];
%     end
%     [~,idx] = max(score,[],2);
%     label = 1:numel(label_set);
%     pred = label(idx);
%     gt = nan(size(testLabel));
%     for label_idx = 1:numel(label_set)
%         for k = 1:numel(label_set{label_idx})
%             gt(testLabel == label_set{label_idx}(k)) = label_idx;
%         end
%     end 
%     gt(isnan(gt))=[];
%     confusionmat(gt,pred)
% end