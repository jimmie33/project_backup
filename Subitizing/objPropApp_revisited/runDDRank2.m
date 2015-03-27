function [res] = runDDRank2(num)

load testImgIdx
% load getBaseline/baselines/testImgIdxLBI
load ../feature/CNN/CNNFT_VGG16_Exp3_3000
load ../testIdx
salfeat = feat(testIdx,:);
param = getParam();

for i = 1:numel(testImgIdx)
    
    % get data
    sbtscore = testImgIdx(i).sbtscore;
    bboxscore = testImgIdx(i).sortbboxscore(1:min(100,numel(testImgIdx(i).sortbboxscore)));
    bboxes = testImgIdx(i).sortbbox(:,1:1:min(100,numel(testImgIdx(i).sortbboxscore)));
    bboxesfull = bsxfun(@times,bboxes,testImgIdx(i).imsz([2 1 2 1])');
    bboxessmall = round(bsxfun(@times,bboxes,[7 7 7 7]'));
    bboxessmall([1 2],:) = max(bboxessmall([1 2],:),1);
    
    tmpfeat = salfeat(i,:);
    tmpfeat = reshape(tmpfeat,7,7,3);
    salmap = 1-tmpfeat(:,:,1)';
    % init data
    [sbtscore, bboxscore, salscore] = initData(sbtscore,bboxscore,bboxes,salmap,param);
    affmat = getAffMat(bboxes);
    
    residx = [];
    for j = 1:num
        [sbtpred, sbtscore] = sampleSbtPred(sbtscore, param);
        if sbtpred == 0
            sbtpred = 4;
        end
        newidx = [];
        if sbtpred >= 1 %get prop
            [newidx, bboxscore] = getMultiProp(bboxscore, salscore, affmat, sbtpred, param);
        elseif sbtpred > 1
%             [newidx, bboxscoreM] = getMultiProp(bboxscoreM, affmat, sbtpred, param);
%             [newidx, bboxscore] = getMultiPropWithSal(bboxscore, affmat, ...
%                 sbtpred, bboxessmall, salmap, param);
        end
        residx = idxMerge(residx,newidx);
        res{j}{i} = bboxesfull(:, residx);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function param = getParam()
param.sbtscore_r = 0.5;
param.bboxscore_r = 0.5;
param.salthresh = 0.5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [newidx, bboxscore] = getMultiProp(bboxscore, salscore, affmat, num, param)
newidx = zeros(1,num);
for i = 1:num
    [~, tmpidx] = max(bboxscore.*salscore);
    bboxscore = bboxscore.*(param.bboxscore_r.^affmat(tmpidx,:))';
    newidx(i) = tmpidx;
end

function [newidx, bboxscore] = getMultiPropWithSal(bboxscore, affmat, num, bboxes, salmap, param)
newidx = zeros(1,num);
salmapS = salmap > param.salthresh;
salmapS = salmapS/sum(salmap(:));

% first one
[~, tmpidx] = max(bboxscore);
bboxscore = bboxscore.*(param.bboxscore_r.^affmat(tmpidx,:))';
newidx(1) = tmpidx;

bb = bboxes(:,tmpidx);
salmapS(bb(2):bb(4),bb(1):bb(3)) = salmapS(bb(2):bb(4),bb(1):bb(3))*0.1;%%%%%%%%%%
tmp = zeros(size(bboxscore));
for i = 1:numel(tmp)
    tmp(i) = sum(sum(salmapS(bboxes(2,i):bboxes(4,i),bboxes(1,i):bboxes(3,i))));
end
tmpbboxscore = bboxscore.*tmp;

for i = 2:num
    [~, tmpidx] = max(tmpbboxscore);
    bboxscore = bboxscore.*(param.bboxscore_r.^affmat(tmpidx,:))';
    newidx(i) = tmpidx;
    
    bb = bboxes(:,tmpidx);
    salmapS(bb(2):bb(4),bb(1):bb(3)) = salmapS(bb(2):bb(4),bb(1):bb(3))*0.1;%%%%%%%%%%
    tmp = zeros(size(bboxscore));
    for kk = 1:numel(tmp)
        tmp(kk) = sum(sum(salmapS(bboxes(2,kk):bboxes(4,kk),bboxes(1,kk):bboxes(3,kk))));
    end
    tmpbboxscore = bboxscore.*tmp;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function affmat = getAffMat(bboxes)
affmat = zeros(size(bboxes,2));
for i = 1:size(bboxes,2)
    affmat(i,i:end) = getIOUFloat(bboxes(:,i:end)',bboxes(:,i)');
end
affmat = triu(affmat,1)'+affmat;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sbtscore, bboxscore, salscore] = initData(sbtscore,bboxscore,bboxes,salmap,param)

salmapS = salmap > param.salthresh;
salmapS = salmapS/sum(salmap(:));
bboxes = round(bsxfun(@times,bboxes,[7 7 7 7]'));
bboxes([1 2],:) = max(bboxes([1 2],:),1);
%for single obj
tmp = zeros(size(bboxscore));
for i = 1:numel(tmp)
    tmp(i) = sum(sum(salmapS(bboxes(2,i):bboxes(4,i),bboxes(1,i):bboxes(3,i))));
end
bboxscore = bboxscore;%%%%%%%
salscore = tmp;




function residx = idxMerge(residx,newidx)
if ~isempty(newidx)
    residx = unique([residx newidx]);
end

function [sbtpred, sbtscore] = sampleSbtPred(sbtscore, param)
[~,i] = max(sbtscore);
sbtscore(i) = sbtscore(i)*param.sbtscore_r; 
sbtpred = i- 1;