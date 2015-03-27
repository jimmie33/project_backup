propName = 'edgeBoxProp_exp/top100_1opt';% the model that uses salmap to mine good proposal in the top 50
predModel = {'pred_AllCat_CNNFT_pca100_aug'};
classifier = {[0],[0,1],[0,1,2],[0:3]};% specified class label + the rest

nFold = 5;

%% data split
folds = cell(nFold,1);
count = 0;
for i = 0:4
    load(fullfile('img',['imgList_' num2str(i)]));
    idx = randperm(numel(imgList));
    step = numel(imgList)/nFold;
    for j = 1:nFold
        folds{j} = [folds{j}, count + idx(round(step*(j-1)+1):round(step*j))];
    end
    count = count + numel(imgList);
end

%% load recall

[R,nProp,nInst]=nRecallEvaluate(propName,[0:4]);

%% cross validation

for modelIdx = 1:numel(predModel)
    % load prediction
    modelpred = [];
    for i = 0:4
        load(fullfile('img',[predModel{modelIdx} '_' num2str(i)]));
        modelpred = [modelpred;pred(:)];
    end
    
    for i = 1:numel(classifier)
        resName = [predModel{modelIdx}];
        cate = classifier{i}; 
        for kk = 1:numel(cate), resName = [resName '_' num2str(cate(kk))]; end
        if exist(fullfile('results',['sal_sum_' resName '.mat']),'file')
            continue
        end
        
        % post-process prediction
        prediction = nan(size(modelpred)); 
        for kk = 1:numel(cate)
            prediction(modelpred == cate(kk)) = kk;
        end
        prediction(isnan(prediction)) = numel(cate)+1;
        
        % nFold cross-val
        newR = [];
        newnProp = [];
        newnInst = [];
        newpred = [];
        for foldIdx = 1:nFold
            trainIdx = []; testIdx = [];
            for kk = 1:nFold
                if kk == foldIdx
                    testIdx = folds{kk};
                else
                    trainIdx = [trainIdx, folds{kk}];
                end
            end
            proportion = nan(1,numel(cate)+1); proportion(1) = 0; % first class 0
            tmpR = R(trainIdx,:);
            tmpnInst = nInst(trainIdx);
            tmppred = prediction(trainIdx);
            for kk = 2:numel(proportion)
                mask = tmppred == kk;
                tmpRecall=sum(tmpR(mask,:))/sum(tmpnInst(mask));
                iiid = find(tmpRecall>0.9);
                proportion(kk) = iiid(1);
            end
            proportion = proportion/max(proportion);
            
            % test
            tmpR = R(testIdx,:);
            tmpnProp = nProp(testIdx,:);
            tmpnInst = nInst(testIdx);
            tmppred = prediction(testIdx);
            for kk = 1:numel(proportion)
                mask = tmppred == kk;
                if proportion(kk) == 0
                    newR = [newR;zeros(sum(mask),2048)];
                    newnProp = [newnProp;zeros(sum(mask),2048)];
                    newnInst = [newnInst;tmpnInst(mask)'];
                    newpred = [newpred;kk*ones(sum(mask),1)];
                    continue
                end
                
                iiid = round([1:2048]*proportion(kk));
                tmp = zeros(sum(mask),2048);
                tmp(:,iiid>0) = tmpR(mask,iiid(iiid>0));
                newR = [newR;tmp];
                tmp = zeros(sum(mask),2048);
                tmp(:,iiid>0) = tmpnProp(mask,iiid(iiid>0));
                newnProp = [newnProp;tmp];
                newnInst = [newnInst;tmpnInst(mask)'];
                newpred = [newpred;kk*ones(sum(mask),1)];
            end
        end
        newR_std = getSTD(newR,newnInst);
        save(fullfile('results',['exp3_1opt_' resName]),'newR','newnProp','newnInst','newpred','newR_std');
    end
    
end